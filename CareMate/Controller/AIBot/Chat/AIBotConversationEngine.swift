//
//  AIBotConversationEngine.swift
//  CareMate
//
//  Frontend-only scripted conversation flow for the AI symptom assistant.
//  This mimics the design's happy path (symptom -> confirm -> recommendation)
//  with local canned responses. The real backend/NLP is wired later; the view
//  controller only talks to this engine, so swapping it out is isolated here.
//

import Foundation

final class AIBotConversationEngine {

    enum State {
        case greeting
        case awaitingSymptoms
        case awaitingConfirmation
        case done
    }

    private(set) var state: State = .greeting

    /// Opening bot messages shown when the chat appears.
    func start() -> [AIBotMessage] {
        state = .awaitingSymptoms
        return [
            .botText(AIBotStrings.chatGreeting),
            .botText(AIBotStrings.chatDescribeSymptoms)
        ]
    }

    /// Produces the bot's reply to a user message. Returns an empty array when
    /// there is nothing more to say in this scripted flow.
    func reply(to message: AIBotMessage) -> [AIBotMessage] {
        switch state {
        case .awaitingSymptoms:
            state = .awaitingConfirmation
            let heard = heardText(from: message)
            return [
                .botText(AIBotStrings.chatHeard(heard)),
                .botText(AIBotStrings.chatReplyTrueFalse)
            ]

        case .awaitingConfirmation:
            state = .done
            let specialty = AIBotStrings.demoSpecialty
            return [
                .botText(AIBotStrings.chatAnalyzing),
                .botText(AIBotStrings.chatRecommend(specialty)),
                .botAction(title: AIBotStrings.chatFindBest(specialty), specialty: specialty)
            ]

        case .greeting, .done:
            return []
        }
    }

    /// For a voice note we don't have real speech-to-text yet, so fall back to
    /// the demo transcript. For typed text we echo what the user wrote.
    private func heardText(from message: AIBotMessage) -> String {
        switch message.kind {
        case .text(let value):
            return value
        case .voice:
            return AIBotStrings.demoHeadache
        case .action:
            return AIBotStrings.demoHeadache
        }
    }
}
