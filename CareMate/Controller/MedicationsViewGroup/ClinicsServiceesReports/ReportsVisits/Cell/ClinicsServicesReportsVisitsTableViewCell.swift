//
//  ClinicsServicesReportsVisitsTableViewCell.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 06/06/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

protocol CLinicsServicesReportsVisitsDelegate {
    func showReports(index: Int)
}

class ClinicsServicesReportsVisitsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDateTItle: UILabel!
    @IBOutlet weak var labelVisitTitle: UILabel!
    @IBOutlet weak var labelNumberTItle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelVisit: UILabel!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelResults: UILabel!
    @IBOutlet weak var viewResults: UIView!
    
    var index = 0
    var delegate: CLinicsServicesReportsVisitsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserManager.isArabic {
            labelDateTItle.text = "التاريخ"
            labelVisitTitle.text = "الزيارة"
            labelNumberTItle.text = "الرقم"
            labelResults.text = "النتائج"
        }
        viewResults.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showResults)))
    }

    func setData(model: ClinicServiceReportVisitModel) {
        labelDate.text = model.VISIT_START_DATE
        labelNumber.text = model.VISIT_ID
    }
    
    @objc func showResults() {
        delegate?.showReports(index: index)
    }
}
