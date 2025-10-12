//
//  LabRadCell.swift
//  CareMate
//
//  Created by Yo7ia on 1/1/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import UIKit

protocol LabRadCellDelagete {
    func CellClicked(_ data: LabsTableViewCell)
    func CellClickedPacks(_ data: LabsTableViewCell)
    func openRad(_ data: LabsTableViewCell)

    
}
protocol showInfoProtocal {
    func showInfoProtocal(_ doctor:LabRadDTO?)
}
class LabRadCell: UITableViewCell {
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var doctorLbl: UILabel!
    @IBOutlet weak var historyImg: UIImageView!
    @IBOutlet weak var resultImg: UIImageView!
    @IBOutlet weak var PacksImg: UIImageView!

    
    @IBOutlet weak var cashImg: UIImageView!
    @IBOutlet weak var alarmImg: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var labelAlert: UILabel!

    var isLab = true
    var data: LabRadDTO?
    var delegate: LabRadCellDelagete?
    var delegateShow: showInfoProtocal?

    func configCell(doctor: LabRadDTO) {
        self.data = doctor
        self.serviceLbl.text = UserManager.isArabic ? doctor.sERVICE_NAME_AR :doctor.sERVICE_NAME_EN
        self.doctorLbl.text = UserManager.isArabic ? doctor.eMP_AR_DATA :doctor.eMP_EN_DATA
        self.dateLbl.text = doctor.rEQ_DATE
        self.statusLbl.text = isLab ? (UserManager.isArabic ? doctor.lABSTATUS_NAME_EN : doctor.lABSTATUS_NAME_EN) : (UserManager.isArabic ? doctor.rADSTATUS_NAME_AR : doctor.rADSTATUS_NAME_EN)
        self.resultLbl.text = UserManager.isArabic ? doctor.nORMALSTATUS_NAME_AR : doctor.nORMALSTATUS_NAME_EN
        self.historyImg.isUserInteractionEnabled = true
        self.resultImg.isUserInteractionEnabled = true
        self.PacksImg.isUserInteractionEnabled = true

        self.historyImg.isHidden = (!isLab && doctor.sERVSTATUS.lowercased() == "f") ? false : true
        self.cashImg.isHidden = (doctor.cASHIER_FLAG == nil || doctor.cASHIER_FLAG == "" ) ? true : false
        self.labelAlert.text =  UserManager.isArabic ? self.data?.PREPARE_DESC_AR : self.data?.PREPARE_DESC_EN
        self.resultImg.isHidden = (isLab && (doctor.sERVSTATUS.lowercased() == "f" || doctor.sERVSTATUS.lowercased() == "t" || doctor.sERVSTATUS == "Q" )) ? false : true
        self.PacksImg.isHidden = (isLab && (doctor.sERVSTATUS.lowercased() == "f" || doctor.sERVSTATUS.lowercased() == "t" || doctor.sERVSTATUS == "Q" )) ? false : true

        
        self.alarmImg.isHidden = (doctor.PREPARE_DESC_EN != "null" && doctor.PREPARE_DESC_EN != "") ? false : true
//        let tapMenu: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuBtnClicked))
//        let tapMenuResult: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuBtnClicked))
//        tapMenu.numberOfTapsRequired = 1
//        tapMenuResult.numberOfTapsRequired = 1
//        resultImg.addGestureRecognizer(tapMenuResult)
        
//        let tapMenupacks: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuBtnClicked))
//
//        let tapMenuResultPacksImg: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MenuBtnClickedPacks))
//        tapMenupacks.numberOfTapsRequired = 1
//        tapMenuResultPacksImg.numberOfTapsRequired = 1
//        PacksImg.addGestureRecognizer(tapMenuResultPacksImg)
//
//        historyImg.addGestureRecognizer(tapMenu)
    }
    
    
    @IBAction func showInfo(sender: UIButton)
    {
     
        self.delegateShow?.showInfoProtocal(self.data)

    }
    
    
//    @objc func MenuBtnClicked() {
//        self.delegate?.CellClicked(self)
//    }
//
//    @objc func MenuBtnClickedPacks() {
//        self.delegate?.CellClickedPacks(self)
//    }
    
}
