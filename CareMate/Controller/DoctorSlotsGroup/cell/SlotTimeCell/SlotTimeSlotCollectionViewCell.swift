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
     //   mainView.makeShadow(color: UIColor.fromHex(hex: "#DDE4EC", alpha: 1.0), alpha: 0.2, radius: 8)
        mainView.setBorder(color: UIColor.fromHex(hex: "#DDE4EC", alpha: 1.0), radius: 12, borderWidth: 1)
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
        labelDayText.textColor = UIColor.fromHex(hex: "#1B2A3A", alpha: 1.0)
       //   self.labelDayText.text = slot.id.ConvertToDate.ToTimeOnlyEn
    }

}

