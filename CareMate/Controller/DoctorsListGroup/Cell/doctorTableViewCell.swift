//
//  doctorTableViewCell.swift
//  CareMate
//
//  Created by Khabber on 21/05/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class doctorTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var pickerReserve: UIView!
    @IBOutlet weak var lblReserve: UILabel!
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var pickerOnline: UIView!
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
    
    override func awakeFromNib() {
      super.awakeFromNib()
  //    doctorImageView.layer.cornerRadius = doctorImageView.bounds.width / 2
        
        doctorNameLabel.textAlignment = UserManager.isArabic ? .right : .left
        clinicNameLanel.textAlignment = UserManager.isArabic ? .right : .left
      //  mainView.makeShadow(color: .black, alpha: 0.14, radius: 4)
        mainView.makeShadow(color: UIColor.fromHex(hex: "#1F2E3D14", alpha: 1.0), alpha: 0.1, radius: 12)
        firstTime.text = UserManager.isArabic ? " اقرب موعد" :  "First Time"
        lblOnline.text = "Accepts Online Consultations"
        lblReserve.text = "Book"
        if UserManager.isArabic {
        //    labelContacts.text = "اضغط لعرض ارقام التواصل مع العيادة"
            lblOnline.text = "يقبل الاستشارة عن بعد"
            lblReserve.text = "حجز"
        }
        lblReserve.textAlignment = .center
       // lblOnline.adjustsFontSizeToFitWidth = true
        doctorImageView.Rounded(corner: 40)

    }
    
    func configCell(doctor: Doctor) {
        self.firstAvaiableDayString.text =    (doctor.FIRST_SLOT_TIME ?? "").formateDAte(dateString:
                                                                                doctor.FIRST_SLOT_TIME, formateString: "EEEE")
        firstAvaiableDayString.adjustsFontSizeToFitWidth = true
        firstAvaiableDayHourMin.text = doctor.FIRST_SLOT_TIME?.ConvertToDate.ToTimeOnly
        firstAvaiableDayHourMin.adjustsFontSizeToFitWidth = true

      nationalityLabel.text = UserManager.isArabic ? doctor.nationalityAR : doctor.nationality
        nationalityLabel.text = nationalityLabel.text?.components(separatedBy: .whitespaces).first
      self.doctorNameLabel.text = UserManager.isArabic ? doctor.englishNameAR : doctor.englishName
        let place  = UserManager.isArabic ? doctor.CLINIC_LOCATION_AR:doctor.CLINIC_LOCATION_EN
        if let loc = place {
            self.clinicNameLanel.text = loc
        }else {
            self.clinicNameLanel.text = UserManager.isArabic ? doctor.clinicNameAR :doctor.clinicName

        }
        let cat =  UserManager.isArabic ? doctor.doctorCategoryAR :doctor.doctorCategory
        if let spec = cat {
            if spec != "" {
                specialityLabel.text = spec
            }else {
               let special = UserManager.isArabic ? doctor.specialAr :doctor.specialEn
                specialityLabel.text = special
            }
        }else {
            let special = UserManager.isArabic ? doctor.specialAr :doctor.specialEn
             specialityLabel.text = special
        }
      pickerOnline.isHidden = !doctor.acceptOnlineConsultation()
        let url = URL(string: "\(Constants.APIProvider.IMAGE_BASE)/\(doctor.DOCTOR_PIC ?? "")")
        print(url?.absoluteString ?? "")
        var flag = doctor.flagPicture ?? ""
        if flag.contains(".jpg") == false {
            flag = "\(flag).jpg"
        }
    self.imgCountry.kf.setImage(with: URL(string: flag), placeholder: UIImage(named: "ic-countryF") , options: nil, completionHandler: nil)
      self.doctorImageView.kf.setImage(with: url, placeholder: doctor.gender == "M" ? UIImage(named: "RectangleMan") : UIImage(named: "RectangleGirl") , options: nil, completionHandler: nil)
        if doctor.NO_RESERVATION_VIEW_ONLY_TEL ?? "" == "1" || doctor.HIDE_SCHEDULE_MOBILE_APP ?? "" == "1" {
            viewTime.isHidden = true
        //    labelContacts.isHidden = false
        } else {
            viewTime.isHidden = false
          //  labelContacts.isHidden = true
        }
    }
}


// Source - https://stackoverflow.com/a/39067610
// Posted by fpg1503, modified by community. See post 'Timeline' for change history
// Retrieved 2026-10-01, License - CC BY-SA 4.0

extension String {
    func removingLeadingSpaces() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }
}
