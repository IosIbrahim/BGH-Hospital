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

    /// Set to the language the user picked in the chat ("ar"/"en"); overrides
    /// the app language for the conversation. nil = follow the app language.
    static var overrideLang: String?

    private static var isAr: Bool {
        if let lang = overrideLang { return lang == "ar" }
        return UserManager.isArabic
    }

    static var assistantTitle: String {
        isAr ? "المساعد الذكي" : "Chat Voice"
    }

    static var brandVoice: String { "Voice" }
    static var brandDoc: String { "Doc" }

    static var brandSubtitle: String {
        isAr ? "المساعد" : "Assistance"
    }

    static var onboardingDescription: String {
        isAr
            ? "مساعد صحي ذكي يستقبل الأعراض عبر الصوت، ويحوّلها إلى نص، ويساعدك في الوصول إلى الأخصائي المناسب."
            : "AI health assistant that can take symptoms through voice input, convert them to text, and help users find the most suitable specialist."
    }

    static var startChat: String {
        isAr ? "ابدأ المحادثة" : "Start Chat"
    }

    // MARK: - Chat

    static var inputPlaceholder: String {
        isAr ? "اكتب الأعراض هنا..." : "Type your symptoms here..."
    }

    /// Opening line before the first question.
    static var chatOpener: String {
        isAr ? "حسناً فلنبدأ." : "Okay, let's start."
    }

    /// Asked only in guest mode (we don't know the user's name).
    static var chatAskName: String {
        isAr ? "مرحبا، ما هو اسمك؟" : "Hello, what is your name?"
    }

    /// Greeting for a logged-in user, whose name we already have.
    static func chatGreetName(_ name: String) -> String {
        isAr ? "مرحباً \(name)!" : "Hello \(name)!"
    }

    static var chatAskAge: String {
        isAr ? "ما هو عمرك؟" : "What is your age?"
    }

    static var chatAskSymptoms: String {
        isAr
            ? "ما الأعراض التي تشعر بها؟"
            : "What are the symptoms you are experiencing?"
    }

    static var chatAnalyzing: String {
        isAr ? "شكراً، جارٍ تحليل الأعراض ..." : "Thanks, analyzing your symptoms ..."
    }

    static func chatRecommend(_ specialty: String) -> String {
        isAr
            ? "بناءً على أعراضك، أنصح بزيارة \(specialty)."
            : "Based on your symptoms, I recommend seeing a \(specialty)."
    }

    static func chatFindBest(_ specialty: String) -> String {
        isAr ? "ابحث عن أفضل \(specialty) الآن" : "Find Best \(specialty) Now"
    }

    // MARK: - Phase A: language / service / find doctor

    static var chatIntro: String {
        isAr
            ? "مرحباً! أنا مساعد الأعراض."
            : "Hello! I'm your Symptom Assistant."
    }

    static var chooseLanguage: String {
        isAr ? "اختر اللغة التي تريد التحدث بها" : "Select the language you need to discuss"
    }

    static var arabic: String { "العربية" }
    static var english: String { "English" }

    static var chooseService: String {
        isAr ? "اختر نوع الخدمة" : "Select Service Type"
    }

    static var bookByComplaint: String {
        isAr ? "حجز موعد بالشكوى" : "Book by Complaint"
    }

    static var bookBySpeciality: String {
        isAr ? "حجز موعد بالتخصص" : "Book by Speciality"
    }

    static var letsStart: String {
        isAr ? "حسناً فلنبدأ" : "Ok let's get started"
    }

    static func recommendSpecialty(_ specialty: String) -> String {
        isAr
            ? "بناءً على الأعراض الخاصة بك، أوصي بمراجعة \(specialty)"
            : "Based on your symptoms, I recommend seeing a \(specialty)"
    }

    static func findBestNow(_ specialty: String) -> String {
        isAr ? "اعثر على أفضل \(specialty) الآن" : "Find Best \(specialty) Now"
    }

    static var needSpecificDoctor: String {
        isAr ? "هل تريد المساعدة في الحصول على دكتور معين؟" : "Do you need help to get a specific doctor?"
    }

    static var yesNeedDoctor: String {
        isAr ? "نعم أحتاج طبيباً محدداً" : "Yes I Need Specific Doctor"
    }

    static var noSearchMyself: String {
        isAr ? "لا، سأبحث بنفسي" : "No I will search by self"
    }

    // MARK: - Book doctor

    static var notSpecified: String {
        isAr ? "غير محدد" : "Not Specified"
    }

    static var consultant: String { isAr ? "استشاري" : "Consultant" }
    static var specialist: String { isAr ? "متخصص" : "Specialist" }
    static var male: String { isAr ? "ذكر" : "Male" }
    static var female: String { isAr ? "أنثى" : "Female" }

    static var bookingDate: String { isAr ? "التاريخ" : "Date" }
    static var bookingDoctorType: String { isAr ? "نوع الطبيب" : "Doctor type" }
    static var bookingDoctorGender: String { isAr ? "جنس الطبيب" : "Doctor gender" }
    static var bookingSpecialty: String { isAr ? "التخصص" : "Specialty" }
    static var confirmDetails: String { isAr ? "تأكيد التفاصيل" : "Confirm Details" }

    static var bookingClosing: String {
        isAr
            ? "هذه تفاصيل الحجز التي ذكرناها معاً، أتمنى لك الشفاء العاجل."
            : "Here are the booking details we agreed on. I wish you a speedy recovery."
    }

    static var genericError: String {
        isAr
            ? "عذراً، لم أتمكن من فهم ردك. يُرجى المحاولة مرة أخرى."
            : "Sorry, I couldn't understand your reply. Please try again."
    }

    static var connectionError: String {
        isAr ? "تعذّر الاتصال بالخادم. حاول مرة أخرى." : "Couldn't reach the server. Please try again."
    }

    // MARK: - Voice mode

    static var voiceListening: String {
        isAr ? "🎤 تحدث الآن..." : "🎤 Listening..."
    }

    static var voiceSpeaking: String {
        isAr ? "المساعد يتحدث..." : "Assistant is speaking..."
    }

    static var voicePermissionDenied: String {
        isAr
            ? "يرجى السماح بالوصول إلى الميكروفون والتعرف على الكلام."
            : "Please allow microphone and speech recognition access."
    }

    // Placeholder used until the analysis endpoint is wired.
    static var demoSpecialty: String {
        isAr ? "طبيب أعصاب" : "Neurologist"
    }
}
