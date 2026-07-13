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

/// A tappable button shown inside a bot message (language pick, service type,
/// "find specific doctor?" yes/no, …).
struct AIBotChoice {
    enum Tag {
        case language(String)      // "ar" / "en"
        case service(bookDoctor: Bool)
        case findDoctor(Bool)      // yes / no
    }
    let title: String
    let tag: Tag
}

struct AIBotMessage {

    enum Kind {
        /// Plain text bubble (bot or user).
        case text(String)
        /// A recorded voice note from the user (duration like "1:07").
        case voice(duration: String)
        /// Recommendation card, e.g. "Find Best Neurologist Now".
        case action(title: String, specialtyCode: String?)
        /// One or more choice buttons shown by the bot.
        case choices(options: [AIBotChoice])
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

    static func botAction(title: String, specialtyCode: String?) -> AIBotMessage {
        AIBotMessage(sender: .bot, kind: .action(title: title, specialtyCode: specialtyCode))
    }

    static func botChoices(_ options: [AIBotChoice]) -> AIBotMessage {
        AIBotMessage(sender: .bot, kind: .choices(options: options))
    }
}
