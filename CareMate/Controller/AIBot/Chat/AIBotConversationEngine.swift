//
//  AIBotConversationEngine.swift
//  CareMate
//
//  Drives the AI symptom-assistant conversation. The question flow is decided
//  here based on who the user is:
//    - Name  : asked only in guest mode (for a logged-in user we already have it).
//    - Age   : asked when we don't have the user's age. The app doesn't store an
//              age today, so it's always asked for now; when an age source is
//              added, populate `AIBotUserContext.age` and this question is skipped.
//    - Symptoms : always asked.
//
//  Answers are collected locally. Sending them to the backend (and the real
//  specialist recommendation) is wired once those endpoints are available; the
//  closing recommendation below is a temporary placeholder.
//

import Foundation

/// Snapshot of what we already know about the current user.
struct AIBotUserContext {

    let isGuest: Bool
    let name: String?
    let age: String?

    /// Builds the context from the app's stored session.
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

        // No age is stored in the app yet.
        return AIBotUserContext(isGuest: isGuest, name: name, age: nil)
    }
}

final class AIBotConversationEngine {

    private enum Question {
        case name
        case age
        case symptoms
    }

    struct Answers {
        var name: String?
        var age: String?
        var symptoms: String?
    }

    private let context: AIBotUserContext
    private var queue: [Question] = []
    private var current: Question?
    private(set) var answers: Answers

    init(context: AIBotUserContext = .current()) {
        self.context = context
        self.answers = Answers(name: context.name, age: context.age, symptoms: nil)
        buildQueue()
    }

    private func buildQueue() {
        var questions: [Question] = []
        if context.isGuest || (context.name ?? "").isEmpty {
            questions.append(.name)
        }
        if (context.age ?? "").isEmpty {
            questions.append(.age)
        }
        questions.append(.symptoms)
        queue = questions
    }

    /// Opening messages plus the first question.
    func start() -> [AIBotMessage] {
        var messages: [AIBotMessage] = [.botText(AIBotStrings.chatOpener)]
        // Greet a known user by name.
        if let name = context.name, !context.isGuest {
            messages.append(.botText(AIBotStrings.chatGreetName(name)))
        }
        if let next = dequeueQuestionMessage() {
            messages.append(next)
        }
        return messages
    }

    /// Records the answer to the current question and returns the next step.
    func reply(to message: AIBotMessage) -> [AIBotMessage] {
        record(answer: text(of: message), for: current)

        if let next = dequeueQuestionMessage() {
            return [next]
        }
        return finish()
    }

    // MARK: - Helpers

    private func dequeueQuestionMessage() -> AIBotMessage? {
        guard !queue.isEmpty else {
            current = nil
            return nil
        }
        let question = queue.removeFirst()
        current = question
        return .botText(prompt(for: question))
    }

    private func prompt(for question: Question) -> String {
        switch question {
        case .name: return AIBotStrings.chatAskName
        case .age: return AIBotStrings.chatAskAge
        case .symptoms: return AIBotStrings.chatAskSymptoms
        }
    }

    private func record(answer: String, for question: Question?) {
        guard let question = question else { return }
        switch question {
        case .name: answers.name = answer
        case .age: answers.age = answer
        case .symptoms: answers.symptoms = answer
        }
    }

    private func text(of message: AIBotMessage) -> String {
        switch message.kind {
        case .text(let value): return value
        // No speech-to-text yet; a voice note has no transcript.
        case .voice, .action: return ""
        }
    }

    /// Placeholder closing until the analysis endpoint is wired.
    private func finish() -> [AIBotMessage] {
        current = nil
        let specialty = AIBotStrings.demoSpecialty
        return [
            .botText(AIBotStrings.chatAnalyzing),
            .botText(AIBotStrings.chatRecommend(specialty)),
            .botAction(title: AIBotStrings.chatFindBest(specialty), specialty: specialty)
        ]
    }
}
