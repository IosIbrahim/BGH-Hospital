//
//  PatientReportCell.swift
//  CareMate
//
//  Created by Khabeer on 2/1/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class PatientReportCell: UITableViewCell {
    @IBOutlet weak var doctorLbl: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var Desc: UILabel!
    @IBOutlet weak var ReportTitle: UILabel!
    func configCell(report: PatientReportDTO) {
        self.doctorLbl.text = UserManager.isArabic ? report.EMP_AR_DATA : report.EMP_EN_DATA
        self.place.text = UserManager.isArabic ? report.PLACE_NAME_AR : report.PLACE_NAME_EN
        self.Desc.text = UserManager.isArabic ? report.DESC_AR : report.DESC_EN
        self.ReportTitle.text = UserManager.isArabic ? "التقرير" : "Report"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
