//
//  UserDefaultsManager.swift
//  Nepros
//
//  Created by Yo7ia on 11/12/18.
//  Copyright © 2018 RMG. All rights reserved.
//

import Foundation
import UIKit

public class UserDefaultsManager {
    
    class func setDefaults() {
        let defaultPrefsFile: String! = Bundle.main.path(forResource: "defaultPrefs", ofType: "plist") ?? ""
        let defaultPreferences: [String: AnyObject] = NSDictionary(contentsOfFile: defaultPrefsFile) as! [String: AnyObject]
        let defaults: UserDefaults = UserDefaults.standard
        defaults.register(defaults: defaultPreferences)
        defaults.synchronize()
    }
    
    public static func getUserPreference(_ key: String!) -> AnyObject {
        let defaults: UserDefaults = UserDefaults.standard
        return defaults.value(forKey: key) as AnyObject
        
    }
    
    public static func setUserPreference(_ value: AnyObject, key: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    public static func resetAppData() {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaults.synchronize()
    }
    
}
