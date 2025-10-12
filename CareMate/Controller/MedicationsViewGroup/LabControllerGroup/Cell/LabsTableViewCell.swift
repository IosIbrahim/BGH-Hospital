//
//  LabsTableViewCell.swift
//  CareMate
//
//  Created by Khabber on 24/05/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

//
//  LabRadCell.swift
//  CareMate
//
//  Created by Yo7ia on 1/1/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import UIKit

class LabsTableViewCell: UITableViewCell {
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var doctorLbl: UILabel!
    @IBOutlet weak var historyImg: UIImageView!
//    @IBOutlet weak var resultImg: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!

    @IBOutlet weak var PacksImg: UIImageView!
    @IBOutlet weak var labRadIocn: UIImageView!

    
    @IBOutlet weak var cashImg: UIImageView!
    @IBOutlet weak var alarmImg: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var labelAlert: UILabel!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var paymentText: UILabel!
    @IBOutlet weak var placeName: UILabel!

    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var stackViewLabResult: UIStackView!
    
    @IBOutlet weak var labelSpeciality: UILabel!
    @IBOutlet weak var imageViewDoc: UIImageView!
    @IBOutlet weak var labelVisitDateTitle: UILabel!
    @IBOutlet weak var labelVisitDate: UILabel!
    @IBOutlet weak var labelVisitTypeTitle: UILabel!
    @IBOutlet weak var labelVisitType: UILabel!
    @IBOutlet weak var labelPlaceTitle: UILabel!
    @IBOutlet weak var labelImportantInstructions: UILabel!
    @IBOutlet weak var viewRad: UIView!
    @IBOutlet weak var labelRad: UILabel!
    

    var isLab = true
    var data: LabRadDTO?
    var delegate: LabRadCellDelagete?
    var delegateShow: showInfoProtocal?

  
    func configCell(doctor: LabRadDTO) {
        
        if UserManager.isArabic {
            labelVisitDateTitle.text = "تاريخ الزيارة"
            labelVisitTypeTitle.text = "نوع الزيارة"
            labelPlaceTitle.text = "الفرع"
            labelImportantInstructions.text = "تعليمات هامة"
            labelRad.text = "صور الآشعة"
        }
        labelVisitType.text = UserManager.isArabic ? doctor.VISIT_TYPE_NAME_AR : doctor.VISIT_TYPE_NAME_EN
        labelVisitDate.text = doctor.VISIT_START_DATE.ConvertToDate.withMonthName
        viewMain.makeShadow(color: .black, alpha: 0.14, radius: 4)
        if isLab{
            labRadIocn.image = UIImage(named: "LabIcon")

        } else {
            stackViewLabResult.isHidden = true
            labRadIocn.image = UIImage(named: "BHG-Xray")

        }
        self.data = doctor
        self.serviceLbl.text = UserManager.isArabic ? doctor.sERVICE_NAME_AR :doctor.sERVICE_NAME_EN
        self.doctorLbl.text = UserManager.isArabic ? doctor.eMP_AR_DATA :doctor.eMP_EN_DATA
        self.dateLbl.text = doctor.rEQ_DATE.formateDAte(dateString: doctor.rEQ_DATE , formateString: "dd MMMM yyyy")
        

        
        self.resultLbl.text = UserManager.isArabic ? doctor.nORMALSTATUS_NAME_AR : doctor.nORMALSTATUS_NAME_EN
        
        let des = UserManager.isArabic ? self.data?.PREPARE_DESC_AR : self.data?.PREPARE_DESC_EN
        self.labelAlert.text = des?.replacingOccurrences(of: "/n", with: "\n")
        
        if self.data?.PREPARE_DESC_AR != ""{
            viewAlert.isHidden = false
        }
        else{
            viewAlert.isHidden = true
        }
        
        labelSpeciality.text = UserManager.isArabic ? doctor.SPECIALITY_NAME_AR : doctor.SPECIALITY_NAME_EN
        self.viewReport.isHidden = ((doctor.sERVSTATUS.lowercased() == "f" || doctor.sERVSTATUS.lowercased() == "t" || doctor.sERVSTATUS == "Q" || doctor.sERVSTATUS.lowercased() == "v" )) ? false : true
        self.resultLabel.isHidden = ( (doctor.sERVSTATUS.lowercased() == "f" || doctor.sERVSTATUS.lowercased() == "t" || doctor.sERVSTATUS == "Q" || doctor.sERVSTATUS.lowercased() == "v" )) ? false : true

        let tapMenu: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuBtnClicked))
        let tapMenuResult: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuBtnClickedPacks))
        tapMenu.numberOfTapsRequired = 1
        tapMenuResult.numberOfTapsRequired = 1
        viewReport.addGestureRecognizer(tapMenuResult)

        paymentText.text = UserManager.isArabic ? "الحالة" : "Status"
        resultLabel.text = UserManager.isArabic ? "عرض التقرير" : "Show report"
        if isLab == true{
            resultText.text = UserManager.isArabic ? "نتيجة التحاليل" : "Lab Result"
        }
        else{
            resultText.text = UserManager.isArabic ? "نتيجة الاشعة" : "Radiology Result"

        }
                placeName.text = UserManager.isArabic ? doctor.BRANCH_NAME_AR : doctor.BRANCH_NAME_EN

        if !isLab {
            if doctor.sERVSTATUS.lowercased() == "f" || doctor.sERVSTATUS.lowercased() == "v" {
                viewRad.isHidden = false
                viewReport.isHidden = false
            } else {
                viewRad.isHidden = true
                viewReport.isHidden = true
            }
            viewRad.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openRad)))
        } else {
            viewRad.isHidden = true
        }
        
        if isLab {
            print(doctor.sERVSTATUS.lowercased())
            switch doctor.sERVSTATUS.lowercased() {
            case "w", "k":
                statusLbl.text = UserManager.isArabic ? "تحتاج موافقة" : "Waiting for Approval"
                break
            case "p":
                statusLbl.text = UserManager.isArabic ? "تمت الموافقة" : "Approved"
                break
            case "r", "s", "j":
                statusLbl.text = UserManager.isArabic ? "تم الطلب" : "For Sampling"
                break
            case "i", "e", "d", "v":
                statusLbl.text = UserManager.isArabic ? "تم تسلم العينة (للكميائي)" : "Sample Received (lab. doctor)"
                break
            case "f", "t", "q":
                statusLbl.text = UserManager.isArabic ? "تم التأكيد" : "Confirmed"
                break
            default:
                statusLbl.text = UserManager.isArabic ? "تم الطلب" : "For Sampling"
                break
            }
        } else {
            switch doctor.sERVSTATUS.lowercased() {
            case "r", "s", "e":
                statusLbl.text = UserManager.isArabic ? "يتم جدولتها" : "To be Scheduled"
                break
            case "m", "l", "t":
                statusLbl.text = UserManager.isArabic ? "على الجهاز" : "On modality"
                break
            case "f":
                statusLbl.text = UserManager.isArabic ? "مؤكدة" : "Confirmed"
                break
            case "w", "k":
                statusLbl.text = UserManager.isArabic ? "تحتاج موافقة" : "Waiting for Approval"
                break
            case "p", "q", "x":
                statusLbl.text = UserManager.isArabic ? "تمت الموافقة" : "Approved"
                break
            case "v":
                statusLbl.text = UserManager.isArabic ? "تم التسليم" : "Delivered"
                break
            default:
                break
            }
        }
    }

    
    @IBAction func showInfo(sender: UIButton)
    {
     
        self.delegateShow?.showInfoProtocal(self.data)

    }
    
    
    @objc func MenuBtnClicked() {
        self.delegate?.CellClicked(self)
    }
    
    @objc func MenuBtnClickedPacks() {
        self.delegate?.CellClickedPacks(self)
    }
    
    @objc func openRad() {
        delegate?.openRad(self)
    }
}
extension UIView
{
    func showToast(toastMessage:String,duration:CGFloat)
    {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = UIColor(red: CGFloat(255.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(0.6))
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = .black
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont.init(name: "Helvetica Neue", size: 17)
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
        lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: self.bounds.size.height - 20 - ((expectedSizeTitle.height+16)/2), width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
        lblMessage.layer.cornerRadius = 8
        lblMessage.layer.masksToBounds = true
//        lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        bgView.addSubview(lblMessage)
        self.addSubview(bgView)
        lblMessage.alpha = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            lblMessage.alpha = 0
            bgView.alpha = 0
            bgView.removeFromSuperview()
        }

    }
}
extension CGFloat
{
    func getminimum(value2:CGFloat)->CGFloat
    {
        if self < value2
        {
            return self
        }
        else
        {
            return value2
        }
    }
}





extension UILabel
{
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }

    var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    override open func draw(_ rect: CGRect) {
        if let insets = padding {
        } else {
            self.drawText(in: rect)
        }
    }


}

