//
//  PaymentPopupViewController.swift
//  Youmeda
//
//  Created by Mohamed on 3/24/21.
//

import UIKit

class PaymentPopupViewController: BaseViewController {

   
    @IBOutlet weak var title1: UILabel!
    
    @IBOutlet weak var lblWhats: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    
    @IBOutlet weak var subTitle: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        if UserManager.isArabic
        {
            title1.text = "الدكتور الذي تم اختياره ليس له جدول مواعيد في هدا اليوم اذا كنت ترغب في حجز موعد في الاوقات الغير متاحه علي التطبيق يرجي التواصل معنا عبر الهاتف"
            subTitle.text = "مع تمنياتنا لكم بدوام الصحه والعافيه"
        }
        else
        {
            title1.text = "The selected doctor does not have a schrdule on the selected date in case you want tot take an appoinment for unavailable dates please call Our call center"
            subTitle.text = "we wish You continued health and wellness"

        }
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserManager.isArabic
        {
            title1.text = "الدكتور الذي تم اختياره ليس له جدول مواعيد في هدا اليوم اذا كنت ترغب في حجز موعد في الاوقات الغير متاحه علي التطبيق يرجي التواصل معنا عبر الهاتف"
            subTitle.text = "مع تمنياتنا لكم بدوام الصحه والعافيه"
        }
        else
        {
            title1.text = "The selected doctor does not have a schrdule on the selected date in case you want tot take an appoinment for unavailable dates please call Our call center"
            subTitle.text = "we wish You continued health and wellness"

        }
        lblMobile.text = "\(ConstantsData.mobile) - \(ConstantsData.mobile1)"
        lblWhats.text = "\(ConstantsData.whatsapp)"
    }
    @IBAction func openWhatsApp(_ sender: Any) {
        let phoneNumber =  "\(ConstantsData.whatsapp)" // you need to change this number
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
    @IBAction func phoneCliked(_ sender: Any) {
        if let url = NSURL(string: "tel://\(ConstantsData.mobile)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
}
