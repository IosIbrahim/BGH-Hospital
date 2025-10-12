//
//  DoctorsSearchViewControllerExtensions.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 22/01/2023.
//  Copyright © 2023 khabeer Group. All rights reserved.
//

import Foundation
import UIKit
import CRRefresh

extension DoctorsSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func initCollectionView() {
        let nib = UINib(nibName: "DoctorCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "DoctorCollectionViewCell")
        collectionView.cr.addFootRefresh(animator: FastAnimator()) { [weak self] in
            self?.search()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayDoctors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoctorCollectionViewCell", for: indexPath) as! DoctorCollectionViewCell
        cell.setData(arrayDoctors[indexPath.row])
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
}

extension DoctorsSearchViewController: DoctorSearchCellDelegate {
    
    func showDocDetails(_ index: Int) {
        var model = arrayDoctors[index]
        model.id = model.DOC_ID
        model.englishName = model.DOC_NAME_EN
        model.englishNameAR = model.DOC_NAME_AR
        model.qualification = model.SPECIALITY_EN
        model.qualificationAR = model.SPECIALITY_AR
        let doctorProfileVC = DoctorProfileViewController()
        doctorProfileVC.doctor = model
        doctorProfileVC.branchID = self.selectedBranch?.id
        doctorProfileVC.branch = self.selectedBranch
        doctorProfileVC.specialityID = model.SPECIAL_SPEC_ID
        doctorProfileVC.DocName = UserManager.isArabic ? model.DOC_NAME_AR : model.DOC_NAME_EN
        doctorProfileVC.docID = model.DOC_ID
        if model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?.count ?? 0 > 1 {
            selectedBranches = []
            for item in model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW ?? [] {
                for itm in self.arrayBranches {
                    if item.HOSP_ID == itm.id && itm.englishName != "All branches" {
                        selectedBranches.append(itm)
                    }
                }
            }
            doctorProfileVC.selectedBranches = selectedBranches
        }
            doctorProfileVC.clincID =  model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?.first?.CLINIC_ID ?? ""
            doctorProfileVC.clinicName = UserManager.isArabic ? model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?.first?.CLINIC_NAME_AR ?? "" : model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?.first?.CLINIC_NAME_EN ?? ""
            doctorProfileVC.doctor?.clinicId = doctorProfileVC.clincID
            doctorProfileVC.noReservation = model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?.first? .NO_RESERVATION_ONLINE_ONLY_TEL ?? "" == "1"
            doctorProfileVC.clinicPhoneNumber = model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?.first?.CLINIC_PHONE_NUMBER ?? ""
            doctorProfileVC.clinicLetter = UserManager.isArabic ? model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?.first?.CLINIC_LETTER ?? "" : model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?.first?.CLINIC_LETTER_EN ?? ""
            self.navigationController?.pushViewController(doctorProfileVC, animated: true)
//        } else {
//            var branchName1 = ""
//            var branchName2 = ""
//            if !arrayBranches.isEmpty {
//                if selectBranchIndex == 0 {
//                    branchName1 = arrayBranches[1].getName()
//                    branchName2 = arrayBranches[2].getName()
//                }else if selectBranchIndex == arrayBranches.count - 1 {
//                    branchName2 = arrayBranches[selectBranchIndex].getName()
//                    branchName1 = arrayBranches[selectBranchIndex - 1].getName()
//                }else {
//                    branchName1 = arrayBranches[selectBranchIndex].getName()
//                    branchName2 = arrayBranches[selectBranchIndex + 1].getName()
//                }
//            }
//            var names = [String]()
//            let itms = model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW ?? []
//            for (i,item) in itms.enumerated() {
//                if i % 2 > 0 {
//                    names.append(item.getName() + " - " +  branchName1)
//                }else {
//                    names.append(item.getName() + " - " +  branchName2)
//                }
//            }
//            OPEN_LIST_POPUP(container: self, arrayNames: names) { index in
//                guard let index else { return }
//                doctorProfileVC.clincID =  model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_ID ?? ""
//                doctorProfileVC.doctor?.clinicId = doctorProfileVC.clincID
//                doctorProfileVC.clinicName = UserManager.isArabic ? model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_NAME_AR ?? "" : model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_NAME_EN ?? ""
//                doctorProfileVC.noReservation =  model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].NO_RESERVATION_ONLINE_ONLY_TEL ?? "" == "1"
//                doctorProfileVC.clinicPhoneNumber = model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_PHONE_NUMBER ?? ""
//                doctorProfileVC.clinicLetter = UserManager.isArabic ? model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_LETTER ?? "" : model.DOCTOR_CLINICS?.DOCTOR_CLINICS_ROW?[index].CLINIC_LETTER_EN ?? ""
//                self.navigationController?.pushViewController(doctorProfileVC, animated: true)
//            }
//        }
    }
}
