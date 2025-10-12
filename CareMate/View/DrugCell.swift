//
//  DrugCell.swift
//  CareMate
//
//  Created by Yo7ia on 1/1/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//



import UIKit

class DrugCell: UITableViewCell {
    @IBOutlet weak var drugLbl: UILabel!
    @IBOutlet weak var doseLbl: UILabel!
    @IBOutlet weak var doctorLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    func configCell(doctor: DrugDTO) {
        self.drugLbl.text = UserManager.isArabic ? doctor.nAME_AR : doctor.nAME_EN
        self.doseLbl.text = UserManager.isArabic ? doctor.nOTES_AR : doctor.nOTES_EN
        self.doctorLbl.text = UserManager.isArabic ? doctor.dOC_NAME_AR : doctor.dOC_NAME_EN
        self.dateLbl.text = doctor.sTARTDATE
    }
}
