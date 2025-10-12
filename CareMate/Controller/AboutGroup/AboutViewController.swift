//
//  AboutVC.swift
//  CareMate
//
//  Created by Yo7ia on 1/7/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//


import SCLAlertView
import UIKit
import MessageUI
class AboutViewController: BaseViewController
{
   
    @IBOutlet weak var ourVisionTitle: UILabel!
    @IBOutlet weak var ourVisionText: UILabel!
    
  
    @IBOutlet weak var ourMission: UILabel!
    @IBOutlet weak var ourMissionDetails: UILabel!
    
  
    @IBOutlet weak var ourVision: UILabel!
    @IBOutlet weak var ourVisionDetails: UILabel!
    
    @IBOutlet weak var ourValuesDetails: UILabel!
    @IBOutlet weak var ourValues: UILabel!

    @IBOutlet weak var uilabelCEOName: UILabel!
    @IBOutlet weak var uilabelCEOTitel: UILabel!
    @IBOutlet weak var uilabelOurStory: UILabel!

    @IBOutlet weak var uiviewOurStory: UIView!
    @IBOutlet weak var imageViewCEO: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
        initHeader(isNotifcation: false, isLanguage: true, title: UserManager.isArabic ? "عن السلام" : "About Al-Salam", hideBack: false)
        uiviewOurStory.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ourStory)))
        
        if UserManager.isArabic
        {
            ourVision.textAlignment = .right
            ourVisionText.textAlignment = .right

         
            ourMission.textAlignment = .right
            ourMissionDetails.textAlignment = .right
        
            ourVision.textAlignment = .right
            ourVisionDetails.textAlignment = .right
            ourValues.textAlignment = .right
//            Communication.textAlignment = .right
//            collaboration.textAlignment = .right
//            respact.textAlignment = .right
//            Commital.textAlignment = .right
//            accountability.textAlignment = .right
//            quality.textAlignment = .right


        }
        else
        {
            ourVision.textAlignment = .left
            ourVisionText.textAlignment = .left

   
            ourMission.textAlignment = .left
            ourMissionDetails.textAlignment = .left
         
            ourVision.textAlignment = .left
            ourVisionDetails.textAlignment = .left
            ourValues.textAlignment = .left
//            Communication.textAlignment = .left
//            collaboration.textAlignment = .left
//            respact.textAlignment = .left
//            Commital.textAlignment = .left
//            accountability.textAlignment = .left
//            quality.textAlignment = .left

        }
    }
    @objc func ourStory(){
        self.navigationController?.pushViewController(HospitalStoryViewController(), animated: true)
    }
    
   
    @IBAction func phoneCliked(_ sender: Any) {
        if let url = NSURL(string: "tel://+9651830003"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = UserManager.isArabic ? "عن التطبيق" : "About App"
        
        self.ourVisionTitle.text = UserManager.isArabic ? "رسالة الإدارة" : "Management message"
//        self.ourVisionText.text = UserManager.isArabic ? "نيابة عن موظفي وأطباء مستشفى السلام الدولي، نود أن نرحب بكم ونشارككم التزامنا التام بتوفير خدمات رعاية طبية استثنائية وآمنة ورحيمة لجميع مرضانا وعائلاتهم نرحب باستفساراتكم واقتراحاتكم ونقدّر آراءكم وملاحظاتكم التي تساعدنا على تقديم جميع احتياجات الرعاية الصحية اللازمة لكم."
//    :
//        "On behalf of Al Salam International Hospital staff and physicians, we would like to welcome you and share with you our total commitment in providing exceptional, safe and compassionate patient care service to all our patients and their families.\nYour comments, suggestions, queries, and feedback are always welcome and extremely valuable to us. It will help us to meet all your healthcare needs."
        
        
        self.ourValues.text = UserManager.isArabic ? "قيمنا" : "Our Values"
        
        self.ourValuesDetails.text = UserManager.isArabic ? "الأداء بروح الفريق - الإحترام - المحافظة على معايرالجودة المسؤولية تجاه المجتمع - المصداقية"
        
        
        
        : "Teamwork\nRespect\nUp to Standards\nSocial Responsibility\nTruth"
        
        
        self.ourMission.text = UserManager.isArabic ? "مهمتنا" : "Mission"
        
        self.ourMissionDetails.text = UserManager.isArabic ? "تقديم رعاية صحية ضمن قيم مهنية متميزة" : "Provide high quality healthcare services in an ethical environment "


        
        self.ourVision.text = UserManager.isArabic ? "رؤيتنا" : "Vision"
        
        self.ourVisionDetails.text = UserManager.isArabic ? "الريادة في قطاع الخدمات الصحية" : " Leader of Excellence in Health Care"
    
        let data = UserDefaults.standard.object(forKey: "splashData") as? [String: AnyObject] ?? [:]
//        self.uilabelCEOName.text = UserManager.isArabic ?  "د ايمن سالم المطوع" : "Dr. Ayman S. AL Mutawa"
        uilabelCEOName.text = data[UserManager.isArabic ? "CeoNameAr" : "CeoNameEn"] as? String ?? ""
        ourVisionText.stringFromHtml(htmlString: data[UserManager.isArabic ? "CeoMessageAr" : "CeoMessageEn"] as? String ?? "")
        let url = "https://\(Constants.APIProvider.IP)/\(data["CeoImage"] as? String ?? "")"
        imageViewCEO.loadFromUrl(url: url)
        self.uilabelCEOTitel.text = UserManager.isArabic ?  "الرئيس التنفيذي" : "Chief Executive Officer"
        self.uilabelOurStory.text = UserManager.isArabic ?  "تعرف علي قصتنا" : "Our Story"


        
//        self.respact.text = UserManager.isArabic ? "احترام" : "Respect"
//
//        self.Commital.text = UserManager.isArabic ? "التزام" : "commitment"
//        self.quality.text = UserManager.isArabic ? "جوده" : "َQuality"
//        self.accountability.text = UserManager.isArabic ? "المسؤلبه" : "َaccountability"
//
//
//        self.collaboration.text = UserManager.isArabic ? "تعاون" : "َcollaboration"
//        self.Communication.text = UserManager.isArabic ? "تواصل" : "َCommunication"
        
     


    }
    

}
extension AboutViewController:MFMailComposeViewControllerDelegate {
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
