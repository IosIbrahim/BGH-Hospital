//
//  AppoimentCollectionViewCell.swift
//  CareMate
//
//  Created by Khabber on 28/06/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit
import SCLAlertView

class AppoimentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var uiimageDoctor: UIImageView!

    @IBOutlet weak var hospital: UILabel!
//    @IBOutlet weak var time: UILabel!
//    @IBOutlet weak var day: UILabel!
//    @IBOutlet weak var month: UILabel!
//    @IBOutlet weak var dayText: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusView: UIView!
//    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var cancel: UIView!
    @IBOutlet weak var rescudle: UIView!
//    @IBOutlet weak var queueNo: UILabel!
        @IBOutlet weak var uilabelDate: UILabel!
    @IBOutlet weak var uilabelTime: UILabel!
    
    @IBOutlet weak var uistackDate: UIStackView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var uilabelCancel: UILabel!
    @IBOutlet weak var uilabelResudle: UILabel!
    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var labelRate: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorClinic: UILabel!
    var delegate: AppointmentCellDelagete?
    var vc : UIViewController?
    var data : AppointmentDTO?
    var selectIndex:Int = .zero
    

    var isUpcomming = true
    func configureCell(vc : UIViewController,data: AppointmentDTO) {
        mainView.makeShadow(color: .black, alpha: 0.25, radius: 3)

        uilabelCancel.text = UserManager.isArabic ? "الغاء" : "Cancel"
        uilabelResudle.text = UserManager.isArabic ? "اعاده الجدوله" : "Reschedule"
        labelRate.text = UserManager.isArabic ? "تقييم" : "Rate"
        rescudle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RescheduleRequestClicked)))
        cancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelCliked)))
        viewRate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rateCliked)))
        if data.eXPECTEDDONEDATE != ""{
            uilabelDate.text = data.eXPECTEDDONEDATE.formateDAte(dateString: data.eXPECTEDDONEDATE, formateString: "dd MMM yyyy")
            let time = data.eXPECTEDDONEDATE.formateDAte(dateString: data.eXPECTEDDONEDATE, formateString: "HH:mm", localEn: true)
            let arr = time.components(separatedBy: ":")
            if arr.count > 1 {
                if Int(arr[0]) ?? 0 > 12 {
                    uilabelTime.text = "\((Int(arr[0]) ?? 0) - 12):\(arr[1]) \(UserManager.isArabic ? "مساء" : "pm")"
                } else {
                    uilabelTime.text = "\((Int(arr[0]) ?? 0)):\(arr[1]) \(UserManager.isArabic ? "صباحا" : "am")"
                }
            }
                uistackDate.isHidden = false
        } else {
            uistackDate.isHidden = true
        }
        let url = URL(string: "\(Constants.APIProvider.IMAGE_BASE)/\(data.DOCTOR_PIC )")
        self.uiimageDoctor.kf.setImage(with: url, placeholder: data.EMP_GENDUR == "M" ? UIImage(named: "RectangleMan") : UIImage(named: "RectangleGirl") , options: nil, completionHandler: nil)
        
        
        self.data = data
     //   doctorName.text = "DR. "+data.eMP_EN_DATA
        doctorName.text = UserManager.isArabic ? data.eMP_AR_DATA :data.eMP_EN_DATA
        doctorClinic.text = UserManager.isArabic ? data.cLINIC_NAME_AR :data.cLINIC_NAME_EN
        hospital.text = UserManager.isArabic ? "\("المستشفي:") \(data.hOSP_NAME_AR)" : "\("Hospital:") \(data.hOSP_NAME_EN)"
        if data.sTATUS_NAME_EN == "Performed" {
            status.text =  UserManager.isArabic ? data.sTATUS_NAME_AR : "Conducted"
        } else {
            status.text =  UserManager.isArabic ? data.sTATUS_NAME_AR : data.sTATUS_NAME_EN
        }

        statusView.Rounded(corner: 8)
        labelLocation.text = UserManager.isArabic ? "\("المكان:") \(data.CLINIC_LOCATION_AR)" : "\("Location:") \(data.CLINIC_LOCATION_EN)"
        switch (self.data!.sTATUS_NAME_EN) {
        case "New":
            cancel.isHidden = false
            rescudle.isHidden = false
            viewRate.isHidden = false
           // viewRate.backgroundColor = .blue
            rescudle.backgroundColor = .blue
            labelRate.text = UserManager.isArabic ? "تأكيد" : "Confirm"
            self.statusView.backgroundColor = UIColor(fromRGBHexString: "008AAF")
            break
        case "Future":
            cancel.isHidden = false
            rescudle.isHidden = true
            viewRate.isHidden = false
            viewRate.backgroundColor = .blue
            labelRate.text = UserManager.isArabic ? "تأكيد" : "Confirm"
            self.statusView.backgroundColor = UIColor(fromRGBHexString: "008AAF")
            break
        case "Canceled":
//            self.moreBtn.isHidden = true
            cancel.isHidden = true
            rescudle.isHidden = true
            viewRate.isHidden = true
            self.statusView.backgroundColor = UIColor(fromRGBHexString: "B22222")
            break
        case "Confirmed":
            cancel.isHidden = true
            rescudle.isHidden = true
            viewRate.isHidden = true
            self.statusView.backgroundColor = UIColor(fromRGBHexString: "228B22")
            break
        case "Performed":
            cancel.isHidden = true
            rescudle.isHidden = true
            if data.EVAL_STATUS == "0" {
                viewRate.isHidden = true
                viewRate.backgroundColor = .green
            } else {
                viewRate.isHidden = true
            }
            self.statusView.backgroundColor = UIColor(fromRGBHexString: "008080")
            break
        default:
            cancel.isHidden = false
            rescudle.isHidden = false
            rescudle.backgroundColor = .blue
            viewRate.isHidden = true
            self.statusView.backgroundColor = UIColor(fromRGBHexString: "008AAF")
            break
        }
        print(isUpcomming)
//        moreBtn.isHidden = isUpcomming
        
//        cancel.titleLabel?.text = UserManager.isArabic ? "Cancel" : "إلغاء"
//        rescudle.titleLabel?.text = UserManager.isArabic ? "اعاده جدوله" : "Reschedule"
        let date = data.eXPECTEDDONEDATE.ConvertToDate
        if  date.trimTime.compare(Date().trimTime) == ComparisonResult.orderedAscending {
            rescudle.isHidden = true
            cancel.isHidden = true
        }
    }
    
    
    @objc func cancelCliked()
    
    {
        print("data?.DOC_ID")

        print(data?.DOC_ID)
        self.delegate!.CancelOrderClicked(self)

    }
    
    @objc func rateCliked() {
        delegate?.rateClicked(self)
    }
    
    @objc func RescheduleRequestClicked()
    {
        self.delegate!.CellClicked(self)

    }
    
    @IBAction func CancelClicked(sender: UIButton)
    {
        
        let alertView = SCLAlertView()
        alertView.addButton( UserManager.isArabic ? "إلغاء الحجز" : "Cancel Appointment") {
            alertView.dismissAnimated()
            self.CancelAppointment()
        }
        alertView.addButton( UserManager.isArabic ? "إعادة الحجز" : "Reschedule Appointment") {
            alertView.dismissAnimated()
            self.delegate!.CellClicked(self)
        }
        
        alertView.showTitle( UserManager.isArabic ? "المزيد" : "More Options", subTitle:   UserManager.isArabic ? "ماذا تريد ؟ " : "What would you like to do?", style: .notice, closeButtonTitle:  UserManager.isArabic ? "إخفاء" : "Dismiss", timeout: nil, colorStyle: 0x3788B0, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
    }
    func CancelAppointment()
    {
        let alertView = SCLAlertView()
        
        alertView.addButton(UserManager.isArabic ? "إلغاء الحجز" : "Cancel Appointment") {
            alertView.dismissAnimated()
            self.delegate!.CancelOrderClicked(self)
        }
        alertView.showTitle(UserManager.isArabic ? "ملحوظة" : "Note", subTitle:  UserManager.isArabic ? "هل تريد إلغاء الحجز" : "Do you want to cancel appointment", style: .notice, closeButtonTitle: UserManager.isArabic ? "إخفاء" : "Dismiss", timeout: nil, colorStyle: 0x3788B0, colorTextButton: 0xFFFFFF, circleIconImage: nil , animationStyle: .topToBottom)
   
    
    }
    
    @IBAction func CellClicked(sender: UIButton)
    {
        self.delegate!.CellClicked(self)
    }
    
}

