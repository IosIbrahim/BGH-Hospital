//
//  SickLeave+TableView.swift
//  CareMate
//
//  Created by MAC on 01/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//



import Foundation

import UIKit
extension sickLeaveViewController:UITableViewDelegate,UITableViewDataSource,goToPrintSickLeve
{
    func goToPrintSickLevefunc(_model: sickLeaveDTO) {
//        let vc = SickLeavePrintViewController()
//        vc.ser = _model.SER
//        self.navigationController?.pushViewController(vc, animated: true)
        let urlString = Constants.APIProvider.sickleaveReport
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: ["SER": _model.SERIAL_BLOB], vc: self) { (data, error) in
            if error == nil {
                if let root = (data as? [String: AnyObject])?["BLOB_PATH"] as? String {
                    let url = "\(Constants.APIProvider.IMAGE_BASE2)\(root)"
                    self.navigationController?.pushViewController(WebViewViewController(url), animated: true)
                } else {
                }
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfdiagnosis.count
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SickLeaveCell", for: indexPath) as! SickLeaveCell
        cell.configure(listOfdiagnosis[indexPath.row])
        cell.delegate = self
        return cell
        
    }
    
    
    func setup()  {
        let cellNib = UINib(nibName: "SickLeaveCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "SickLeaveCell")
        table.rowHeight = UITableViewAutomaticDimension
        

    }
    
    func getdata() {
        
//        let urlString = Constants.APIProvider.searchSickleave+"patient_id=\(Utilities.sharedInstance.getPatientId())&branch_id=1"
//        let url = URL(string: urlString)
////        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
//        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
//            if error == nil {
//                if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["SICK_LEAVE"] as? [String:AnyObject] {
//                    if root["SICK_LEAVE_ROW"] is [[String:AnyObject]] {
//                        let appoins = root["SICK_LEAVE_ROW"] as! [[String: AnyObject]]
//                        for i in appoins {
//                            self.listOfdiagnosis.append(sickLeaveDTO(JSON: i)!)
//                        }
//                    } else if root["SICK_LEAVE_ROW"] is [String:AnyObject] {
//                        self.listOfdiagnosis.append(sickLeaveDTO(JSON:root["SICK_LEAVE_ROW"] as![String:AnyObject] )!)
//                    }
//                    self.table.delegate = self
//                    self.table.dataSource = self
//                    self.table.reloadData()
//                } else {
//                }
//            }
//        }
        
        let urlString = Constants.APIProvider.searchSickleave2+"PATIENT_ID=\(Utilities.sharedInstance.getPatientId())&CAT_ID=50"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["VISIT_SCAN"] as? [String:AnyObject] {
                    if root["VISIT_SCAN_ROW"] is [[String:AnyObject]] {
                        let appoins = root["VISIT_SCAN_ROW"] as! [[String: AnyObject]]
                        for i in appoins {
                            self.listOfdiagnosis.append(sickLeaveDTO(JSON: i)!)
                        }
                    } else if root["VISIT_SCAN_ROW"] is [String:AnyObject] {
                        self.listOfdiagnosis.append(sickLeaveDTO(JSON:root["VISIT_SCAN_ROW"] as![String:AnyObject] )!)
                    }
                    self.table.delegate = self
                    self.table.dataSource = self
                    self.table.reloadData()
                } else {
                }
            }
        }
    }
}
