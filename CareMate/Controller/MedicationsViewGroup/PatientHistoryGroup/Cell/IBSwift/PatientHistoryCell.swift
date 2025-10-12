//
//  PatientHistoryCell.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
import ObjectMapper

class PatientHistoryCell: UITableViewCell {
    @IBOutlet weak var labelDescripation: UILabel!
    @IBOutlet weak var labelDepartment: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelSatutes: UILabel!
    @IBOutlet weak var viewSatutes: UIView!
    @IBOutlet weak var viewMain: UIView!




    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.makeShadow(color: .black, alpha: 0.14, radius: 4)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(_ Object:historyModel)  {
        
        labelDescripation.text = UserManager.isArabic ? Object.DESC_EN : Object.DESC_EN
      
        labelDepartment.text = UserManager.isArabic ? Object.VISIT_SPECIALITY_NAME_AR : Object.VISIT_SPECIALITY_NAME_EN
        
        
        labelDate.text = Object.VISIT_START_DATE.formateDAte(dateString: Object.VISIT_START_DATE , formateString: "dd MMMM yyyy")
        
                if Object.H_FAMILY_FLAG == "1"{
                    viewSatutes.layer.borderColor =  #colorLiteral(red: 0.9411764706, green: 0.6509803922, blue: 0.2705882353, alpha: 1)
                    
                    labelSatutes.text = UserManager.isArabic ? "مرض عائلي" : "Family Disease"
                    labelSatutes.tintColor = #colorLiteral(red: 0.9411764706, green: 0.6509803922, blue: 0.2705882353, alpha: 1)
                  }
                 else if Object.H_PAST_FLAG == "1"{
                      viewSatutes.layer.borderColor =  #colorLiteral(red: 0.1019607843, green: 0.6039215686, blue: 0.5490196078, alpha: 1)
                      labelSatutes.text = UserManager.isArabic ? "مرض قديم" : "Past Disease "
                      labelSatutes.tintColor = #colorLiteral(red: 0.1019607843, green: 0.6039215686, blue: 0.5490196078, alpha: 1)

                      
                  }
                  else if Object.H_PRESENT_FLAG == "1"
                  {
                      viewSatutes.layer.borderColor =  #colorLiteral(red: 0.1803921569, green: 0.3058823529, blue: 0.5568627451, alpha: 1)
                      labelSatutes.text = UserManager.isArabic ? "مرض حاضر" : "Present Disease "
                      labelSatutes.tintColor = #colorLiteral(red: 0.1803921569, green: 0.3058823529, blue: 0.5568627451, alpha: 1)
                  }
        else{
       
                let arrayOfDespcriptions = Object.DESC_EN.components(separatedBy: "-")
//                 labelSatutes.text =  arrayOfDespcriptions[1]
        }
        
        
        
       
    }
}
