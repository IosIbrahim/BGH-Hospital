//
//  AllergyTableViewCell.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class AllergyTableViewCell: UITableViewCell {
    @IBOutlet weak var labelDes: UILabel!
    @IBOutlet weak var labelALLERGY: UILabel!
    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet weak var labelTransTime: UILabel!
    @IBOutlet weak var typeText: UILabel!


    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        typeText.text = UserManager.isArabic ? "النوع" : "Type"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(_ Object:allergyModel)  {
        
        labelALLERGY.text = UserManager.isArabic ? Object.ALLERGY_TYPE_NAME_AR : Object.ALLERGY_TYPE_NAME_EN
        labelDes.text = UserManager.isArabic ? Object.DESC_AR : Object.DESC_EN
//        labelTransTime.text = Object.TRANS_DATE.formateDAte(dateString: Object.TRANS_DATE, formateString: "dd-MM_yyy HH:mm:ss")
        labelStartTime.text = Object.DATE_START.formateDAte(dateString: Object.DATE_START, formateString: "dd MMMM yyyy")
        
        if UserManager.isArabic
        {
        
        }
        else
        {
     
        }
     
    }
    
}

