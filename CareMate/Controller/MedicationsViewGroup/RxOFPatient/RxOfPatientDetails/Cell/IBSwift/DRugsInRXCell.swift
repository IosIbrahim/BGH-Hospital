//
//  DRugsInRXCell.swift
//  CareMate
//
//  Created by MAC on 28/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

protocol DrugCellDelegate {
    func addReminder(_ index: Int)
    func openImage(_ image: UIImageView)
}

class DRugsInRXCell: UITableViewCell {

    @IBOutlet weak var DotorNAme: UILabel!
    @IBOutlet weak var drufDose: UILabel!
    @IBOutlet weak var drugStatues: UILabel!
    @IBOutlet weak var drugName: UILabel!
    @IBOutlet weak var needApproveView: UIView!
    @IBOutlet weak var imageViewMed: UIImageView!
    @IBOutlet weak var btnAddReminder: UIButton!
    @IBOutlet weak var viewpharmacyStatus: UIView!
    @IBOutlet weak var labelPharmacyStatus: UILabel!
    
    var delegate: DrugCellDelegate?
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewMed.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImage)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ Object:RxModelDetails)  {
        drugName.text = UserManager.isArabic ? Object.ITEM_NAME_AR : Object.ITEM_NAME_EN
        drufDose.text = UserManager.isArabic ? Object.NOTES_AR : Object.NOTES_EN
        if Object.APPROVE_NAME_AR != ""{
            needApproveView.isHidden = false

        drugStatues.text = UserManager.isArabic ? Object.APPROVE_NAME_AR :Object.APPROVE_NAME_EN
        }
        else{
            needApproveView.isHidden = true
//            drugStatues.text = UserManager.isArabic ? "عادي" :"Regular"
        }
        let url = "\(Constants.APIProvider.IMAGE_BASE)\(Object.DRUG_IMAGE)"
        imageViewMed.loadFromUrl(url: url, placeHolder: "BHG-medicineBottel")
        if UserManager.isArabic {
            btnAddReminder.setTitle("اضافة منبه", for: .normal)
        }
        if Object.ITEM_STATUS == "2" || Object.ITEM_STATUS == "3" || Object.ITEM_STATUS == "7" {
            labelPharmacyStatus.text = UserManager.isArabic ? "صرف من الصيدلية" : "Issued from Pharmacy"
            viewpharmacyStatus.isHidden = false
        } else {
            viewpharmacyStatus.isHidden = true
        }
    }
    
    @IBAction func addReminder(_ sender: Any) {
        delegate?.addReminder(index)
    }
    
    @objc func openImage() {
        delegate?.openImage(imageViewMed)
    }
}

