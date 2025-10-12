//
//  termsAndConditionVC.swift
//  careMatePatient
//
//  Created by khabeer on 12/29/20.
//  Copyright © 2020 khabeer. All rights reserved.
//

import UIKit
import MessageUI
import WebKit

class termsAndConditionVC: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelPrivacy: UILabel!
    @IBOutlet weak var textViewPrivacy: UITextView!
    @IBOutlet weak var textViewPrivacyArabic: UITextView!
    @IBOutlet weak var textViewTermsEN: UITextView!
    @IBOutlet weak var textViewTermsAR: UITextView!
    @IBOutlet weak var textViewTermsEn2: UITextView!
    @IBOutlet weak var textViewTermsAr2: UITextView!
    
    var typePrivacyPolicy = false
    var typeTerms2 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var title = ""
        if typePrivacyPolicy {
            title = UserManager.isArabic ? "سياسة الخصوصية" : "Privacy Policy"
            labelPrivacy.text = UserManager.isArabic ? "سياسة الخصوصية" : "Privacy Policy"
            textViewTermsAR.isHidden = true
            textViewTermsEN.isHidden = true
            textViewTermsAr2.isHidden = true
            textViewTermsEn2.isHidden = true
            if UserManager.isArabic {
                textViewPrivacyArabic.isHidden = false
                textViewPrivacy.isHidden = true
            } else {
                textViewPrivacyArabic.isHidden = true
                textViewPrivacy.isHidden = false
            }
        } else {
            title = UserManager.isArabic ? "الشروط والاحكام" : "Terms And Conditions"
            labelPrivacy.text = UserManager.isArabic ? "الشروط والاحكام" : "Terms And Conditions"
            textViewPrivacy.isHidden = true
            textViewPrivacyArabic.isHidden = true
            if typeTerms2 {
                textViewTermsAR.isHidden = true
                textViewTermsEN.isHidden = true
                if UserManager.isArabic {
                    textViewTermsAr2.isHidden = false
                    textViewTermsEn2.isHidden = true
                } else {
                    textViewTermsAr2.isHidden = true
                    textViewTermsEn2.isHidden = false
                }
            } else {
                textViewTermsAr2.isHidden = true
                textViewTermsEn2.isHidden = true
                if UserManager.isArabic {
                    textViewTermsAR.isHidden = false
                    textViewTermsEN.isHidden = true
                } else {
                    textViewTermsAR.isHidden = true
                    textViewTermsEN.isHidden = false
                }
            }
        }
        initHeader(isNotifcation: false, isLanguage: false, title: title, hideBack: false)
        labelPrivacy.font = UIFont(name: "Tajawal-Regular", size: 19)
        textViewPrivacy.font = UIFont(name: "Tajawal-Regular", size: 14)
        textViewPrivacyArabic.font = UIFont(name: "Tajawal-Regular", size: 14)
        textViewTermsEN.font = UIFont(name: "Tajawal-Regular", size: 14)
        textViewTermsAR.font = UIFont(name: "Tajawal-Regular", size: 14)
        textViewTermsEn2.font = UIFont(name: "Tajawal-Regular", size: 14)
        textViewTermsAr2.font = UIFont(name: "Tajawal-Regular", size: 14)
        viewBackground.setBorder(color: .gray, radius: 8, borderWidth: 1)
        
        let link = URL(string:"https://patientmobapp.alsalamhosp.com/mobileapitest/images/prhterms.pdf")!
        let request = URLRequest(url: link)
        webView.load(request)
    }
}
