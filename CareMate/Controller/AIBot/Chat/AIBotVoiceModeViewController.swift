//
//  AIBotVoiceModeViewController.swift
//  CareMate
//
//  Full-screen "live voice" overlay: listens with on-device speech recognition,
//  shows the partial transcript, and reflects when the bot is speaking. Mirrors
//  the Android VoiceAiLiveBottomSheet.
//

import UIKit

protocol AIBotVoiceModeDelegate: AnyObject {
    func voiceMode(_ controller: AIBotVoiceModeViewController, didRecognize text: String)
    func voiceModeDidClose(_ controller: AIBotVoiceModeViewController)
}

final class AIBotVoiceModeViewController: UIViewController {

    weak var delegate: AIBotVoiceModeDelegate?

    private let recognizer: AIBotSpeechRecognizer
    private var authorized = false
    private var wantsToListen = false

    private let pulseView = UIView()
    private let micCircle = UIView()
    private let micImageView = UIImageView()
    private let robotImageView = UIImageView()
    private let statusLabel = UILabel()
    private let transcriptLabel = UILabel()
    private let closeButton = UIButton(type: .system)

    init(localeId: String) {
        recognizer = AIBotSpeechRecognizer(localeId: localeId)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        wireRecognizer()
        setSpeaking() // bot speaks first; we start listening when asked to.

        AIBotSpeechRecognizer.requestAuthorization { [weak self] granted in
            guard let self = self else { return }
            self.authorized = granted
            if !granted {
                self.statusLabel.text = AIBotStrings.voicePermissionDenied
            } else if self.wantsToListen {
                self.startListening()
            }
        }
    }

    // MARK: - Public control

    func startListening() {
        wantsToListen = true
        guard authorized else { return }
        statusLabel.text = AIBotStrings.voiceListening
        transcriptLabel.text = ""
        showListeningVisuals(true)
        startPulse()
        recognizer.start()
    }

    /// Bot is talking — pause listening and reflect it.
    func setSpeaking() {
        wantsToListen = false
        recognizer.stop()
        stopPulse()
        showListeningVisuals(false)
        statusLabel.text = AIBotStrings.voiceSpeaking
    }

    func closeMode() {
        recognizer.stop()
        dismiss(animated: true)
    }

    // MARK: - Recognizer

    private func wireRecognizer() {
        recognizer.onPartial = { [weak self] text in
            self?.transcriptLabel.text = text
        }
        recognizer.onResult = { [weak self] text in
            guard let self = self else { return }
            self.stopPulse()
            self.statusLabel.text = AIBotStrings.voiceSpeaking
            self.delegate?.voiceMode(self, didRecognize: text)
        }
        recognizer.onError = { [weak self] in
            self?.stopPulse()
            self?.statusLabel.text = AIBotStrings.voiceListening
        }
    }

    // MARK: - UI

    private func buildUI() {
        view.backgroundColor = .white

        closeButton.setImage(AIBotIcon.symbol("xmark", pointSize: 18, bold: true), for: .normal)
        closeButton.tintColor = AIBotTheme.headerIndigo
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        // Robot shown while the bot is speaking.
        robotImageView.image = UIImage(named: "aibot_avatar")
        robotImageView.contentMode = .scaleAspectFit
        robotImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(robotImageView)

        // Blue mic circle + halo shown while listening.
        pulseView.backgroundColor = AIBotTheme.blue.withAlphaComponent(0.18)
        pulseView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pulseView)

        micCircle.backgroundColor = AIBotTheme.blue
        micCircle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(micCircle)

        micImageView.image = AIBotIcon.symbol("mic.fill", pointSize: 34, bold: true)
        micImageView.tintColor = .white
        micImageView.contentMode = .scaleAspectFit
        micImageView.translatesAutoresizingMaskIntoConstraints = false
        micCircle.addSubview(micImageView)

        statusLabel.textColor = AIBotTheme.headerIndigo
        statusLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        statusLabel.textAlignment = .center
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)

        transcriptLabel.textColor = AIBotTheme.bodyGray
        transcriptLabel.font = .systemFont(ofSize: 16)
        transcriptLabel.textAlignment = .center
        transcriptLabel.numberOfLines = 0
        transcriptLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(transcriptLabel)

        pulseView.layer.cornerRadius = 80
        micCircle.layer.cornerRadius = 50

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),

            micCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            micCircle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            micCircle.widthAnchor.constraint(equalToConstant: 100),
            micCircle.heightAnchor.constraint(equalToConstant: 100),

            pulseView.centerXAnchor.constraint(equalTo: micCircle.centerXAnchor),
            pulseView.centerYAnchor.constraint(equalTo: micCircle.centerYAnchor),
            pulseView.widthAnchor.constraint(equalToConstant: 160),
            pulseView.heightAnchor.constraint(equalToConstant: 160),

            micImageView.centerXAnchor.constraint(equalTo: micCircle.centerXAnchor),
            micImageView.centerYAnchor.constraint(equalTo: micCircle.centerYAnchor),

            robotImageView.centerXAnchor.constraint(equalTo: micCircle.centerXAnchor),
            robotImageView.centerYAnchor.constraint(equalTo: micCircle.centerYAnchor),
            robotImageView.widthAnchor.constraint(equalToConstant: 150),
            robotImageView.heightAnchor.constraint(equalToConstant: 150),

            statusLabel.topAnchor.constraint(equalTo: pulseView.bottomAnchor, constant: 40),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            transcriptLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            transcriptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            transcriptLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    private func showListeningVisuals(_ listening: Bool) {
        micCircle.isHidden = !listening
        micImageView.isHidden = !listening
        pulseView.isHidden = !listening
        robotImageView.isHidden = listening
    }

    private func startPulse() {
        pulseView.layer.removeAnimation(forKey: "pulse")
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.8
        animation.toValue = 1.25
        animation.duration = 0.9
        animation.autoreverses = true
        animation.repeatCount = .infinity
        pulseView.layer.add(animation, forKey: "pulse")
    }

    private func stopPulse() {
        pulseView.layer.removeAnimation(forKey: "pulse")
    }

    @objc private func didTapClose() {
        recognizer.stop()
        delegate?.voiceModeDidClose(self)
        dismiss(animated: true)
    }
}
