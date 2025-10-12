//
//  slotNot.swift
//  CareMate
//
//  Created by mostafa gabry on 5/31/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import MessageUI
import UIKit

class slotNot: BaseViewController {

    
    @IBOutlet weak var labeleAlert: UILabel!
    var messageAr1 = ""
    var messageEn1 = ""

    @IBOutlet weak var textFieldHeigthConstaint: UITextView!
    @IBOutlet weak var labelHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var textViewAlertMessage: UILabel!
    
    init(messageAr: String,MessageEn:String) {

        super.init(nibName: "slotNot", bundle: nil)
        self.messageAr1 = messageAr
        self.messageEn1 = MessageEn
     
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBOutlet weak var wishMessage: UILabel!
    @IBOutlet weak var LabelAlert: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let amountOfLinesToBeShown: CGFloat = 6
//        let maxHeight: CGFloat = textViewAlertMessage.font!.lineHeight * amountOfLinesToBeShown
//        textViewAlertMessage.sizeThatFits(CGSize(width: textViewAlertMessage.frame.size.width, height: maxHeight))
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
      
        let font = UIFont(name: "Helvetica", size: 20.0)

        if UserManager.isArabic
        {
            textViewAlertMessage.text = self.messageAr1
            textViewAlertMessage.textAlignment = .right
            wishMessage.text = "مع تمنياتنا لكم بدوام الصحة والعافية."
            labelHeightConstaint.constant =  heightForView(text: messageAr1, font:font! , width: screenWidth - 40)
            labeleAlert.text = "تنبيه"
            
        }
        else
        {
            textViewAlertMessage.text = self.messageEn1
            
           
            labelHeightConstaint.constant =  heightForView(text: messageEn1, font:font! , width: screenWidth - 40)
            wishMessage.text = "We wish you continued health and wellness!"
//            LabelEmail.text = "E-mail"
            textViewAlertMessage.textAlignment = .left

            labeleAlert.text = "Alert"

        }

        // Do any additional setup after loading the view.
    }

    @IBAction func dissmiss(_ sender: Any) {
        mz_dismissFormSheetController(animated: true, completionHandler: nil)
    }
    @IBAction func phoneCiked(_ sender: Any) {
        if let url = NSURL(string: "tel://96524997000"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    

    @IBAction func emailCliked(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail() {
               let mail = MFMailComposeViewController()
               mail.mailComposeDelegate = self
                mail.setToRecipients([ConstantsData.email])
               mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

               present(mail, animated: true)
           } else {
               // show failure alert
           }
    }
    @IBAction func openWhatsApp(_ sender: Any) {
        let phoneNumber =  "+9651830003" // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            // WhatsApp is not installed
        }
        
    }

  

}

extension slotNot:MFMailComposeViewControllerDelegate {
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
       label.numberOfLines = 0
       label.lineBreakMode = NSLineBreakMode.byWordWrapping
       label.font = font
       label.text = text

       label.sizeToFit()
       return label.frame.height
   }
}
extension String {
   
}
