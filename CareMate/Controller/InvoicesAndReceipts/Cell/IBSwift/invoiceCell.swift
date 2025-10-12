//
//  invoiceCell.swift
//  CareMate
//
//  Created by MAC on 18/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class invoiceCell: UITableViewCell {
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDoctorTitle: UILabel!
    @IBOutlet weak var labelDoctor: UILabel!
    @IBOutlet weak var labelMoneyTitle: UILabel!
    @IBOutlet weak var labelMoney: UILabel!
    @IBOutlet weak var labelContractTitle: UILabel!
    @IBOutlet weak var labelContract: UILabel!
    @IBOutlet weak var labelStartDateTitle: UILabel!
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelEndDateTitle: UILabel!
    @IBOutlet weak var labelEndTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserManager.isArabic {
            labelDoctorTitle.text = "الطبيب"
            labelMoneyTitle.text = "المبلغ"
            labelContractTitle.text = "نوع التعاقد"
            labelStartDateTitle.text = "تاريخ البداية"
            labelEndDateTitle.text = "تاريخ النهاية"
        }
    }

    func configure(_ objc: invociesDTO?) {
        labelDoctor.text = objc?.DOC_NAME_EN
        labelContract.text = objc?.FINAN_NAME_EN
        labelDate.text = objc?.BILLDATE.formateDAte(dateString: objc?.VISIT_START_DATE, formateString: "E,d MMM yyyy HH:mm a")
        labelMoney.text = "\(objc?.PAT_SHARE ?? "") \(UserManager.isArabic ? "د.ك" : "KD")"
        labelStartDate.text = objc?.VISIT_START_DATE.formateDAte(dateString: objc?.VISIT_START_DATE, formateString: "d MMM yyyy")
        labelEndTitle.text = objc?.VISIT_END_DATE.formateDAte(dateString: objc?.VISIT_END_DATE, formateString: "d MMM yyyy")
        labelStartDate.textAlignment = .center
        labelEndTitle.textAlignment = .center
    }
}
