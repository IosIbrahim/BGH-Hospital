//
//  AIBotConversationEngine.swift
//  CareMate
//
//  Coordinates the AI symptom-assistant conversation against AIBotService,
//  ported from the Android VoiceAiFeature flow:
//    generate-session -> greeting + language chooser -> set_conversation_language
//    -> service chooser -> (complaint) name/age/symptoms answered by the user
//    -> medical_conversation_v2 loop -> diagnosis + recommended specialty card
//    -> "find specific doctor?" -> doctor search.
//
//  Voice (record / speech-to-text / TTS) and the full book-doctor sub-flow are
//  later phases; this coordinator covers the typed complaint conversation.
//

import Foundation

/// Snapshot of what we already know about the current user.
struct AIBotUserContext {

    let isGuest: Bool
    let name: String?
    let age: String?

    static func current() -> AIBotUserContext {
        let patientId = (UserDefaults.standard.object(forKey: "patienId") as? String) ?? ""
        let isGuest = patientId.trimmingCharacters(in: .whitespaces).isEmpty

        var name: String?
        if let saved = UserDefaults.standard.object(forKey: "SavedPerson") as? Data,
           let user = try? JSONDecoder().decode(LoginedUser.self, from: saved) {
            let full = UserManager.isArabic ? user.COMPLETEPATNAME_AR : user.COMPLETEPATNAME_EN
            let trimmed = full.trimmingCharacters(in: .whitespaces)
            name = trimmed.isEmpty ? nil : trimmed
        }
        return AIBotUserContext(isGuest: isGuest, name: name, age: nil)
    }

    var firstName: String? {
        guard let name = name else { return nil }
        return name.components(separatedBy: " ").first ?? name
    }
}

protocol AIBotChatCoordinatorDelegate: AnyObject {
    func coordinator(_ coordinator: AIBotChatCoordinator, didAdd messages: [AIBotMessage])
    func coordinatorDidStartLoading(_ coordinator: AIBotChatCoordinator)
    func coordinatorDidStopLoading(_ coordinator: AIBotChatCoordinator)
    /// Whether the typed-input bar should be shown (hidden while choosing buttons).
    func coordinator(_ coordinator: AIBotChatCoordinator, setInputVisible visible: Bool)
    func coordinator(_ coordinator: AIBotChatCoordinator, openDoctorSearchForSpecialty code: String?)
    /// Ask the UI to open the live voice mode for the given recognizer language.
    func coordinator(_ coordinator: AIBotChatCoordinator, didRequestVoiceModeWithLang lang: String)
    /// A bot TTS reply finished playing (used to resume listening).
    func coordinatorDidFinishSpeaking(_ coordinator: AIBotChatCoordinator)
}

final class AIBotChatCoordinator {

    weak var delegate: AIBotChatCoordinatorDelegate?

    private let service = AIBotService.shared
    private let context = AIBotUserContext.current()

    private enum State {
        case start
        case choosingLanguage
        case choosingService
        case asking
        case finished
    }

    private enum Question {
        case name, age, symptoms
        var prompt: String {
            switch self {
            case .name: return AIBotStrings.chatAskName
            case .age: return AIBotStrings.chatAskAge
            case .symptoms: return AIBotStrings.chatAskSymptoms
            }
        }
    }

    private var state: State = .start
    private var isBusy = false
    private var sessionKey: String?
    private var lang = UserManager.isArabic ? "ar" : "en"
    private var isBookDoctor = false
    private var pendingQuestions: [Question] = []
    private var currentQuestion: Question?

    // MARK: - Start

    func start() {
        AIBotStrings.overrideLang = nil // language chooser uses the app default
        delegate?.coordinatorDidStartLoading(self)
        service.generateSession { [weak self] result in
            guard let self = self else { return }
            self.delegate?.coordinatorDidStopLoading(self)
            switch result {
            case .success(let session):
                self.sessionKey = session.session_key
                self.state = .choosingLanguage
                self.delegate?.coordinator(self, setInputVisible: false)
                self.delegate?.coordinator(self, didAdd: [
                    .botText(AIBotStrings.chatIntro),
                    .botText(AIBotStrings.chooseLanguage),
                    .botChoices([
                        AIBotChoice(title: AIBotStrings.arabic, tag: .language("ar")),
                        AIBotChoice(title: AIBotStrings.english, tag: .language("en"))
                    ])
                ])
            case .failure:
                self.delegate?.coordinator(self, didAdd: [.botText(AIBotStrings.connectionError)])
            }
        }
    }

    // MARK: - Choices

    func handleChoice(_ choice: AIBotChoice) {
        switch choice.tag {
        case .language(let lang):
            selectLanguage(lang)
        case .service(let bookDoctor):
            selectService(bookDoctor: bookDoctor)
        case .findDoctor:
            // Both paths lead to doctor search for now; the dedicated
            // book-doctor sub-flow is a later phase.
            delegate?.coordinator(self, openDoctorSearchForSpecialty: recommendedSpecialtyCode)
        }
    }

    private func selectLanguage(_ lang: String) {
        guard state == .choosingLanguage, !isBusy, let key = sessionKey else { return }
        self.lang = lang
        AIBotStrings.overrideLang = lang // rest of the chat now follows this language
        delegate?.coordinator(self, didAdd: [.userText(lang == "ar" ? AIBotStrings.arabic : AIBotStrings.english)])
        isBusy = true
        delegate?.coordinatorDidStartLoading(self)
        service.setLanguage(lang: lang, sessionKey: key) { [weak self] result in
            guard let self = self else { return }
            self.isBusy = false
            self.delegate?.coordinatorDidStopLoading(self)
            switch result {
            case .success:
                self.state = .choosingService
                self.delegate?.coordinator(self, didAdd: [
                    .botText(AIBotStrings.chooseService),
                    .botChoices([
                        AIBotChoice(title: AIBotStrings.bookByComplaint, tag: .service(bookDoctor: false)),
                        AIBotChoice(title: AIBotStrings.bookBySpeciality, tag: .service(bookDoctor: true))
                    ])
                ])
            case .failure:
                self.delegate?.coordinator(self, didAdd: [.botText(AIBotStrings.connectionError)])
            }
        }
    }

    private func selectService(bookDoctor: Bool) {
        isBookDoctor = bookDoctor
        delegate?.coordinator(self, didAdd: [
            .userText(bookDoctor ? AIBotStrings.bookBySpeciality : AIBotStrings.bookByComplaint)
        ])

        // Build the question queue (name only for guests, age always for now).
        pendingQuestions = []
        if context.isGuest || (context.firstName ?? "").isEmpty {
            pendingQuestions.append(.name)
        }
        pendingQuestions.append(.age)
        pendingQuestions.append(.symptoms)

        state = .asking
        delegate?.coordinator(self, setInputVisible: true)
        delegate?.coordinator(self, didRequestVoiceModeWithLang: lang)

        var opener: [AIBotMessage] = [.botText(AIBotStrings.letsStart)]
        if let first = context.firstName, !context.isGuest {
            opener.append(.botText(AIBotStrings.chatGreetName(first)))
        }
        opener.append(askNextQuestion())
        emit(opener, speak: true)
    }

    // MARK: - Typed answers

    func submitAnswer(_ text: String) {
        guard state == .asking, !isBusy, let key = sessionKey else { return }
        let answeredQuestion = currentQuestion
        isBusy = true
        delegate?.coordinatorDidStartLoading(self)
        let request = MedicalConversationRequest(
            question: answeredQuestion?.prompt,
            user_response: text,
            session_key: key
        )
        service.medicalConversation(request) { [weak self] result in
            guard let self = self else { return }
            self.isBusy = false
            self.delegate?.coordinatorDidStopLoading(self)
            switch result {
            case .success(let response):
                self.handleConversation(response)
            case .failure(let error):
                self.delegate?.coordinator(self, didAdd: [.botText(AIBotStrings.connectionError + "\n[\(error.debugText)]")])
            }
        }
    }

    /// Uploads a recorded clip to speech-to-text, then submits the transcript.
    func submitVoiceRecording(fileURL: URL) {
        guard state == .asking, !isBusy, let key = sessionKey else { return }
        isBusy = true
        delegate?.coordinatorDidStartLoading(self)
        service.speechToText(fileURL: fileURL, sessionKey: key) { [weak self] result in
            guard let self = self else { return }
            self.isBusy = false
            self.delegate?.coordinatorDidStopLoading(self)
            switch result {
            case .success(let stt):
                let text = (stt.transcription ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                if text.isEmpty {
                    self.delegate?.coordinator(self, didAdd: [.botText(AIBotStrings.genericError)])
                } else {
                    self.submitAnswer(text)
                }
            case .failure(let error):
                self.delegate?.coordinator(self, didAdd: [.botText(AIBotStrings.connectionError + "\n[STT: \(error.debugText)]")])
            }
        }
    }

    private func handleConversation(_ response: MedicalConversationResponse) {
        let content = response.content ?? ""
        // Backend signals "didn't understand" with an error token ("error" in
        // English, "خطأ" in Arabic). Show a friendly retry message instead of
        // the raw token, and keep the same question (don't advance).
        let token = content.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if token == "error" || token == "خطأ" {
            delegate?.coordinator(self, didAdd: [.botText(AIBotStrings.genericError)])
            return
        }

        if response.is_conversation_finished == true {
            finish(with: response.conversation_info)
            return
        }

        var messages: [AIBotMessage] = []
        // Acknowledgement / dynamic question returned by the backend.
        if !content.isEmpty {
            messages.append(.botText(content))
        }
        // Move on to the next scripted question if any remain; otherwise the
        // backend content above is the next prompt.
        if !pendingQuestions.isEmpty {
            messages.append(askNextQuestion())
        } else {
            currentQuestion = nil
        }
        emit(messages, speak: true)
    }

    private func finish(with info: ConversationInfo?) {
        state = .finished
        currentQuestion = nil
        recommendedSpecialtyCode = info?.recommended_speciality_code
        delegate?.coordinator(self, setInputVisible: false)

        var messages: [AIBotMessage] = []
        if let diagnosis = info?.diagnosis, !diagnosis.isEmpty {
            messages.append(.botText(diagnosis))
        }
        let specialty = info?.recommended_speciality ?? AIBotStrings.demoSpecialty
        messages.append(.botText(AIBotStrings.recommendSpecialty(specialty)))
        messages.append(.botAction(title: AIBotStrings.findBestNow(specialty),
                                    specialtyCode: info?.recommended_speciality_code))
        messages.append(.botText(AIBotStrings.needSpecificDoctor))
        messages.append(.botChoices([
            AIBotChoice(title: AIBotStrings.yesNeedDoctor, tag: .findDoctor(true)),
            AIBotChoice(title: AIBotStrings.noSearchMyself, tag: .findDoctor(false))
        ]))
        emit(messages, speak: true)
    }

    // MARK: - Recommendation card tap

    func openRecommendedDoctorSearch(specialtyCode: String?) {
        delegate?.coordinator(self, openDoctorSearchForSpecialty: specialtyCode ?? recommendedSpecialtyCode)
    }

    // MARK: - Helpers

    private var recommendedSpecialtyCode: String?

    /// Adds messages and, when `speak` is set, plays the joined bot text via TTS
    /// and appends a playable audio bubble (mirrors the Android voice replies).
    private func emit(_ messages: [AIBotMessage], speak: Bool = false) {
        delegate?.coordinator(self, didAdd: messages)
        guard speak, let key = sessionKey else { return }
        let text = messages.compactMap { message -> String? in
            if case .text(let value) = message.kind, message.sender == .bot, !value.isEmpty {
                return value
            }
            return nil
        }.joined(separator: " ")
        guard !text.isEmpty else { return }
        service.textToSpeech(text: text, sessionKey: key) { [weak self] result in
            guard let self = self else { return }
            guard case .success(let url) = result else {
                self.delegate?.coordinatorDidFinishSpeaking(self)
                return
            }
            let duration = AIBotAudioPlayer.durationString(for: url)
            self.delegate?.coordinator(self, didAdd: [.botAudio(url: url, duration: duration)])
            AIBotAudioPlayer.shared.play(url: url) { [weak self] in
                guard let self = self else { return }
                self.delegate?.coordinatorDidFinishSpeaking(self)
            }
        }
    }

    /// True while the coordinator is waiting for the user's answer to a question.
    var expectsUserAnswer: Bool { state == .asking }

    /// Recognizer language for voice mode ("ar" / "en").
    var languageCode: String { lang }

    private func askNextQuestion() -> AIBotMessage {
        guard !pendingQuestions.isEmpty else {
            currentQuestion = nil
            return .botText("")
        }
        let next = pendingQuestions.removeFirst()
        currentQuestion = next
        return .botText(next.prompt)
    }
}
