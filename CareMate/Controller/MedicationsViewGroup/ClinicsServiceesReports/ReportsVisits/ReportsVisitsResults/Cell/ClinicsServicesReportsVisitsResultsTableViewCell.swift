//
//  ClinicsServicesReportsVisitsResultsTableViewCell.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 07/06/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

protocol CLinicsServicesReportsResultsVisitsDelegate {
    func showReports(index: Int)
}

class ClinicsServicesReportsVisitsResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDateTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var labelPreview: UILabel!
    
    var index = 0
    var delegate: CLinicsServicesReportsResultsVisitsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserManager.isArabic {
            labelDateTitle.text = "التاريخ"
            labelPreview.text = "إظهار النتيجة"
        }
        viewPreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showResults)))
    }

    func setData(model: ClinicServiceReportVisitResultModel) {
        labelDate.text = model.RESULT_DATE
    }
    
    @objc func showResults() {
        delegate?.showReports(index: index)
    }
}
