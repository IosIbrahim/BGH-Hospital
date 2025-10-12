//
//  DermatolgySpcialitiesCell.swift
//  CareMate
//
//  Created by mostafa gabry on 4/28/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class DermatolgySpcialitiesCell: UITableViewCell {

    @IBOutlet weak var outerView: RoundUIView!
    @IBOutlet weak var innerView: RoundUIView!
    @IBOutlet weak var specilaityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
