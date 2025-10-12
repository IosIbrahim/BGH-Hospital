//
//  UserInfoManager.swift
//  Nepros
//
//  Created by Yo7ia on 11/12/18.
//  Copyright © 2018 RMG. All rights reserved.
//

import UIKit
import MOLH

open class BaseUserManager {

    public static var isArabic: Bool {
        get {
            if let lang = UserDefaults.standard.string(forKey: "appLang") {
                return lang == "ar"
            }
            return MOLHLanguage.isArabic() // fallback
        }
    }
}
 
