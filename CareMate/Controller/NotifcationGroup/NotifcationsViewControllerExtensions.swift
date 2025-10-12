//
//  NotifcationsViewControllerExtensions.swift
//  CareMate
//
//  Created by Khabber on 12/01/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import Foundation

extension NotifcationsViewController :UITableViewDelegate ,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return showGroups ? dataSources.count: alertGroupSource.count
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showGroups {
            let cellIdentifier: String = "GroupCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! GroupCell
            cell.selectionStyle = .none
    //        cell.labelName.text = listOfVisit[indexPath.row].NAME_EN
            cell.drawCell(dataSources[indexPath.row])
            return cell
        }else {
            let cellIdentifier: String = "NotifcationaTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NotifcationaTableViewCell
            cell.selectionStyle = .none
         //   cell.setModel(listOfNotiofcation[indexPath.row])
            cell.drawCell(alertGroupSource[indexPath.row], index: indexPath.row)
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showGroups {
            let vc = NotifcationsViewController()
            vc.showGroups = false
            vc.group = dataSources[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }else {
            let model = alertGroupSource[indexPath.row]
            if model.alertID == "132" || model.alertID == "268" || model.alertID == "735" || model.alertID == "741" || model.alertID == "742" {
                var item = notifcationDTO(JSON: .init())
                item?.ALERT_ID = model.alertID ?? ""
                item?.ALERT_BODY = model.getBody()
                item?.ALERT_HEADER = model.getHeader()
                item?.ALERT_SERIAL = model.alertSerial ?? ""
                item?.PATIENTID = "\(Utilities.sharedInstance.getPatientId())"
                item?.TRANSDATE = model.newTransdate ?? ""
                navigationController?.pushViewController(NotificationDetailsViewController(item!), animated: true)
                let body = model.getBody() 
                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: body, options: [], range: NSRange(location: 0, length: body.utf16.count))
                for match in matches {
                    guard let range = Range(match.range, in: body) else { continue }
                    let url = body[range]
                    print(url)
                    guard let url = URL(string: String(url)) else { return }
                    UIApplication.shared.open(url)
                }
            }
            
            let body = model.getBody()
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: body, options: [], range: NSRange(location: 0, length: body.utf16.count))
            for match in matches {
                guard let range = Range(match.range, in: body) else { continue }
                let url = body[range]
                print(url)
                guard let url = URL(string: String(url)) else { return }
                UIApplication.shared.open(url)
            }
        }
        
    }

    
}
