//
//  DiagnosisTableViewCell.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class DiagnosisTableViewCell: UITableViewCell {
    @IBOutlet weak var labelItemDescription: UILabel!
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelStatues: UILabel!
    @IBOutlet weak var labelDoctor: UILabel!
    @IBOutlet weak var viewMain: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.makeShadow(color: .black, alpha: 0.14, radius: 4)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ Object:diagnosisModel)  {
        
        labelItemDescription.text = Object.ITEM_DESC
        
        if UserManager.isArabic
        {
//            labelDoctor.text =  Object.DOC_NAME_AR
            labelStatues.text = Object.STATUS_NAME_AR
            labelDate.text = Object.LAST_MOSD_DATE.formateDAte(dateString: Object.LAST_MOSD_DATE, formateString: "dd MMMM yyyy")

        }
        else
        {
//            labelDoctor.text =  Object.DOC_NAME_EN
            labelStatues.text = Object.STATUS_NAME_EN
            labelDate.text = Object.LAST_MOSD_DATE.formateDAte(dateString: Object.LAST_MOSD_DATE, formateString: "dd MMMM yyyy")


        }
     
    }
}

