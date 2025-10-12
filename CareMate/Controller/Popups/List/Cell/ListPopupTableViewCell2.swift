//
//  ListPopupTableViewCell.swift
//  nasTrends
//
//  Created by Mohamed Elmaazy on 2/5/19.
//  Copyright © 2019 Mohamed Elmaazy. All rights reserved.
//

import UIKit

class ListPopupTableViewCell2: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(name: String) {
        labelName.text = name
    }
}
