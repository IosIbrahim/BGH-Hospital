//
//  schedleNotifcationCliked.swift
//  CareMate
//
//  Created by khabeer on 12/8/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import UIKit
import UserNotifications
class schedleNotifcationCliked: UIViewController,UNUserNotificationCenterDelegate {

    @IBOutlet weak var doseName: UILabel!
    @IBOutlet weak var drugName: UILabel!
    @IBOutlet weak var drugDate: UILabel!
    var notifcationIdendifier = ""
    var drugSelected :reminderDrug?
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

        doseName.text = drugSelected?.drugName
        drugName.text = drugSelected?.drugdose
        drugDate.text = drugSelected?.date

        print(notifcationIdendifier)
    }
    

    @IBAction func snoozeCliked(_ sender: Any) {
     
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        
        
        let dateFromString =  dateFormatter.date(from: notifcationIdendifier)
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let identifierForRequest = dateFormatter.string(from: dateFromString!)
        dateFormatter.dateFormat = "yyyy"
        let yaer = dateFormatter.string(from: dateFromString!)
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: dateFromString!)
        
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: dateFromString!)
        
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
            content.title = (drugSelected?.drugName)!
            content.body = drugSelected!.drugdose
           
            content.sound = UNNotificationSound.default()
            if #available(iOS 10.0, *) {
                
                print("year \(yaer) month \(month) day \(day) hour \(hour) min \(min) secnde\(second)" )
                //                let dateComponents = DateComponents(year: Int(yaer), month: Int(month),  hour: Int(hour), minute: Int(min) ,second: Int(second)! + 02,weekday:2)
                var dateComponents = DateComponents()
                
              
                dateComponents.minute = Int(min)! + 5 
                dateComponents.second = Int(second)
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
        self.dismiss(animated: true, completion: nil)

        
        
        //        self.dismissAnimated()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

}
extension schedleNotifcationCliked{
    
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound, .badge])
        
        
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    
    
    
}



