//
//  Allergy+TableView.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation
//
//  Diagnosis+TableView.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//


//

import Foundation

import UIKit
extension AllergyViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfAllergies.count
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllergyTableViewCell", for: indexPath) as! AllergyTableViewCell
        cell.configure(listOfAllergies[indexPath.row])
        return cell
        
    }
    
    
    func setup()  {
        let cellNib = UINib(nibName: "AllergyTableViewCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "AllergyTableViewCell")
        table.rowHeight = 150

    }
    
    func getdata() {
        
        let urlString = Constants.APIProvider.getPatientAllergy+"patient_id=\(patientId)&branch_id=1"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["ALLERGY"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["ALLERGY_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["ALLERGY_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.listOfAllergies.append(allergyModel(JSON: i)!)
                      
                        
                    }
                    }
                    else if root["ALLERGY_ROW"] is [String:AnyObject]
                    {
                        self.listOfAllergies.append(allergyModel(JSON:root["ALLERGY_ROW"] as![String:AnyObject] )!)
                     
                        
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
