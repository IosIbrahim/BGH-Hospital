//
//  doctorTableViewCell.swift
//  CareMate
//
//  Created by Khabber on 21/05/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class doctorTableViewCell: UITableViewCell {

    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var firstTime: UILabel!

    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var clinicNameLanel: UILabel!
      @IBOutlet weak var doctorNameLabel: UILabel!
  //    @IBOutlet weak var doctorQualificationLabel: UILabel!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!

      
      @IBOutlet weak var firstAvaiableDayString: UILabel!

      @IBOutlet weak var firstAvaiableDayHourMin: UILabel!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var labelContacts: UILabel!
    
    override func awakeFromNib() {
      super.awakeFromNib()
  //    doctorImageView.layer.cornerRadius = doctorImageView.bounds.width / 2
        
        doctorNameLabel.textAlignment = UserManager.isArabic ? .right : .left
        clinicNameLanel.textAlignment = UserManager.isArabic ? .right : .left

        mainView.makeShadow(color: .black, alpha: 0.14, radius: 4)

        firstTime.text = UserManager.isArabic ? " اقرب موعد" :  "First Available Time"
        if UserManager.isArabic {
            labelContacts.text = "اضغط لعرض ارقام التواصل مع العيادة"
        }
    }
    
    func configCell(doctor: Doctor) {
      self.firstAvaiableDayString.text =    (doctor.FIRST_SLOT_TIME ?? "").formateDAte(dateString:
                                                                                  doctor.FIRST_SLOT_TIME, formateString: "EEEE")

//      self.firstAvaiableDayHourMin.text =   doctor.FIRST_SLOT_TIME!.formateDAte(dateString:
//                                                          doctor.FIRST_SLOT_TIME, formateString: "HH:mm a")
        firstAvaiableDayHourMin.text = doctor.FIRST_SLOT_TIME?.ConvertToDate.ToTimeOnly

      self.nationalityLabel.text = UserManager.isArabic ? doctor.HREMPLOYEELANGUAGE_AR : doctor.HREMPLOYEELANGUAGE_EN
      self.doctorNameLabel.text = UserManager.isArabic ? doctor.englishNameAR : doctor.englishName
      self.clinicNameLanel.text = UserManager.isArabic ? doctor.clinicNameAR :doctor.clinicName
      self.specialityLabel.text = UserManager.isArabic ? doctor.doctorCategoryAR :doctor.doctorCategory
  //    self.doctorQualificationLabel.text = UserManager.isArabic ? doctor.qualificationAR : doctor.qualification
  //    self.doctorImageView.image = doctor.gender == "M" ? #imageLiteral(resourceName: "doctor") : #imageLiteral(resourceName: "doctor_woman")
      
      
        let url = URL(string: "\(Constants.APIProvider.IMAGE_BASE)/\(doctor.DOCTOR_PIC ?? "")")

        print(url?.absoluteString ?? "")
      self.doctorImageView.kf.setImage(with: url, placeholder: doctor.gender == "M" ? UIImage(named: "RectangleMan") : UIImage(named: "RectangleGirl") , options: nil, completionHandler: nil)
        if doctor.NO_RESERVATION_VIEW_ONLY_TEL ?? "" == "1" || doctor.HIDE_SCHEDULE_MOBILE_APP ?? "" == "1" {
            viewTime.isHidden = true
            labelContacts.isHidden = false
        } else {
            viewTime.isHidden = false
            labelContacts.isHidden = true
        }
    }
}
