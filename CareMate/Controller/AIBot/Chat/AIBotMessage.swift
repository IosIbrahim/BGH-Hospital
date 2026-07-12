//
//  AIBotMessage.swift
//  CareMate
//
//  Model for a single message in the AI bot conversation.
//

import Foundation

enum AIBotSender {
    case bot
    case user
}

struct AIBotMessage {

    enum Kind {
        /// Plain text bubble (bot or user).
        case text(String)
        /// A recorded voice note from the user (duration like "1:07").
        case voice(duration: String)
        /// A tappable suggestion / call-to-action shown by the bot
        /// (e.g. "Find Best Neurologist Now"). `specialty` is passed through
        /// so the handler knows what to search for.
        case action(title: String, specialty: String)
    }

    let sender: AIBotSender
    let kind: Kind

    // Convenience builders
    static func botText(_ text: String) -> AIBotMessage {
        AIBotMessage(sender: .bot, kind: .text(text))
    }

    static func userText(_ text: String) -> AIBotMessage {
        AIBotMessage(sender: .user, kind: .text(text))
    }

    static func userVoice(duration: String) -> AIBotMessage {
        AIBotMessage(sender: .user, kind: .voice(duration: duration))
    }

    static func botAction(title: String, specialty: String) -> AIBotMessage {
        AIBotMessage(sender: .bot, kind: .action(title: title, specialty: specialty))
    }
}
