//
//  doseTimes.swift
//  CareMate
//
//  Created by khabeer on 11/25/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import UIKit
import RealmSwift
import MZFormSheetController

class DoseTimesViewController: BaseViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var labelDrugName: UILabel!
    @IBOutlet weak var labelLastTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelPeriod: UILabel!
    @IBOutlet weak var viewLastTaken: UIView!
    @IBOutlet weak var viewTake: UIView!
    @IBOutlet weak var viewSchedule: UIView!
    @IBOutlet weak var viewStop: UIView!
    @IBOutlet weak var labelLastTakenTitle: UILabel!
    @IBOutlet weak var labelDateTitl: UILabel!
    @IBOutlet weak var labelTimeTitle: UILabel!
    @IBOutlet weak var labelPeriodTitle: UILabel!
    @IBOutlet weak var labelTaken: UILabel!
    @IBOutlet weak var labelReschedule: UILabel!
    @IBOutlet weak var labelStop: UILabel!
    
    var selectedDrug:reminderDrug?
    var allTiemsWithThisDateName:[reminderDrug]?

    let realm = try! Realm()
    var delegate: takeRescudle!
    var delegatedelete: delete!
    var fromcalender = ""
    var drugName = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        drugDate.text = selectedDrug?.dateALL
//        drugDose.text = selectedDrug?.drugdose
        labelDrugName.text = selectedDrug?.drugName ?? ""
        viewLastTaken.isHidden = selectedDrug?.take ?? "" == "0"
        labelLastTime.text = selectedDrug?.take
        let timeArr = selectedDrug?.dateALL.components(separatedBy: " ")
        if timeArr?.count ?? 0 > 1 {
            labelDate.text = timeArr![0]
            labelTime.text = timeArr![1]
        }
        //labelPeriod.text = selectedDrug?.drugdose
//        FIX BY HAMDIIIIIIII ... 
        labelPeriod.text = UserManager.isArabic ? selectedDrug?.drugdose : selectedDrug?.drugdoseEn

        viewTake.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(takeCliked)))
        viewSchedule.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(schedleCliked)))
        viewStop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stopCliked)))
        if UserManager.isArabic {
            labelLastTakenTitle.text = "اخر مرة اخدت فيه الدواء"
            labelDateTitl.text = "اليوم"
            labelTimeTitle.text = "الوقت"
            labelPeriodTitle.text = "الجرعة"
            labelTaken.text = "اخذت الجرعة"
            labelReschedule.text = "اعادة الجدولة"
            labelStop.text = "اوقف الجرعة"
        }
    }
  
    
    
    @objc func schedleCliked() {
      
        
        let classBObject = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pickerviewUpdateNotifcation") as! pickerviewUpdateNotifcation
        //        classBObject.delegate = self
//        classBObject.GEN_SERIAL_ITEM = getCurrentMedDTOList[indexPath.row].GEN_SERIAL_ITEM
//        classBObject.selectedDrugName = getCurrentMedDTOList[indexPath.row].ITEMENNAME
        classBObject.selectedDrug = self.selectedDrug
        
        self.present(classBObject, animated:true, completion:nil)

        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.presentingViewController!.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        self.delegate?.reloadList()
        
    }


    @objc func takeCliked() {
        self.mz_dismissFormSheetController(animated: true, completionHandler: nil)

        try! realm.write {
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "HH:mm E, d MMM y"
            self.selectedDrug?.take = formatter3.string(from: Date())
//            self.presentingViewController!.dismiss(animated: true, completion: nil)

            self.dismiss(animated: true, completion: nil)
            self.delegate.reloadList()
            realm.add(selectedDrug!)

        }
    }
    
    @objc func stopCliked() {

        let refreshAlert = UIAlertController(title: "Stop", message: "Please Choose This Day Or All Days", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "STOP ALL", style: .default, handler: { (action: UIAlertAction!) in
             
            self.delegatedelete.reloadListallTiemsWithThisDateName(selected: self.allTiemsWithThisDateName!, fromcalender: self.fromcalender)
            self.dismiss(animated: true)
            self.mz_dismissFormSheetController(animated: true, completionHandler: nil)

        }))

        refreshAlert.addAction(UIAlertAction(title: "STOP This Day", style: .cancel, handler: { (action: UIAlertAction!) in
            self.delegatedelete.reloadList1(selected: self.selectedDrug!, fromcalender: self.fromcalender)
            self.dismiss(animated: true)
            self.mz_dismissFormSheetController(animated: true, completionHandler: nil)
        }))

        present(refreshAlert, animated: true, completion: nil)
        
    }
 
    @IBAction func skipCliked(_ sender: Any) {
        self.mz_dismissFormSheetController(animated: true, completionHandler: nil)

        self.delegatedelete.reloadList1(selected: self.selectedDrug!, fromcalender: fromcalender)

        do {
            let realm = try Realm()
            
            
//            self.presentingViewController!.dismiss(animated: true, completion: nil)

        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
       

    }
}

