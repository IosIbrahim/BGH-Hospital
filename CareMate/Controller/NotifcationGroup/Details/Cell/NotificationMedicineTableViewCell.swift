//
//  NotificationMedicineTableViewCell.swift
//  CareMate
//
//  Created by m3azy on 24/10/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class NotificationMedicineTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setData(_ model: NotificationModel) {
        labelName.text = UserManager.isArabic ? model.ITEMARNAME : model.ITEMENNAME
    }
}
