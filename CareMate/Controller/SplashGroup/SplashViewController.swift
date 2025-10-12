//
//  SplashViewController.swift
//  CareMate
//
//  Created by mostafa gabry on 4/7/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
import LocalAuthentication
import SCLAlertView

extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}

class SplashViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.4235294118, blue: 0.8039215686, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.06274509804, green: 0.4235294118, blue: 0.8039215686, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        initBackGround()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "NotificationHandler"), object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            if self.navigationController?.viewControllers.last is SplashViewController {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    self.navigationController?.pushViewController(NotifcationsViewController(), animated: true)
                }
            } else {
                self.navigationController?.pushViewController(NotifcationsViewController(), animated: true)
            }
        }
        
        extraLongFactorials(n: 25)
    }
    
    func extraLongFactorials(n: Int) -> Void {
        var count: NSDecimalNumber = 1
        for i in 1...n {
            count = count.multiplying(by: NSDecimalNumber(integerLiteral: i))
        }
        print(count)
    }
    
    func climbingLeaderboard(ranked: [Int], player: [Int]) -> [Int] {
        var newRanked = [Int]()
        if ranked.count > 0 {
            newRanked.append(ranked.first!)
            if ranked.count > 1 {
                for i in 1...ranked.count - 1 {
                    if ranked[i] != newRanked.last! {
                        newRanked.append(ranked[i])
                    }
                }
            }
        }
        var returnArray = [Int]()
        return getArray(ranked: newRanked, player: player)
    }
    
    func getArray(ranked: [Int], player: [Int]) -> [Int] {
        var arr = [Int]()
        for item in player {
            index = 0
            arr.append(getIndex(ranked: ranked, item: item))
        }
        return arr
    }

    var index = 0

    func getIndex(ranked: [Int], item: Int) -> Int {
        guard let firstItem = ranked.first else { return 1 }
        if item >= firstItem {
            return 1
        }
        guard let lastItem = ranked.last else { return 1 }
        if item <= lastItem {
            return ranked.count + 1
        }
        let arrs = ranked.split()
        if item > arrs.right.first! {
            index = getIndex(ranked: arrs.left, item: item)
        } else if item < arrs.left.last! {
            index = getIndex(ranked: arrs.right, item: item)
        } else {
            index = arrs.left.count + 1
        }
        return index
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getKnowYourDoctor()
    }

    func getKnowYourDoctor() {
//        WebserviceMananger.sharedInstance.makeCall(method: .get, url: Constants.APIProvider.getKnowYourDoctor, parameters: nil, vc: self, showIndicator: false) { (data, error) in
//            if error == nil {
//                let data = data as? [String: AnyObject] ?? [:]
//                UserDefaults.standard.set(data["arabicLink"] as? String ?? "", forKey: "knowYourDoctorAr")
//                UserDefaults.standard.set(data["englishLink"] as? String ?? "", forKey: "knowYourDoctorEn")
//                UserDefaults.standard.set(data["UserGuideAr"] as? String ?? "", forKey: "UserGuideAr")
//                UserDefaults.standard.set(data["UserGuideEn"] as? String ?? "", forKey: "UserGuideEn")
//                UserDefaults.standard.set(data, forKey: "splashData")
//                //FIXED BY HAmdi
//                let serverForceUpdateVersion = data["IosVersion"] as? String ?? "0"
//                let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
//
//                print("Server version: \(serverForceUpdateVersion)")
//                print("Current version: \(currentVersion)")
//
//                if currentVersion.compare(serverForceUpdateVersion, options: .numeric) == .orderedAscending {
//                    self.navigationController?.pushViewController(ForceUpdateViewController(), animated: true)
//                    return
//                }
//            }
//fwds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let defaults = UserDefaults.standard
                if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
                    let decoder = JSONDecoder()
                    if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {
                        self.authenticateUser()
                    }
                } else {
                    let vc = BHGLoginController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
       // }
    }

    func initBackGround() {
        let imageBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        imageBackground.contentMode = .scaleAspectFill
        imageBackground.image = UIImage(named: "BHG-SplashScreen")
        view.insertSubview(imageBackground, at: 0)
    }

    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeNavNav") as! UITabBarController
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                    } else {
                        let vc = BHGLoginController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "homeNavNav") as! UITabBarController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}

extension Double {
    func round(places: Int = 2) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


