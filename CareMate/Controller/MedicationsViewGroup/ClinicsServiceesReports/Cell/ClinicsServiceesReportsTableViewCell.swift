//
//  ClinicsServiceesReportsTableViewCell.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 06/06/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class ClinicsServiceesReportsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(model: ClinicServiceReportModel) {
        labelName.text = UserManager.isArabic ? model.NAME_AR : model.NAME_EN
        labelCount.text = model.COUNT_VAL
    }
}
