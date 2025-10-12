//
//  receptionCell.swift
//  CareMate
//
//  Created by MAC on 17/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class receptionCell: UITableViewCell {
    
    
//    @IBOutlet weak var dateTimeText: UILabel!
//    @IBOutlet weak var contractText: UILabel!
//    @IBOutlet weak var clinicText: UILabel!
//    @IBOutlet weak var cashText: UILabel!
//    @IBOutlet weak var visaText: UILabel!
    

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var contract: UILabel!
    @IBOutlet weak var clinic: UILabel!
    @IBOutlet weak var cash: UILabel!
    @IBOutlet weak var visa: UILabel!
    @IBOutlet weak var viewCash: UIView!
    @IBOutlet weak var viewVisa: UIView!
    @IBOutlet weak var labelCashTitle: UILabel!
    @IBOutlet weak var labelVisaTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UserManager.isArabic {
//            dateTimeText.text = "تاريخ"
//            contractText.text = "عقد"
//            clinicText.text = "عياده"
            labelCashTitle.text = "المبلغ الإجمالي"
            labelVisaTitle.text = "فيزا"
            dateTime.textAlignment = .right
            clinic.textAlignment = .right
            dateTime.font = UIFont(name: "Tajawal-Regular", size: 17)
            clinic.font = UIFont(name: "Tajawal-Bold", size: 17)
            contract.font = UIFont(name: "Tajawal-Bold", size: 17)
            labelCashTitle.font = UIFont(name: "Tajawal-Regular", size: 17)
            labelVisaTitle.font = UIFont(name: "Tajawal-Regular", size: 17)
            cash.font = UIFont(name: "Tajawal-Bold", size: 17)
            visa.font = UIFont(name: "Tajawal-Bold", size: 17)
        }
//        else
//        {
//            dateTimeText.text = "Date"
//            contractText.text = "contract"
//            clinicText.text = "Clinc"
//            cashText.text = "Cash"
//            visaText.text = "Visa"
//
//
//        }
        viewCash.setBorder(color: .fromHex(hex: "#F1F1F1", alpha: 1), radius: 11, borderWidth: 1)
        viewVisa.setBorder(color: .fromHex(hex: "#F1F1F1", alpha: 1), radius: 11, borderWidth: 1)
        viewBackground.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewBackground.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ objc:RECEIPTSDTO?)  {
        clinic.text = UserManager.isArabic ? objc?.PLACE_AR_NAME : objc?.PLACE_EN_NAME
        contract.text = UserManager.isArabic ? objc?.FINAN_NAME_AR : objc?.FINAN_NAME_EN
        dateTime.text = objc?.TRANSDATE.formateDAte(dateString: objc?.TRANSDATE, formateString: "d MMM yyyy HH:mm a")
        cash.text = "\((Double(objc?.CASH_AMOUNT ?? "0") ?? 0) + (Double(objc?.VISA_AMOUNT ?? "0") ?? 0)) \(UserManager.isArabic ? " د.ك" : " KD")"
        visa.text = (objc?.VISA_AMOUNT ?? "") + (UserManager.isArabic ? " د.ك" : " KD")
    }
    
}
