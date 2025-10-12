//
//  OutCell.swift
//  CareMate
//
//  Created by Ibrahim on 23/12/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class OutCell: UICollectionViewCell {

    @IBOutlet weak var lblChild: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func drawCell(_ item:String) {
        lblChild.text = item
       // lblChild.textAlignment = .center
    }

}
