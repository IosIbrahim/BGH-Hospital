 //
 //  ClincViewController.swift
 //  CareMate
 //
 //  Created by Eng Nour Hegazy on 11/11/17.
 //  Copyright © 2017 khabeer Group. All rights reserved.
 //
 
import UIKit
import PopupDialog
import DZNEmptyDataSet
import SCLAlertView
import MZFormSheetController
import ImageSlideshow

 var isFromOrder = false

struct branchData{
    
    var nameAr = ""
    var nameEn = ""
    var Phone = ""
    var descriptionAr = ""
    var descriptionEn = ""
    
}


enum listOfOtherScreenTypeBrnach {
    case fromReservation
    case fromEmergency
    case fromOUrLocation

}
 class BranchesViewController: BaseViewController {
  @IBOutlet weak var tableView: UITableView!
     var fromMedicalRecord = false
     var arrayOfBranch = [branchData]()
     
  var branches = [Branch]()
  var specialityFilterPopup: PopupDialog?
  var selectedBranch: Branch?
     var vcType:listOfOtherScreenTypeBrnach?
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    self.tableView.emptyDataSetSource = self
    self.tableView.emptyDataSetDelegate = self
    loadData()
 }
     
     func loadData(){
         let sharafia1 =  branchData(nameAr: "مستشفي الدكتور بخش فرع الشرفية",
                                                nameEn: "Dr. Bakhsh Hospital – Sharafiyah Branch",
                                                Phone: "0126510666",
                                                descriptionAr:" حي الشرفية، جدة، المملكة العربية السعودية ص.ب 6940 ،الرمز البريدي 21452",
                                                descriptionEn: "Al-Sharafiyah District, Jeddah, Saudi Arabia, P.O. Box 6940, Postal Code: 21452")
         let sharafia2 =  branchData(nameAr: "عيادات الدكتور بخش - فرع الشرفية",
                                                nameEn: "Dr.Bakhsh Clinics - Al-Sharafiyah",
                                                Phone: "0126510666",
                                                descriptionAr:" حي الشرفية، جدة، المملكة العربية السعودية ص.ب 6940 ،الرمز البريدي 21452",
                                                descriptionEn: "Al-Sharafiyah District, Jeddah, Saudi Arabia, P.O. Box 6940, Postal Code: 21452")
         let sharafia3 =  branchData(nameAr: "العلاج الطبيعي - فرع الشرفية",
                                                nameEn: "Physio Therapy – Al-Sharafiyah  Branch",
                                                Phone: "0126510666",
                                                descriptionAr:" حي الشرفية، جدة، المملكة العربية السعودية ص.ب 6940 ،الرمز البريدي 21452",
                                                descriptionEn: "Al-Sharafiyah District, Jeddah, Saudi Arabia, P.O. Box 6940, Postal Code: 21452")
         
         let bakshClinicsObject =  branchData(nameAr: "عيادات الدكتور بخش - فرع المحمدية", nameEn: "Dr.Bakhsh Clinics - Al-Mohammadiyah", Phone: "0126510555"
                                            ,descriptionAr: "شارع الامير سلطان مقابل ايه مول (عالم ساكو) المحمدية جدة ص.ب 6940 ، الرمز البريدي 21452",descriptionEn: "Prince Sultan Street, opposite Aya Mall (SACO World), Al-Mohammadiyah, Jeddah, P.O. Box 6940, Postal Code 21452")

        arrayOfBranch.append(sharafia1)
        arrayOfBranch.append(sharafia2)
        arrayOfBranch.append(sharafia3)
        arrayOfBranch.append(bakshClinicsObject)
        self.tableView.reloadData()
     }
     
     
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  self.dismiss(animated: true, completion: nil)
    }
     override func viewWillDisappear(_ animated: Bool) {
         
//         self.navigationController?.navigationBar.isHidden = false

     }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let defaults = UserDefaults.standard

        if fromMedicalRecord == false
        {
            if  defaults.bool(forKey: "loginOrNO") ==  true
            {
//              self.navigationController?.navigationBar.isHidden = true
                initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "اختر الفرع" : "Choose Branch", hideBack: true)

            }
              else
            {
//              self.navigationController?.navigationBar.isHidden = false
                initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "اختر الفرع" : "Choose Branch", hideBack: false)

            }
        }
        else
        {
            initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "اختر الفرع" : "Choose Branch", hideBack: false)
//            self.navigationController?.navigationBar.isHidden = false

        }
        

//        UIView.appearance().semanticContentAttribute = !UserManager.isArabic ? .forceLeftToRight : .forceRightToLeft

        self.tabBarController?.title = UserManager.isArabic ? "الحجز" : "Reservation"
        
        if !isFromOrder
        {

        }
    }
  @IBAction func backPressed(_ sender: AnyObject) {
    
    self.navigationController?.popViewController(animated: true)
  }

 }
 
 extension BranchesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return arrayOfBranch.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BranchCell", for: indexPath) as! BranchCell
    cell.configCell(onlineAppointment: arrayOfBranch[indexPath.row])
      cell.slider.Rounded(corner: 15)
      cell.slider.contentScaleMode = .scaleAspectFill
      if indexPath.row == 0
      {
          cell.hospitalImage.image = UIImage(named: "br1")
          cell.slider.setImageInputs([
            ImageSource(image: UIImage(named: "br1")!),
          ])
      }
      else if indexPath.row == 1
                
      {
          cell.hospitalImage.image = UIImage(named: "br2")
          cell.slider.setImageInputs([
            ImageSource(image: UIImage(named: "br2")!)
          ])

      }
      else if indexPath.row == 2
      {
          cell.hospitalImage.image = UIImage(named: "br3")
          cell.slider.setImageInputs([
            ImageSource(image: UIImage(named: "br3")!)
          ])
      }else if indexPath.row == 3 {
          cell.hospitalImage.image = UIImage(named: "br4")
          cell.slider.setImageInputs([
            ImageSource(image: UIImage(named: "br4")!)
          ])
      }
      
      
    return cell
  }
    
 }
 
 extension BranchesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 250
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      
//      if vcType == .fromReservation
//      {
//
//        selectedBranch = branches[indexPath.row]
//
//          let vc:SpecialityFilter = SpecialityFilter()
//
//          vc.delegate = self
//
//          AppPopUpHandler.instance.openVCPop(vc, height: 600)
//      }
//      else if vcType == .fromOUrLocation
//      {
      //zozo
          if indexPath.row <= 2
          {
              openMap(lat: ConstantsData.lat1, lng: ConstantsData.long1)
          }
          else
          {
              openMap(lat: ConstantsData.lat1, lng: ConstantsData.long1)
          }
  }
     
     func openMap(lat: Double, lng: Double) {
         if let googleMapsUrl = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(lng)&directionsmode=driving"),
            UIApplication.shared.canOpenURL(googleMapsUrl) {
             UIApplication.shared.open(googleMapsUrl, options: [:], completionHandler: nil)
         } else {
             openTrackerInBrowser(lat: lat, lng: lng)
         }
     }

     func openTrackerInBrowser(lat: Double, lng: Double) {
         var url = ConstantsData.branchLoc
         if lat == ConstantsData.lat1 {
             url = ConstantsData.branchLoc
         }else if lat == ConstantsData.lat2 {
             url = ConstantsData.branchLoc2
         }
//         if let browserUrl = URL(string: "https://www.google.com/maps/dir/?saddr=&daddr=\(lat),\(lng)&directionsmode=driving") {
//             UIApplication.shared.open(browserUrl, options: [:], completionHandler: nil)
//         }
         
         if let browserUrl = URL(string: url) {
             UIApplication.shared.open(browserUrl, options: [:], completionHandler: nil)
         }
     }


 }

 extension BranchesViewController: SpecialityFilterDelegate {
  func specialityFilter(_ specialityFilter: SpecialityFilter, didSelectSpeciality speciality: Speciality) {
    specialityFilterPopup?.dismiss()
      self.mz_dismissFormSheetController(animated: true, completionHandler: nil)
    let doctorsVC = DoctorsViewController()
    doctorsVC.branchId = selectedBranch?.id
    doctorsVC.branch = selectedBranch!
    doctorsVC.specialityId = speciality.id
    isReschedule = false
    self.navigationController?.pushViewController(doctorsVC, animated: true)
  }
 }

 extension BranchesViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // ===============================================
    // ==== DZNEmptyDataSet Delegate & Datasource ====
    // ===============================================
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return branches.count == 0
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "error")
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "transform")
        
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 0.0, 1.0))
        
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        
        return animation
    }
    

 }

