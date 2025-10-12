//
//  complainsList+TableView.swift
//  CareMate
//
//  Created by MAC on 06/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation
//
//  OperationExtenTion+TableView.swift
//  CareMate
//
//  Created by MAC on 04/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation
//

import UIKit
extension complainListViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfComplains.count
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompainsTableViewCell", for: indexPath) as! CompainsTableViewCell
        cell.configure(listOfComplains[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.navigationController?.pushViewController(ShowComplaintViewController(listOfComplains[indexPath.row]), animated: true)
    }
    
    func setup()  {
        let cellNib = UINib(nibName: "CompainsTableViewCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "CompainsTableViewCell")
        table.rowHeight = UITableViewAutomaticDimension

    }

    func getdata() {
        if let savedPerson = UserDefaults.standard.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {
                
            
                var urlString = Constants.APIProvider.CRMCOMPLAINTHistory+"BENEFICIARY_CODE=\(loadedPerson.PATIENTID)&BENEFICIARY_TYPE=1&BRANCH_ID=1&USER_ID=KHABEER"
                
                //        urlString =   urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                print(urlString)
                WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
                    
                    if error == nil
                    {
                        if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["CRM_COMPLAINTS"] as? [String:AnyObject]
                        {
                            
                            
                            
                            if root["CRM_COMPLAINTS_ROW"] is [[String:AnyObject]]
                            {
                                
                                let appoins = root["CRM_COMPLAINTS_ROW"] as! [[String: AnyObject]]
                                for i in appoins
                                {
                                    
                                    self.listOfComplains.append(ComplainsDTO(JSON: i)!)
                                    
                                    
                                }
                            }
                            else if root["CRM_COMPLAINTS_ROW"] is [String:AnyObject]
                            {
                                self.listOfComplains.append(ComplainsDTO(JSON:root["CRM_COMPLAINTS_ROW"] as![String:AnyObject] )!)
                                
                                
                            } else {
                                self.setErrorLabelText(error: UserManager.isArabic ? "لا يوجد شكاوي/إقتراحات سابقة" : "No previous Complaints/Suggestions found")
                            }
                            self.table.delegate = self
                            self.table.dataSource = self
                            self.table.reloadData()
                            
                            
                        }
                        else
                        {
                            self.setErrorLabelText(error: UserManager.isArabic ? "لا يوجد شكاوي/إقتراحات سابقة" : "No previous Complaints/Suggestions found")
                        }
                    }else {
                        self.setErrorLabelText(error: UserManager.isArabic ? "لا يوجد شكاوي/إقتراحات سابقة" : "No previous Complaints/Suggestions found")
                    }
                    
                    
                }
            }
        }
    }
    

    
    
}
