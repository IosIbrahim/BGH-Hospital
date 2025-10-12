//
//  AnswerCell.swift
//  CareMate
//
//  Created by Yo7ia on 2/18/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//


import UIKit

protocol AnswerCellDelagete {
    func CellClicked(_ data: AnswerCell)
    
}
class AnswerCell: UICollectionViewCell {
    
    @IBOutlet weak var timeSlotLabel: UILabel!
    @IBOutlet weak var slotTimeView: UIView!
    var delegate: AnswerCellDelagete?
    var data: ITEM_TYPE_SETUP_ROW?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(slot: ITEM_TYPE_SETUP_ROW)
    {
        self.data = slot
        self.timeSlotLabel.text = UserManager.isArabic ? slot.nAME_AR : slot.nAME_EN!
        self.contentView.backgroundColor = slot.isSelected ? UIColor.darkGray : UIColor.groupTableViewBackground
        self.timeSlotLabel.textColor = slot.isSelected ? UIColor.white : UIColor.black
        self.layer.cornerRadius = 10
    }
    
    @IBAction func cellClicked()
    {
        self.delegate?.CellClicked(self)
    }
}
