//
//  ClincCell.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/11/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import UIKit

class BranchCell: UITableViewCell {
    
    @IBOutlet weak var hospitalImage: UIImageView!
    @IBOutlet weak var hospitalNumber: UILabel!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var getlocation: UILabel!
    @IBOutlet weak var btnVisit: UIButton!
    
    var onlineAppointment: Branch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        hospitalImage.layer.cornerRadius = 10
        btnVisit.layer.cornerRadius = 8
    }
    
    func configCell(onlineAppointment: branchData)  {
        
        self.hospitalName.text =  UserManager.isArabic ? onlineAppointment.nameAr : onlineAppointment.nameEn
        self.hospitalNumber.text = onlineAppointment.Phone
//        self.hospitalDescropation.text = UserManager.isArabic ? onlineAppointment.descriptionAr : onlineAppointment.descriptionEn
        getlocation.text =  UserManager.isArabic ? onlineAppointment.descriptionAr : onlineAppointment.descriptionEn
        btnVisit.setTitle(UserManager.isArabic ? "زيارة الموقع" : "Visit site", for: .normal)
    }
    
    @IBAction func callBtn(_ sender: Any) {
        phone(phoneNum: self.hospitalNumber.text!)
    }
    
    func phone(phoneNum: String) {
        if let url = URL(string: "tel://\(phoneNum)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
}
