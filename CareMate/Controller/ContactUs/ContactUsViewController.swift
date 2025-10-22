//
//  ContactUsViewController.swift
//  CareMate
//
//  Created by m3azy on 24/07/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: BaseViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewWhatsapp: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var labelContact: UILabel!
    @IBOutlet weak var labelContactDetails: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var labelWhatsapp: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelContactUsThrow: UILabel!
    @IBOutlet weak var imageViewIn: UIImageView!
    @IBOutlet weak var imageViewFacebook: UIImageView!
    @IBOutlet weak var imageViewinsta: UIImageView!
    @IBOutlet weak var imageViewYoutube: UIImageView!
    @IBOutlet weak var imageViewDerma: UIImageView!
    @IBOutlet weak var imageViewTwitter: UIImageView!
    @IBOutlet weak var viewHelpAndSupport: UIView!
    @IBOutlet weak var labelHelpAndSupport: UILabel!
    
    @IBOutlet weak var lblContantinforamtion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(title: UserManager.isArabic ? "تواصل معنا" : "Contact Us")
        viewPhone.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callPhone)))
        viewWhatsapp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openChatOnWhatsapp)))
        viewEmail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openEmail)))
        viewHelpAndSupport.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openHelpAndSupport)))
        if UserManager.isArabic {
            lblContantinforamtion.text = "بيانات التواصل"
            labelContact.text = "تواصل معنا"
            labelContactDetails.text = "لأي استفسار او مساعدة, يمكنكم التواصل معناعن طريق قنوات الاتصال المختلفة أدناه."
            labelPhoneNumber.text = "رقم الهاتف"
            labelWhatsapp.text = "الرقم الموحد المختصر"
            labelEmail.text = "البريد الالكتروني"
            labelContactUsThrow.text = "تواصل معنا عبر"
            labelHelpAndSupport.text = "المساعدة والدعم"
            labelContactUsThrow.font = UIFont(name: "Tajawal-Regular", size: 12)
        }
        imageViewIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkedIn)))
        imageViewFacebook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebook)))
        imageViewinsta.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagram)))
        imageViewYoutube.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(youtube)))
        imageViewDerma.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(derma)))
        imageViewTwitter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twitter)))
    }
    
    @objc func linkedIn() {
        openUrl(ConstantsData.linkedin)
    }
    
    @objc func facebook() {
        openUrl(ConstantsData.facebook)
    }
    
    @objc func instagram() {
        openUrl(ConstantsData.instegram)
    }
    
    @objc func youtube() {
        openUrl(ConstantsData.youtube)
    }
    @objc func derma() {
        openUrl(ConstantsData.drama)
    }
    
    @objc func twitter() {
        openUrl(ConstantsData.twitter)
    }

    @objc func callPhone() {
        call(phoneNumber: ConstantsData.mobile)
    }
    
    @objc func openChatOnWhatsapp() {
      //  openWhatsApp(number: ConstantsData.whatsapp)
        call(phoneNumber: ConstantsData.unifiedNumber)

    }
    
    @objc func openHelpAndSupport() {
//        openWhatsApp(number: "+96594032241")
        navigationController?.pushViewController(GuideAndSupportViewController(), animated: true)
    }
    
    func openWhatsApp(number: String) {
        openUrl("https://api.whatsapp.com/send?phone=\(number)")
    }
    
    @objc func openEmail() {
        if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
            mail.setToRecipients([ConstantsData.email])
//                mail.setMessageBody("", isHTML: true)

                present(mail, animated: true)
            } else {
                let alert = UIAlertController(title: "Alert", message: "Can't send email", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension UIViewController {
    func call(phoneNumber:String) {
        if let mobileCallUrl = URL(string: "tel://\(phoneNumber)") {
            let application = UIApplication.shared
            if application.canOpenURL(mobileCallUrl) {
                if #available(iOS 10.0, *) {
                    application.open(mobileCallUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(mobileCallUrl)
                }
            } else {
                let alert = UIAlertController(title: "Alert", message: "Can't make call", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "Can't make call", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
