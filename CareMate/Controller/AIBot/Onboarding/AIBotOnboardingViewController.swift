//
//  AIBotOnboardingViewController.swift
//  CareMate
//
//  Entry / onboarding screen for the AI Bot ("VoiceDoc Assistance") feature.
//  Opened from the AI bot icon in the home header. Matches the "Chat Voice"
//  design: indigo header, hero illustration, VoiceDoc wordmark, description
//  and a teal "Start Chat" call to action.
//

import UIKit

final class AIBotOnboardingViewController: BaseViewController {

    // MARK: - UI

    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)

    private let illustrationView = UIImageView()
    private let wordmarkLabel = UILabel()
    private let assistanceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startChatButton = UIButton(type: .custom)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        AIBotStrings.overrideLang = nil // follow app language until a chat language is picked
        view.backgroundColor = .white
        buildHeader()
        buildContent()
        buildStartButton()
        applyContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // The home screen hides the navigation bar; keep it hidden here since
        // we use a custom colored header, and back is handled by our button.
        navigationController?.navigationBar.isHidden = true
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
        backButton.setImage(Self.backChevron(), for: .normal)
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

    private func buildContent() {
        illustrationView.image = UIImage(named: "aibot_onboarding")
        illustrationView.contentMode = .scaleAspectFit
        illustrationView.translatesAutoresizingMaskIntoConstraints = false

        wordmarkLabel.textAlignment = .center
        wordmarkLabel.translatesAutoresizingMaskIntoConstraints = false

        assistanceLabel.textAlignment = .center
        assistanceLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = AIBotTheme.bodyGray
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [illustrationView, wordmarkLabel, assistanceLabel, descriptionLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.setCustomSpacing(24, after: illustrationView)
        stack.setCustomSpacing(14, after: assistanceLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stack.topAnchor.constraint(greaterThanOrEqualTo: headerView.bottomAnchor, constant: 16),

            illustrationView.heightAnchor.constraint(equalToConstant: 240),
            illustrationView.widthAnchor.constraint(equalToConstant: 260)
        ])
    }

    private func buildStartButton() {
        startChatButton.backgroundColor = AIBotTheme.teal
        startChatButton.setTitle(AIBotStrings.startChat, for: .normal)
        startChatButton.setTitleColor(.white, for: .normal)
        startChatButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        startChatButton.setImage(UIImage(named: "aibot_chat_bubble"), for: .normal)
        startChatButton.imageView?.contentMode = .scaleAspectFit
        startChatButton.layer.cornerRadius = 27
        startChatButton.translatesAutoresizingMaskIntoConstraints = false
        // small gap between icon and title
        let spacing: CGFloat = 8
        startChatButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
        startChatButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
        startChatButton.addTarget(self, action: #selector(didTapStartChat), for: .touchUpInside)
        view.addSubview(startChatButton)

        NSLayoutConstraint.activate([
            startChatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            startChatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            startChatButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startChatButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }

    private func applyContent() {
        // "VoiceDoc" wordmark: "Voice" indigo + "Doc" teal.
        let wordmark = NSMutableAttributedString(
            string: AIBotStrings.brandVoice,
            attributes: [
                .foregroundColor: AIBotTheme.voiceIndigo,
                .font: UIFont.systemFont(ofSize: 26, weight: .bold)
            ]
        )
        wordmark.append(NSAttributedString(
            string: AIBotStrings.brandDoc,
            attributes: [
                .foregroundColor: AIBotTheme.teal,
                .font: UIFont.systemFont(ofSize: 26, weight: .bold)
            ]
        ))
        wordmarkLabel.attributedText = wordmark

        assistanceLabel.attributedText = NSAttributedString(
            string: AIBotStrings.brandSubtitle,
            attributes: [
                .foregroundColor: AIBotTheme.titleGray,
                .font: UIFont.systemFont(ofSize: 13, weight: .medium),
                .kern: 3.0
            ]
        )

        descriptionLabel.text = AIBotStrings.onboardingDescription
    }

    // MARK: - Actions

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapStartChat() {
        navigationController?.pushViewController(AIBotChatViewController(), animated: true)
    }

    // MARK: - Helpers

    private static func backChevron() -> UIImage? {
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
            return UIImage(systemName: "chevron.left", withConfiguration: config)
        }
        return UIImage(named: "back")
    }
}
