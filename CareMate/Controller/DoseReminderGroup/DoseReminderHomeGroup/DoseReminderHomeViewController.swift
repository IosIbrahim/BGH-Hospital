//
//  DoseReminderVC.swift
//  CareMate
//
//  Created by khabeer on 11/24/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//




import UIKit
import PopupDialog
import UserNotifications
import RealmSwift
import DZNEmptyDataSet



class DoseReminderHomeViewController: BaseViewController,UNUserNotificationCenterDelegate {

    var doseReminderPopup: PopupDialog?
    var ddd = [[Results<reminderDrug>]]()
    let realm = try! Realm()
    var dateCurrent = ""
    var day = ""
    var dateFromCalender = ""
    var getCurrentMedDTOList = [getCurrentMedDTO]()
    var re:reminderDrug?

    
    var valueMonth = 1
    var valueIndex = 1
    var datesInMonthList = [Date]()
    var selecteIndex = 0
    var selecteIndexPAth = 0
    var year: Int = Calendar.current.component(.year, from: Date())
    var selecteDate = ""
    let monthsEn = ["January","Febrary","March","April","May","June","July","August","September","October","November","December"]
    let monthsAr = ["يناير","فبراير","مارس","ابريل","مايو","يونيه","يوليو","اغسطس","سبتمبر","اكتوبر","نوفمبر","ديسمبر"]
 
    @IBOutlet weak var doseReminderTableView: UITableView!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var collectioViewSlotDays: UICollectionView!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minsBtn: UIButton!
    
    @IBOutlet weak var labelAddDoseReminder: UILabel!
    @IBOutlet weak var viewPlus: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "منبه الدواء" : "Dose Reminder", hideBack: false)
        self.doseReminderTableView.emptyDataSetSource = self
        self.doseReminderTableView.emptyDataSetDelegate = self
                if #available(iOS 10.0, *) {
                    let center = UNUserNotificationCenter.current()
                    center.getPendingNotificationRequests { (notifications) in
                        print("Countkaskas: \(notifications.count)")
                        
                        for item in notifications {
                            print("item.identifier")
                            print(item.identifier)
                            print("item.trigger")
                            print(item.trigger)
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
       
        if UserManager.isArabic {
            labelAddDoseReminder.text = "إضافة منبه دواء";
        }
    }
    @objc func openDoseReminder(sender : UITapGestureRecognizer) {
        let v1 = MedicationOnPatientViewControoler()
        self.navigationController?.pushViewController(v1, animated: true)
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataFound()
        self.ddd = []
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy/MM/dd"
        self.dateCurrent =   dateFormatterPrint.string(from: Date())

        self.dateFromCalender = dateFormatterPrint.string(from: Date())

        
        var allDays: Results<reminderDrug> = (realm.objects(reminderDrug.self))
        
        for item in allDays
                
        {
            print(item.drugName)
            print(item.allDate)

        }
        
        var categories: Results<reminderDrug> = (realm.objects(reminderDrug.self).filter("allDate = '\( self.dateCurrent)'"))
//
        print("categories")
        print(categories)


        let scope = (realm.objects(reminderDrug.self).distinct(by: ["date"]).filter("allDate = '\( self.dateCurrent)'").value(forKeyPath: "date") ) as?[String]
        

        print("scope")
        
        print(scope)
        for s in scope!{
            var categories1: Results<reminderDrug> = (categories.filter("date = '\(s)'"))
            self.ddd.append([categories1])

        }
      
        if ddd.count == 0 {
            initNotDataShape(200)
       //     viewNoDAtaIsHidden = false
            let nc = NotificationCenter.default
         //   nc.post(name: Notification.Name("nodataFound"), object: nil)
            nc.post(name: Notification.Name("changeErrorTitle"), object: nil)

        }
        else{
            initNotDataShape(200)

        }
        self.doseReminderTableView.reloadData()
        doseReminderTableView.delegate = self
        doseReminderTableView.dataSource = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound, .badge])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Local Notification :: ", response)
    }
    
    func setupView(){
        setMonth(value: valueMonth)
        plusBtn.setTitle("", for: .normal)
        minsBtn.setTitle("", for: .normal)
        setupcollectionView()
        openTermsConditions()
        nc.addObserver(self, selector: #selector(refreshAfterAddDose), name: Notification.Name("refreshAfterAddDose"), object: nil)
    }
    
    private func openTermsConditions() {
        let msg = UserManager.isArabic ? ConstantsData.termsDosAr:ConstantsData.termsDosEn
        OPEN_HINT_POPUP(container: self, message: msg,dismiss: false) {
            if self.ddd.isEmpty {
                  self.viewNoDAtaIsHidden = false
                  let nc = NotificationCenter.default
                  nc.post(name: Notification.Name("nodataFound"), object: nil)
            }
        }
    }
    
    @objc func refreshAfterAddDose(){
    
        self.ddd = []
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy/MM/dd"
        self.dateCurrent =   dateFormatterPrint.string(from: Date())
        self.dateFromCalender = dateFormatterPrint.string(from: Date())
        let allDays: Results<reminderDrug> = (realm.objects(reminderDrug.self))
        for item in allDays
                
        {
            print(item.drugName)
            print(item.allDate)
        }
        
        let categories: Results<reminderDrug> = (realm.objects(reminderDrug.self).filter("allDate = '\( self.dateCurrent)'"))
        print("categories")
        print(categories)
        let scope = (realm.objects(reminderDrug.self).distinct(by: ["date"]).filter("allDate = '\( self.dateCurrent)'").value(forKeyPath: "date") ) as?[String]
        print("scope")
        print(scope)
        for s in scope!{
            let categories1: Results<reminderDrug> = (categories.filter("date = '\(s)'"))
            self.ddd.append([categories1])
        }
        if ddd.count == 0 {
            initNotDataShape(200)
          //  viewNoDAtaIsHidden = false
            let nc = NotificationCenter.default
         //   nc.post(name: Notification.Name("nodataFound"), object: nil)
            nc.post(name: Notification.Name("changeErrorTitle"), object: nil)
        }
        else{
            initNotDataShape(200)

        }
        self.doseReminderTableView.reloadData()
        doseReminderTableView.delegate = self
        doseReminderTableView.dataSource = self
    }
    
    func setMonth(value:Int){
        let index = Calendar.current.component(.month, from: Date())
        labelMonth.text  =  "\(UserManager.isArabic ?  monthsAr[index - 1] :  monthsEn[index - 1]) \(year)"
        valueIndex = index
        let dateComponents = DateComponents(year: year, month: valueIndex)
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        let date34 = calendar.date(from: dateComponents)!
        let allDays = date34.getAllDays()
        print(allDays)
        datesInMonthList = allDays
        print("datesInMonthList")
        print(datesInMonthList)
        setupcollectionView()
        reloadTableView()
        let gestureCurrentMedVC = UITapGestureRecognizer(target: self, action:  #selector(self.openDoseReminder))
        self.viewPlus.addGestureRecognizer(gestureCurrentMedVC)
    }
    
    func reloadTableView(){
        for (index,item) in datesInMonthList.enumerated(){
            let dateFormatterYYYMMDD = DateFormatter()
            dateFormatterYYYMMDD.dateFormat = "dd/MM/yyyy"
            dateFormatterYYYMMDD.locale = Locale(identifier: "en_US_POSIX")
            let dayInYYYMMDDDateInCell = dateFormatterYYYMMDD.string(from: item)
            let dayInYYYMMDDCuurentDate = dateFormatterYYYMMDD.string(from: Date())
            if dayInYYYMMDDDateInCell == dayInYYYMMDDCuurentDate{
                selecteIndex = index
                selecteDate = dayInYYYMMDDCuurentDate
                break
            }
        }
        collectioViewSlotDays.reloadData()
        let indexPath = IndexPath(item: selecteIndex, section: 0)
//        self.collectioViewSlotDays.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
        
        if UserManager.isArabic{
            collectioViewSlotDays.layoutIfNeeded()
//            collectioViewSlotDays.transform = CGAffineTransform(scaleX: -1, y: 1)

            collectioViewSlotDays.semanticContentAttribute = .forceRightToLeft
            self.collectioViewSlotDays.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
//            collectioViewSlotDays.scrollToItem(at: indexPath, at: .right,animated: true)
        }
        else{
            collectioViewSlotDays.layoutIfNeeded()
            collectioViewSlotDays.semanticContentAttribute = .forceLeftToRight

            self.collectioViewSlotDays.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
        }

    }
    
    @IBAction func monthPlus(_ sender: Any) {
        selecteIndexPAth = -1
        selecteIndex = 0
        valueIndex += 1
        if valueIndex > 12 {
            year += 1
            valueIndex = 1
        }
        labelMonth.text  =  "\(UserManager.isArabic ? monthsAr[valueIndex - 1] : monthsEn[valueIndex - 1]) \(year)"
        let dateComponents = DateComponents(year: year, month: valueIndex)
        let calendar = Calendar.current
        let date34 = calendar.date(from: dateComponents)!
        let allDays = date34.getAllDays()
        datesInMonthList = allDays
        reloadTableView()
//        loadSlots()
        
       
    }
    @IBAction func monthMins(_ sender: Any) {
//        selecteIndexPAth = -1
//        selecteIndex = 0
//        valueIndex -= 1
//        if valueIndex < 1{
//            year -= 1
//            valueIndex = 12
//        }
//        labelMonth.text  =  "\(UserManager.isArabic ?   monthsAr[valueIndex - 1] :  monthsEn[valueIndex - 1]) \(year)"
//        
//       
//        let dateComponents = DateComponents(year: year, month: valueIndex)
//        let calendar = Calendar.current
//        let date34 = calendar.date(from: dateComponents)!
//        let allDays = date34.getAllDays()
//        datesInMonthList = allDays
//        reloadTableView()
        let now = Date()
            let calendar = Calendar.current
            let currentMonth = calendar.component(.month, from: now)
            let currentYear = calendar.component(.year, from: now)

            if year == currentYear && valueIndex <= currentMonth {
                return // prevent going back past current month
            }

            selecteIndexPAth = -1
            selecteIndex = 0
            valueIndex -= 1
            if valueIndex < 1 {
                year -= 1
                valueIndex = 12
            }

            labelMonth.text  =  "\(UserManager.isArabic ? monthsAr[valueIndex - 1] : monthsEn[valueIndex - 1]) \(year)"
            let dateComponents = DateComponents(year: year, month: valueIndex)
            let date34 = Calendar.current.date(from: dateComponents)!
            datesInMonthList = date34.getAllDays()
            reloadTableView()
    }
   

}
extension DoseReminderHomeViewController:UITableViewDelegate,UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ddd[section][0][0].date
   
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return  self.ddd.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classBObject = DoseTimesViewController()
        //        classBObject.delegate = self
        classBObject.selectedDrug = ddd[indexPath.section][0][indexPath.row]
        let model = ddd[indexPath.section][0][indexPath.row]
        classBObject.delegate = self
        classBObject.delegatedelete = self
        classBObject.fromcalender = self.dateFromCalender
  

        var allTiemsWithThisDateNameArr = [reminderDrug]()
        let allTiemsWithThisDateName: Results<reminderDrug> = (realm.objects(reminderDrug.self).filter("drugName = '\(  ddd[indexPath.section][0][indexPath.row].drugName)'"))
        for item in allTiemsWithThisDateName
        {
            allTiemsWithThisDateNameArr.append(item)
        }
        classBObject.allTiemsWithThisDateName = allTiemsWithThisDateNameArr
        
        AppPopUpHandler.instance.openVCPop(classBObject, height: 550, bottomSheet: true)
        
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.ddd[section][0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell( withIdentifier: "DoseTimesTableViewCell") as? DoseTimesTableViewCell
        cell?.selectionStyle = .none
        cell?.getCurrentMed.text = UserManager.isArabic ? ddd[indexPath.section][0][indexPath.row].drugName : ddd[indexPath.section][0][indexPath.row].drugNameEn

        cell?.ItemDose.text = UserManager.isArabic ?  ddd[indexPath.section][0][indexPath.row].drugdose : ddd[indexPath.section][0][indexPath.row].drugdoseEn
       if ddd[indexPath.section][0][indexPath.row].take == "0"{
        cell?.TakeImage.isHidden = true
        }
       else{
        cell?.TakeImage.isHidden = false

        }
        return cell!
        
    }
    
    func filterByDate(date:Date){
        print("KASKAS")
        print(date)
        self.ddd = []
        let scope = (realm.objects(reminderDrug.self).distinct(by: ["allDate"]).value(forKeyPath: "allDate") ) as?[String]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        dateFormatterGet.locale = Locale(identifier: "en")
        dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy/MM/dd"
        dateFormatterPrint.locale = Locale(identifier: "en")
        self.dateCurrent =   dateFormatterPrint.string(from: date)
        self.dateFromCalender = dateFormatterPrint.string(from: date)
        
        
        let dateFormatterPrintday = DateFormatter()
        dateFormatterPrintday.dateFormat = "dd"
        dateFormatterPrintday.locale = Locale(identifier: "en")
        self.day =   dateFormatterPrintday.string(from: date)
        
      

        
        self.ddd = []

        
        var categories: Results<reminderDrug> = (realm.objects(reminderDrug.self).filter("allDate = '\( self.dateCurrent)'"))
     
        
        var dates = (realm.objects(reminderDrug.self).distinct(by: ["date"]).filter("allDate = '\( self.dateCurrent)'").value(forKeyPath: "date") ) as?[String]
        
        print("categories")
        
        
        print(categories)
        
        
        print("dates")

        
        print(dates)
        for s in dates!
        {
            
            print("cateInFor")
            print(categories)
            
            
            var categories1: Results<reminderDrug> = (categories.filter("date = '\(s)'"))
            //
            self.ddd.append([categories1])
            
        }
        if ddd.count == 0 {
            initNotDataShape(200)
          //  viewNoDAtaIsHidden = false
            let nc = NotificationCenter.default
        //    nc.post(name: Notification.Name("nodataFound"), object: nil)
            nc.post(name: Notification.Name("changeErrorTitle"), object: nil)

        }
        else{
            initNotDataShape(200)

        }
        self.doseReminderTableView.reloadData()

    }
    
    
    
    
}
extension DoseReminderHomeViewController:FSCalendarDelegate
{

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
      

    }
    
    
    
}

extension DoseReminderHomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // ===============================================
    // ==== DZNEmptyDataSet Delegate & Datasource ====
    // ===============================================
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return ddd.count == 0
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "results")
    }
    
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "transform")
        
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 0.0, 1.0))
        
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        
        return animation
    }
    
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text =  UserManager.isArabic ?  "لا يوجد أدوية في هذا الوقت" : "No questions found !"
//        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:Color.darkGray]
//        
//        return NSAttributedString(string: text, attributes: attributes)
//    }
}
extension DoseReminderHomeViewController:takeRescudle
{
    func reloadList() {
        
        
        
        doseReminderTableView.reloadData()
    }
    
    
}
extension DoseReminderHomeViewController:delete
{
    func reloadListallTiemsWithThisDateName(selected: [reminderDrug], fromcalender: String) {
        do {
            
            for item in selected
            {
                try! realm.write {
                    
                    realm.delete(item)
                    
                }
            }
           
          
                self.ddd = []
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
                dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as! TimeZone
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "yyyy/MM/dd"
                self.dateCurrent =   fromcalender
//            let center = UNUserNotificationCenter.current()
//
//            center.removeAllPendingNotificationRequests()

                
                var categories: Results<reminderDrug> = (realm.objects(reminderDrug.self).filter("allDate = '\( self.dateCurrent)'"))
                //
                print("categories")
                print(categories)
                //
                //        if !categories.isEmpty
                //        {
                //            self.ddd.append(categories)
                //
                //        }
                //        self.doseReminderTableView.reloadData()

                let scope = (realm.objects(reminderDrug.self).distinct(by: ["date"]).filter("allDate = '\( self.dateCurrent)'").value(forKeyPath: "date") ) as?[String]


                print("scope")

                print(scope)
                for s in scope!
                {

                    print("cateInFor")
                    print(categories)


                    var categories1: Results<reminderDrug> = (realm.objects(reminderDrug.self).filter("allDate = '\( self.dateCurrent)'").filter("date = '\(s)'"))
                    //
                    self.ddd.append([categories1])

                }
            
            print(self.ddd)

            
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
        if ddd.count == 0 {
            initNotDataShape(200)
      //      viewNoDAtaIsHidden = false
            let nc = NotificationCenter.default
         //   nc.post(name: Notification.Name("nodataFound"), object: nil)
            nc.post(name: Notification.Name("changeErrorTitle"), object: nil)

        }
        else{
            initNotDataShape(200)

        }
        doseReminderTableView.reloadData()
        
    }
    func reloadList1(selected: reminderDrug,fromcalender: String) {
      
        var day = ""
        do {
            try! realm.write {
                
                realm.delete(selected)
                
            }
          
                self.ddd = []
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
                dateFormatterGet.timeZone = NSTimeZone(name: "UTC") as! TimeZone
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "yyyy/MM/dd"

            
              


                self.dateCurrent =   fromcalender
                
//            let center = UNUserNotificationCenter.current()
//            
//            center.removePendingNotificationRequests(withIdentifiers: ["\(selected.drugName)\(self.day)"])
                
                var categories: Results<reminderDrug> = (realm.objects(reminderDrug.self).filter("allDate = '\( self.dateCurrent)'"))
                //
                print("categories")
                print(categories)
                //
                //        if !categories.isEmpty
                //        {
                //            self.ddd.append(categories)
                //
                //        }
                //        self.doseReminderTableView.reloadData()

                let scope = (realm.objects(reminderDrug.self).distinct(by: ["date"]).filter("allDate = '\( self.dateCurrent)'").value(forKeyPath: "date") ) as?[String]


                print("scope")

                print(scope)
                for s in scope!
                {

                    print("cateInFor")
                    print(categories)


                    var categories1: Results<reminderDrug> = (realm.objects(reminderDrug.self).filter("allDate = '\( self.dateCurrent)'").filter("date = '\(s)'"))
                    //
                    self.ddd.append([categories1])

                }
            
            print(self.ddd)

            
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
        if ddd.count == 0 {
            initNotDataShape(200)
        //    viewNoDAtaIsHidden = false
            let nc = NotificationCenter.default
         //   nc.post(name: Notification.Name("nodataFound"), object: nil)
            nc.post(name: Notification.Name("changeErrorTitle"), object: nil)

        }
        else{
            initNotDataShape(200)

        }
    
        doseReminderTableView.reloadData()

      
    }
    
    
}
