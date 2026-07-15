//
//  AIBotChatViewController.swift
//  CareMate
//
//  The "Chat Voice" symptom-assistant conversation screen. Drives
//  AIBotChatCoordinator (session + language + service + medical conversation).
//  Voice recording / speech-to-text / TTS are a later phase.
//

import UIKit
import IQKeyboardManagerSwift

final class AIBotChatViewController: BaseViewController {

    // MARK: - State

    private let coordinator = AIBotChatCoordinator()
    private var messages: [AIBotMessage] = []
    private var voiceMode: AIBotVoiceModeViewController?

    // MARK: - UI

    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    private let inputContainer = UIView()
    private let fieldView = UIView()
    private let textField = UITextField()
    private let actionButton = UIButton(type: .custom)
    private var inputBottomConstraint: NSLayoutConstraint!
    private var inputHeightConstraint: NSLayoutConstraint!
    private var isKeyboardVisible = false

    // Recording
    private let recorder = AIBotAudioRecorder()
    private let recordingBar = UIView()
    private let recordDot = UIView()
    private let recordTimerLabel = UILabel()
    private let cancelRecordButton = UIButton(type: .system)
    private var isRecording = false
    private var recordTimer: Timer?
    private var recordSeconds = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AIBotTheme.chatBackground
        buildHeader()
        buildInputBar()
        buildTableView()
        buildLoading()
        registerKeyboardObservers()
        updateActionButton()

        setInputVisible(false, animated: false)
        coordinator.delegate = self
        coordinator.start()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        // This screen manages the keyboard itself (custom input bar). Turn off
        // IQKeyboardManager so it doesn't push the whole view up or add a toolbar.
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isKeyboardVisible {
            inputBottomConstraint.constant = -(view.safeAreaInsets.bottom + 8)
        }
    }

    // MARK: - Build

    private func buildHeader() {
        headerView.backgroundColor = AIBotTheme.headerIndigo
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        titleLabel.text = AIBotStrings.assistantTitle
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        backButton.tintColor = .white
        backButton.setImage(AIBotIcon.symbol("chevron.left", pointSize: 18, bold: true), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(titleLabel)
        headerView.addSubview(backButton)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
        ])
    }

    private func buildInputBar() {
        inputContainer.backgroundColor = .clear
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputContainer)

        let field = fieldView
        field.backgroundColor = .white
        field.layer.cornerRadius = 26
        field.layer.borderWidth = 1
        field.layer.borderColor = AIBotTheme.inputBorder.cgColor
        field.layer.shadowColor = UIColor.black.cgColor
        field.layer.shadowOpacity = 0.06
        field.layer.shadowRadius = 6
        field.layer.shadowOffset = CGSize(width: 0, height: 3)
        field.translatesAutoresizingMaskIntoConstraints = false

        textField.placeholder = AIBotStrings.inputPlaceholder
        textField.font = .systemFont(ofSize: 15)
        textField.returnKeyType = .send
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false

        actionButton.layer.cornerRadius = 26
        actionButton.tintColor = .white
        actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        inputContainer.addSubview(field)
        inputContainer.addSubview(actionButton)
        field.addSubview(textField)

        inputBottomConstraint = inputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        inputHeightConstraint = inputContainer.heightAnchor.constraint(equalToConstant: 52)

        NSLayoutConstraint.activate([
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputBottomConstraint,
            inputHeightConstraint,

            field.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor),
            field.topAnchor.constraint(equalTo: inputContainer.topAnchor),
            field.heightAnchor.constraint(equalToConstant: 52),
            field.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -10),

            textField.leadingAnchor.constraint(equalTo: field.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: field.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: field.topAnchor),
            textField.bottomAnchor.constraint(equalTo: field.bottomAnchor),

            actionButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor),
            actionButton.topAnchor.constraint(equalTo: inputContainer.topAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 52),
            actionButton.heightAnchor.constraint(equalToConstant: 52)
        ])

        buildRecordingBar()
    }

    private func buildRecordingBar() {
        recordingBar.backgroundColor = .white
        recordingBar.layer.cornerRadius = 26
        recordingBar.layer.borderWidth = 1
        recordingBar.layer.borderColor = AIBotTheme.inputBorder.cgColor
        recordingBar.isHidden = true
        recordingBar.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(recordingBar)

        cancelRecordButton.setImage(AIBotIcon.symbol("trash.fill", pointSize: 16, bold: false), for: .normal)
        cancelRecordButton.tintColor = .systemRed
        cancelRecordButton.addTarget(self, action: #selector(cancelRecording), for: .touchUpInside)
        cancelRecordButton.translatesAutoresizingMaskIntoConstraints = false

        recordDot.backgroundColor = .systemRed
        recordDot.layer.cornerRadius = 5
        recordDot.translatesAutoresizingMaskIntoConstraints = false

        recordTimerLabel.textColor = AIBotTheme.bubbleText
        recordTimerLabel.font = .systemFont(ofSize: 15, weight: .medium)
        recordTimerLabel.text = "0:00"
        recordTimerLabel.translatesAutoresizingMaskIntoConstraints = false

        recordingBar.addSubview(cancelRecordButton)
        recordingBar.addSubview(recordDot)
        recordingBar.addSubview(recordTimerLabel)

        NSLayoutConstraint.activate([
            recordingBar.leadingAnchor.constraint(equalTo: fieldView.leadingAnchor),
            recordingBar.trailingAnchor.constraint(equalTo: fieldView.trailingAnchor),
            recordingBar.topAnchor.constraint(equalTo: fieldView.topAnchor),
            recordingBar.bottomAnchor.constraint(equalTo: fieldView.bottomAnchor),

            cancelRecordButton.leadingAnchor.constraint(equalTo: recordingBar.leadingAnchor, constant: 12),
            cancelRecordButton.centerYAnchor.constraint(equalTo: recordingBar.centerYAnchor),
            cancelRecordButton.widthAnchor.constraint(equalToConstant: 32),
            cancelRecordButton.heightAnchor.constraint(equalToConstant: 32),

            recordDot.leadingAnchor.constraint(equalTo: cancelRecordButton.trailingAnchor, constant: 8),
            recordDot.centerYAnchor.constraint(equalTo: recordingBar.centerYAnchor),
            recordDot.widthAnchor.constraint(equalToConstant: 10),
            recordDot.heightAnchor.constraint(equalToConstant: 10),

            recordTimerLabel.leadingAnchor.constraint(equalTo: recordDot.trailingAnchor, constant: 8),
            recordTimerLabel.centerYAnchor.constraint(equalTo: recordingBar.centerYAnchor)
        ])
    }

    private func buildTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.register(AIBotTextBubbleCell.self, forCellReuseIdentifier: AIBotTextBubbleCell.reuseID)
        tableView.register(AIBotVoiceCell.self, forCellReuseIdentifier: AIBotVoiceCell.reuseID)
        tableView.register(AIBotActionCell.self, forCellReuseIdentifier: AIBotActionCell.reuseID)
        tableView.register(AIBotChoiceCell.self, forCellReuseIdentifier: AIBotChoiceCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(tableView, belowSubview: inputContainer)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: -6)
        ])
    }

    private func buildLoading() {
        loadingView.hidesWhenStopped = true
        loadingView.color = AIBotTheme.blue
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: -14)
        ])
    }

    // MARK: - Messaging

    private func appendSequentially(_ toSend: [AIBotMessage], index: Int = 0) {
        guard index < toSend.count else { return }
        let delay = index == 0 ? 0.15 : 0.55
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            self.append(toSend[index])
            self.appendSequentially(toSend, index: index + 1)
        }
    }

    private func append(_ message: AIBotMessage) {
        messages.append(message)
        tableView.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .fade)
        scrollToBottom()
    }

    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let last = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: last, at: .bottom, animated: true)
    }

    private func setInputVisible(_ visible: Bool, animated: Bool = true) {
        inputHeightConstraint.constant = visible ? 52 : 0
        if !visible { textField.resignFirstResponder() }
        let apply = {
            self.inputContainer.alpha = visible ? 1 : 0
            self.view.layoutIfNeeded()
        }
        if animated { UIView.animate(withDuration: 0.2, animations: apply) } else { apply() }
    }

    // MARK: - Actions

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func textChanged() {
        updateActionButton()
    }

    private var hasText: Bool {
        !(textField.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func updateActionButton() {
        if hasText {
            actionButton.backgroundColor = AIBotTheme.teal
            actionButton.setImage(AIBotIcon.symbol("paperplane.fill", pointSize: 18, bold: true), for: .normal)
        } else {
            actionButton.backgroundColor = AIBotTheme.blue
            actionButton.setImage(AIBotIcon.symbol("mic.fill", pointSize: 18, bold: true), for: .normal)
        }
    }

    @objc private func didTapAction() {
        if isRecording {
            stopRecordingAndSend()
        } else if hasText {
            let text = (textField.text ?? "").trimmingCharacters(in: .whitespaces)
            textField.text = ""
            updateActionButton()
            append(.userText(text))
            coordinator.submitAnswer(text)
        } else if coordinator.expectsUserAnswer {
            // Empty state = mic → record a voice clip (uploaded to speech-to-text).
            startRecording()
        }
    }

    // MARK: - Recording

    private func startRecording() {
        AIBotAudioRecorder.requestPermission { [weak self] granted in
            guard let self = self, granted else { return }
            do {
                try self.recorder.start()
                self.enterRecordingUI()
            } catch {
                self.exitRecordingUI()
            }
        }
    }

    private func stopRecordingAndSend() {
        let url = recorder.stop()
        exitRecordingUI()
        guard let fileURL = url else { return }
        let duration = AIBotAudioPlayer.durationString(for: fileURL)
        append(.userAudio(url: fileURL, duration: duration))
        coordinator.submitVoiceRecording(fileURL: fileURL)
    }

    @objc private func cancelRecording() {
        recorder.cancel()
        exitRecordingUI()
    }

    private func enterRecordingUI() {
        isRecording = true
        recordSeconds = 0
        recordTimerLabel.text = "0:00"
        fieldView.isHidden = true
        recordingBar.isHidden = false
        actionButton.backgroundColor = AIBotTheme.teal
        actionButton.setImage(AIBotIcon.symbol("arrow.up", pointSize: 18, bold: true), for: .normal)
        recordTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordSeconds += 1
            self.recordTimerLabel.text = String(format: "%d:%02d", self.recordSeconds / 60, self.recordSeconds % 60)
            if self.recordSeconds >= 60 { self.stopRecordingAndSend() } // cap like Android
        }
    }

    private func exitRecordingUI() {
        isRecording = false
        recordTimer?.invalidate()
        recordTimer = nil
        fieldView.isHidden = false
        recordingBar.isHidden = true
        updateActionButton()
    }

    private func presentVoiceMode(lang: String, autoListen: Bool) {
        guard voiceMode == nil else {
            if autoListen { voiceMode?.startListening() }
            return
        }
        let localeId = (lang == "ar") ? "ar-SA" : "en-US"
        let vc = AIBotVoiceModeViewController(localeId: localeId)
        vc.delegate = self
        voiceMode = vc
        present(vc, animated: true) {
            if autoListen { vc.startListening() }
        }
    }

    // MARK: - Keyboard

    private func registerKeyboardObservers() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: .UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    @objc private func keyboardWillChange(_ note: Notification) {
        guard let info = note.userInfo,
              let endFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25

        let keyboardFrameInView = view.convert(endFrame, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardFrameInView.minY)
        let hiding = note.name == .UIKeyboardWillHide || overlap == 0

        isKeyboardVisible = !hiding
        inputBottomConstraint.constant = hiding ? -(view.safeAreaInsets.bottom + 8) : -(overlap + 8)

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        DispatchQueue.main.async { self.scrollToBottom() }
    }
}

// MARK: - Coordinator delegate

extension AIBotChatViewController: AIBotChatCoordinatorDelegate {

    func coordinator(_ coordinator: AIBotChatCoordinator, didAdd messages: [AIBotMessage]) {
        appendSequentially(messages)
    }

    func coordinatorDidStartLoading(_ coordinator: AIBotChatCoordinator) {
        loadingView.startAnimating()
    }

    func coordinatorDidStopLoading(_ coordinator: AIBotChatCoordinator) {
        loadingView.stopAnimating()
    }

    func coordinator(_ coordinator: AIBotChatCoordinator, setInputVisible visible: Bool) {
        setInputVisible(visible)
    }

    func coordinator(_ coordinator: AIBotChatCoordinator, openDoctorSearchForSpecialty code: String?) {
        // TODO (book-doctor phase): pass the specialty filter into the search.
        voiceMode?.closeMode()
        voiceMode = nil
        navigationController?.pushViewController(DoctorsSearchViewController(), animated: true)
    }

    func coordinator(_ coordinator: AIBotChatCoordinator, didRequestVoiceModeWithLang lang: String) {
        // Bot speaks the opener first; we start listening once it finishes.
        presentVoiceMode(lang: lang, autoListen: false)
    }

    func coordinatorDidFinishSpeaking(_ coordinator: AIBotChatCoordinator) {
        guard let voiceMode = voiceMode else { return }
        if coordinator.expectsUserAnswer {
            voiceMode.startListening()
        } else {
            voiceMode.closeMode()
            self.voiceMode = nil
        }
    }
}

// MARK: - Voice mode delegate

extension AIBotChatViewController: AIBotVoiceModeDelegate {

    func voiceMode(_ controller: AIBotVoiceModeViewController, didRecognize text: String) {
        controller.setSpeaking()
        append(.userText(text))
        coordinator.submitAnswer(text)
    }

    func voiceModeDidClose(_ controller: AIBotVoiceModeViewController) {
        voiceMode = nil
        setInputVisible(true)
    }
}

// MARK: - UITableView

extension AIBotChatViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        switch message.kind {
        case .text(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: AIBotTextBubbleCell.reuseID, for: indexPath) as! AIBotTextBubbleCell
            cell.configure(text: text, sender: message.sender)
            return cell
        case .audio(let url, let duration):
            let cell = tableView.dequeueReusableCell(withIdentifier: AIBotVoiceCell.reuseID, for: indexPath) as! AIBotVoiceCell
            cell.configure(url: url, duration: duration, sender: message.sender)
            return cell
        case .action(let title, let specialtyCode):
            let cell = tableView.dequeueReusableCell(withIdentifier: AIBotActionCell.reuseID, for: indexPath) as! AIBotActionCell
            cell.configure(title: title) { [weak self] in
                self?.coordinator.openRecommendedDoctorSearch(specialtyCode: specialtyCode)
            }
            return cell
        case .choices(let options):
            let cell = tableView.dequeueReusableCell(withIdentifier: AIBotChoiceCell.reuseID, for: indexPath) as! AIBotChoiceCell
            cell.configure(options: options) { [weak self] choice in
                self?.coordinator.handleChoice(choice)
            }
            return cell
        }
    }
}

// MARK: - UITextFieldDelegate

extension AIBotChatViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if hasText { didTapAction() }
        return true
    }
}
