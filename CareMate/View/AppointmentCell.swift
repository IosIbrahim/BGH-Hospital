//
//  OrderCell.swift
//  الرومانسية
//
//  Created by Yo7ia on 4/2/18.
//  Copyright © 2018 Yo7ia. All rights reserved.
//





import UIKit
import SCLAlertView
protocol AppointmentCellDelagete {
    func CancelOrderClicked(_ data: AppoimentCollectionViewCell)
    func CellClicked(_ data: AppoimentCollectionViewCell)
    func rateClicked(_ data: AppoimentCollectionViewCell)

}
class AppointmentCell: UICollectionViewCell {
   
    @IBOutlet weak var hospital: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var dayText: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var rescudle: UIButton!
    @IBOutlet weak var queueNo: UILabel!

    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorClinic: UILabel!
    var delegate: AppointmentCellDelagete?
    var vc : UIViewController?
    var data : AppointmentDTO?
    var isUpcomming = true
    func configureCell(vc : UIViewController,data: AppointmentDTO)
    {
        
        
        
        self.data = data
        queueNo.text = self.data?.QUE_SYS_SER
        if self.data?.sTATUS_NAME_EN  == "New"
        {
//            moreBtn.isHidden = false
            cancel.isHidden = false
            rescudle.isHidden = false
        }
        else
        {
//            moreBtn.isHidden = true
            cancel.isHidden = true
            rescudle.isHidden = true

        }
        doctorName.text = "DR. "+data.eMP_EN_DATA
        doctorClinic.text = UserManager.isArabic ? data.cLINIC_NAME_AR :data.cLINIC_NAME_EN
        hospital.text = UserManager.isArabic ? data.hOSP_NAME_AR : data.hOSP_NAME_EN
        if data.sTATUS_NAME_EN == "Performed"
        {
            
            
            status.text =  UserManager.isArabic ? data.sTATUS_NAME_AR : "Conducted"
        }
        else
        {
            status.text =  UserManager.isArabic ? data.sTATUS_NAME_AR : data.sTATUS_NAME_EN
        }
       
        status.transform =  CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        statusView.Rounded(corner: 8)
        time.text = data.eXPECTEDDONEDATE.ConvertToDate.ToTimeOnly
        day.text = data.eXPECTEDDONEDATE.ConvertToDate.ToDayOnly
        dayText.text = data.eXPECTEDDONEDATE.ConvertToDate.dayOfWeek()!
        month.text = data.eXPECTEDDONEDATE.ConvertToDate.monthName()!
        switch (self.data!.sTATUS_NAME_EN) {
        case "New":
            self.statusView.backgroundColor = UIColor(fromRGBHexString: "008AAF")
            break
            
        case "Canceled":
//            self.moreBtn.isHidden = true
            cancel.isHidden = true
            rescudle.isHidden = true
            self.statusView.backgroundColor = UIColor(fromRGBHexString: "B22222")
            break
            
        case "Confirmed":
            self.statusView.backgroundColor = UIColor(fromRGBHexString: "228B22")
            break
        
        case "Performed":
            self.statusView.backgroundColor = UIColor(fromRGBHexString: "008080")
            break

        default:
            self.statusView.backgroundColor = UIColor(fromRGBHexString: "008AAF")
            break
        }
        print(isUpcomming)
//        moreBtn.isHidden = isUpcomming
        
        cancel.titleLabel?.text = UserManager.isArabic ? "Cancel" : "إلغاء"
        rescudle.titleLabel?.text = UserManager.isArabic ? "اعاده جدولة" : "Reschedule"
        
    }
    
    
    @IBAction func CancelRequestClicked(sender: UIButton)
    
    {
//        self.delegate!.CancelOrderClicked(self)

    }
    @IBAction func RescheduleRequestClicked(sender: UIButton)
    {
//        self.delegate!.CellClicked(self)

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
//            self.delegate!.CellClicked(self)
        }
        
        alertView.showTitle( UserManager.isArabic ? "المزيد" : "More Options", subTitle:   UserManager.isArabic ? "ماذا تريد ؟ " : "What would you like to do?", style: .notice, closeButtonTitle:  UserManager.isArabic ? "إخفاء" : "Dismiss", timeout: nil, colorStyle: 0x3788B0, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
    }
    func CancelAppointment()
    {
        let alertView = SCLAlertView()
        
        alertView.addButton(UserManager.isArabic ? "إلغاء الحجز" : "Cancel Appointment") {
            alertView.dismissAnimated()
//            self.delegate!.CancelOrderClicked(self)
        }
        alertView.showTitle(UserManager.isArabic ? "ملحوظة" : "Note", subTitle:  UserManager.isArabic ? "هل تريد إلغاء الحجز" : "Do you want to cancel appointment", style: .notice, closeButtonTitle: UserManager.isArabic ? "إخفاء" : "Dismiss", timeout: nil, colorStyle: 0x3788B0, colorTextButton: 0xFFFFFF, circleIconImage: nil , animationStyle: .topToBottom)
   
    
    }
    
    @IBAction func CellClicked(sender: UIButton)
    {
//        self.delegate!.CellClicked(self)
    }
    
}







