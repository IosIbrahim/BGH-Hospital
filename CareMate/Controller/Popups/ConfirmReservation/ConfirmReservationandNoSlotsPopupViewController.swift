//
//  ConfirmReservationandNoSlotsPopupViewController.swift
//  CareMate
//
//  Created by m3azy on 21/11/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit
import MessageUI

enum ReservationPopupScreenType {
    case reservationDone
    case noSlots
    case register
    case forgotPassword
}

func OPEN_RESERVATION_AND_NO_SLOTS_POPUP(container: UIViewController, type: ReservationPopupScreenType, closure: HintPopupClosure? = nil) {
    let vc = ConfirmReservationandNoSlotsPopupViewController(screenType: type)
    vc.closure = {
        vc.dismiss(animated: false) {
            closure?()
        }
    }
    vc.modalPresentationStyle = .overFullScreen
    container.present(vc, animated: false)
}

class ConfirmReservationandNoSlotsPopupViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDear: UILabel!
    @IBOutlet weak var labelDetails: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewemail: UIView!
    @IBOutlet weak var viewWhatsapp: UIView!
    @IBOutlet weak var viewClose: UIView!
    @IBOutlet weak var labelClose: UILabel!
    
    var screenType: ReservationPopupScreenType = .reservationDone
    var closure: HintPopupClosure?
    
    init(screenType: ReservationPopupScreenType) {
        super.init(nibName: "ConfirmReservationandNoSlotsPopupViewController", bundle: nil)
        self.screenType = screenType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .fromHex(hex: "000000", alpha: 0.25)
        viewClose.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePopup)))
        if UserManager.isArabic {
            labelTitle.text = "تنبيه"
            labelDear.text = "عزيزي المراجع"
            labelData.text = "تواصل معنا"
            labelClose.text = "إغلاق"
            if screenType == .reservationDone {
                labelDetails.text = "لديك ملف بالفعل في سجلات المستشفى لدينا، يمكنك الإنتقال إلي تسجيل الدخول أو      لمزيد من المعلومات، يرجي الإتصال بنا"
            } else if screenType == .noSlots {
                labelDetails.text = "الطبيب الذي تم إختياره ليس له جدول مواعيد في هذا اليوم، إذا كنت ترغب في حجز موعد في الأوقات الغير متاحة علي التطبيق يرجي التواصل معنا:"
            } else if screenType == .register {
                labelDetails.text = "عذرآ, البيانات المدخلة لا تتطابق مع سجلاتنا لمزيد من المعلومات , يرجي التواصل معنا عبر:"
            } else if screenType == .forgotPassword {
                labelDetails.text = "عفوآ, بيانات الهاتف غير معرفة لدينا بالمستشفى, إذا كان لديكم ملف بالمستشفى يرجي تسجيل الحساب, او التواصل معنا للمزيد من المساعدة عبر:"
            }
        } else {
            if screenType == .reservationDone {
                labelDetails.text = "You already have a file in hospital records With us, you can navigate to login or For more information, please contact us:"
            } else if screenType == .noSlots {
                labelDetails.text = "The selected doctor does not have an appointment schedule On this day, if you want to book an appointment At times not available on the application Please contact us:"
            } else if screenType == .register {
                labelDetails.text = "Sorry, the data entered doesn't match our record, for further information Please contact us via:"
            } else if screenType == .forgotPassword {
                labelDetails.text = "Sorry, the phone number data is not known to us at the hospital, so if you have a hospital file, please register account, or contact us for more help via:"
            }
        }
        viewPhone.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makACall)))
        viewemail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendEmail)))
        viewWhatsapp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendWhatsapp)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewBackground.popIn()
    }
    
    @objc func closePopup() {
        viewBackground.popOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.closure?()
        }
    }

    @objc func makACall() {
        call(phoneNumber: ConstantsData.mobile)
    }
    
    @objc func sendEmail() {
        openEmail()
    }
    
    @objc func sendWhatsapp() {
        openUrl("https://api.whatsapp.com/send?phone=\(ConstantsData.whatsapp)")
    }
    
    
    
//    func openUrl(_ url: String) {
//        let urlString = url
//        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        let URL = NSURL(string: urlStringEncoded!)
//        if UIApplication.shared.canOpenURL(URL! as URL) {
//            UIApplication.shared.openURL(URL! as URL)
//        }
//    }
    
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
