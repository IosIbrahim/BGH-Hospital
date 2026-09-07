//
//  ZoomUserCell.swift
//  CareMate
//
//  Created by Ibrahim on 06/09/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

import UIKit
import ZoomVideoSDK

class ZoomUserCell: UICollectionViewCell {

    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func drawCell(_ model:ZoomVideoSDKUser) {
        lblUser.text = model.getName()
        if model.getVideoCanvas().
    }

}
