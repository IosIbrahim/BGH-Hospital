//
//  DoctorsSearchViewController.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 22/01/2023.
//  Copyright © 2023 khabeer Group. All rights reserved.
//

import UIKit
import CRRefresh

class DoctorsSearchViewController: BaseViewController {

    @IBOutlet weak var textfieldDoctorName: UITextField!
    @IBOutlet weak var viewBranches: UIView!
    @IBOutlet weak var labelBranch: UITextField!
    @IBOutlet weak var viewClinics: UIView!
    @IBOutlet weak var labelClinic: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelNoDoctorsFound: UILabel!
    @IBOutlet weak var lblSearch: UILabel!
    
    var arrayBranches = [Branch]()
    var selectedBranches = [Branch]()
    var selectedBranch: Branch?
    var selectBranchID: String = ""
    var arraySpecialities = [Speciality]()
    var selectedSpeciality: Speciality?
    var index = 0
    var selectBranchIndex = 0
    var arrayDoctors = [Doctor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(title: UserManager.isArabic ? "إبحث عن طبيب" : "Search for doctor")
        getBranches()
        initViews()
    }
    
    func initViews() {
        initCollectionView()
        lblSearch.text =  UserManager.isArabic ? "بحث" : "Search"
        labelBranch.text =  UserManager.isArabic ? "كل الفروع" : "All Branches"
        labelClinic.text =  UserManager.isArabic ? "جميع التخصصات" : "All Specialities"
        textfieldDoctorName.placeholder = UserManager.isArabic ? "اسم الطبيب":"Doctor Name"
        viewBranches.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openBranches)))
        viewClinics.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openClinics)))
        viewSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchClicked)))
    }
    
    func getBranches() {
        Branch.getOnlineAppointment() { onlineAppointments, branchesDic  in
            guard let onlineAppointments = onlineAppointments else {
                OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "خطأ في الاتصال" : "Error in connection") {
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            self.arrayBranches = onlineAppointments
            var allBranchesModel = Branch()
            allBranchesModel.id = "1"
            allBranchesModel.arabicName = "كل الفروع"
            allBranchesModel.englishName = "All branches"
            self.arrayBranches.insert(allBranchesModel, at: 0)
            self.selectedBranch = self.arrayBranches.first
            if self.arrayBranches.count > 2 {
                self.selectBranchID = "\(self.selectedBranch?.id ?? ""),\(self.arrayBranches[1].id)"
                self.selectBranchID = "\(self.selectedBranch?.id ?? "")"
                self.selectedBranches = [self.arrayBranches[1],self.arrayBranches[2]]
            }
            self.labelBranch.text = UserManager.isArabic ? self.selectedBranch?.arabicName : self.selectedBranch?.englishName
            self.getClinics()
        }
    }
    
    func getClinics() {
        self.selectedSpeciality = nil
        self.labelClinic.text = UserManager.isArabic ? "جميع التخصصات" : "All Specialities"
        let id = selectedBranch?.id ?? ""
        Speciality.getSpecialist(id: id, type: selectedBranch?.BRANCH_TYPE ?? "") { specialities in
            guard let specialities = specialities else {return}
            self.arraySpecialities = specialities
            self.searchClicked()
        }
    }
    
    @objc func openBranches() {
        OPEN_LIST_POPUP(container: self, arrayNames: (arrayBranches ).map({UserManager.isArabic ? $0.arabicName : $0.englishName})) { index in
            guard let index else { return }
            self.selectBranchIndex = index
            self.selectedBranch = self.arrayBranches[index]
            if index == self.arrayBranches.count - 1 {
                self.selectBranchID = "\(self.selectedBranch?.id ?? ""),\(self.arrayBranches[index - 1].id)"
                self.selectedBranches = [self.arrayBranches[index],self.arrayBranches[index - 1]]
            }else {
                self.selectBranchID = "\(self.selectedBranch?.id ?? ""),\(self.arrayBranches[index + 1].id)"
                self.selectedBranches = [self.arrayBranches[index],self.arrayBranches[index + 1]]
            }
            self.selectBranchID = "\(self.selectedBranch?.id ?? "")"
            self.selectedBranches = [self.arrayBranches[index]]
            self.labelBranch.text = UserManager.isArabic ? self.selectedBranch?.arabicName : self.selectedBranch?.englishName
            self.getClinics()
        }
    }
    
    @objc func openClinics() {
        if arraySpecialities.count > 0 {
            OPEN_LIST_POPUP(container: self, arrayNames: (arraySpecialities ).map({UserManager.isArabic ? $0.arabicName : $0.englishName})) { index in
                guard let index else { return }
                self.selectedSpeciality = self.arraySpecialities[index]
                self.labelClinic.text = UserManager.isArabic ? self.selectedSpeciality?.arabicName : self.selectedSpeciality?.englishName
            }
        }
    }
    
    @objc func searchClicked() {
        index = 0
        search()
    }
    
    func search() {
        if index == 0 {
            showIndicator()
            arrayDoctors.removeAll()
            collectionView.reloadData()
        }
        labelNoDoctorsFound.isHidden = true
   //     let urlString = "\(Constants.APIProvider.searchDoctors)index_from=\(index)&index_to=\(index + 40)&branch_id%20in%20(\(selectBranchID))&spec_id=\(selectedSpeciality?.id ?? "")&detect_text=\(textfieldDoctorName.text ?? "")"
        let urlString = "\(Constants.APIProvider.searchDoctors)index_from=\(index)&index_to=\(index + 40)&branch_id=\(selectBranchID)&spec_id=\(selectedSpeciality?.id ?? "")&detect_text=\(textfieldDoctorName.text ?? "")"
        index += 41
        Doctor.getSearchDoctors(url: urlString) { doctors in
            hideIndicator()
            self.collectionView.cr.endLoadingMore()
            if doctors == nil && self.index == 41 {
                self.labelNoDoctorsFound.isHidden = false
            } else {
                self.arrayDoctors.append(contentsOf: doctors ?? [])
                self.collectionView.reloadData()
                if Int(self.arrayDoctors.first?.PAGES_COUNT ?? "0") ?? 0 == self.arrayDoctors.count {
                    self.collectionView.cr.noticeNoMoreData()
                }
            }
        }
    }
}
