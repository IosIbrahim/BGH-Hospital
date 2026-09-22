//
//  DoctorFilterCell.swift
//  CareMate
//
//  Created by Ibrahim on 22/09/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

import UIKit

class DoctorFilterCell: UICollectionViewCell {

    @IBOutlet weak var pickerFilter: UIView!
    @IBOutlet weak var lblFilter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pickerFilter.setBorder(color: UIColor.fromHex(hex: "#DDE4EC", alpha: 1.0), radius: 15, borderWidth: 1)
    }
    //#1B2A3A
    // #003B71 green
    // #DDE4EC border
    
    func drawCell(_ model:DoctorFilter,isSelect:Bool) {
        if isSelect {
            pickerFilter.backgroundColor = UIColor.fromHex(hex: "#003B71", alpha: 1.0)
            lblFilter.textColor = .white
        }else {
            pickerFilter.backgroundColor = .white
            lblFilter.textColor = UIColor.fromHex(hex: "#1B2A3A", alpha: 1.0)
        }
        lblFilter.textAlignment = .center
        lblFilter.text = model.title
    }
    
}


struct DoctorFilter {
    var id: Int
    var title:String
}
