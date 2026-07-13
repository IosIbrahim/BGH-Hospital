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

    /// Opening line before the first question.
    static var chatOpener: String {
        UserManager.isArabic ? "حسناً فلنبدأ." : "Okay, let's start."
    }

    /// Asked only in guest mode (we don't know the user's name).
    static var chatAskName: String {
        UserManager.isArabic ? "مرحبا، ما هو اسمك؟" : "Hello, what is your name?"
    }

    /// Greeting for a logged-in user, whose name we already have.
    static func chatGreetName(_ name: String) -> String {
        UserManager.isArabic ? "مرحباً \(name)!" : "Hello \(name)!"
    }

    static var chatAskAge: String {
        UserManager.isArabic ? "ما هو عمرك؟" : "What is your age?"
    }

    static var chatAskSymptoms: String {
        UserManager.isArabic
            ? "ما الأعراض التي تشعر بها؟"
            : "What are the symptoms you are experiencing?"
    }

    static var chatAnalyzing: String {
        UserManager.isArabic ? "شكراً، جارٍ تحليل الأعراض ..." : "Thanks, analyzing your symptoms ..."
    }

    static func chatRecommend(_ specialty: String) -> String {
        UserManager.isArabic
            ? "بناءً على أعراضك، أنصح بزيارة \(specialty)."
            : "Based on your symptoms, I recommend seeing a \(specialty)."
    }

    static func chatFindBest(_ specialty: String) -> String {
        UserManager.isArabic ? "ابحث عن أفضل \(specialty) الآن" : "Find Best \(specialty) Now"
    }

    // MARK: - Phase A: language / service / find doctor

    static var chatIntro: String {
        UserManager.isArabic
            ? "مرحباً! أنا مساعد الأعراض."
            : "Hello! I'm your Symptom Assistant."
    }

    static var chooseLanguage: String {
        UserManager.isArabic ? "اختر اللغة التي تريد التحدث بها" : "Select the language you need to discuss"
    }

    static var arabic: String { "العربية" }
    static var english: String { "English" }

    static var chooseService: String {
        UserManager.isArabic ? "اختر نوع الخدمة" : "Select Service Type"
    }

    static var bookByComplaint: String {
        UserManager.isArabic ? "حجز موعد بالشكوى" : "Book by Complaint"
    }

    static var bookBySpeciality: String {
        UserManager.isArabic ? "حجز موعد بالتخصص" : "Book by Speciality"
    }

    static var letsStart: String {
        UserManager.isArabic ? "حسناً فلنبدأ" : "Ok let's get started"
    }

    static func recommendSpecialty(_ specialty: String) -> String {
        UserManager.isArabic
            ? "بناءً على الأعراض الخاصة بك، أوصي بمراجعة \(specialty)"
            : "Based on your symptoms, I recommend seeing a \(specialty)"
    }

    static func findBestNow(_ specialty: String) -> String {
        UserManager.isArabic ? "اعثر على أفضل \(specialty) الآن" : "Find Best \(specialty) Now"
    }

    static var needSpecificDoctor: String {
        UserManager.isArabic ? "هل تريد المساعدة في الحصول على دكتور معين؟" : "Do you need help to get a specific doctor?"
    }

    static var yesNeedDoctor: String {
        UserManager.isArabic ? "نعم أحتاج طبيباً محدداً" : "Yes I Need Specific Doctor"
    }

    static var noSearchMyself: String {
        UserManager.isArabic ? "لا، سأبحث بنفسي" : "No I will search by self"
    }

    static var genericError: String {
        UserManager.isArabic
            ? "عذراً، لم أتمكن من فهم ردك. يُرجى المحاولة مرة أخرى."
            : "Sorry, I couldn't understand your reply. Please try again."
    }

    static var connectionError: String {
        UserManager.isArabic ? "تعذّر الاتصال بالخادم. حاول مرة أخرى." : "Couldn't reach the server. Please try again."
    }

    // MARK: - Voice mode

    static var voiceListening: String {
        UserManager.isArabic ? "🎤 تحدث الآن..." : "🎤 Listening..."
    }

    static var voiceSpeaking: String {
        UserManager.isArabic ? "المساعد يتحدث..." : "Assistant is speaking..."
    }

    static var voicePermissionDenied: String {
        UserManager.isArabic
            ? "يرجى السماح بالوصول إلى الميكروفون والتعرف على الكلام."
            : "Please allow microphone and speech recognition access."
    }

    // Placeholder used until the analysis endpoint is wired.
    static var demoSpecialty: String {
        UserManager.isArabic ? "طبيب أعصاب" : "Neurologist"
    }
}
