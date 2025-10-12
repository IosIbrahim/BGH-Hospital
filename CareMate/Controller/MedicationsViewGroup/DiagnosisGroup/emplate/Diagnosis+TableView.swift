//
//  Diagnosis+TableView.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation
//
//  PatientHistory+TableView.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation

import UIKit
extension DiagnosisViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfdiagnosis.count
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiagnosisTableViewCell", for: indexPath) as! DiagnosisTableViewCell
        cell.configure(listOfdiagnosis[indexPath.row])
        return cell
        
    }
    
    
    func setup()  {
        let cellNib = UINib(nibName: "DiagnosisTableViewCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "DiagnosisTableViewCell")
        table.rowHeight = 125

    }
    
    func getdata() {
        
        let urlString = Constants.APIProvider.getPatientDiagnosis+"patient_id=\(Utilities.sharedInstance.getPatientId())&branch_id=1"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["DIAGNOSIS"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["DIAGNOSIS_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["DIAGNOSIS_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.listOfdiagnosis.append(diagnosisModel(JSON: i)!)
                      
                        
                    }
                    }
                    else if root["DIAGNOSIS_ROW"] is [String:AnyObject]
                    {
                        self.listOfdiagnosis.append(diagnosisModel(JSON:root["DIAGNOSIS_ROW"] as![String:AnyObject] )!)
                     
                        
                    }
                    self.table.delegate = self
                    self.table.dataSource = self
                    self.table.reloadData()
                    
                    
                }
                else
                 {
                }
            }

           
        }
    }
    

    
    
}
