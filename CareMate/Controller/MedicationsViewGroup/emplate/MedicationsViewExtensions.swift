//
//  MedicationsViewExtensions.swift
//  CareMate
//
//  Created by MAC on 08/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation
import UIKit

enum ScreenType {
    case medicalPrescription
    case monthlyPrescription
    case lab
    case rad
    case medicalReport
    case allergies
    case medicalHistory
    case sickLeave
    case operation
    case diagnosis
    case clinicServicesReport
}
extension MedicationsViewViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func setup()  {
        let nib = UINib(nibName: "medicationsViewCell", bundle: nil)
            collection?.register(nib, forCellWithReuseIdentifier: "medicationsViewCell")
        collection.delegate = self
        collection.dataSource = self
        collection.reloadData()
        let prescreptionsImage =  UIImage(named: "OverViewRXICon.png")
        prescreptionsImage?.changeColor()
         list.append(medicalViewModel(imagee: UIImage(named: "BHG-medicine"), NameAr: "الوصفات الطبية", NameEn:"Prescription", type: .medicalPrescription))
      //  list.append(medicalViewModel(imagee: UIImage(named: "BHG-medicine"), NameAr: "الوصفات الشهرية", NameEn:"Monthly Prescriptions", type: .monthlyPrescription))
        list.append(medicalViewModel(imagee: UIImage(named: "BHG-Labs"), NameAr: "المختبر", NameEn: "Lab", type: .lab))
        list.append(medicalViewModel(imagee: UIImage(named: "BHG-x-ray"), NameAr: "الأشعة", NameEn: "Rad", type: .rad))
        list.append(medicalViewModel(imagee: UIImage(named: "BHG-MedicalRepp"), NameAr:"التقارير الطبية", NameEn:  "Medical Reports", type: .medicalReport))
        list.append(medicalViewModel(imagee: UIImage(named: "BHG-DocPice"), NameAr:  "التشخيص المرضي", NameEn: "Patient Diagnosis", type: .diagnosis))
        list.append(medicalViewModel(imagee: UIImage(named: "BHG-allergy"), NameAr: "الحساسيه", NameEn: "Allergies", type: .allergies))
        // list.append(medicalViewModel(imagee: UIImage(named: "OverViewHistoryIcon.png"), NameAr: "التاريخ المرضي" , NameEn:"Patient History", type: .medicalHistory))
         list.append(medicalViewModel(imagee: UIImage(named: "BHG-hospitalBed"), NameAr:"العمليات", NameEn:"Operations", type: .operation))
       // list.append(medicalViewModel(imagee: UIImage(named: "Group 8014"), NameAr: "الاجازات المرضيه" , NameEn: "Sick Leave", type: .sickLeave))
       // list.append(medicalViewModel(imagee: UIImage(named: "BHG-ClinicResults"), NameAr: "نتائج خدمات العيادة" , NameEn: "Clinic Services Reports", type: .clinicServicesReport))

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "medicationsViewCell", for: indexPath) as? medicationsViewCell
        
        cell?.LabName.text = UserManager.isArabic  ? list[indexPath.row].NameAr :  list[indexPath.row].NameEn
        cell?.image123.image = list[indexPath.row].imagee
//        cell?.fromHos = true
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width =   UIScreen.main.bounds.width

        return CGSize(width: width * 0.5 - 30, height: 130 )
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var vc = UIViewController()
        switch list[indexPath.row].type {
        case .medicalPrescription:
            vc = RXOFPatientViewController(month: nil)
            break
        case .monthlyPrescription:
            vc = RXOFPatientViewController(month: 1)
            break
        case .lab:
            vc = LabVC()
            break
        case .rad:
            vc = RadiologyVC()
            break
        case .medicalReport:
            vc = MedicalReportsVC()
            break
        case .diagnosis:
            vc = DiagnosisViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1")
            break
        case .allergies:
            vc = AllergyViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1")
            break
        case .medicalHistory:
            vc = PatientHistoryViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1")
            break
        case .sickLeave:
            vc = sickLeaveViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1")
            break
        case .operation:
            vc = OperationViewController(patientId: Utilities.sharedInstance.getPatientId(), branchId: "1", Type: "1")
            break
        case .clinicServicesReport:
            vc = ClinicsServiceesReportsViewController()
        default :
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIImage{
    
    func changeColor(){
        
       
        
        if #available(iOS 13.0, *) {
//         self.withRenderingMode(.alwaysTemplate)
            self.withTintColor(UIColor.green)
        } else {
            // Fallback on earlier versions
        }
    }
  
}
class uilabelCenter :UILabel{
    
    override func awakeFromNib() {
        self.textAlignment = .center
    }
    
}
