//
//  reportRequestsTableViewCell.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit


protocol openSave {
    func openSaveFunc()
//    func openWebView(_ index: Int)
    func showReport(_ index: Int)
    func delete(_ index: Int)
}

class reportRequestsTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var labelPatientNameText: UILabel!
//    @IBOutlet weak var labelMedicalNoText: UILabel!
//    @IBOutlet weak var labelReportNameText: UILabel!
//    @IBOutlet weak var labelRequestStatuesText: UILabel!
//    @IBOutlet weak var requestDateText: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var needSupportText: UILabel!
    
    @IBOutlet weak var labelStatues: uilabelCenter!

    @IBOutlet weak var viewStatus: UIView!
    
    @IBOutlet weak var labelPatientName: UILabel!
    @IBOutlet weak var labelMedicalNo: UILabel!
    @IBOutlet weak var labelReportName: UILabel!
//    @IBOutlet weak var labelRequestStatues: UILabel!
    @IBOutlet weak var requestDate: UILabel!
    @IBOutlet weak var needSupport: UILabel!
    @IBOutlet weak var viewStatues: UILabel!
    @IBOutlet weak var labelSpeciality: UILabel!
    @IBOutlet weak var visitDateLabel: UILabel!
    @IBOutlet weak var labelVisitDate: UILabel!
    @IBOutlet weak var labelVisitTypeTitle: UILabel!
    @IBOutlet weak var labelVisitType: UILabel!
    @IBOutlet weak var labelLocationTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var viewShowReport: UIView!
    @IBOutlet weak var labelShowReport: UILabel!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var labelDelete: UILabel!
    
    var delegate:openSave?
    var index = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UserManager.isArabic
        {
//            labelPatientNameText.text = "اسم المريض"
//            labelMedicalNoText.text = "الرقم المرضي"
//            labelReportNameText.text  = "اسم التقرير"
//            labelRequestStatuesText.text  = "الحاله"
//            requestDateText.text = "تاريخ الطلب"
            needSupportText.text = "يحتاج توقيع"
            visitDateLabel.text = "تاريخ الزيارة"
            labelVisitTypeTitle.text = "نوع الزيارة"
            labelLocationTitle.text = "الفرع"
            labelShowReport.text = "عرض التقرير"
                labelPatientName.textAlignment = .right
                labelMedicalNo.textAlignment = .right
                labelReportName.textAlignment = .right
        
            labelDelete.text = "حذف"
                labelReportName.textAlignment = .left

        }
        else
        {
//            labelPatientNameText.text = "Patient Name"
//            labelMedicalNoText.text = "Medical No"
//            labelReportNameText.text  = "report Name"
//            labelRequestStatuesText.text  = "Statues"
//            requestDateText.text = "request Date"
            needSupportText.text = "Need Sign"
            
            labelPatientName.textAlignment = .left
            labelMedicalNo.textAlignment = .left


        }
        viewBackground.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewShowReport.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showReport)))
        viewDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteReport)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(_ Object:ReportRequestsModel)  {
        
        labelPatientName.text = UserManager.isArabic ? Object.DOC_NAME_AR  : Object.DOC_NAME_EN
        labelSpeciality.text = UserManager.isArabic ? Object.SPECIALITY_NAME_AR : Object.SPECIALITY_NAME_EN
        labelMedicalNo.text = UserManager.isArabic ? Object.SERIAL  : Object.SERIAL
        requestDate.text = UserManager.isArabic ? Object.ENTRY_DATE.formateDAte(dateString: Object.ENTRY_DATE, formateString: "yyyy MMMM  dd")  : Object.ENTRY_DATE
        labelVisitDate.text = Object.ENTRY_DATE.formateDAte(dateString: Object.VISIT_START_DATE, formateString: "yyyy MMMM  dd")
        needSupport.text = UserManager.isArabic ? Object.NEED_SIGN_AR  : Object.NEED_SIGN_EN
//        labelRequestStatues.text = UserManager.isArabic ? Object.STATUS_AR  : Object.STATUS_EN
        labelReportName.text = UserManager.isArabic ? Object.TEMP_DESC_AR  : Object.TEMP_DESC_EN
        
        if Object.ACTION_SER == "1" || Object.ACTION_SER == "2" || Object.ACTION_SER == "4" || Object.ACTION_SER == "6" {
            viewStatus.isHidden = false
            labelStatues.text = UserManager.isArabic ? Object.STATUS_AR : Object.STATUS_EN
        } else {
            viewStatus.isHidden = true
        }
        
        if Object.STATUS_AR == "Written"{
            
        }
        else if Object.STATUS_EN == "New"{
            
        }
        labelVisitType.text = UserManager.isArabic ? Object.VISIT_TYPE_AR : Object.VISIT_TYPE_EN
        labelLocation.text = UserManager.isArabic ? Object.BRANCH_NAME_AR : Object.BRANCH_NAME_EN
        if Object.IS_FILE_SCANNED == "1" {
            viewShowReport.isHidden = false
        } else {
            viewShowReport.isHidden = true
        }
        if Object.ACTION_SER == "6" {
            viewDelete.isHidden = true
        } else {
            viewDelete.isHidden = false
        }
    }
    @IBAction func openSAve(_ sender: Any) {
        delegate?.openSaveFunc()
    }
    
    @objc func showReport() {
        delegate?.showReport(index)
    }
    
    @objc func deleteReport() {
        delegate?.delete(index)
    }
}
