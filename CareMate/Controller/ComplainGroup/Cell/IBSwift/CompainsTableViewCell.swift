//
//  CompainsTableViewCell.swift
//  CareMate
//
//  Created by MAC on 06/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class CompainsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var importanceTextKabel: UILabel!
    
    @IBOutlet weak var labelVisitTypeText: UILabel!
    @IBOutlet weak var labelImportanceText: UILabel!
    @IBOutlet weak var lableComplaintText: UILabel!
    @IBOutlet weak var labelComplaintTypeText: UILabel!
    @IBOutlet weak var LabelcomplaintNumberText: UILabel!
    
    
    @IBOutlet weak var labelVisitType: UILabel!
    @IBOutlet weak var labelImportance: UILabel!
    @IBOutlet weak var lableComplaint: UILabel!
    @IBOutlet weak var labelComplaintType: UILabel!
    @IBOutlet weak var LabelcomplaintNumber: UILabel!
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDateTitle: UILabel!
    @IBOutlet weak var labelStatusTitle: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    @IBOutlet weak var labelSpeciality: UILabel!
    @IBOutlet weak var labelDocName: UILabel!
    @IBOutlet weak var labelVisitDateTitle: UILabel!
    @IBOutlet weak var labelVisitDate: UILabel!
    @IBOutlet weak var labelVisitTypeTitle: UILabel!
    @IBOutlet weak var labelVisitType2: UILabel!
    @IBOutlet weak var labelPlaceTitle: UILabel!
    @IBOutlet weak var labelplace: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserManager.isArabic {
            labelVisitDateTitle.text = "تاريخ الزيارة"
            labelVisitTypeTitle.text = "نوع الزيارة"
            labelPlaceTitle.text = "الفرع"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        "3BP-Ic-4WK.text" = "الاهميه";
//
//        /* Class = "UILabel"; text = "Complaint type"; ObjectID = "3ru-Is-B7r"; */
//        "3ru-Is-B7r.text" = "نوع الشكوي";
//
//        /* Class = "UILabel"; text = "Visit Type"; ObjectID = "Jcv-2n-6LV"; */
//        "Jcv-2n-6LV.text" = "نوع الزياره";
//
//        /* Class = "UILabel"; text = "Complaint Number"; ObjectID = "Qdc-4w-wce"; */
//        "Qdc-4w-wce.text" = "رقم الشكوب";
    }
    
    func configure(_ object:ComplainsDTO)  {

//        if UserManager.isArabic
//        {
//            labelImportanceText.text = "الاولويه"
//
//            lableComplaintText.text = "نوع الشكوي"
//            labelVisitTypeText.text = "نوع الزياره"
////            labelComplaintTypeText.text = "رقم الشكوي"
//
//            labelImportance.text = object.COMPLAINTS_CAT_NAME_AR
//
//        }
//
//        else
//        {
//            labelImportanceText.text = "Priority"
//
//            lableComplaintText.text =  "Complaint type"
//            labelVisitTypeText.text = "Visit Type"
////            labelComplaintTypeText.text = "Complaint Number"
//            labelImportance.text = object.COMPLAINTS_CAT_NAME_EN
//
//        }
        viewMain.makeShadow(color: .black, alpha: 0.14, radius: 4)

        
        if UserManager.isArabic{
            labelComplaintType.textAlignment = .right
            LabelcomplaintNumber.textAlignment = .right
            labelImportance.textAlignment = .right
            labelDateTitle.text = "التاريخ"
            labelStatusTitle.text = "الحالة"
        }
        else{
            labelComplaintType.textAlignment = .left
            LabelcomplaintNumber.textAlignment = .left
            labelImportance.textAlignment = .left
        }
        
        labelComplaintType.text = UserManager.isArabic ? object.COMPLAINT_STATUS_NAME_AR :object.COMPLAINT_STATUS_NAME_EN
        LabelcomplaintNumber.text = UserManager.isArabic ? object.COMPLAIN_SERIAL :object.COMPLAIN_SERIAL
        labelImportance.text =  UserManager.isArabic ? object.COMPLAINTS_TYPE_NAME_AR + " / " + object.COMPLAINTS_CAT_NAME_AR :object.COMPLAINTS_TYPE_NAME_EN + " / " + object.COMPLAINTS_CAT_NAME_EN
        labelDate.text = object.COMPLAIN_TRANSDATE.ConvertToDate.withMonthNameWithTime
//        labelStatus.text = UserManager.isArabic ? object.COMPLAINT_STATUS_NAME_AR.first ?? "" : object.COMPLAINT_STATUS_NAME_EN.first ?? ""
        labelDocName.text = UserManager.isArabic ? object.DOC_NAME_AR : object.DOC_NAME_EN
        labelVisitDate.text = object.VISIT_START_DATE.ConvertToDate.withMonthName
        labelVisitType2.text = UserManager.isArabic ? object.CLASSNAME : object.CLASSNAME_EN
        labelplace.text = UserManager.isArabic ? object.HOSP_AR_NAME : object.HOSP_EN_NAME
    }
}
