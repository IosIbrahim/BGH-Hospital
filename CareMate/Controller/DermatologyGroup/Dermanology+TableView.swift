//
//  Dermanology+TableView.swift
//  CareMate
//
//  Created by mostafa gabry on 4/28/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation
import UIKit

extension DermatologySpecialitesiVC:UITableViewDelegate,UITableViewDataSource
{
    
    
    func setupUI()  {
        listOfDermenology.register(UINib(nibName: "DermatolgySpcialitiesCell", bundle: nil), forCellReuseIdentifier: "DermatolgySpcialitiesCell")
        listOfDermenology.layer.cornerRadius = 25
        listOfDermenology.delegate = self
        listOfDermenology.dataSource = self
        getData()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.ServiceBigModelObject?.services.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DermatolgySpcialitiesCell") as? DermatolgySpcialitiesCell
        
        cell?.specilaityLabel.text =  self.ServiceBigModelObject?.services[indexPath.row].displayNameEn ?? ""
        
        if let indexpathinCondext = indexpathin
        {
            if indexpathinCondext == indexPath.row {
                cell?.innerView.isHidden = false

            }
            else
            {
                cell?.innerView.isHidden = true

            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexpathin = indexPath.row
        listOfDermenology.reloadData()
        print(DoctorObject?.englishName)
        
        delegate?.gotToDoctorProfileFromDermenologyFunc(dermenologyService: (self.ServiceBigModelObject?.services[indexPath.row])!)
//        let vc:DoctorProfileVC = DoctorProfileVC()
//
//        vc.doctor = DoctorObject
//
//        self.navigationController?.pushViewController(vc, animated: true)

    }
    
   
 
    
    func getData() {
        indicator.sharedInstance.show()

        let url = Constants.APIProvider.getReservationServices + "USER_ID=khabeer" + "&BRANCH_ID=\(branhcId ?? "")" + "&CLINIC_ID=\(ClinicID ?? "")" + "&DOC_ID=\(doctorId)" + "&OP_CALL_SER=1"
        AppConnectionsHandler.get(url: url, headers:nil, type: ServiceBigModel.self) { (status, model, error) in
            indicator.sharedInstance.dismiss()
            switch status {
            case .sucess:
                let model = model as! ServiceBigModel
                
                
                self.ServiceBigModelObject = model
                
                print(self.ServiceBigModelObject?.services.count)
                
                self.listOfDermenology.reloadData()
              

                break
            case .error:
                break
            }
        }
    }
    
    
}


