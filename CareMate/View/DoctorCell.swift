//
//  doctorsCell.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/14/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import UIKit
import Kingfisher
import Foundation

class DoctorCell: UITableViewCell {
  @IBOutlet weak var nationalityLabel: UILabel!
  @IBOutlet weak var specialityLabel: UILabel!
  @IBOutlet weak var clinicNameLanel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
//    @IBOutlet weak var doctorQualificationLabel: UILabel!
  @IBOutlet weak var doctorImageView: UIImageView!
    
    
    @IBOutlet weak var firstAvaiableDayString: UILabel!

    @IBOutlet weak var firstAvaiableDayHourMin: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
//    doctorImageView.layer.cornerRadius = doctorImageView.bounds.width / 2
  }
  
  func configCell(doctor: Doctor) {
    self.firstAvaiableDayString.text =    doctor.FIRST_SLOT_TIME!.formateDAte(dateString:
                                                                                doctor.FIRST_SLOT_TIME, formateString: "EEEE")

    self.firstAvaiableDayHourMin.text =   doctor.FIRST_SLOT_TIME!.formateDAte(dateString:
                                                        doctor.FIRST_SLOT_TIME, formateString: "HH:mm a")

    self.nationalityLabel.text = UserManager.isArabic ? doctor.HREMPLOYEELANGUAGE_AR : doctor.HREMPLOYEELANGUAGE_EN
    self.doctorNameLabel.text = UserManager.isArabic ? doctor.englishNameAR : doctor.englishName
    self.clinicNameLanel.text = UserManager.isArabic ? doctor.clinicNameAR :doctor.clinicName
    self.specialityLabel.text = UserManager.isArabic ? doctor.doctorCategoryAR :doctor.doctorCategory
//    self.doctorQualificationLabel.text = UserManager.isArabic ? doctor.qualificationAR : doctor.qualification
//    self.doctorImageView.image = doctor.gender == "M" ? #imageLiteral(resourceName: "doctor") : #imageLiteral(resourceName: "doctor_woman")
    
    
    let url = URL(string: "http://172.25.26.140/mobileapi/\(doctor.DOCTOR_PIC ?? "")")
    print("lhhihojohjiguyfdresrdtfyguhijokiuhgyftdfguhijokjihugyftfyguhi")
      print("\(Constants.APIProvider.IMAGE_BASE)\(doctor.DOCTOR_PIC ?? "")")

    self.doctorImageView.kf.setImage(with: url, placeholder: doctor.gender == "M" ? UIImage(named: "doctor") : UIImage(named: "doctor_woman") , options: nil, completionHandler: nil)
  }
}
