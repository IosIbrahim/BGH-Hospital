//
//  AccoutMobileTableViewCell.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 29/07/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class AccoutMobileTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.setBorder(color: .gray, radius: 8, borderWidth: 1)
        if UserManager.isArabic {
            labelChange.text = "تغيير"
        }
    }
    
    func setData(_ user: UserMobileDTO) {
        labelNumber.text = user.PATIENTID
        labelName.text = user.COMPLETEPATNAME_EN
        let imageUrl = "\(Constants.APIProvider.IMAGE_BASE)\(user.PAT_PIC ?? "")"
        imageViewUser.loadFromUrl(url: imageUrl, placeHolder: "Group 2319")
    }
}
