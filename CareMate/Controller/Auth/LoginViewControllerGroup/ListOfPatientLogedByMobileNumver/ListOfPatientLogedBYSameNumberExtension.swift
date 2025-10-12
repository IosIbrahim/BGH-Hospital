//
//  ListOfPatientLogedBYSameNumberExtension.swift
//  CareMate
//
//  Created by Khabber on 09/01/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import Foundation
import PopupDialog
import MZFormSheetController

extension LitsOfPatientLogedBySameMobileNumberViewController: UITableViewDelegate,UITableViewDataSource {
    func initTableView() {
        tableViewListOfOthers.register("ListOfLogedPatientTableViewCell")
        tableViewListOfOthers.delegate = self
        tableViewListOfOthers.dataSource = self
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  listOfOthersPatient.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.vcType == .fromLogin
        {
            currentPatientIDOrigni = listOfOthersPatient[indexPath.row].PATIENTID
            Utilities.sharedInstance.setPatientId(patienId:listOfOthersPatient[indexPath.row].PATIENTID)
            currentPatientMobile = listOfOthersPatient[indexPath.row].PAT_TEL
            UserDefaults.standard.set(listOfOthersPatient[indexPath.row].PATIENTID , forKey: "patientIdWithSpaces")
//            currentPatientID =   currentPatientID.replacingOccurrences(of: " ", with: "")
            UserDefaults.standard.set(true, forKey: "loginOrNO")
            
            let user1 =     LoginedUser(COMPLETEPATNAME_AR: listOfOthersPatient[indexPath.row].COMPLETEPATNAME_AR  , COMPLETEPATNAME_EN: listOfOthersPatient[indexPath.row].COMPLETEPATNAME_EN , PAT_TEL: listOfOthersPatient[indexPath.row].PAT_TEL , PAT_EMAIL: listOfOthersPatient[indexPath.row].PAT_EMAIL , PATIENTID: listOfOthersPatient[indexPath.row].PATIENTID )
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(user1) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: "SavedPerson")
            }
            
            

//
            self.navigationController?.pushViewController(  CompleteLoginWithPasswordViewController(mobile: listOfOthersPatient[indexPath.row].PAT_TEL, patientId: Utilities.sharedInstance.getPatientId(), mobileWithoutCode: primaryPhoneNumber), animated: true)
          
            selectedIndexsignICon = indexPath.row
            tableViewListOfOthers.reloadData()
        }
        else if self.vcType == .fromRegister
        {
//            sendCode(listOfOthersPatient[indexPath.row].PATIENTID)
            
                let vc:ConfirmAfterSignUpVC =   ConfirmAfterSignUpVC()

                vc.patientId = listOfOthersPatient[indexPath.row].PATIENTID


                vc.delegete = self
//                let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  gestureDismissal: true)
//                                self.present(popup, animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)

        }
        else
        {
            sendCode(listOfOthersPatient[indexPath.row].PATIENTID)
        }
        
        
    }
    func sendCode(_ patientId:String)
    {
      
        indicator.sharedInstance.show()
        
      
        var  pars = ["PATIENT_ID":patientId,"TYPE":"1"] as [String : String]
      
        let urlString = Constants.APIProvider.VERIFYPATIENTID
        print(urlString)
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.VERIFYPATIENTID + "?" + Constants.getoAuthValue(url: url!, method: "POST",parameters: nil)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: pars, vc: self) { (data, error) in
            let root = (data as! [String:AnyObject])
            
            print(root)
            print(root["Root"])
            print(type(of: root["Code"]))
            let Code = root["Code"] as? Int
//            if Code == 200
//            {
                
            
           
                if let patientId = root["PATIENT_ID"]  as? String
                {
                
                    
                    let vc:verifcationAddOtherVC = verifcationAddOtherVC(PatientId: patientId, patientIdArray: nil, vcType: .fromRetrive)
                    vc.fromForget = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                else
                {
                   
                    if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["OUT_PARMS"] as? [String:AnyObject]
                   {
                       
                       
                       
                       if root["OUT_PARMS_ROW"] is [String:AnyObject]
                           
                       {
                           let OUT_PARMS_ROW = root["OUT_PARMS_ROW"] as!  AnyObject

                           if let PATIENT_ID = OUT_PARMS_ROW["PATIENT_ID_ARRAY"] as? String as? String {
                               
                               if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["SELECT_PATIENT"] as? [String:AnyObject]
                               {
                                   
//                                   var listOfOTher1 = [listOfTherPatient]()
//
//                                   if root["SELECT_PATIENT_ROW"] is [[String:AnyObject]]
//                                   {
//
//                                       let appoins = root["SELECT_PATIENT_ROW"] as! [[String: AnyObject]]
//
//                                       print(appoins)
//                                       for i in appoins
//                                       {
//                                           print(i)
//                                           listOfOTher1.append(listOfTherPatient(JSON: i)!)
//
//
//                                       }
//                                   }
//                                   else if root["SELECT_PATIENT_ROW"] is [String:AnyObject]
//                                   {
//                                       listOfOTher1.append(listOfTherPatient(JSON:root["SELECT_PATIENT_ROW"] as![String:AnyObject] )!)
//
//                                   }
//
//                                   let vc:LitsOfPatientLogedBySameMobileNumberViewController = LitsOfPatientLogedBySameMobileNumberViewController(listOfOthers: listOfOTher1, VcType: .fromretrive)
//
////                                   vc.listOfOTher = listOfOTher1
////                                   vc.fromForget = true
//
//                                   self.navigationController?.pushViewController(vc, animated: true)
                                   
                               }

                          
                           }
                       }
                        
                        
                        
                    }
                }
                
                
                
             
                
                
                
               
                
               
             
                
//                let vc:ConfirmAfterSignUpVC =   ConfirmAfterSignUpVC()
//
//                vc.patientId = self.patientID
//
//
//                vc.delegete = self
//                let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  gestureDismissal: true)
//                                self.present(popup, animated: true, completion: nil)
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            
         
//            let vc:verifcationAddOtherVC = verifcationAddOtherVC()
//            vc.PATIENT_ID = self.patientID
//            vc.delegate = self
//            vc.fromForget = true
//            self.navigationController?.pushViewController(vc,animated: true)
            
            if root.keys.contains("MESSAGE")
            {
                
                    let loginStatus = (((((data as! [String: Any])["Root"])as! [String: Any])["MESSAGE"] as! [String:Any])["MESSAGE_ROW"] as! [String: Any])["NAME_EN"] as! String
                        Utilities.showAlert(messageToDisplay:loginStatus)

            }
           

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfLogedPatientTableViewCell", for: indexPath) as! ListOfLogedPatientTableViewCell
        cell.setData(listOfOthersPatient[indexPath.row], _index: indexPath.row, selectedIndexsignICon)
        return cell
    }
   
}

extension LitsOfPatientLogedBySameMobileNumberViewController:fromChangePass
{
    func chnagePassword() {
     
        delegate?.chnagePassword()
    }
    
    
}
