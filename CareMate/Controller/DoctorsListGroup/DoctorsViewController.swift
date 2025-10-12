//
//  DoctorsViewController.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/14/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
class DoctorsViewController: BaseViewController ,UISearchBarDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

  var branchId: String?
    var branch: Branch?
  var specialityId: String?
    var SpecType = ""
    var doctors = [Doctor]()
    var fullDoctors = [Doctor]()
    var delegate :gotToDoctorProfileFromDermenology?
    
    var indexRowDermenology = 0
    
    var serviceOb:Service?
    
    var speciality = ""
    var doctorObject:Doctor?
    var guestName = ""
    var guestPhone = ""
    var guestPhoneCode = ""
    var guestGender = ""
    var guestBithDate = ""
    var isScedule = false
    var guestIdentityType = ""
    var guestSSN = ""
    var selectedSpeciality: Speciality?

  override func viewDidLoad() {
    super.viewDidLoad()
//      setupTabBar.instance.setuptabBar(vc: self)
      initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "اختر الطبيب" : "Choose Doctor", hideBack: false)
  
      self.navigationController?.tabBarController?.tabBar.isHidden = false
      tableView.tableFooterView = UIView()
      tableView.register("doctorTableViewCell")
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.delegate = self
      tableView.dataSource = self
      tableView.backgroundColor = .clear
      self.tableView.emptyDataSetSource = self
      self.tableView.emptyDataSetDelegate = self
      searchBar.delegate = self

      tableView.keyboardDismissMode = .onDrag
      guard let specialityId = specialityId, let branchId = branchId else {return}
      Doctor.getDoctors(withSpecialityId: specialityId, andBranchId: branchId, type: branch?.BRANCH_TYPE ?? "1") { doctors in
        guard let doctors = doctors else {return}
          self.doctors = doctors
          self.fullDoctors = doctors
        self.tableView.reloadData()
      }

      self.title = UserManager.isArabic ? "الأطباء" : "Doctors"
  
  }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIView.appearance().semanticContentAttribute = !UserManager.isArabic ? .forceLeftToRight : .forceRightToLeft
        
        
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmed == "" {
            self.doctors = self.fullDoctors
        }
        else
        {
            self.doctors = self.fullDoctors.filter{$0.englishName!.lowercased().contains(searchText.lowercased())}
        }
        self.tableView.reloadData()
    }
  @IBAction func backPressed(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profile"
        {
            
            if  SpecType == "4" {
                let doctorProfileVC = segue.destination as! DoctorProfileVC
                let doctor = sender as! Doctor
                doctorProfileVC.doctor = doctorObject
                doctorProfileVC.branchID = self.branchId
                doctorProfileVC.branch = self.branch!
                doctorProfileVC.specialityID = self.specialityId
                doctorProfileVC.clincID = doctor.clinicId
                doctorProfileVC.clicnName = doctor.clinicName
                doctorProfileVC.DocName = doctor.englishName
                doctorProfileVC.docID = doctor.id
                
                doctorProfileVC.serviceObject = serviceOb
            }
            else
            {
                let doctorProfileVC = segue.destination as! DoctorProfileVC
                let doctor = sender as! Doctor
                doctorProfileVC.doctor = doctor
                doctorProfileVC.branchID = self.branchId
                doctorProfileVC.branch = self.branch!
                doctorProfileVC.specialityID = self.specialityId
                doctorProfileVC.clincID = doctor.clinicId
                doctorProfileVC.clicnName = doctor.clinicName
                doctorProfileVC.DocName = doctor.englishName
                doctorProfileVC.docID = doctor.id
                
                doctorProfileVC.serviceObject = serviceOb
            }
           
          
            

        }
    }
}

extension DoctorsViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return     }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return doctors.count

  }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 140
//    }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "doctorTableViewCell", for: indexPath) as! doctorTableViewCell
    cell.layer.cornerRadius = 10
    cell.configCell(doctor: doctors[indexPath.row])
    return cell
  }
}

extension DoctorsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = doctors[indexPath.row]
        if model.NO_RESERVATION_VIEW_ONLY_TEL ?? "" == "1" {
//            OPEN_HINT_POPUP(container: self, message: "\(UserManager.isArabic ? "اضغط للنسخ" : "Click to copy")\n\(model.CLINIC_PHONE_NUMBER ?? "")\n\(UserManager.isArabic ? model.CLINIC_LETTER ?? "" : model.CLINIC_LETTER_EN ?? "")")
            AppPopUpHandler.instance.openPopup(container: self, vc: ContactDoctorPopupViewController(phoneNumber: model.CLINIC_PHONE_NUMBER ?? "", place: UserManager.isArabic ? model.CLINIC_LETTER ?? "" : model.CLINIC_LETTER_EN ?? ""))
        } else if model.HIDE_SCHEDULE_MOBILE_APP ?? "" == "1" {
            AppPopUpHandler.instance.openPopup(container: self, vc: ContactDoctorPopupViewController(phoneNumber: model.CONTACT_TEL1 ?? "", place: UserManager.isArabic ? model.CLINIC_LETTER ?? "" : model.CLINIC_LETTER_EN ?? "", phoneNumber2: model.CONTACT_TEL2 ?? ""))
        } else {
            if SpecType == "4" {
                let vc:DermatologySpecialitesiVC =  DermatologySpecialitesiVC()
                vc.specilaityId = specialityId ?? ""
                vc.branhcId = branchId ?? ""
                vc.doctorId = doctors[indexPath.row].id ?? ""
                vc.ClinicID = doctors[indexPath.row].clinicId ?? ""
                vc.DoctorObject = doctors[indexPath.section]
                self.doctorObject =  doctors[indexPath.section]
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                indexRowDermenology = indexPath.section
                tableView.deselectRow(at: indexPath, animated: true)
                let doctorProfileVC = DcotorSlotsViewController()
                doctorProfileVC.doctor = self.doctors[indexPath.row]
                doctorProfileVC.branchID = self.branchId
                doctorProfileVC.branch = self.branch!
                doctorProfileVC.specialityID = self.specialityId
                doctorProfileVC.clincID = self.doctors[indexPath.row].clinicId ?? ""
                doctorProfileVC.clicnName = self.doctors[indexPath.row].clinicName ?? ""
                doctorProfileVC.DocName = self.doctors[indexPath.row].englishName ?? ""
                doctorProfileVC.docID = self.doctors[indexPath.row].id ?? ""
                doctorProfileVC.serviceObject = serviceOb
                doctorProfileVC.guestName = guestName
                doctorProfileVC.guestPhone = guestPhone
                doctorProfileVC.guestPhoneCode = guestPhoneCode
                doctorProfileVC.guestGender = guestGender
                doctorProfileVC.guestIdentityType = guestIdentityType
                doctorProfileVC.guestSSN = guestSSN
                doctorProfileVC.guestBithDate = guestBithDate
                doctorProfileVC.isScedule = isScedule
                doctorProfileVC.speciality = speciality
                doctorProfileVC.selectedSpeciality = selectedSpeciality
                let url = URL(string: "\(Constants.APIProvider.IMAGE_BASE)\(doctors[indexPath.row].DOCTOR_PIC ?? "")")
                doctorProfileVC.url = url
                self.navigationController?.pushViewController(doctorProfileVC, animated: true)
            }
        }
  }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
  
}
extension DoctorsViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // ===============================================
    // ==== DZNEmptyDataSet Delegate & Datasource ====
    // ===============================================
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return doctors.count == 0
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
    
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text =  UserManager.isArabic ?  "لم يتم العثور على أطباء" : "No doctors found !"
//        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:Color.darkGray]
//
//        return NSAttributedString(string: text, attributes: attributes)
//    }
}


extension DoctorsViewController:gotToDoctorProfileFromDermenology
{
    
    
    func gotToDoctorProfileFromDermenologyFunc(dermenologyService: Service) {
      
        self.serviceOb = dermenologyService
        
        
        performSegue(withIdentifier: "profile", sender: doctors[indexRowDermenology])
        
   
    }
    
   
    
    
}

struct Pizza {
  let ingredients: [String]
}

protocol Pizzeria {
  func makePizza(_ ingredients: [String]) -> Pizza
//  func makeMargherita() -> Pizza
}

extension Pizzeria {
//  func makeMargherita() -> Pizza {
//    return makePizza(["tomato", "mozzarella"])
//  }
}

struct Lombardis: Pizzeria {
  func makePizza(_ ingredients: [String]) -> Pizza {
    return Pizza(ingredients: ingredients)
  }

  func makeMargherita() -> Pizza {
    return makePizza(["tomato", "basil", "mozzarella"])
  }
}
