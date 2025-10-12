//
//  special_list.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/14/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

protocol SpecialityFilterDelegate: class {
  func specialityFilter(_ specialityFilter: SpecialityFilter, didSelectSpeciality speciality: Speciality)
}

class SpecialityFilter: BaseViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var collectionview: UICollectionView!
    var selectedBranch: Branch?

    
    var fromMedicalRecord = false
  
  var specialities = [Speciality]()
  var filterData = [Speciality]()
  var isSearching = false
  weak var delegate: SpecialityFilterDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let cellNib = UINib(nibName: "SpecialityCell", bundle: nil)
      collectionview.register(cellNib, forCellWithReuseIdentifier: "SpecialityCell")

      searchBar.returnKeyType = .done
      searchBar.barTintColor = #colorLiteral(red: 0.8861967325, green: 0.8863243461, blue: 0.8861687779, alpha: 1)
      if #available(iOS 13.0, *) {
          searchBar.searchTextField.backgroundColor = .white
      

          searchBar.searchTextField.placeholder  =  UserManager.isArabic ? "بحث عن التخصص" :  "Search For a speciality"


      } else {
          // Fallback on earlier versions
      }


      collectionview.delegate = self
      collectionview.dataSource = self
   
  
      initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "اختر التخصص" : "Choose Speciality", hideBack: false)
    
      Speciality.getSpecialist(id: selectedBranch?.id ?? "", type: selectedBranch?.BRANCH_TYPE ?? "") { specialities in
          guard let specialities = specialities else {return}
          self.specialities = specialities
          self.collectionview.reloadData()
      }
  }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard


   
      
    }
}

extension SpecialityFilter: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.width / 3)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filterData.count : specialities.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialityCell", for: indexPath) as! SpecialityCell
        cell.specialityTitle.text = isSearching ? (UserManager.isArabic ? filterData[indexPath.row].arabicName : filterData[indexPath.row].englishName) : (UserManager.isArabic ? specialities[indexPath.row].arabicName : specialities[indexPath.row].englishName)
  
        
        print("Url Speciality")

        print("\(Constants.APIProvider.SpeclitiesImages)/\(specialities[indexPath.row].ICON_PATH ?? "")")
//        cell.image1.kf.setImage(with:URL(string: "\(Constants.APIProvider.SpeclitiesImages)/\(specialities[indexPath.row].ICON_PATH ?? "")") , placeholder:  UIImage(named: "specilityIConnn"))
        
        cell.image1.loadFromUrl(url: isSearching ?  "\(Constants.APIProvider.SpeclitiesImages)/\(filterData[indexPath.row].ICON_PATH ?? "")" : "\(Constants.APIProvider.SpeclitiesImages)/\(specialities[indexPath.row].ICON_PATH ?? "")", placeHolder: "specilityIConnn")
    
    
        return cell
    }
    

}

extension SpecialityFilter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectRow(at: indexPath, animated: true)
        let selectedSpeciality = isSearching ? filterData[indexPath.row] : specialities[indexPath.row]
//        delegate?.specialityFilter(self, didSelectSpeciality: selectedSpeciality)
      
        

        let doctorsVC = DoctorsViewController()
        doctorsVC.speciality = UserManager.isArabic ? selectedSpeciality.arabicName : selectedSpeciality.englishName 
        doctorsVC.branchId = selectedBranch?.id
        doctorsVC.branch = selectedBranch!
        doctorsVC.specialityId = selectedSpeciality.id
        doctorsVC.selectedSpeciality = selectedSpeciality
        isReschedule = false
        self.navigationController?.pushViewController(doctorsVC, animated: true)
  
     

    }
 
}

extension SpecialityFilter: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text == nil || searchBar.text == "" {
      isSearching = false
    } else {
      isSearching = true
        if UserManager.isArabic
        {
            filterData = specialities.filter({$0.arabicName.localizedCaseInsensitiveContains(searchBar.text!)})
        }
        else
        {
             filterData = specialities.filter({$0.englishName.localizedCaseInsensitiveContains(searchBar.text!)})
        }
    }
    self.collectionview.reloadData()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
}



extension Session {
//static func getManager() -> SessionManager{
//
//    let serverTrustPolicies: [String: ServerTrustPolicy] = [
//        "app.sidra.hospital": .disableEvaluation
//    ]
//
//    let configuration = URLSessionConfiguration.default
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//
//    return Alamofire.SessionManager(
//        configuration: configuration,
//        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
//    )
//}

}
