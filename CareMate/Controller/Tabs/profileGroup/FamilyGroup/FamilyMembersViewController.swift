//
//  FamilyMembersViewController.swift
//  CareMate
//
//  Created by Khabber on 09/05/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class FamilyMembersViewController: BaseViewController {

    @IBOutlet weak var table: UITableView!
    var listOfFamilies = [familtyDTO]()

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getdata()
        if UserManager.isArabic
        {
            title = "العائلة"
        }
        else
        {
            title = "Family"

        }
    }
    func getdata() {
        
        var urlString = Constants.APIProvider.load_patient_family+"PatientID=\(Utilities.sharedInstance.getPatientId())&branchID=1"
        let urly = URL(string: urlString)
        
//        urlString =   urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!

        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["WIFES"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["WIFES_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["WIFES_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                
                        var  ob = familtyDTO(JSON: i)!
                        ob.wifeSon =  "Wife"
                        self.listOfFamilies.append(ob)
                      
                        
                    }
                    }
                    else if root["WIFES_ROW"] is [String:AnyObject]
                    {
                        var  ob = familtyDTO(JSON:root["WIFES_ROW"] as![String:AnyObject] )!
                        ob.wifeSon = "Wife"
                        self.listOfFamilies.append(ob)
//
                        
                    }
                  
                     if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["SONS"] as? [String:AnyObject]
                    {
                        
                   
                        
                        if root["SONS"] is [[String:AnyObject]]
                        {
                        
                        let appoins = root["SONS_ROW"] as! [[String: AnyObject]]
                        for i in appoins
                        {
                    
                            var  ob = familtyDTO(JSON: i)!
                            ob.wifeSon =  "Son"
                            self.listOfFamilies.append(ob)
                          
                            
                        }
                        }
                        else if root["SONS_ROW"] is [String:AnyObject]
                        {
    //
                            var  ob = familtyDTO(JSON:root["SONS_ROW"] as![String:AnyObject] )!
                            ob.wifeSon = "Son"
                            self.listOfFamilies.append(ob)
                            
                        }
                        self.table.delegate = self
                        self.table.dataSource = self
                        self.table.reloadData()
                        
                        
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
