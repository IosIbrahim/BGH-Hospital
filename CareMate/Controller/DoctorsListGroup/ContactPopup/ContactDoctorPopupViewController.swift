//
//  ContactDoctorPopupViewController.swift
//  CareMate
//
//  Created by m3azy on 05/11/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class ContactDoctorPopupViewController: UIViewController {

    @IBOutlet weak var viewPhone2: UIStackView!
    @IBOutlet weak var viewPhone1: UIStackView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPhoneNumberHeader: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var imageViewCopy: UIImageView!
    @IBOutlet weak var labelClinicPlaceTitle: UILabel!
    @IBOutlet weak var labelPlace: UILabel!
    @IBOutlet weak var imageViewPhoneNumber: UIImageView!
    @IBOutlet weak var labelPhone2: UILabel!
    @IBOutlet weak var imageViewCopy2: UIImageView!
    
    var phoneNumber = ""
    var phoneNumber2 = ""
    var place = ""
    
    init(phoneNumber: String, place: String, phoneNumber2: String = "") {
        super.init(nibName: "ContactDoctorPopupViewController", bundle: nil)
        self.phoneNumber = phoneNumber
        self.phoneNumber2 = phoneNumber2
        self.place = place
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserManager.isArabic {
            labelTitle.text = "لحجز موعد يرجي الإتصال بنا "
            labelPhoneNumberHeader.text = "رقم الهاتف"
            labelClinicPlaceTitle.text = "مكان العيادة"
        }
        imageViewCopy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyNumber)))
        imageViewCopy2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyNumber2)))
        imageViewPhoneNumber.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callNumber)))
        labelPhoneNumber.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callNumber)))
        labelPhoneNumber.text = phoneNumber
        labelPhone2.text = phoneNumber2
        labelPlace.text = place
        if phoneNumber2 == "" {
            viewPhone2.isHidden = true
        }
        if place == "" {
            labelPlace.isHidden = true
            labelClinicPlaceTitle.isHidden = true
        }
    }

    @objc func copyNumber() {
        UIPasteboard.general.string = phoneNumber
        self.view.showToast(toastMessage: UserManager.isArabic ? "تم النسخ" : "Copying done", duration: 2)
    }
    
    @objc func copyNumber2() {
        UIPasteboard.general.string = phoneNumber2
        self.view.showToast(toastMessage: UserManager.isArabic ? "تم النسخ" : "Copying done", duration: 2)
    }
    
    @objc func callNumber() {
        call(phoneNumber: phoneNumber)
    }
}
