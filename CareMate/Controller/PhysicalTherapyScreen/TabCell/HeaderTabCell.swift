//
//  HeaderTabCell.swift
//  CareMate
//
//  Created by Ibrahim on 05/05/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

import UIKit

class HeaderTabCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var picker: UIView!
    
    var cellSelected:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picker.setShadowLight()
        // Initialization code
    }
   
    
    func drawCell(_ title:String) {
        lblTitle.text = title
        picker.backgroundColor = cellSelected ? UIColor.fromHex(hex: ConstantsData.physical_blue, alpha: 1.0):.white
        lblTitle.textColor = cellSelected ? .white:UIColor.fromHex(hex: ConstantsData.physical_black, alpha: 1.0)
    }
}
