//
//  AppDelegate.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/4/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseCore
import MOLH
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "AIzaSyCvqTMWmMzDZSi7iCKI0hrkT0vjgzuZ56U"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // تعديل اللغة واتجاه الواجهة
        if UserManager.isArabic {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }


        UIApplication.shared.setMinimumBackgroundFetchInterval(10)
        IQKeyboardManager.shared.enable = true

        GMSServices.provideAPIKey("AIzaSyCW-ztCCYJaL5SFK7adXf-oqA6_iMpqm0w")
        GMSPlacesClient.provideAPIKey("AIzaSyCGaGQyQGdpB_dn12H0o9nNv1O19Dm80XY")

        initFirebase(application)
        Messaging.messaging().delegate = self

        // تفعيل MOLH
        MOLH.shared.activate(true)

        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        return true
    }

    func initFirebase(_ application: UIApplication) {
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let refreshedToken = Messaging.messaging().fcmToken {
            print("InstanceID token: \(refreshedToken)")
            UserDefaults.standard.set(refreshedToken, forKey: "pushToken")
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {}

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        UserDefaults.standard.set(fcmToken, forKey: "pushToken")
    }
}

@available(iOS 10, *)
extension AppDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        UserDefaults.standard.set(userInfo, forKey: "remoteNotif")
        NotificationCenter.default.post(name: Notification.Name("new.push.notifications"), object: nil)
        completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        UserDefaults.standard.set(userInfo, forKey: "remoteNotif")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationHandler"), object: self, userInfo: userInfo)
        if UIApplication.shared.applicationState == .active || UIApplication.shared.applicationState == .background {
            showNotificationPopUp()
        }
        completionHandler()
    }

    func showNotificationPopUp() {
        if let dic = UserDefaults.standard.object(forKey: "remoteNotif") as? [String:Any] {
            let abs = dic["aps"] as? [String:Any]
            let alert = abs?["alert"] as? [String:Any]
            let body = alert?["body"] as? String ?? ""
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: body, options: [], range: NSRange(location: 0, length: body.utf16.count))
            for match in matches {
                guard let range = Range(match.range, in: body) else { continue }
                let url = body[range]
                guard let url = URL(string: String(url)) else { return }
                UIApplication.shared.open(url)
                UserDefaults.standard.removeObject(forKey: "remoteNotif")
            }
        }
    }
}

extension UITableViewCell {
    open override func awakeFromNib() {
        self.selectionStyle = .none
    }
}

// MOLH Resetable لتغيير اللغة وإعادة تحميل التطبيق
extension AppDelegate: MOLHResetable {
    func reset() {
     //   guard let window = self.window else { return }
      //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
      //  let rootVC = storyboard.instantiateViewController(withIdentifier: "SplashNavigation")
      //  window.rootViewController = rootVC
      //  window.makeKeyAndVisible()
    }
}
