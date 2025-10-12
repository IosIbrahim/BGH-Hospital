//
//  ReportRequest+Tableview.swift
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
extension reportRequestsViewController: UITableViewDelegate, UITableViewDataSource, openSave {
    
    func openSaveFunc() {
        self.navigationController?.pushViewController(SaveViewController(), animated: true)
    }
    
    func showReport(_ index: Int) {
        let model = listOfReportRequest[index]
        let urlString = Constants.APIProvider.loadReport + "BRANCH_ID=1&USER_ID=KHABEER&REF_CODE=\(model.SERIAL)&OWNER_TYPE=1&ALL_CATEGORIES=0&OWNER_ID=\(Utilities.sharedInstance.getPatientId())&PROCESS_ID=6022"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            let root = (data as! [String: AnyObject])
            if let val = root["BLOB"] as? [String: AnyObject] {
                if let blobRaw = val["BLOB_ROW"] as? [String: AnyObject] {
                    let blobPath = blobRaw["BLOB_PATH"] as? String
                    let url = "\(Constants.APIProvider.IMAGE_BASE2)/\(blobPath ?? "")"
                    self.navigationController?.pushViewController(WebViewViewController(url), animated: true)
                }
                
            } else {
                print("key is not present in dict")
            }
        }
    }
    
    func delete(_ index: Int) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "", message: UserManager.isArabic ? "من فضلك اكتب سبب الالغاء" : "Please enter the cancellation reason", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: UserManager.isArabic ? "تاكيد" : "Confirm", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.deleteIndex(index: index, reason: textField?.text ?? "")
        }))
        alert.addAction(UIAlertAction(title: UserManager.isArabic ? "الغاء" : "Cancel", style: .cancel))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteIndex(index: Int, reason: String) {
        let model = listOfReportRequest[index]
        let urlString = Constants.APIProvider.deleteReport
        let params = ["COMPUTER_NAME" : "iOS",
                      "SER": model.SERIAL,
                      "USER_ID": "KHABEER",
                      "REMARKS": reason,
                      "BRANCH_ID": "1"]
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: params, vc: self) { (data, error) in
            let root = (data as! [String: AnyObject])
            self.getdata(DateTo: self.dateTo, DateFrom: self.dateFrom)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfReportRequest.count
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportRequestsTableViewCell", for: indexPath) as! reportRequestsTableViewCell
        cell.delegate = self
        cell.index = indexPath.row
        cell.configure(listOfReportRequest[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func setup()  {
        let cellNib = UINib(nibName: "reportRequestsTableViewCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "reportRequestsTableViewCell")
        self.table.rowHeight = 280


        
//        let viewDateForm = UITapGestureRecognizer(target: self, action:  #selector(self.DateForm))
//        self.viewDateForm.addGestureRecognizer(viewDateForm)
//
//        let viewDateTo = UITapGestureRecognizer(target: self, action:  #selector(self.DateTo))
//        self.viewDateTo.addGestureRecognizer(viewDateTo)
//
//        labelDateFrom.text = Date().asString
//        labelDateTo.text = Date().asString
//
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd/MM/yyyy"
//
//        labelDateFrom.text = formatter3.string(from: Date())
//        labelDateTo.text = formatter3.string(from: Date())

        dateTo = formatter3.string(from: Date())
        dateFrom = formatter3.string(from: Date())

        getdata(DateTo: "", DateFrom: "")

    }
//
//    func getdata(DateTo:String,DateFrom:String) {
//
//        let urlString = Constants.APIProvider.patientReportsRequests + "BRANCH_ID=1&PATIENT_ID=\(Utilities.sharedInstance.getPatientId())&USER_ID=KHABEER&Lang=0&DISEASE_ID=0"
//        let url = URL(string: urlString)
////        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
//        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
//
//            let root = (data as! [String:AnyObject])
//
//            if root.keys.contains("SEARCH_REQ_RESULT")
//            {
//
//                if error == nil
//                {
//                     if let root = ((data as! [String: AnyObject])["SEARCH_REQ_RESULT"] as! [String:AnyObject])["SEARCH_REQ_RESULT_ROW"] as? [[String:AnyObject]]
//                    {
//
//                   for i in root
//                   {
//
//                    self.listOfReportRequest.append(ReportRequestsModel(JSON: i)!)
//                   }
//
//                        self.table.dataSource = self
//                        self.table.delegate = self
//                        self.table.reloadData()
//
//                    }
//                    else
//                     {
//                        let object = ((data as! [String: AnyObject])["SEARCH_REQ_RESULT"] as! [String:AnyObject])["SEARCH_REQ_RESULT_ROW"] as? [String:AnyObject]
//                        self.listOfReportRequest.append(ReportRequestsModel(JSON: object!)!)
//                        self.table.dataSource = self
//                        self.table.delegate = self
//                        self.table.reloadData()
//
//
//                    }
//                }
//
//            }
//
//
//
//
//        }
//    }
    func getdata(DateTo:String,DateFrom:String) {
        self.listOfReportRequest.removeAll()
        let urlString = Constants.APIProvider.patientReportsRequests + "BRANCH_ID=1&PATIENT_ID=\(Utilities.sharedInstance.getPatientId())&USER_ID=KHABEER&Lang=0&DISEASE_ID=0&DATE_FROM=\(DateFrom)&DATE_TO=\(DateTo)"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            let root = (data as! [String:AnyObject])

            if let val = root["SEARCH_REQ_RESULT"] {
                print("val")
                
                let rootval = (val as? [String:AnyObject])
                
                if ((rootval?.keys.contains("SEARCH_REQ_RESULT_ROW")) != nil){
                    //                    if root.keys.contains("SEARCH_REQ_RESULT_ROW")
                    //                    {
                    
                    if error == nil
                    {
                        if let root = ((data as! [String: AnyObject])["SEARCH_REQ_RESULT"] as! [String:AnyObject])["SEARCH_REQ_RESULT_ROW"] as? [[String:AnyObject]]{
                            
                            for i in root{
                                self.listOfReportRequest.append(ReportRequestsModel(JSON: i)!)
                            }
                            
                            self.table.dataSource = self
                            self.table.delegate = self
                            self.table.reloadData()
                            
                        }
                        else
                        {
                            let object = ((data as! [String: AnyObject])["SEARCH_REQ_RESULT"] as! [String:AnyObject])["SEARCH_REQ_RESULT_ROW"] as? [String:AnyObject]
                            self.listOfReportRequest.append(ReportRequestsModel(JSON: object!)!)
                            self.table.dataSource = self
                            self.table.delegate = self
                            self.table.reloadData()
                            
                            
                        }
                    } else {
                        self.setErrorLabelText(error: UserManager.isArabic ? "لا يوجد طلبات سابقة" : "No previous requests found")
                    }
                    
                    //                    }
                    
                    
                } else {
                    self.setErrorLabelText(error: UserManager.isArabic ? "لا يوجد طلبات سابقة" : "No previous requests found")
                }
               print(val)
            } else {
                print("key is not present in dict")
                self.setErrorLabelText(error: UserManager.isArabic ? "لا يوجد طلبات سابقة" : "No previous requests found")
            }
                
            
           
        }
    }
    

    
    
}
