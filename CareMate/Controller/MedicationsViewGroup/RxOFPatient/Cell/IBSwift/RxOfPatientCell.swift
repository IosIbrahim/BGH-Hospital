//
//  RxOfPatientCell.swift
//  CareMate
//
//  Created by MAC on 28/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

protocol ReceptionPrintProtocol {
    func printReception(_ index:Int)
}

class RxOfPatientCell: UITableViewCell {
    @IBOutlet weak var visitType: UILabel!
    @IBOutlet weak var Dcotor: UILabel!
    @IBOutlet weak var VisitDate: UILabel!
    @IBOutlet weak var RxType: UILabel!
    @IBOutlet weak var ItemCount: UILabel!
    
    @IBOutlet weak var ItemCountText: UILabel!
    @IBOutlet weak var labelBranchTitle: UILabel!
    @IBOutlet weak var labelBranch: UILabel!
    @IBOutlet weak var pickerPrint: UIView!
    @IBOutlet weak var lblPrint: UILabel!
    
    @IBOutlet weak var ItemsApproved: UILabel!
    @IBOutlet weak var ItemsApprovedCount: UILabel!
    @IBOutlet weak var RxDate: UILabel!
    @IBOutlet weak var visitTypeText: UILabel!
    
    @IBOutlet weak var visitDateText: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var viewApproval: UIView!
    @IBOutlet weak var labelSpeciality: UILabel!
    @IBOutlet weak var labelShowDetails: UILabel!
    
    var index: Int = .zero
    var delegate: ReceptionPrintProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.makeShadow(color: .black, alpha: 0.14, radius: 4)

    }

    
    func configure(_ object:RxModel, monthly: Bool = true)  {
        visitType.text = UserManager.isArabic ? object.VISIT_TYPE_AR :object.VISIT_TYPE_EN
        Dcotor.text = UserManager.isArabic ? object.DOC_NAME_AR :object.DOC_NAME_EN
        RxDate.text = object.MEDPLANDATE.formateDAte(dateString: object.MEDPLANDATE, formateString: "dd MMMM yyyy")
        RxType.text = UserManager.isArabic ? object.PRESC_TYPE_AR :object.PREC_TYPE_EN
        ItemCount.text = String(Int(object.APPROVED_ITEMS_COUNT )! + Int(object.DIS_APPROVED_ITEMS_COUNT)! )
        labelSpeciality.text = UserManager.isArabic ? object.SPECIALTY_NAME_AR : object.SPECIALTY_NAME_EN
       
        labelBranch.text = UserManager.isArabic ? object.HOSP_NAME_AR : object.HOSP_NAME_EN
        VisitDate.text  =  object.VISIT_START_DATE.formateDAte(dateString: object.VISIT_START_DATE, formateString: "dd MMMM yyyy")
        ItemsApprovedCount.text = object.APPROVED_ITEMS_COUNT
        
        ItemCount.text = "\( (Int(object.APPROVED_ITEMS_COUNT ?? "") ?? 0) + (Int(object.REGULAR_ITEMS_COUNT ?? "") ?? 0) + (Int(object.NEED_APPROVAL_ITEMS_COUNT ?? "") ?? 0))"

        
        if UserManager.isArabic{
            visitTypeText.text = "نوع الزيارة"
            visitDateText.text = "تاريخ الزيارة"
            lblPrint.text = "طباعة"
            lblPrint.text = "مشاركة"
            ItemsApproved.text =  "تم الموافقة"
            ItemCountText.text = "عنصر"
            labelBranchTitle.text = "الفرع"
            labelShowDetails.text = "عرض التفاصيل"
        }
        else{
            visitTypeText.text = "Visit Type"
            visitDateText.text = "Visit Date"
            lblPrint.text = "Print"
            lblPrint.text = "Share"
            ItemsApproved.text = "APPROVED"
            ItemCountText.text = "Item"
        }
        lblPrint.textAlignment = .center
        labelShowDetails.textAlignment = .center

        viewApproval.isHidden = !monthly
        viewApproval.isHidden = true
        pickerPrint.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(printRec)))

    }
    
    @objc func printRec() {
        delegate?.printReception(index)
    }
    
    func configureString(_ object:String)  {
//        visitType.text = UserManager.isArabic ? object.VISIT_TYPE_AR :object.VISIT_TYPE_EN
//        Dcotor.text = UserManager.isArabic ? object.DOC_NAME_AR :object.DOC_NAME_EN
//        RxDate.text = object.MEDPLANDATE.formateDAte(dateString: object.MEDPLANDATE, formateString: "dd/MM/yyyy HH:mm:ss")
//        RxType.text = UserManager.isArabic ? object.PRESC_TYPE_AR :object.PREC_TYPE_EN
//        ItemCount.text = object.REGULAR_ITEMS_COUNT
//        ItemsApproved.text = object.APPROVED_ITEMS_COUNT
//        VisitDate.text  =  object.VISIT_START_DATE.formateDAte(dateString: object.VISIT_START_DATE, formateString: "dd/MM/yyyy HH:mm:ss")
        
        
//        Outpatient
//         Visit No 7
//         From 15/01/2022 12:36 pm
//         Opened
//         Doctor Mohamad Azab Mohamad
//        Internal Medicine Clinic
        
        var arrayOfInfo =   object.components(separatedBy: ",")
      

        
        for item in arrayOfInfo {

            print("$$$$$$$$$$$$$$$")
            print(item)
        }
        visitType.text = arrayOfInfo[0]
        VisitDate.text = arrayOfInfo[2]
        Dcotor.text = arrayOfInfo[4]
//        ItemsApproved.text  = arrayOfInfo[3]
        
        if UserManager.isArabic
        {
       
            visitTypeText.text = "نوع الزيارة"
            visitDateText.text = "تاريخ الزيارة"
        }
        else
        {
            visitTypeText.text = "Visit Type"
            visitDateText.text = "Visit Date"


        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
