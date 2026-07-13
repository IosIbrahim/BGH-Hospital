//
//  PhysicalController.swift
//  CareMate
//
//  Created by Ibrahim on 05/05/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

import UIKit
enum SessionFilter {
    case all
    case schedule
    case reschedule
}

class PhysicalController: BaseViewController {

    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var stkNoData: UIStackView!
    @IBOutlet weak var tblSessions: UITableView!
    @IBOutlet weak var clcTabs: UICollectionView!
    
    private var dataSources = [ServiceSessionRowModel]()
    private var tabIndex:Int = .zero
    private var tabsDataSources = [String]()
    var branch:Branch?
    var filter:SessionFilter = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stkNoData.isHidden = !dataSources.isEmpty
        lblNoData.text = UserManager.isArabic ? "لا توجد جلسات" : "No Sessions Found"
        lblNoData.textAlignment = .center
        initTable()
        getSessions()
        let titl = UserManager.isArabic ? "العلاج الطبيعي" : "Physical Therapy"
        initHeader(isNotifcation: true, isLanguage: true, title: titl, hideBack: false)
        // Do any additional setup after loading the view.
    }
    
    func initTable() {
        tblSessions.register("PhysGroubCell")
        clcTabs.register("HeaderTabCell")
        let all = UserManager.isArabic ? "الكل":"All"
        let scheduled = UserManager.isArabic ? "مجدولة":"Scheduled"
        let rescheduled = UserManager.isArabic ? "تجتاج جدولة":"Need Schedule"
        tabsDataSources = [all,scheduled,rescheduled]
        clcTabs.reloadData()
    }
    
     func getSessions() {
         let id = Utilities.sharedInstance.getPatientId()
         let urlString = "\(Constants.APIProvider.GetPhysicalSessions)bRANCH_ID=\(branch?.id ?? "")&pATIENT_ID=\(id)&PHSIO_FILTER=2"
         var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
     //    request.addValue("Bearer \()", forHTTPHeaderField: "Authorization")

         request.httpMethod = "GET"
         indicator.sharedInstance.show()
//    let url = URL(string: urlString)
//    let parseUrl = urlString + "?" + Constants.getoAuthValue(url: url!, method: "GET")
         print(urlString)
         URLSession.shared.dataTask(with: request) { data, response, error in
             indicator.sharedInstance.dismiss()
             if error != nil {//Has error for request
                 if error?._code == -1001 {
                     //Domain=NSURLErrorDomain Code=-1001 "The request timed out."
            DispatchQueue.main.async {
                  print(error?.localizedDescription ?? "")
              }
            return
          }
            DispatchQueue.main.async {
                print(error?.localizedDescription ?? "")
            }
        }
        guard let data = data else {
//        Utilities.showAlert(messageToDisplay:"Couldn't connect to server")
            DispatchQueue.main.async {
                print("Empty Data")
            }
        return
      }
        
//      guard let json = String.init(data: data, encoding: .utf8), json.contains("PAT_SERVICES") else {
////        Utilities.showAlert(messageToDisplay:"No branches found")
//          DispatchQueue.main.async {
//              print("Empty Data")
//          }
//        return
//      }
        
   //     print(json)
        
             let decoder = JSONDecoder()
             if let sessions = try? decoder.decode(SessionResponseModel.self, from: data) {
                 self.dataSources = sessions.services?.rows ?? []
             }
             
//        let sessions = try? SessionResponseModel(data: data, keyPath: "PAT_SERVICES")
             DispatchQueue.main.async {
                 self.stkNoData.isHidden = !self.dataSources.isEmpty
                 self.tblSessions.reloadData()
             }
      }.resume()
  }

}


extension PhysicalController: UITableViewDataSource,UITableViewDelegate,SessionRowProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhysGroubCell", for: indexPath) as! PhysGroubCell
        cell.delegate = self
        cell.drawCell(dataSources[indexPath.row],filter: filter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       dataSources[indexPath.row].isSelected = !(dataSources[indexPath.row].isSelected ?? false)
       if indexPath.row == .zero {
           filter = .all
       }else if indexPath.row == 1 {
           filter = .schedule
       }else {
           filter = .reschedule
       }
       tblSessions.reloadRows(at: [indexPath], with: .automatic)
   }
   
    func setlectSession(_ row:SessionRowModel,hospital:String){
        let doctorProfileVC = DcotorSlotsViewController()
        var item:ServiceSessionRowModel?
        for itm in dataSources {
            if itm.getHospital() == hospital {
                item = itm
                break
            }
        }
        doctorProfileVC.doctor = Doctor(id: item?.doctorId,
                                        englishName: item?.doctorNameEn,
                                        englishNameAR: item?.doctorNameAr,
                                        gender: nil,
                                        doctorCategory: item?.doctorSpecialEn,
                                        doctorCategoryAR: item?.doctorSpecialAr,
                                        clinicName: item?.hospitalNameEn,
                                        clinicNameAR: item?.hospitalNameAr,
                                        nationality: nil,
                                        nationalityAR: nil,
                                        clinicId: nil,
                                        qualification: item?.doctorSpecialEn,
                                        qualificationAR: item?.doctorSpecialAr,
                                        FIRST_SLOT_TIME: "",
                                        DOCTOR_PIC: "",
                                        HREMPLOYEELANGUAGE_EN: "",
                                        HREMPLOYEELANGUAGE_AR: "",
                                        CLINIC_PHONE_NUMBER: "",
                                        DOCCATNAME: item?.doctorSpecialEn,
                                        DOCCATNAMEen: item?.doctorSpecialAr,
                                        NO_RESERVATION_VIEW_ONLY_TEL: "",
                                        INFORMAT_ONLY: "",
                                        CLINIC_LETTER: "",
                                        CLINIC_LETTER_EN: "",
                                        DOC_ID: item?.doctorId,
                                        DOC_NAME_AR: item?.doctorNameAr,
                                        DOC_NAME_EN: item?.doctorNameEn,
                                        SPECIAL_SPEC_ID: item?.doctorSpecialId,
                                        SPECIALITY_AR: item?.doctorSpecialAr,
                                        SPECIALITY_EN: item?.doctorSpecialEn,
                                        PAGES_COUNT: nil,
                                        RNUM: nil,
                                        DOCTOR_CLINICS: nil,
                                        GENDERCODE: "", HIDE_SCHEDULE_MOBILE_APP: "", CONTACT_TEL1: "", CONTACT_TEL2: "", CLINIC_LOCATION_AR: "", CLINIC_LOCATION_EN: "", branchAr: "", branchEn: "")
        doctorProfileVC.branchID = branch?.id ?? ""
        doctorProfileVC.branch = branch
        doctorProfileVC.specialityID = item?.doctorSpecialId
        doctorProfileVC.DocName = item?.getDoctorName()
        doctorProfileVC.docID = item?.doctorId
        doctorProfileVC.clincID = ""
        doctorProfileVC.clicnName = item?.getHospital()
        doctorProfileVC.isPhysical = true
        doctorProfileVC.session = row
        self.navigationController?.pushViewController(doctorProfileVC, animated: true)
    }
}


extension PhysicalController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabsDataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderTabCell", for: indexPath) as! HeaderTabCell
        cell.cellSelected = indexPath.row == tabIndex
        cell.drawCell(tabsDataSources[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tabIndex = indexPath.row
        clcTabs.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenSize = UIScreen.main.bounds
            var screenWidth = screenSize.width
            screenWidth = screenWidth - 30
            let cellSize = screenWidth / 3
            var size = CGSize.zero
            size.width = cellSize
            size.height =  55
            return size
    }
}
