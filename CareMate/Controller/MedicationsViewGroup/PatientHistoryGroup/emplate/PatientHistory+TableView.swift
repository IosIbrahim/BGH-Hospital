//
//  PatientHistory+TableView.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation

import UIKit
extension PatientHistoryViewController:UITableViewDelegate,UITableViewDataSource
{
    
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return listOfHistorysection.count
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return  UserManager.isArabic ? listOfHistorysection[section].titleAr : listOfHistorysection[section].titleEN
//
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfHistory.count
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientHistoryCell", for: indexPath) as! PatientHistoryCell
        cell.configure(listOfHistory[indexPath.row])
        return cell
        
    }
    
    
    func setup()  {
        let cellNib = UINib(nibName: "PatientHistoryCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "PatientHistoryCell")
        table.rowHeight = UITableViewAutomaticDimension
        

    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func getdata() {
        
        let urlString = Constants.APIProvider.GetPatientHistory+"patient_id=\(Utilities.sharedInstance.getPatientId())&branch_id=1"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["HISTORY"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["HISTORY_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["HISTORY_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.listOfHistory.append(historyModel(JSON: i)!)
                      
                        
                    }
                    }
                    else if root["HISTORY_ROW"] is [String:AnyObject]
                    {
                        self.listOfHistory.append(historyModel(JSON:root["HISTORY_ROW"] as![String:AnyObject] )!)
                     
                        
                    }
//
                    
                    self.setupForSection()
                }
                else
                 {
                }
            }
            
            

           
        }
    }
    

    func setupForSection()  {
        
        
//        var family = [historyModel]()
        var past = [historyModel]()
        var persent = [historyModel]()
        
        for item in listOfHistory
        {
//            if item.H_FAMILY_FLAG == "1"
//            {
//                family.append(item)
//            }
            if item.H_PAST_FLAG == "1"
            {
                past.append(item)
            }
            if item.H_PRESENT_FLAG == "1"
            {
                persent.append(item)
            }
        }
//        listOfHistorysection.insert(patientHistoryWithSection(arrayOfHistory: family, titleAr:"عائلي",titleEN: "Family" ), at: 0)
        listOfHistorysection.insert(patientHistoryWithSection(arrayOfHistory: past, titleAr: "السابق",titleEN: "Past"), at: 0)
        listOfHistorysection.insert(patientHistoryWithSection(arrayOfHistory: persent, titleAr: "الحاضر",titleEN: "Persent illness"), at: 1)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.reloadData()
    }
    
}
