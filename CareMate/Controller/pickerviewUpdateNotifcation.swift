//
//  pickerviewUpdateNotifcation.swift
//  CareMate
//
//  Created by khabeer on 12/7/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import UIKit
import UserNotifications
import MZFormSheetController

class pickerviewUpdateNotifcation: BaseViewController ,UNUserNotificationCenterDelegate{
    @IBOutlet weak var datePicker: UIDatePicker!
    var selectedDrug:reminderDrug?
    var REMARKS = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
//        setupTabBar.instance.setuptabBar(vc: self)

        if #available(iOS 14, *) {
             datePicker.preferredDatePickerStyle = .wheels
             datePicker.sizeToFit()
         }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatterGet.locale = Locale(identifier: "en")
        dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatterPrint.locale = Locale(identifier: "en")
        self.REMARKS = dateFormatterPrint.string(from: Date())

    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day,.second,.hour,.minute], from: sender.date)
        
             print("sender.sate")
            print(        sender.date as? String)
            components.date
             print(components.date)
               if let day = components.day, let month = components.month, let year = components.year ,let sec = components.second , let hour = components.hour ,let  min = components.minute {
            
          
                
                
                print(min)
                let dateFormatterGet = DateFormatter()
                   dateFormatterGet.locale = Locale(identifier: "en")
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
                dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as! TimeZone
                
                let dateFormatterPrint = DateFormatter()
                   dateFormatterPrint.locale = Locale(identifier: "en")
                dateFormatterPrint.dateFormat = "dd/MM/yyyy HH:mm:ss"
                self.REMARKS = dateFormatterPrint.string(from: sender.date)
                
            
            
        }
    }
    @IBAction func closeCliked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func okCliked(_ sender: Any) {
        
        var idendifier = [String]()
        idendifier.append((selectedDrug?.dateALL)!)
        
        
        print(idendifier)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idendifier)
        } else {
            // Fallback on earlier versions
        
        }

        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        dateFormatter.locale = Locale(identifier: "en")
        
        let dateFromString =  dateFormatter.date(from: self.REMARKS)
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatter.dateFormat = "yyyy"
        let yaer = dateFormatter.string(from: dateFromString!)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: dateFromString!)
        
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: dateFromString!)
        
        let identifierForRequest = selectedDrug?.drugName ?? "" + day

        dateFormatter.dateFormat = "HH"
        let hour = dateFormatter.string(from: dateFromString!)
        dateFormatter.dateFormat = "mm"
        let min = dateFormatter.string(from: dateFromString!)
        
        dateFormatter.dateFormat = "ss"
        let second = dateFormatter.string(from: dateFromString!)
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.string(from: dateFromString!)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: dateFromString!)
        let currentDate = dateFormatter.string(from: Date())
        
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            
            UNUserNotificationCenter.current().delegate = self
            content.title = (selectedDrug?.drugName)!
            content.body = selectedDrug!.drugdose
            content.sound = UNNotificationSound.default()
            if #available(iOS 10.0, *) {
                
                print("year \(yaer) month \(month) day \(day) hour \(hour) min \(min) secnde\(second)" )
                //                let dateComponents = DateComponents(year: Int(yaer), month: Int(month),  hour: Int(hour), minute: Int(min) ,second: Int(second)! + 02,weekday:2)
                var dateComponents = DateComponents()
                
                if second > "55"
                {
                    dateComponents.minute = Int(min)! + 01
                    dateComponents.second = 00
                    
                }
                else
                {
                    dateComponents.second = Int(second)! + 04
                    dateComponents.minute = Int(min)
       
                }
                dateComponents.hour = Int(hour)
                dateComponents.month = Int(month)
                dateComponents.day = Int(day)
                dateComponents.year = Int(yaer)
                
                
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                            repeats: false)
                let request = UNNotificationRequest(identifier: identifierForRequest, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
            } else {
                // Fallback on earlier versions
            }
        } else {
            // Fallback on earlier versions
        }
        
        self.mz_dismissFormSheetController(animated: true, completionHandler: nil)

        self.dismiss(animated: true, completion: nil)
        
//        self.dismissAnimated()

        
        
        
        
        
    }
}
extension pickerviewUpdateNotifcation
{
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
        completionHandler([.alert, .sound, .badge])
        
    
        
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let classBObject = storyboard?.instantiateViewController(withIdentifier: "schedleNotifcationCliked") as! schedleNotifcationCliked
        //        classBObject.delegate = self
        
        print(response.notification.request.identifier)
        print("mostafa")
        
        classBObject.notifcationIdendifier =      response.notification.request.identifier
        classBObject.drugSelected = self.selectedDrug

        self.present(classBObject, animated:true, completion:nil)
        print("Local Notification :: ", response)
    }

}
