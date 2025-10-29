//
//  BranchNCell.swift
//  CareMate
//
//  Created by Ibrahim on 29/10/2025.
//  Copyright © 2025 khabeer Group. All rights reserved.
//

import UIKit
import ImageSlideshow

class BranchNCell: UITableViewCell {

    @IBOutlet weak var btnSite: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgSlider: ImageSlideshow!
    
    private var site:String = ""
    private var phoneNumber = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BranchNCell.didTap))
        imgSlider.addGestureRecognizer(gestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func callOnTap(_ sender: Any) {
        if let url = URL(string: "tel://\(phoneNumber)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    @IBAction func siteOnTap(_ sender: Any) {
        if let browserUrl = URL(string: site) {
            UIApplication.shared.open(browserUrl, options: [:], completionHandler: nil)
        }
    }
    
    @objc func didTap() {
      imgSlider.presentFullScreenController(from: rootNavigation)
    }
    
    func drawData(_ item:branchData) {
        lblTitle.textAlignment = UserManager.isArabic ? .right:.left
        lblDes.textAlignment = UserManager.isArabic ? .right:.left
        lblTitle.text = UserManager.isArabic ? item.nameAr:item.nameEn
        lblDes.text = UserManager.isArabic ? item.descriptionAr:item.descriptionEn
        btnCall.setTitle(item.Phone, for: .normal)
        btnSite.setTitle(UserManager.isArabic ? "زيارة الموقع" : "Visit site", for: .normal)
        site = item.site
        phoneNumber = item.Phone
    }
    
}
