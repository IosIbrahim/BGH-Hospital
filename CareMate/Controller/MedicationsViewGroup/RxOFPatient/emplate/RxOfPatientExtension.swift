//
//  RxOfPatientExtension.swift
//  CareMate
//
//  Created by MAC on 28/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation
import UIKit
extension RXOFPatientViewController:UITableViewDelegate,UITableViewDataSource, ReceptionPrintProtocol
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOFRx.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 290
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let var1 = (Int(listOFRx[indexPath.row].APPROVED_ITEMS_COUNT ?? "") ?? 0)
        let var2 = (Int(listOFRx[indexPath.row].REGULAR_ITEMS_COUNT ?? "") ?? 0)
        let var3 = (Int(listOFRx[indexPath.row].NEED_APPROVAL_ITEMS_COUNT ?? "") ?? 0)
        let nuberOfItemString =   "\(var1 + var2 + var3)"
        
        self.navigationController?.pushViewController(RXOfPatientDetails(MEDPLANCD: listOFRx[indexPath.row].MEDPLANCD, object: listOFRx[indexPath.row], nuberOfItems: nuberOfItemString), animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RxOfPatientCell", for: indexPath) as! RxOfPatientCell
        cell.index = indexPath.row
        cell.delegate = self
        cell.configure(listOFRx[indexPath.row], monthly: month != nil)
        return cell
        
    }
    
    
    func setup()  {
        let cellNib = UINib(nibName: "RxOfPatientCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "RxOfPatientCell")
    }
    
    func printReception(_ index: Int) {
        let vc =  LabResultController()
        vc.aCCESSION_NO = listOFRx[index].VISIT_ID
        vc.rxModel = listOFRx[index]
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func getdata() {
        var urlString = ""
        if month == nil {
            urlString = Constants.APIProvider.getPatPrescHistory+"patient_id=\(Utilities.sharedInstance.getPatientId())&INDEX_TO=1000&INDEX_FROM=1&branch_id=1"
        } else {
            urlString = Constants.APIProvider.getPatPrescHistory+"patient_id=\(Utilities.sharedInstance.getPatientId())&INDEX_TO=1000&INDEX_FROM=1&branch_id=1&P_MONTHLY_ITEMS=1"
        }
        
        
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["PAT_PRESC"] as? [String:AnyObject]
                {
                    if root["PAT_PRESC_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["PAT_PRESC_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.listOFRx.append(RxModel(JSON: i)!)
                    }
                    }
                    else if root["PAT_PRESC_ROW"] is [String:AnyObject]
                    {
                        self.listOFRx.append(RxModel(JSON:root["PAT_PRESC_ROW"] as![String:AnyObject] )!)
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
