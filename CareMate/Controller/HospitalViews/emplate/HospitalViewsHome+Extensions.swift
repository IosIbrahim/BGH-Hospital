//
//  HospitalViewsHome+Extensions.swift
//  CareMate
//
//  Created by MAC on 14/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation
import Kingfisher
extension HospitalViewsHomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    
    
    
    func setup()  {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1346794665, green: 0.5977677703, blue: 0.5819112062, alpha: 1)
     
        
        list.append(medicalViewModel(NameAr: "السرداب الاول" , NameEn: "Basement 1", Url: "https://dec35x714wl62.cloudfront.net/assets/uploads/default/_130x130_crop_center-center_none/2021513222935.jpg"))
        list.append(medicalViewModel( NameAr: "الدور الارضي", NameEn: "Ground Floor", Url: "https://dec35x714wl62.cloudfront.net/assets/uploads/default/_130x130_crop_center-center_none/2021513223633.jpg"))
        list.append(medicalViewModel( NameAr: "الدور الاول", NameEn: "First Floor",Url:"https://dec35x714wl62.cloudfront.net/assets/uploads/default/_130x130_crop_center-center_none/202151322439.jpg"))
        
        list.append(medicalViewModel( NameAr:"الدور الثالث", NameEn:  "3rd - Floor",Url: "https://dec35x714wl62.cloudfront.net/assets/uploads/default/_130x130_crop_center-center_none/2021513223854.jpg"))
        
        list.append(medicalViewModel( NameAr:"الغرف والأجنحة", NameEn:  "Rooms and Suites",Url: "https://dec35x714wl62.cloudfront.net/assets/uploads/default/_130x130_crop_center-center_none/20211222141444.jpg"))

        list.append(medicalViewModel( NameAr:  "لؤلؤة دسمان", NameEn: "Dasman Pearl",Url: "https://dec35x714wl62.cloudfront.net/assets/uploads/default/_130x130_crop_center-center_none/louloua2.jpg"))
        list.append(medicalViewModel( NameAr: "أجنحة دسمان" , NameEn:"Dasman Suite", Url: "https://dec35x714wl62.cloudfront.net/assets/uploads/default/_130x130_crop_center-center_none/2021513224815.jpg"))
        list.append(medicalViewModel( NameAr: "برج المسيله الدور الارضي", NameEn: "Messila Ground floor Dental center",Url: "https://dec35x714wl62.cloudfront.net/assets/uploads/default/_130x130_crop_center-center_none/thumb_2025-01-17-035407_yffq.jpg"))
        list.append(medicalViewModel( NameAr:  "برج المسيله الدور الثامن" , NameEn:"Messila 8th floor - Derma Care",Url: "https://dec35x714wl62.cloudfront.net/assets/uploads/default/_130x130_crop_center-center_none/2021513225232.jpg"))
        
        let nib = UINib(nibName: "medicationsViewCell", bundle: nil)
            collection?.register(nib, forCellWithReuseIdentifier: "medicationsViewCell")
        collection.delegate = self
        collection.dataSource = self
        collection.reloadData()

    
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "medicationsViewCell", for: indexPath) as? medicationsViewCell
//        cell?.fromHos = true
        cell?.handelCEll()

        cell?.image123.kf.indicatorType = .activity

        cell?.LabName.text = UserManager.isArabic  ? list[indexPath.row].NameAr :  list[indexPath.row].NameEn
        cell?.image123.kf.setImage(with: URL(string: list[indexPath.row].Url ?? ""))

        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width =   UIScreen.main.bounds.width

        return CGSize(width: width * 0.5 - 30, height: width * 0.5 + 30 )
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            let vc:viewAllHospital = viewAllHospital(Url: "https://dec35x714wl62.cloudfront.net/vtour/basement-final/sihb.html", title: UserManager.isArabic  ? list[indexPath.row].NameAr :  list[indexPath.row].NameEn)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1
        {
            let vc:viewAllHospital = viewAllHospital(Url: "https://dec35x714wl62.cloudfront.net/vtour/sih-gf/sih_gf.html", title: UserManager.isArabic  ? list[indexPath.row].NameAr :  list[indexPath.row].NameEn)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2
        {
            let vc:viewAllHospital = viewAllHospital(Url: "https://dec35x714wl62.cloudfront.net/vtour/sih-mezzanine/sih-mezzanine.html", title: UserManager.isArabic  ? list[indexPath.row].NameAr :  list[indexPath.row].NameEn)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3
        {
            let vc:viewAllHospital = viewAllHospital(Url: "https://dec35x714wl62.cloudfront.net/vtour/3rd-floor/sih-3rdfloor.html", title: UserManager.isArabic  ? list[indexPath.row].NameAr :  list[indexPath.row].NameEn)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if  indexPath.row == 4
        {
            
        
            let vc:viewAllHospital = viewAllHospital(Url: "https://dec35x714wl62.cloudfront.net/vtour/5thfloor1/5th-floor.html", title: UserManager.isArabic  ? list[indexPath.row].NameAr :  list[indexPath.row].NameEn)
            self.navigationController?.pushViewController(vc, animated: true)
         
        }
        else if indexPath.row == 5
        {
            let vc:viewAllHospital = viewAllHospital(Url: "https://dec35x714wl62.cloudfront.net/vtour/louloua-suite/index.html", title: UserManager.isArabic  ? list[indexPath.row].NameAr :  list[indexPath.row].NameEn)
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
        else if indexPath.row == 6
        {
        
            let vc:viewAllHospital = viewAllHospital(Url: "https://dec35x714wl62.cloudfront.net/vtour/9th-floor/sih-9thfloor.html", title: UserManager.isArabic  ? list[indexPath.row].NameAr :  list[indexPath.row].NameEn)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else if indexPath.row == 7
        {
            
      
            let vc:viewAllHospital = viewAllHospital(Url: "https://dec35x714wl62.cloudfront.net/vtour/Messilah-dental-clinic/sih-dental-clinic.html", title: UserManager.isArabic  ? list[indexPath.row].NameAr :  list[indexPath.row].NameEn)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else 
        {
        
            let vc:viewAllHospital = viewAllHospital(Url: "https://dec35x714wl62.cloudfront.net/vtour/Messilah-8th-floor/messilah-derma.html", title: UserManager.isArabic  ? list[indexPath.row].NameAr :  list[indexPath.row].NameEn)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    
    }

}
