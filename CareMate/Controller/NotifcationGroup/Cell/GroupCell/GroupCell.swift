//
//  GroupCell.swift
//  CareMate
//
//  Created by Ibrahim on 24/02/2025.
//  Copyright © 2025 khabeer Group. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var pickerCount: RoundUIView!
    @IBOutlet weak var lblGroup: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func drawCell(_ model:AlertsCountsRow){
        lblGroup.text = model.getDes()
        lblCount.text = model.countUnread
        let cnt = Int(model.countUnread ?? "") ?? .zero
        pickerCount.isHidden = cnt == .zero
        lblCount.textAlignment = .center
    }
}
