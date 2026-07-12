//
//  AIBotStrings.swift
//  CareMate
//
//  Centralized localized copy for the AI Bot feature.
//

import UIKit

/// Colors used across the AI Bot feature, taken from the design.
enum AIBotTheme {
    static let headerIndigo = UIColor.fromHex(hex: "#2E3192", alpha: 1)
    static let teal = UIColor.fromHex(hex: "#29A69A", alpha: 1)
    static let voiceIndigo = UIColor.fromHex(hex: "#2E3192", alpha: 1)
    static let titleGray = UIColor.fromHex(hex: "#7C7C93", alpha: 1)
    static let bodyGray = UIColor.fromHex(hex: "#9A9AAE", alpha: 1)
}

enum AIBotStrings {

    static var assistantTitle: String {
        UserManager.isArabic ? "المساعد الذكي" : "Chat Voice"
    }

    static var brandVoice: String { "Voice" }
    static var brandDoc: String { "Doc" }

    static var brandSubtitle: String {
        UserManager.isArabic ? "المساعد" : "Assistance"
    }

    static var onboardingDescription: String {
        UserManager.isArabic
            ? "مساعد صحي ذكي يستقبل الأعراض عبر الصوت، ويحوّلها إلى نص، ويساعدك في الوصول إلى الأخصائي المناسب."
            : "AI health assistant that can take symptoms through voice input, convert them to text, and help users find the most suitable specialist."
    }

    static var startChat: String {
        UserManager.isArabic ? "ابدأ المحادثة" : "Start Chat"
    }
}
