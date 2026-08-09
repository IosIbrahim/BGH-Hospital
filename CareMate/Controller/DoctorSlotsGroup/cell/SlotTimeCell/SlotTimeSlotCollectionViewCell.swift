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
        let dateCom = slot.id?.convertArabicNumbers().components(separatedBy: .whitespaces) ?? []
        let date = dateCom.last?.ConvertToDate
        print(date ?? .init())
        if let dat = date?.ToTimeOnlyEn {
            if dat != Date().ToTimeOnlyEn {
                self.labelDayText.text = dat
            }else {
                self.labelDayText.text = dateCom.last?.getSlotTime()
            }
        }else {
            self.labelDayText.text = dateCom.last?.convertArabicNumbers()
        }
       //   self.labelDayText.text = slot.id.ConvertToDate.ToTimeOnlyEn
    }

}

