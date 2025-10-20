//
//  DoctorCollectionViewCell.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 22/01/2023.
//  Copyright © 2023 khabeer Group. All rights reserved.
//

import UIKit

protocol DoctorSearchCellDelegate {
    func showDocDetails(_ index: Int)
}

class DoctorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblShow: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageViewDoctor: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSpeciality: UILabel!
    @IBOutlet weak var viewShow: UIView!
    
    var index = 0
    var delegate: DoctorSearchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewShow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openDocDetails)))
    }

    func setData(_ model: Doctor) {
//        let imageUrl = "\(Constants.APIProvider.IMAGE_BASE)\(model.DOCTOR_PIC ?? "")"
//        imageViewDoctor.loadFromUrl(url: imageUrl)
        let url = URL(string: "\(Constants.APIProvider.IMAGE_BASE)\(model.DOCTOR_PIC ?? "")")
        print("http://172.25.26.140/mobileApi/\(model.DOCTOR_PIC ?? "")")
        print("\(Constants.APIProvider.IMAGE_BASE)\(model.DOCTOR_PIC ?? "")")
        imageViewDoctor.kf.setImage(with: url, placeholder: UIImage(named: model.GENDERCODE ?? "M" == "M" ? "RectangleMan" : "RectangleGirl"))
        labelName.text = UserManager.isArabic ? model.DOC_NAME_AR : model.DOC_NAME_EN ?? ""
        labelSpeciality.text = UserManager.isArabic ? model.SPECIALITY_AR : model.SPECIALITY_EN
        labelName.textAlignment = .center
        labelSpeciality.textAlignment = .center
        lblShow.text = UserManager.isArabic ? "عرض":"Show"
    }
    
    @objc func openDocDetails() {
        delegate?.showDocDetails(index)
    }
}
