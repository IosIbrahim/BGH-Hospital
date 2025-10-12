//
//  LanguageViewController.swift
//  CareMate
//
//  Created by Khabber on 29/03/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit
import MOLH

class LanguageViewController: BaseViewController {

    @IBOutlet weak var imageViewArarbic: UIImageView!
    @IBOutlet weak var imageViewEnglish: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initHeader(isNotifcation: false, isLanguage: false,
                   title: UserManager.isArabic ? "تغيير اللغه": "Change Language",
                   hideBack: false)
        updateLanguageUI()
    }

    private func updateLanguageUI() {
        imageViewArarbic.isHidden = !UserManager.isArabic
        imageViewEnglish.isHidden = UserManager.isArabic
    }

    @IBAction func arabciClicked(_ sender: Any) {
        guard !UserManager.isArabic else { return }
        UserDefaults.standard.setValue("ar", forKey: "appLang")
        indicator.sharedInstance.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            MOLH.setLanguageTo("ar")
            self.reloadApp()
        }
    }

    @IBAction func englishCliked(_ sender: Any) {
        guard UserManager.isArabic else { return }
        UserDefaults.standard.setValue("en", forKey: "appLang")
        indicator.sharedInstance.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            MOLH.setLanguageTo("en")
            self.reloadApp()
        }
    }

    private func reloadApp() {
        indicator.sharedInstance.dismiss()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.reset() // MOLHResetable reset
        }
    }
}


