//
//  OperationExtenTion+TableView.swift
//  CareMate
//
//  Created by MAC on 04/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation
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
extension OperationViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfOperation.count
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperationTableViewCell", for: indexPath) as! OperationTableViewCell
        cell.configure(listOfOperation[indexPath.row])
        cell.delegate = self
        cell.index = indexPath.row
        return cell
        
    }
    
    
    func setup()  {
        let cellNib = UINib(nibName: "OperationTableViewCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "OperationTableViewCell")
        table.rowHeight = 280

    }
    
    func getdata() {
        self.listOfOperation.removeAll()
        let urlString = Constants.APIProvider.getPatientOperation+"PATIENTID=\(patientId)&branch_id=1&type=\(type)"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["PAT_OPER"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["PAT_OPER_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["PAT_OPER_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                       var model = operationDTO(JSON: i)!
                        self.listOfOperation.append(operationDTO(JSON: i)!)
                      
                        
                    }
                    }
                    else if root["PAT_OPER_ROW"] is [String:AnyObject]
                    {
                        self.listOfOperation.append(operationDTO(JSON:root["PAT_OPER_ROW"] as![String:AnyObject] )!)
                     
                        
                    }
                    self.table.delegate = self
                    self.table.dataSource = self
                    self.table.reloadData()
                    
                    
                }
                else
                 {
                }
            }

            self.table.delegate = self
            self.table.dataSource = self
            self.table.reloadData()
           
        }
    }
    

    
    
}

extension OperationViewController: OperationCellDelegate {
    
    func showReport(_ index: Int) {
        let vc1:SaveViewController = SaveViewController()
        vc1.visitId = listOfOperation[index].VISIT_ID
        vc1.hospID = listOfOperation[index].BRANCH_NAME_EN.getBranchID()
        self.navigationController?.pushViewController(vc1, animated: true)
    }
    
    func showInstructions(_ index: Int) {
        let model = listOfOperation[index]
        var counter = 1
        var text = ""
        for i in model.OPERATION_INSTRUCTIONS?.OPERATION_INSTRUCTIONS_ROW ?? [] {
            text += "\(counter)- \(UserManager.isArabic ? i.DESC_AR : i.DESC_EN)\n"
            counter += 1
        }
        text.removeLast()
        OPEN_HINT_POPUP(container: self, message: text)
    }
}
