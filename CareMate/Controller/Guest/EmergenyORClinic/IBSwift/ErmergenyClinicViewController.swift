//
//  ErmergenyClinicViewController.swift
//  CareMate
//
//  Created by MAC on 25/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class ErmergenyClinicViewController: BaseViewController {
    var delegate:  clinicOrEmergency?
    var branches = [Branch]()
    var selectedBranch: Branch?
    
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var viewAmbelance: UIView!
    @IBOutlet weak var viewAppoiment: UIView!
    @IBOutlet weak var viewlocation: UIView!
    @IBOutlet weak var view365Tour: UIView!
    @IBOutlet weak var viewgolah: UIView!

    @IBOutlet weak var labelContact: UILabel!
    

    @IBOutlet weak var labelAmbelance: uilabelCenter!
    @IBOutlet weak var labelAppoiment: uilabelCenter!
    @IBOutlet weak var labellocation: uilabelCenter!
    @IBOutlet weak var LabelgolahTile: UILabel!
    @IBOutlet weak var LabelgolahSubTile: UILabel!

    @IBOutlet weak var label365TourTitle: UILabel!
    @IBOutlet weak var label365TourSubTitle: UILabel!
    @IBOutlet weak var labelBookAppointment: UILabel!
    @IBOutlet weak var labelBookWithGoof: UILabel!
    @IBOutlet weak var labelServices: UILabel!
    

    @IBOutlet weak var imageViewIn: UIImageView!
    @IBOutlet weak var imageViewFacebook: UIImageView!
    @IBOutlet weak var imageViewinsta: UIImageView!
    @IBOutlet weak var imageViewYoutube: UIImageView!
    @IBOutlet weak var imageViewDerma: UIImageView!
    @IBOutlet weak var imageViewTwitter: UIImageView!
    @IBOutlet weak var viewKnowYourDoctor: UIView!
    @IBOutlet weak var labelKnowYourDoctor: uilabelCenter!
    @IBOutlet weak var imageViewlocations: UIImageView!
    @IBOutlet weak var imageViewSurvey: UIImageView!
    
    @IBOutlet weak var labelChat: uilabelCenter!
    @IBOutlet weak var labelHelp: uilabelCenter!
    @IBOutlet weak var viewHelp: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
        imageViewSurvey.loadFromUrl(url: ConstantsData.survey, placeHolder: "Image 5")
        imageViewlocations.loadFromUrl(url: ConstantsData.locationIMG)
        if UserManager.isArabic {
            labelBookAppointment.text = "احجز موعد"
            labelBookWithGoof.text = "لحجز موعد مع نخبة متميزة من الأطباء"
            labelServices.text = "خدماتنا"
            labelKnowYourDoctor.text = "إعرف طبيبك"
            labelContact.text = "تواصل معنا عبر"
            labelChat.text = "الدردشة مع سالم"
            labelHelp.text = "المساعدة والدعم"
        }
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "بلدخول كضيف" : "Continue As guest", hideBack: false)

        let viewAppoimentUITAP = UITapGestureRecognizer(target: self, action:  #selector(self.requestClinic))
        self.viewAppoiment.addGestureRecognizer(viewAppoimentUITAP)
        let viewAmbelanceUITAP = UITapGestureRecognizer(target: self, action:  #selector(self.requestEmergency))
        self.viewAmbelance.addGestureRecognizer(viewAmbelanceUITAP)
        
        let viewlocationeUITAP = UITapGestureRecognizer(target: self, action:  #selector(self.viewReservation))
        self.viewlocation.addGestureRecognizer(viewlocationeUITAP)
        
        let gestureopenopenopenQuestionary = UITapGestureRecognizer(target: self, action:  #selector(self.openquesCliked))
        self.viewgolah.addGestureRecognizer(gestureopenopenopenQuestionary)
        let gestureopenHospitalViews = UITapGestureRecognizer(target: self, action:  #selector(self.openHospitalViewsCliked))
        self.view365Tour.addGestureRecognizer(gestureopenHospitalViews)
        
        let p = "Virtual Tour (360)"
        self.label365TourTitle.text = UserManager.isArabic ? "جولة إفتراضيه (360)" : p
        self.label365TourSubTitle.text = UserManager.isArabic ? "تجول في مرافقنا" : "Tour our facilities"

        self.LabelgolahTile.text = UserManager.isArabic ? "مواقعنا" : "Our Locations"

        self.LabelgolahSubTile.text = UserManager.isArabic ? "مواقع المستشقي المتنوعه": "Various hospital locations"
        labelAmbelance.text =  UserManager.isArabic ? "زيارة منزلية/اسعاف" : "Ambulance/ Home Visit"
        labellocation.text =  UserManager.isArabic ? "حجز موعد" : "Book Appointment"
        
        labelAppoiment.text = UserManager.isArabic ? "حجوزاتي" : "My Appointment"
        
        imageViewIn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkedIn)))
        imageViewFacebook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebook)))
        imageViewinsta.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(instagram)))
        imageViewYoutube.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(youtube)))
        imageViewDerma.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(derma)))
        imageViewTwitter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(twitter)))
        viewKnowYourDoctor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openKnowDoctor)))
        viewChat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chatWhatsapp)))
        viewHelp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chatWhatsapp2)))

    }
//050167476

    @objc func requestClinic(_ sender: Any) {
        delegate?.clinicOrEmergencyfunc(ClinicOrEmergency: "C")
    }
    
    @objc func openHospitalViewsCliked(sender : UITapGestureRecognizer) {
        
        navigationController?.pushViewController(Choose365HospitalViewController(), animated: true)
    }
    
    @objc func openquesCliked(sender : UITapGestureRecognizer) {
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BranchesViewController") as? BranchesViewController
            self.navigationController?.pushViewController(nextViewController!, animated: true)
        
    }
    

    @objc func requestEmergency(_ sender: Any) {
       
        delegate?.clinicOrEmergencyfunc(ClinicOrEmergency: "E")

       
    }
    @objc  func viewReservation(_ sender: Any) {
       
        delegate?.clinicOrEmergencyfunc(ClinicOrEmergency: "Retrive")
   
    }
    
    @objc func linkedIn() {
        openUrl(ConstantsData.linkedin)
    }
    
    @objc func facebook() {
        openUrl(ConstantsData.facebook)
    }
    
    @objc func instagram() {
        openUrl(ConstantsData.instegram)
    }
    
    @objc func youtube() {
        openUrl(ConstantsData.youtube)
    }
    @objc func derma() {
        openUrl(ConstantsData.drama)
    }
    
    @objc func twitter() {
        openUrl(ConstantsData.twitter)
    }
    
 
    
    @objc func openKnowDoctor() {
//        navigationController?.pushViewController(WebViewViewController(UserDefaults.standard.object(forKey: UserManager.isArabic ? "knowYourDoctorAr" : "knowYourDoctorEn") as? String ?? "" , showShare: false), animated: true)
        navigationController?.pushViewController(DoctorsSearchViewController(), animated: true)
    }
    
    @objc func chatWhatsapp() {
        sendMessageWhatsApp(ConstantsData.whatsapp)
    }
    
    func sendMessageWhatsApp(_ number: String) {
  //FIXED BY HAMDI ......
        let urlString = UserManager.isArabic ?
        "https://api.whatsapp.com/send/?phone=9651830003&text=سلام+سالم+لنتحدث" : "https://api.whatsapp.com/send/?phone=9651830003&text=Hello+Salem+let’s+chat"
        openUrl(urlString)
        print (number)

    }
    
    @objc func chatWhatsapp2() {
//        openUrl("https://api.whatsapp.com/send?phone=\("+96594032241")")
        navigationController?.pushViewController(GuideAndSupportViewController(), animated: true)
    }
}
extension ErmergenyClinicViewController: SpecialityFilterDelegate {
 func specialityFilter(_ specialityFilter: SpecialityFilter, didSelectSpeciality speciality: Speciality) {
//   specialityFilterPopup?.dismiss()
    
     Branch.getOnlineAppointment() { onlineAppointments, branchsDic  in
    guard let onlineAppointments = onlineAppointments else {
        return

    }
    self.branches = onlineAppointments
    self.selectedBranch = self.branches[0]

    // Create a custom view controller
    let specialityFilter = SpecialityFilter(nibName: "SpecialityFilter", bundle: nil)
    specialityFilter.delegate = self


   let doctorsVC = DoctorsViewController()
        doctorsVC.branchId = self.selectedBranch?.id
        doctorsVC.branch = self.selectedBranch!

         doctorsVC.specialityId = speciality.id
        doctorsVC.SpecType = speciality.SPEC_TYPE ?? ""
   isReschedule = false
   self.navigationController?.pushViewController(doctorsVC, animated: true)
 }
}
}

extension UIViewController {
    func openUrl(_ url: String) {
        let urlString = url
        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let URL = URL(string: urlStringEncoded!) {
            if UIApplication.shared.canOpenURL(URL) {
                UIApplication.shared.open(URL , options: [:], completionHandler: nil)
            }
        }
    }
}
