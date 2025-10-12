//
//  FamilyTableViewCell.swift
//  CareMate
//
//  Created by Khabber on 09/05/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class FamilyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageViewGender: UIImageView!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.setBorder(color: .fromHex(hex: "#E5E9EF", alpha: 1), radius: 10, borderWidth: 1)
        if UserManager.isArabic {
            labelName.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelType.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelPhone.font = UIFont(name: "Tajawal-Regular", size: 17)
        }
    }

    func configure(_ object: familtyDTO) {
        labelName.text = UserManager.isArabic ? object.COMPLETEPATNAME_EN :  object.COMPLETEPATNAME_EN
        labelPhone.text = object.PATIENTID
        imageViewGender.image = UIImage.init(named: object.GENDERCODE.lowercased() == "f" ? "Group 7858" : "Group 7859")
        labelType.text = UserManager.isArabic ? object.RELATION_NAME_AR : object.RELATION_NAME_EN
    }
}
