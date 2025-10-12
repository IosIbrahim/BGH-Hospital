//
//  pickerDateVC.swift
//  CareMate
//
//  Created by khabeer on 11/27/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class PickerDateViewController: UIViewController,UNUserNotificationCenterDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewOk: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var labelRescudle: UILabel!
    @IBOutlet weak var labelCancel: UILabel!
    @IBOutlet weak var labelOk: UILabel!
    
    var delegate:popToDoseHome?
    

    let weekDayNumbers = [
        "sunday": 1,
        "monday": 2,
        "tuesday": 3,
        "wednesday": 4,
        "thursday": 5,
        "friday": 6,
        "saturday": 7,
        ]
    var selectedDrugName = ""
    var selectedDrugNameEn = ""
    var selectedDrugDoseNAme = ""
    var selectedDrugDoseNAmeEn = ""
    var GEN_SERIAL_ITEM = ""
    var REMARKS = ""
    var ddd = [Results<reminderDrug>]()
    var datiesOFtommorow = [String]()
    
    var numberOfNotifcation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

      
        print(Date())
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatterGet.locale = Locale(identifier: "en")
        dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatterPrint.locale = Locale(identifier: "en")
        self.REMARKS = dateFormatterPrint.string(from: Date())
   
        self.datePicker?.backgroundColor = UIColor.red
        self.datePicker?.datePickerMode = UIDatePickerMode.dateAndTime
        self.datePicker?.layer.masksToBounds = true
        datePicker.center = view.center
       if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }

        let openOkCliked = UITapGestureRecognizer(target: self, action:  #selector(self.okCliked))
        self.viewOk.addGestureRecognizer(openOkCliked)
        let openCancelCliked = UITapGestureRecognizer(target: self, action:  #selector(closeCliked))
        self.viewCancel.addGestureRecognizer(openCancelCliked)
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        print(self.REMARKS)
      
        labelRescudle.text = UserManager.isArabic ? "جدولة الدواء" : "Medication Scheduling"
        if UserManager.isArabic {
            labelCancel.text = "الغاء"
            labelOk.text = "موافق"
        }
    }
    
    @objc func okCliked() {
        let urlString = Constants.APIProvider.schedule_items+"GEN_SERIAL_ITEM=\(GEN_SERIAL_ITEM)"+"&"+"REMARKS=\(REMARKS)"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            print(data as! [String:AnyObject])
            if error == nil {
                if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["ITEM_SCHEDULES"] as? [String:AnyObject] {
                    if root["ITEM_SCHEDULES_ROW"] is [[String:AnyObject]] {
                        let appoins = root["ITEM_SCHEDULES_ROW"] as! [[String: AnyObject]]
                        for i in appoins {
                            let reminderDrugObject = reminderDrug()
                            let reminderDrugCopyForLocalNotifcationObject = reminderDrugCopyForLocalNotifcation()
                            reminderDrugObject.date = self.parseDateTOHM(date: i["PLANNEDTIME"] as! String )
                            reminderDrugObject.drugName = self.selectedDrugName
                            reminderDrugObject.drugNameEn = self.selectedDrugNameEn
                            reminderDrugObject.drugdose = self.selectedDrugDoseNAme
                            reminderDrugObject.drugdoseEn = self.selectedDrugDoseNAmeEn
                            
                            reminderDrugObject.allDate = self.parseDateTODayDate(date: i["PLANNEDTIME"] as! String )
                            reminderDrugObject.take = "0"
                            reminderDrugObject.dateALL =  i["PLANNEDTIME"] as! String
                            reminderDrugCopyForLocalNotifcationObject.date = self.parseDateTOHM(date: i["PLANNEDTIME"] as! String )
                            //FIXED BY HAMDIIIIII .....
                            reminderDrugCopyForLocalNotifcationObject.drugName = if UserManager.isArabic { self.selectedDrugName
                            }else {
                                self.selectedDrugNameEn
                            }
                            reminderDrugCopyForLocalNotifcationObject.drugdose = if UserManager.isArabic { self.selectedDrugDoseNAme
                            }else {
                                self.selectedDrugDoseNAmeEn
                            }
                            
                            print("reminderDrugCopyForLocalNotifcation:: xxxx drugName" + reminderDrugCopyForLocalNotifcationObject.drugName)
                            print("reminderDrugCopyForLocalNotifcation:: xxxx drugdose" + reminderDrugCopyForLocalNotifcationObject.drugdose)
                            
                            
                            reminderDrugCopyForLocalNotifcationObject.allDate = self.parseDateTODayDate(date: i["PLANNEDTIME"] as! String )
                            reminderDrugCopyForLocalNotifcationObject.dateALL =  i["PLANNEDTIME"] as! String
                            reminderDrugCopyForLocalNotifcationObject.take = "0"
                            let realm = try! Realm()
                            try! realm.write {
                                self.registerNotifcatiom(fff:i["PLANNEDTIME"] as! String  , object: reminderDrugCopyForLocalNotifcationObject)
                                realm.add(reminderDrugObject)
                                realm.add(reminderDrugCopyForLocalNotifcationObject)
                            }
                        }
                    } else if root["ITEM_SCHEDULES_ROW"] is [String:AnyObject] {
                        let i = root["ITEM_SCHEDULES_ROW"] as! [String:AnyObject]
                        let reminderDrugObject = reminderDrug()
                        let reminderDrugCopyForLocalNotifcationObject = reminderDrugCopyForLocalNotifcation()
                        reminderDrugObject.date = self.parseDateTOHM(date: i["PLANNEDTIME"] as! String )
                        reminderDrugObject.drugName = self.selectedDrugName
                        reminderDrugObject.drugNameEn = self.selectedDrugNameEn
                        reminderDrugObject.drugdose = self.selectedDrugDoseNAme
                        reminderDrugObject.drugdoseEn = self.selectedDrugDoseNAmeEn
                        reminderDrugObject.allDate = self.parseDateTODayDate(date: i["PLANNEDTIME"] as! String )
                        reminderDrugObject.take = "0"
                        reminderDrugObject.dateALL =  i["PLANNEDTIME"] as! String
                        reminderDrugCopyForLocalNotifcationObject.date = self.parseDateTOHM(date: i["PLANNEDTIME"] as! String )
                        if UserManager.isArabic {
                            reminderDrugCopyForLocalNotifcationObject.drugName = self.selectedDrugName
                            reminderDrugCopyForLocalNotifcationObject.drugdose = self.selectedDrugDoseNAme
                        }else {
                            reminderDrugCopyForLocalNotifcationObject.drugName = self.selectedDrugNameEn
                            reminderDrugCopyForLocalNotifcationObject.drugdose = self.selectedDrugDoseNAmeEn
                        }
                        reminderDrugCopyForLocalNotifcationObject.drugName = self.selectedDrugName
                        reminderDrugCopyForLocalNotifcationObject.drugdose = self.selectedDrugDoseNAme
                        reminderDrugCopyForLocalNotifcationObject.allDate = self.parseDateTODayDate(date: i["PLANNEDTIME"] as! String )
                        reminderDrugCopyForLocalNotifcationObject.dateALL =  i["PLANNEDTIME"] as! String
                        reminderDrugCopyForLocalNotifcationObject.take = "0"
                        let realm = try! Realm()
                        try! realm.write {
                            self.registerNotifcatiom(fff:i["PLANNEDTIME"] as! String  , object: reminderDrugCopyForLocalNotifcationObject)
                            realm.add(reminderDrugObject)
                            realm.add(reminderDrugCopyForLocalNotifcationObject)
                        }
                    }
                    self.delegate?.popToDoseHome()
                    self.mz_dismissFormSheetController(animated: true, completionHandler: nil)
                } else {
                    if let root = (((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["MESSAGE"] as? [String:AnyObject])?["MESSAGE_ROW"] as? [String:AnyObject]  {
                        OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? root["NAME_AR"] as? String ?? "" : root["NAME_EN"] as? String ?? "")
                    } else {
                        OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "Error in connection" : "مشكلة في الاتصال")
                    }
                }
            } else {
                OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "Error in connection" : "مشكلة في الاتصال")
            }
        }
    }
    
    @objc func closeCliked() {
        
        self.mz_dismissFormSheetController(animated: true, completionHandler: nil)
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
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
            dateFormatterGet.locale = Locale(identifier: "en")
            dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as! TimeZone

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd/MM/yyyy HH:mm:ss"
            dateFormatterPrint.locale = Locale(identifier: "en")
            self.REMARKS = dateFormatterPrint.string(from: sender.date)

            
            


        }
    }

}
extension PickerDateViewController{
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                    let realm = try! Realm()
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatterGet.locale = Locale(identifier: "en")
        dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy/MM/dd"
        dateFormatterPrint.locale = Locale(identifier: "en")
      let currentDate =  dateFormatterPrint.string(from: Date())
        
      let notifcationDate =  notification.request.identifier
        

        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        let tomorrowYearMonthDay =  dateFormatterPrint.string(from: tomorrow!)

        
        print(tomorrowYearMonthDay)
        
        let drugs: Results<reminderDrugCopyForLocalNotifcation> = (realm.objects(reminderDrugCopyForLocalNotifcation.self))

    
      


        completionHandler([.alert, .sound, .badge])
        
        
        for drug in drugs
        {
            
            if drug.allDate == tomorrowYearMonthDay
            {
                
                self.registerNotifcatiom(dateFromnotifcation: drug.dateALL, object: drug)
            }
            
            
        }
        
            
        
        
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Local Notification :: ", response)
    }
    
//
    func parseDateTOHM(date:String) -> String {
     
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en")
        let date1 = dateFormatter.date(from:date)!
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm a"
        dateFormatterPrint.locale = Locale(identifier: "en")
       
        print( dateFormatterPrint.string(from: date1))
        return  dateFormatterPrint.string(from: date1)
    }
    func parseDateTODayDate(date:String) -> String {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en")
        let date1 = dateFormatter.date(from:date)!
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy/MM/dd"
        dateFormatterPrint.locale = Locale(identifier: "en")
        print( dateFormatterPrint.string(from: date1))
        return  dateFormatterPrint.string(from: date1)
    }

    
    
    func registerNotifcatiom(fff:String,object:reminderDrugCopyForLocalNotifcation)   {
        
//        Utilities.showAlert(messageToDisplay: "\(fff)")

    
        print("mostafa ios 01021333862\(fff)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone

        
            let dateFromString =  dateFormatter.date(from: fff)
        
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

    
        if date == currentDate
        {
            if #available(iOS 10.0, *) {
                let content = UNMutableNotificationContent()
                UNUserNotificationCenter.current().delegate = self
                content.title = object.drugName
                content.body = object.drugdose
                print("reminderDrugCopyForLocalNotifcation:: drugName" + object.drugName)
                print("reminderDrugCopyForLocalNotifcation:: drugdose" + object.drugdose)
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
                    let request = UNNotificationRequest(identifier: "\(fff)", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    
                } else {
                    // Fallback on earlier versions
                }
            } else {
                // Fallback on earlier versions
            }

            
        }




    }
    
    func registerNotifcatiom(dateFromnotifcation:String,object:reminderDrugCopyForLocalNotifcation)   {
        
        //        Utilities.showAlert(messageToDisplay: "\(fff)")
        
        
        print("mostafa ios 01021333862\(dateFromnotifcation)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        
        
        let dateFromString =  dateFormatter.date(from: dateFromnotifcation)
        
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
                content.title = object.drugName
                content.body = object.drugdose
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
                    let request = UNNotificationRequest(identifier: "\(dateFromnotifcation)", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    
                } else {
                    // Fallback on earlier versions
                }
            } else {
                // Fallback on earlier versions
            }
            
            
       
        
        
        
        
    }
    
}
