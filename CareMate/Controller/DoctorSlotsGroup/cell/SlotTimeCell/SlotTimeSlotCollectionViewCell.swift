//
//  SlotTimeSlotCollectionViewCell.swift
//  CareMate
//
//  Created by Khabber on 21/06/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class SlotTimeSlotCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelDayText: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.makeShadow(color: .black, alpha: 0.14, radius: 4)

    }
    
    func configCell(slot: Slot)
    {
//        var slot = String ( describing: slot.id )
//        
//        let timeOnly = String(slot.characters.suffix(8))
        
        
        self.labelDayText.text = slot.id.ConvertToDate.ToTimeOnlyEn
    }

}
