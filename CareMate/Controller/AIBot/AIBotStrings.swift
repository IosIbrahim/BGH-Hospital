//
//  AIBotStrings.swift
//  CareMate
//
//  Centralized localized copy for the AI Bot feature.
//

import Foundation

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
