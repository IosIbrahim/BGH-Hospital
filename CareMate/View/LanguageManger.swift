//
//  LanguageManger.swift
//  CareMate
//
//  Created by Khabber on 18/05/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//


import Foundation


import UIKit
//import Localize_Swift
import MOLH
class LanguageManager: NSObject {
    struct Font {
        static let ENGLISH_FONT_REGULAR = "Cairo-Regular"
        static let ENGLISH_FONT_BOLD = "Cairo-Bold"
        static let ARABIC_FONT_REGULAR = "Cairo-Regular"
        static let ARABIC_FONT_BOLD = "Cairo-Bold"
    }
    

    
    static var languageId :String {
        return LanguageManager.isArabic() ? "1":"0"
    }
    static var localizedTitleInset :UIEdgeInsets {
        return LanguageManager.isArabic() ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8) : UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
    class func isArabic()->Bool{
        return MOLHLanguage.isArabic()
    }
//    class func initAppConfiguration(){
//        MOLH.shared.activate(true)
//        if MOLHLanguage.isArabic(){
//            LanguageManager.switchToArabic()
//        }else {
//            LanguageManager.switchToEnglish()
//        }
//    }
//    class func switchToArabic(){
//        if !LanguageManager.isArabic() {
//            MOLH.setLanguageTo("ar")
//            Localize.setCurrentLanguage("ar")
//            MOLH.reset()
//        }
//    }
//    class func switchToEnglish(){
//        if LanguageManager.isArabic() {
//            MOLH.setLanguageTo("en")
//            Localize.setCurrentLanguage("en")
//            MOLH.reset()
//            
//        }
//    }
    class func getLanguageCode()->String{
        if LanguageManager.isArabic(){
            return "ar"
        }
        return "en"
    }
    class func getTextAlignment()->NSTextAlignment{
        if LanguageManager.isArabic() {
            return .right
        }else {
            return .left
        }
    }
    class func getTextAlignment()->UIControl.ContentHorizontalAlignment{
        if LanguageManager.isArabic() {
            return .right
        }else {
            return .left
        }
    }
    class func getEnglishLocalForAppLanuage() -> Locale? {
        let locale = Locale.init(identifier: "en")
        return locale
    }
    
    class func getArabicLocalForAppLanuage() -> Locale? {
        let locale = Locale.init(identifier: "ar")
        return locale
    }
    
    class func getLocale() -> Locale? {
        if isArabic(){
            return getArabicLocalForAppLanuage()
        }
        return getEnglishLocalForAppLanuage()
    }
//    class func getCurrentLanguage()-> String{
//        if isArabic() {
//            return "Arabic".localized()
//        }
//        return "English".localized()
//    }
    class func getLocalizedFont(fontSize:CGFloat = 16.0)->UIFont{
        
        for family in UIFont.familyNames.sorted(){
            let name = UIFont.fontNames(forFamilyName: family)
            print("family : \(family) font name: \(name)")
        }
        
        if isArabic() {
            return UIFont.init(name: LanguageManager.Font.ARABIC_FONT_REGULAR, size: fontSize)!
        }
        return UIFont.init(name: LanguageManager.Font.ENGLISH_FONT_REGULAR, size: fontSize)!
    }
    class func getLocalizedBoldFont(fontSize:CGFloat = 16.0)->UIFont{
        if isArabic() {
            return UIFont.init(name: LanguageManager.Font.ARABIC_FONT_BOLD, size: fontSize)!
        }
        return UIFont.init(name: LanguageManager.Font.ENGLISH_FONT_BOLD, size: fontSize)!
    }
    class func toggleLanguage(){
//        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
//        MOLH.reset()
    }
    
    
//    class func SetLanguage(langkey:String){
//
//               APIClient.SetLanguage(lang: langkey, onComplete: { (model) in
//
//                   print(model.result , model.message)
//
//                   if model.result == "success"
//                   {
//                   print("done")
//
//                   }else{
//                           print("error")
//                   }
//               })
//               { (error) in
//                print(error)
//               }
//           }
//
    

}
