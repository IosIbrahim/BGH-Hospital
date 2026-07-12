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

    // Chat screen
    static let chatBackground = UIColor.white
    static let botBubble = UIColor.fromHex(hex: "#E9F1FE", alpha: 1)
    static let userBubble = UIColor.fromHex(hex: "#D8F0EA", alpha: 1)
    static let voiceBubble = UIColor.fromHex(hex: "#3D5CF0", alpha: 1)
    static let bubbleText = UIColor.fromHex(hex: "#2B2B3A", alpha: 1)
    static let blue = UIColor.fromHex(hex: "#3D5CF0", alpha: 1)
    static let inputBorder = UIColor.fromHex(hex: "#ECECF3", alpha: 1)
    static let avatarBackground = UIColor.fromHex(hex: "#EFF1FB", alpha: 1)
    static let cardBorder = UIColor.fromHex(hex: "#DADCF2", alpha: 1)
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

    // MARK: - Chat

    static var inputPlaceholder: String {
        UserManager.isArabic ? "اكتب الأعراض هنا..." : "Type your symptoms here..."
    }

    static var chatGreeting: String {
        UserManager.isArabic
            ? "مرحباً! أنا مساعد الأعراض. كيف يمكنني مساعدتك اليوم؟"
            : "Hello! I'm your Symptom Assistant. How can I help you today?"
    }

    static var chatDescribeSymptoms: String {
        UserManager.isArabic
            ? "هل يمكنك وصف الأعراض بالتفصيل؟"
            : "Can you describe your symptoms in detail?"
    }

    /// Bot repeating back what it "heard".
    static func chatHeard(_ text: String) -> String {
        UserManager.isArabic
            ? "سمعت: \"\(text)\". هل هذا صحيح؟"
            : "I heard: \"\(text)\". Is this correct?"
    }

    static var chatReplyTrueFalse: String {
        UserManager.isArabic
            ? "من فضلك أجب بـ 'true' أو 'false'."
            : "Please reply with 'true' or 'false'."
    }

    static var chatAnalyzing: String {
        UserManager.isArabic ? "دعني أحلل الأعراض ..." : "Let me analyze your symptoms ..."
    }

    static func chatRecommend(_ specialty: String) -> String {
        UserManager.isArabic
            ? "بناءً على أعراضك، أنصح بزيارة \(specialty)."
            : "Based on your symptoms, I recommend seeing a \(specialty)."
    }

    static func chatFindBest(_ specialty: String) -> String {
        UserManager.isArabic ? "ابحث عن أفضل \(specialty) الآن" : "Find Best \(specialty) Now"
    }

    // Demo (frontend-only) content used until the backend is wired.
    static var demoHeadache: String {
        UserManager.isArabic ? "لدي صداع" : "I have a headache"
    }

    static var demoSpecialty: String {
        UserManager.isArabic ? "طبيب أعصاب" : "Neurologist"
    }

    static var demoYes: String {
        UserManager.isArabic ? "نعم" : "Yes"
    }
}
