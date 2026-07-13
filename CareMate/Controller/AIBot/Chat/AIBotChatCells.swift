//
//  AIBotChatCells.swift
//  CareMate
//
//  Table cells for the AI bot chat: bot/user text bubbles, a user voice note
//  and a tappable recommendation card.
//

import UIKit

// MARK: - Icon helper

enum AIBotIcon {
    static func symbol(_ name: String, pointSize: CGFloat, bold: Bool = false) -> UIImage? {
        if #available(iOS 13.0, *) {
            let weight: UIImage.SymbolWeight = bold ? .semibold : .regular
            let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
            return UIImage(systemName: name, withConfiguration: config)
        }
        return nil
    }
}

// MARK: - Avatars

private func makeBotAvatar() -> UIImageView {
    let iv = UIImageView(image: UIImage(named: "aibot_icon"))
    iv.contentMode = .scaleAspectFit
    iv.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        iv.widthAnchor.constraint(equalToConstant: 30),
        iv.heightAnchor.constraint(equalToConstant: 30)
    ])
    return iv
}

private func makeUserAvatar() -> UIView {
    let container = UIView()
    container.backgroundColor = AIBotTheme.avatarBackground
    container.layer.cornerRadius = 15
    container.translatesAutoresizingMaskIntoConstraints = false
    let iv = UIImageView(image: AIBotIcon.symbol("person.fill", pointSize: 14))
    iv.tintColor = AIBotTheme.blue
    iv.contentMode = .scaleAspectFit
    iv.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(iv)
    NSLayoutConstraint.activate([
        container.widthAnchor.constraint(equalToConstant: 30),
        container.heightAnchor.constraint(equalToConstant: 30),
        iv.centerXAnchor.constraint(equalTo: container.centerXAnchor),
        iv.centerYAnchor.constraint(equalTo: container.centerYAnchor)
    ])
    return container
}

// MARK: - Text bubble cell (bot or user)

final class AIBotTextBubbleCell: UITableViewCell {

    static let reuseID = "AIBotTextBubbleCell"

    private let avatar = UIView()
    private let bubble = UIView()
    private let label = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        bubble.layer.cornerRadius = 16
        bubble.translatesAutoresizingMaskIntoConstraints = false

        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textColor = AIBotTheme.bubbleText
        label.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(bubble)
        bubble.addSubview(label)

        NSLayoutConstraint.activate([
            bubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            bubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            bubble.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.72),

            label.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -12),
            label.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -14)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private var sideConstraints: [NSLayoutConstraint] = []

    func configure(text: String, sender: AIBotSender) {
        label.text = text

        // reset previous avatar + side constraints
        avatar.subviews.forEach { $0.removeFromSuperview() }
        avatar.removeFromSuperview()
        NSLayoutConstraint.deactivate(sideConstraints)

        let avatarView: UIView = (sender == .bot) ? makeBotAvatar() : makeUserAvatar()
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarView)

        if sender == .bot {
            bubble.backgroundColor = AIBotTheme.botBubble
            sideConstraints = [
                avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                avatarView.topAnchor.constraint(equalTo: bubble.topAnchor),
                bubble.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8)
            ]
        } else {
            bubble.backgroundColor = AIBotTheme.userBubble
            sideConstraints = [
                avatarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                avatarView.topAnchor.constraint(equalTo: bubble.topAnchor),
                bubble.trailingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: -8)
            ]
        }
        NSLayoutConstraint.activate(sideConstraints)
    }
}

// MARK: - Audio bubble cell (bot TTS or user voice note)

final class AIBotVoiceCell: UITableViewCell {

    static let reuseID = "AIBotVoiceCell"

    private let pill = UIView()
    private let playButton = UIButton(type: .system)
    private let waveform = AIBotWaveformView()
    private let durationLabel = UILabel()
    private var avatarView = UIView()
    private var url: URL?
    private var sideConstraints: [NSLayoutConstraint] = []

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        pill.backgroundColor = AIBotTheme.voiceBubble
        pill.layer.cornerRadius = 26
        pill.translatesAutoresizingMaskIntoConstraints = false

        playButton.backgroundColor = .white
        playButton.layer.cornerRadius = 18
        playButton.tintColor = AIBotTheme.voiceBubble
        playButton.setImage(AIBotIcon.symbol("play.fill", pointSize: 14, bold: true), for: .normal)
        playButton.addTarget(self, action: #selector(togglePlay), for: .touchUpInside)
        playButton.translatesAutoresizingMaskIntoConstraints = false

        waveform.translatesAutoresizingMaskIntoConstraints = false

        durationLabel.textColor = .white
        durationLabel.font = .systemFont(ofSize: 12, weight: .medium)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(pill)
        pill.addSubview(playButton)
        pill.addSubview(waveform)
        pill.addSubview(durationLabel)

        NSLayoutConstraint.activate([
            pill.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            pill.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            pill.heightAnchor.constraint(equalToConstant: 52),

            playButton.leadingAnchor.constraint(equalTo: pill.leadingAnchor, constant: 8),
            playButton.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 36),
            playButton.heightAnchor.constraint(equalToConstant: 36),

            waveform.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 10),
            waveform.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            waveform.heightAnchor.constraint(equalToConstant: 24),
            waveform.widthAnchor.constraint(equalToConstant: 130),

            durationLabel.leadingAnchor.constraint(equalTo: waveform.trailingAnchor, constant: 8),
            durationLabel.trailingAnchor.constraint(equalTo: pill.trailingAnchor, constant: -14),
            durationLabel.centerYAnchor.constraint(equalTo: pill.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(url: URL?, duration: String, sender: AIBotSender) {
        self.url = url
        durationLabel.text = duration

        avatarView.removeFromSuperview()
        NSLayoutConstraint.deactivate(sideConstraints)

        let avatar: UIView = (sender == .bot) ? makeBotAvatar() : makeUserAvatar()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatar)
        avatarView = avatar

        if sender == .bot {
            sideConstraints = [
                avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                avatar.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
                pill.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 8),
                pill.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50)
            ]
        } else {
            sideConstraints = [
                avatar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                avatar.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
                pill.trailingAnchor.constraint(equalTo: avatar.leadingAnchor, constant: -8),
                pill.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 50)
            ]
        }
        NSLayoutConstraint.activate(sideConstraints)
        updatePlayIcon()
    }

    @objc private func togglePlay() {
        guard let url = url else { return }
        if AIBotAudioPlayer.shared.currentURL == url && AIBotAudioPlayer.shared.isPlaying {
            AIBotAudioPlayer.shared.stop()
        } else {
            AIBotAudioPlayer.shared.play(url: url) { [weak self] in self?.updatePlayIcon() }
        }
        updatePlayIcon()
    }

    private func updatePlayIcon() {
        let playing = url != nil && AIBotAudioPlayer.shared.currentURL == url && AIBotAudioPlayer.shared.isPlaying
        playButton.setImage(AIBotIcon.symbol(playing ? "pause.fill" : "play.fill", pointSize: 14, bold: true), for: .normal)
    }
}

// MARK: - Recommendation / action card (bot)

final class AIBotActionCell: UITableViewCell {

    static let reuseID = "AIBotActionCell"

    private let card = UIView()
    private let titleLabel = UILabel()
    private let iconView = UIImageView()
    private var onTap: (() -> Void)?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        card.backgroundColor = .white
        card.layer.cornerRadius = 26
        card.layer.borderWidth = 1
        card.layer.borderColor = AIBotTheme.cardBorder.cgColor
        card.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = AIBotTheme.voiceIndigo
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        iconView.image = AIBotIcon.symbol("magnifyingglass", pointSize: 17, bold: true)
        iconView.tintColor = AIBotTheme.blue
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(card)
        card.addSubview(titleLabel)
        card.addSubview(iconView)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            card.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -40),
            card.heightAnchor.constraint(equalToConstant: 52),

            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),

            iconView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            iconView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            iconView.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])

        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(title: String, onTap: @escaping () -> Void) {
        titleLabel.text = title
        self.onTap = onTap
    }

    @objc private func didTap() { onTap?() }
}

// MARK: - Choice buttons cell (bot)

final class AIBotChoiceCell: UITableViewCell {

    static let reuseID = "AIBotChoiceCell"

    private let stack = UIStackView()
    private var options: [AIBotChoice] = []
    private var onSelect: ((AIBotChoice) -> Void)?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(options: [AIBotChoice], onSelect: @escaping (AIBotChoice) -> Void) {
        self.options = options
        self.onSelect = onSelect
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, option) in options.enumerated() {
            let button = UIButton(type: .system)
            button.tag = index
            button.setTitle("  \(option.title)  ", for: .normal)
            button.setTitleColor(AIBotTheme.voiceIndigo, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            button.backgroundColor = .white
            button.layer.cornerRadius = 22
            button.layer.borderWidth = 1
            button.layer.borderColor = AIBotTheme.blue.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
    }

    @objc private func didTap(_ sender: UIButton) {
        guard sender.tag < options.count else { return }
        onSelect?(options[sender.tag])
    }
}

// MARK: - Waveform

/// Simple static voice waveform (white bars) used inside the voice pill.
final class AIBotWaveformView: UIView {

    private let heights: [CGFloat] = [
        6, 10, 16, 22, 14, 8, 12, 20, 24, 18, 10, 6, 12, 16, 22, 14,
        8, 12, 18, 10, 6, 14, 20, 16, 10, 8, 12, 6, 10, 16, 12, 8
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isOpaque = false
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setFillColor(UIColor.white.cgColor)
        let barWidth: CGFloat = 2
        let gap: CGFloat = 2.6
        let midY = rect.height / 2
        var x: CGFloat = 0
        var i = 0
        while x < rect.width {
            let h = heights[i % heights.count]
            let bar = CGRect(x: x, y: midY - h / 2, width: barWidth, height: h)
            let path = UIBezierPath(roundedRect: bar, cornerRadius: barWidth / 2)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
            x += barWidth + gap
            i += 1
        }
    }
}
