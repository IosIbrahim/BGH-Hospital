//
//  PatientReportCell.swift
//  CareMate
//
//  Created by Khabeer on 2/1/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

protocol ReportCellDelegate {
    func showReport(_ index: Int)
}

class ReportTableViewCell: UITableViewCell {
    @IBOutlet weak var doctorLbl: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var Desc: UILabel!
    @IBOutlet weak var ReportTitle: UILabel!
//    @IBOutlet weak var viewMAin: UIView!
    @IBOutlet weak var loadText: UILabel!
    @IBOutlet weak var dateLAbel: UILabel!

    
    @IBOutlet weak var viewLoad: UIView!
    @IBOutlet weak var labelSpec: UILabel!
    @IBOutlet weak var labelVisitTypeTitle: UILabel!
    @IBOutlet weak var labelVisitType: UILabel!
    @IBOutlet weak var labelVisitDateTitle: UILabel!
    @IBOutlet weak var labelVisitDate: UILabel!
    @IBOutlet weak var labelPlacetitle: UILabel!
    
    
    var delegate: ReportCellDelegate?
    var index = 0
    
    

    func configCell(report: PatientReportDTO) {
        self.doctorLbl.text = UserManager.isArabic ? report.VISIT_DOC_NAME_AR : report.VISIT_DOC_NAME_EN
        labelSpec.text = UserManager.isArabic ? report.SPECIALITY_NAME_AR : report.SPECIALITY_NAME_EN
        self.place.text = UserManager.isArabic ? report.BRANCH_NAME_AR : report.BRANCH_NAME_EN
        self.Desc.text = UserManager.isArabic ? report.DESC_AR : report.DESC_EN
//        self.ReportTitle.text = UserManager.isArabic ? "التقرير" : "Report"
        
        dateLAbel.text = report.LASTMODDATE.formateDAte(dateString: report.LASTMODDATE , formateString: "dd MMMM yyyy")
        loadText.text = UserManager.isArabic ? "عرض التقرير" : "Show report"
//        viewMAin.makeShadow(color: .black, alpha: 0.14, radius: 4)
       
//        viewLoad.setTitle("", for: .normal)
        
        viewLoad.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editPhoneNumber)))
        labelVisitDate.text = report.VISIT_START_DATE.ConvertToDate.withMonthName
        labelVisitType.text = UserManager.isArabic ? report.VISIT_TYPE_AR : report.VISIT_TYPE_EN
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if UserManager.isArabic {
            labelVisitDateTitle.text = "تاريخ الزيارة"
            labelVisitTypeTitle.text = "نوع الزيارة"
            labelPlacetitle.text = "الفرع"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    var weView= ""
//    let Vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewController") as! WebviewController
//    Vc.reportText = replaced
//    
//    self.navigationController?.pushViewController(Vc, animated: true)

    @objc func editPhoneNumber() {
        delegate?.showReport(index)
    }
}

