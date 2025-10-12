//
//  LabResultCollectionViewCell.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 08/06/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class LabResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewResult: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setData(model: LabResultModel) {
        labelDate.text = model.DATE_ENTER
        imageViewResult.loadFromUrl(url: "\(Constants.APIProvider.IMAGE_BASE2)/\(model.BLOB_PATH)")
    }
}
