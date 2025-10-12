//
//  AmbulanceHistoryViewControllerExtensions.swift
//  CareMate
//
//  Created by m3azy on 25/09/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import Foundation
import UIKit

extension AmbulanceHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView() {
        let nib = UINib(nibName: "AmbulanceHistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AmbulanceHistoryTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAmbulanceFiltered.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayAmbulanceFiltered[indexPath.row].ACTION_SER == "1" {
            return 250
        }
        return  250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "AmbulanceHistoryTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AmbulanceHistoryTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.index = indexPath.row
        cell.setData(arrayAmbulanceFiltered[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension AmbulanceHistoryViewController: AmbulanceCellDelegate {
    
    func cancelOrder(_ index: Int) {
        let urlString = Constants.APIProvider.ambulanceCancelReasons
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                if let root = (data as? [String: AnyObject])?["PATIENT_CANCEL_REASON"] {
                    var arrayReasons = [AmbulanceReasonModel]()
                    if root["PATIENT_CANCEL_REASON_ROW"] is [String: Any] {
                        let jsonModel = root["PATIENT_CANCEL_REASON_ROW"] as? [String: Any] ?? [:]
                        let model = AmbulanceReasonModel()
                        model.ID = jsonModel["ID"] as? String ?? ""
                        model.NAME_AR = jsonModel["NAME_AR"] as? String ?? ""
                        model.NAME_EN = jsonModel["NAME_EN"] as? String ?? ""
                        model.NEED_TEXT = jsonModel["NEED_TEXT"] as? String ?? ""
                        arrayReasons.append(model)
                    } else {
                        for jsonModel in root["PATIENT_CANCEL_REASON_ROW"] as? [[String: Any]] ?? [[:]]{
                            let model = AmbulanceReasonModel()
                            model.ID = jsonModel["ID"] as? String ?? ""
                            model.NAME_AR = jsonModel["NAME_AR"] as? String ?? ""
                            model.NAME_EN = jsonModel["NAME_EN"] as? String ?? ""
                            model.NEED_TEXT = jsonModel["NEED_TEXT"] as? String ?? ""
                            arrayReasons.append(model)
                        }
                    }
                    OPEN_CANCEL_POPUP(container: self, arrayReasons: arrayReasons, message: UserManager.isArabic ? "من فضلك اكتب سبب الالغاء" : "Please enter the cancellation reason") { (ok, reason, reasonModel) in
                        if ok {
                            let urlString = Constants.APIProvider.cancelAmbulanceRequest
                            let param = ["SER": self.arrayAmbulanceFiltered[index].SERIAL,
                                         "REASON_DECLINE": reason,
                                         "CANCEL_REASON_ID": reasonModel?.ID ?? ""]
                            WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: param as [String : Any], vc: self) { (data, error) in
                                if error == nil {
                                    OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "تم الالغاء بنجاح" : "Order cancelled", dismiss: false) {
                                        self.getData()
                                    }
                                } else {
                                    OPEN_HINT_POPUP(container: self, message: error ?? "")
                                }
                            }
                        }
                    }
                } else {
                    OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "خطأ في الاتصال" : "Error in connection")
                }
            } else {
                OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "خطأ في الاتصال" : "Error in connection")
            }
        }
    }
}

class AmbulanceReasonModel {
    
    var ID = ""
    var NAME_AR = ""
    var NAME_EN = ""
    var NEED_TEXT = ""
}
