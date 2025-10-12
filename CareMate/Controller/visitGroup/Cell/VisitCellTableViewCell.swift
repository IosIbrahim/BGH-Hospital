//
//  VisitCellTableViewCell.swift
//  CareMate
//
//  Created by Khabber on 16/01/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class VisitCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var visitTypeText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var healer: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var visitType: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewEval: UIView!
    @IBOutlet weak var labelEval: UILabel!
    @IBOutlet weak var labelBranch: UILabel!
    @IBOutlet weak var labelBranchDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMain.makeShadow(color: .black, alpha: 0.14, radius: 4)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureString(_ object:visitDTO, hideEvaluation: Bool = true)  {
        if !hideEvaluation && object.EVAL_STATUS == "1" {
            viewEval.isHidden = false
        } else {
            viewEval.isHidden = true
        }
        visitType.text = UserManager.isArabic ? object.CLASSNAME_AR : object.CLASSNAME_EN
        if visitType.text == "" {
            visitType.text = object.CLASSNAME
        }
        date.text = object.VISIT_START_DATE
        healer.text = UserManager.isArabic ?  object.EMP_AR_DATA  : object.EMP_EN_DATA
        place.text =       UserManager.isArabic ?  object.SPECIALITY_NAME_AR  : object.SPECIALITY_NAME_EN
        labelBranchDetails.text = UserManager.isArabic ? object.NAME_AR : object.NAME_EN
        if UserManager.isArabic
        {
//           
            visitTypeText.text = "نوع الزيارة"
            labelEval.text = "تم التقييم"
            dateText.text = "التاريخ"
            labelBranch.text = "الفرع"
//            healerText.text = "المعالج"
//            placeText.text = "المكان"
//
//
        }
        else
        {
        
            visitTypeText.text = "Visit Type"
//            visitNumberText.text = "Visit Number"
            dateText.text = "Date"
            labelBranch.text = "Branch"
//            healerText.text = "Healer"
//            placeText.text = "Place"
//
//
        }
    }
    
}
