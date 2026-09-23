//
//  daySlotCollectionViewCell.swift
//  CareMate
//
//  Created by Khabber on 20/06/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class daySlotCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelDayText: uilabelCenter!
    @IBOutlet weak var labelDaynumber: UILabel!

    @IBOutlet weak var mainView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        mainView.makeShadow(color: .black, alpha: 0.25, radius: 3)
//        self.transform = CGAffineTransform(scaleX: -1, y: 1)
        mainView.setBorder(color: UIColor.fromHex(hex: "#DDE4EC", alpha: 1.0), radius: 14, borderWidth: 1)
        mainView.Rounded(corner: 14)
        mainView.backgroundColor = .white
        labelDayText.adjustsFontSizeToFitWidth = true
        
    }

}
