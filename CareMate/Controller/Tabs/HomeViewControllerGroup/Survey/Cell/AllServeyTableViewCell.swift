//
//  AllServeyTableViewCell.swift
//  CareMate
//
//  Created by m3azy on 19/09/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class AllServeyTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDateTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSpeciality: UILabel!
    @IBOutlet weak var labelVisitDate: UILabel!
    @IBOutlet weak var labelVisitDateTitle: UILabel!
    @IBOutlet weak var labelVisitTypeTitle: UILabel!
    @IBOutlet weak var labelVisitType: UILabel!
    @IBOutlet weak var labelBranchTitle: UILabel!
    @IBOutlet weak var labelBranch: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserManager.isArabic {
            labelDateTitle.text = "تاريخ الإستطلاع"
            labelVisitDateTitle.text = "تاريخ الزيارة"
            labelVisitTypeTitle.text = "نوع الزيارة"
            labelBranchTitle.text = "الفرع"
        }
//        labelDateTitle.setLineHeight(lineHeight: 0.8)
    }
    
    func setData(_ model: SurveyModel) {
        labelDate.text = model.TRANSDATE.ConvertToDate.withMonthName
        labelName.text = UserManager.isArabic ? model.DOCTOR_NAME_AR : model.DOCTOR_NAME_EN
        labelSpeciality.text = UserManager.isArabic ? model.PLACE_AR : model.PLACE_EN
        labelVisitDate.text = model.VISIT_START_DATE.ConvertToDate.withMonthName
        labelVisitType.text = UserManager.isArabic ? model.CLASSNAME : model.CLASSNAME_EN
        labelBranch.text = UserManager.isArabic ? model.HOSP_AR_NAME : model.HOSP_EN_NAME
    }
}

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineHeightMultiple = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
            self.textAlignment = .right
        }
    }
}
