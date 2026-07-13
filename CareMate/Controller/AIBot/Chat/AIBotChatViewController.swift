//
//  AIBotChatViewController.swift
//  CareMate
//
//  The "Chat Voice" symptom-assistant conversation screen. UI + scripted
//  flow only; speech-to-text and the recommendation backend are wired later.
//

import UIKit
import IQKeyboardManagerSwift

final class AIBotChatViewController: BaseViewController {

    // MARK: - State

    private let engine = AIBotConversationEngine()
    private var messages: [AIBotMessage] = []
    private let demoVoiceDuration = "1:07"

    // MARK: - UI

    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)

    private let tableView = UITableView(frame: .zero, style: .plain)

    private let inputContainer = UIView()
    private let textField = UITextField()
    private let actionButton = UIButton(type: .custom)
    private var inputBottomConstraint: NSLayoutConstraint!
    private var isKeyboardVisible = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AIBotTheme.chatBackground
        buildHeader()
        buildInputBar()
        buildTableView()
        registerKeyboardObservers()
        updateActionButton()

        // Kick off the conversation.
        appendSequentially(engine.start())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        // This screen manages the keyboard itself (custom input bar). Turn off
        // IQKeyboardManager here so it doesn't push the whole view up or add its
        // toolbar above the keyboard.
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
        // Keep the input bar resting above the home indicator when no keyboard.
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

        let field = UIView()
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

        NSLayoutConstraint.activate([
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputBottomConstraint,
            inputContainer.heightAnchor.constraint(equalToConstant: 52),

            field.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor),
            field.topAnchor.constraint(equalTo: inputContainer.topAnchor),
            field.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor),
            field.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -10),

            textField.leadingAnchor.constraint(equalTo: field.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: field.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: field.topAnchor),
            textField.bottomAnchor.constraint(equalTo: field.bottomAnchor),

            actionButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor),
            actionButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 52),
            actionButton.heightAnchor.constraint(equalToConstant: 52)
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(tableView, belowSubview: inputContainer)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: -6)
        ])
    }

    // MARK: - Messaging

    /// Appends bot messages one-by-one with a short "typing" delay.
    private func appendSequentially(_ toSend: [AIBotMessage], index: Int = 0) {
        guard index < toSend.count else { return }
        let delay = index == 0 ? 0.25 : 0.7
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

    private func handleUser(_ message: AIBotMessage) {
        append(message)
        appendSequentially(engine.reply(to: message))
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
        if hasText {
            let text = (textField.text ?? "").trimmingCharacters(in: .whitespaces)
            textField.text = ""
            updateActionButton()
            handleUser(.userText(text))
        } else {
            // No backend yet: simulate a recorded voice note.
            handleUser(.userVoice(duration: demoVoiceDuration))
        }
    }

    private func openFindDoctor(specialty: String) {
        navigationController?.pushViewController(DoctorsSearchViewController(), animated: true)
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

        // How much of the view the keyboard actually covers (in this view's space).
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
        case .voice(let duration):
            let cell = tableView.dequeueReusableCell(withIdentifier: AIBotVoiceCell.reuseID, for: indexPath) as! AIBotVoiceCell
            cell.configure(duration: duration)
            return cell
        case .action(let title, let specialty):
            let cell = tableView.dequeueReusableCell(withIdentifier: AIBotActionCell.reuseID, for: indexPath) as! AIBotActionCell
            cell.configure(title: title) { [weak self] in
                self?.openFindDoctor(specialty: specialty)
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
