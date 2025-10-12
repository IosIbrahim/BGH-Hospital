//
//  NotifcationsViewController.swift
//  CareMate
//
//  Created by Khabber on 11/01/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class NotifcationsViewController: BaseViewController {
    var showGroups:Bool = true
    var dataSources = [AlertsCountsRow]()
    var listOfNotiofcation = [notifcationDTO]()
    var group :AlertsCountsRow?
    var alertGroupSource = [AlertsResultRow]()
    
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.register("GroupCell")
        table.register("NotifcationaTableViewCell")
        table.rowHeight = UITableViewAutomaticDimension
        self.table.delegate = self
        self.table.dataSource = self
        // Do any additional setup after loading the view.
     
        let notif = UserManager.isArabic ? "الاشعارات" : "Notifcations"
        let titl = showGroups ? notif:group?.getDes()
        initHeader(isNotifcation: false, isLanguage: false, title: titl ?? "", hideBack: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showGroups ? getGroupData() : getGroupDetails()
    }
    
    func getGroupData() {
        let lan = UserManager.isArabic ? 1:2
        let urlString = Constants.APIProvider.notificationGroups + "USER_ID=\(Utilities.sharedInstance.getPatientId())&OBJECT_TYPE=3&langId=\(lan)"
        
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil
            {
                let dictionary = data as? [String: AnyObject] ?? .init()
                if let jsonData = try? JSONSerialization.data(withJSONObject:dictionary) {
                    do {
                        let model = try JSONDecoder().decode(NotificationGroupModel.self, from: jsonData)
                        self.dataSources = model.root?.alertsCounts?.alertsCountsRow ?? []
                        self.table.reloadData()
                    }catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func getGroupDetails() {
        let lan = UserManager.isArabic ? 1:2
        let urlString = Constants.APIProvider.notifGroupDetail + "USER_ID=\(Utilities.sharedInstance.getPatientId())&alert_id=\(group?.alertID ?? "")&indexFrom=1&indexTo=30&OBJECT_TYPE=3&langId=\(lan)"
        
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil
            {
                let dictionary = data as? [String: AnyObject] ?? .init()
                if let jsonData = try? JSONSerialization.data(withJSONObject:dictionary) {
                    do {
                        let model = try JSONDecoder().decode(NotificationGroupDetailsModel.self, from: jsonData)
                        self.alertGroupSource = model.alertsResult?.alertsResultRow ?? []
                        self.table.reloadData()
                        let cnt = Int(self.group?.countUnread ?? "") ?? .zero
                        if cnt > .zero {
                            self.updateNotification()
                        }
                    }catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func updateNotification() {
        let urlString = Constants.APIProvider.updateNotificationCount
        let lan = UserManager.isArabic ? 1:2
        let params:[String : Any] = ["alert_id":group?.alertID ?? "",
                            "LanguageID":lan,
                            "OBJECT_NAME":Utilities.sharedInstance.getPatientId(),
                            "OBJECT_TYPE":3]
        print(params)
        WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: params, vc: self) { (data, error) in
            if error == nil {
                print(data as? [String:AnyObject] ?? .init())
            }else {
                print(error ?? "")
            }
        }
    }
    
    // old notification
    func getdata() {
        var lan = 1
        if UserManager.isArabic
        {
            lan = 1
        }
        else
        {
            lan = 2
        }

        let urlString = Constants.APIProvider.loadPatNotification + "PATIENTID=\(Utilities.sharedInstance.getPatientId())&langId=\(lan)"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil
            {
                if let root = ((data as? [String: AnyObject]))?["PAT_ALERTS"] as? [String:AnyObject]
                {
                    if root["PAT_ALERTS_ROW"] is [[String:AnyObject]]
                    {
                    let appoins = root["PAT_ALERTS_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        self.listOfNotiofcation.append(notifcationDTO(JSON: i)!)
                    }
                    }
                    else if root["PAT_ALERTS_ROW"] is [String:AnyObject]
                    {
                        self.listOfNotiofcation.append(notifcationDTO(JSON:root["PAT_ALERTS_ROW"] as![String:AnyObject] )!)
                    }
                    self.table.reloadData()
                    
                }
            }
        }
    }
    

}
