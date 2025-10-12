//
//  ProfileDoctorsViewController.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/15/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import UIKit

class DoctorProfileViewController2: BaseViewController {
  var doctor: Doctor?
  var qualifications = [Qualification]()
  var clincID: String?
  var branchID: String?
  var docID: String?
  var clicnName: String?
  var DocName: String?

  @IBOutlet weak var doctorName: UILabel!
  @IBOutlet weak var doctorImage: UIImageView!
  @IBOutlet weak var specilityTitle: UILabel!
  @IBOutlet weak var doctorNationality: UILabel!
  @IBOutlet weak var hospitalName: UILabel!
  @IBOutlet weak var qualificationsTableView: UITableView!
  @IBOutlet weak var bookAppoinmentButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    clincID = doctor?.clinicId
    doctorName.text = doctor?.englishName
//      setupTabBar.instance.setuptabBar(vc: self)

//    doctorImage.layer.cornerRadius = self.doctorImage.bounds.width / 2
    doctorImage.layer.borderWidth = 3
    doctorImage.layer.borderColor = #colorLiteral(red: 0.2156862745, green: 0.5333333333, blue: 0.6901960784, alpha: 1)
    doctorImage.image = doctor?.gender == "M" ? #imageLiteral(resourceName: "bluemobile") : #imageLiteral(resourceName: "lo_title_ico")

    doctorNationality.text = doctor?.nationality

    qualificationsTableView.tableFooterView = UIView()
    bookAppoinmentButton.layer.cornerRadius = 15

    Qualification.getQualifications(forDoctorWithId: docID!) { qualifications in
      guard let qualifications = qualifications else {return}
//      self.qualifications = qualifications
      self.qualificationsTableView.reloadData()
    }
  }
    override func viewWillAppear(_ animated: Bool) {
        
        
        let  loginOrNO =   UserDefaults.standard.bool(forKey: "loginOrNO")
        
//        if loginOrNO == true
//        {
//            
//            
//         self.navigationController?.navigationBar.isHidden = false
//         self.navigationController?.setNavigationBarHidden(false, animated: true)
//            
////            if fromMedicalRecord == true
////            {
////                navigationController?.setNavigationBarHidden(false, animated: true)
////            }
////            else
////            {
////            navigationController?.setNavigationBarHidden(false, animated: true)
////
////            }
//        }
//        else
//        {
//            self.navigationController?.navigationBar.isHidden = true
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//        }
        
        let defaults = UserDefaults.standard

        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {

//                navigationController?.setNavigationBarHidden(false, animated: animated)

            }
        }
        else
        {

//            navigationController?.setNavigationBarHidden(true, animated: animated)


        }
        

    }

  @IBAction func backPressed(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }

  @IBAction func BookAppoinment(_ sender: Any) {
    let bookAppVC = self.storyboard?.instantiateViewController(withIdentifier: "bookAppID") as!ReservationClinicAppiontmentViewController
    bookAppVC.branchID = self.branchID
    bookAppVC.clincID = self.clincID
    bookAppVC.clinicNameL = self.clicnName
    bookAppVC.docNameL = self.DocName
    bookAppVC.docID = self.docID
    self.navigationController?.pushViewController(bookAppVC, animated: true)
  }
}

extension DoctorProfileViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return qualifications.count
      return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorProfileCell", for: indexPath) as! DoctorProfileCell
    cell.qualificationTitle.text = "hellow" //qualifications[indexPath.row].qualificationName

    return cell
  }
}
