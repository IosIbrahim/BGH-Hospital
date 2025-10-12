//
//  LabResultCell.swift
//  CareMate
//
//  Created by Yo7ia on 4/2/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import UIKit

protocol showPanicIfon {
    func showPanicIfonfunc(_Objc:LabReportDTO?)
}
class  LabResultCell: UITableViewCell {
//
//    @IBOutlet weak var nameLbl: UILabel!
//    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var resultImg: UIImageView!
    @IBOutlet weak var infoButtonInCasePanic: UIButton!

    var delegate:showPanicIfon?
    var data: LabReportDTO?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        infoButtonInCasePanic.isUserInteractionEnabled = false
        infoButtonInCasePanic.setTitle("", for: .normal)

    }
    
    func configCell(slot: LabReportDTO)
    {
        self.data = slot
//        self.nameLbl.text = slot.iTEMDDESCR
//        self.dataLbl.text = slot.rEFERENCE_DATA
        self.resultLbl.text = slot.rESULT_LAB + "MG"

        switch slot.uPNORMAL_VAL {
        case "0":

            break
        case "1","5":
            resultImg.image = #imageLiteral(resourceName: "arrow-down (1)")

            break
        case "2","6":
            resultImg.image = #imageLiteral(resourceName: "arrow-up (1)")

            break
        case "3":
            resultImg.image = #imageLiteral(resourceName: "arrow-up (1)")
            infoButtonInCasePanic.isUserInteractionEnabled = true

            break
        default:
            resultImg.image = #imageLiteral(resourceName: "normal_icon")

            break
        }
        self.layer.cornerRadius = 10
    }
    
    @IBAction func showInfo(sender: UIButton){
    
        self.delegate?.showPanicIfonfunc(_Objc: self.data)
    
    }
    
   
}
