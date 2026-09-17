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

    @IBOutlet weak var picker: UIView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func drawCell(_ model:ZoomVideoSDKUser) {
        lblUser.text = model.getName()
        lblUser.textAlignment = .center
        picker.setPhysShadow()
        picker.layer.cornerRadius = 12
        imgUser.layer.cornerRadius = 12
        let isVideoOn = model.getVideoCanvas()?.videoStatus()?.on
        if isVideoOn == true {
            // Get the user's videoCanvas.
            if let usersVideoCanvas = model.getVideoCanvas() {
                // Set the video aspect.
                let videoAspect = ZoomVideoSDKVideoAspect.panAndScan
                // Subscribe the user's videoCanvas to render their video stream.
                usersVideoCanvas.subscribe(with: imgUser, aspectMode: videoAspect, andResolution: ._360)
            }
        }
        
    }

}
