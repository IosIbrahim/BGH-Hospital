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
protocol takeRescudle {
    func reloadList()
}
protocol delete {
    func reloadList1(selected:reminderDrug,fromcalender:String)
    func reloadListallTiemsWithThisDateName(selected: [reminderDrug],fromcalender: String)
}
class doseTimes: BaseViewController {
    @IBOutlet weak var mainView: UIView!
    var selectedDrug:reminderDrug?
    var allTiemsWithThisDateName:[reminderDrug]?

    let realm = try! Realm()
    var delegate: takeRescudle!
    var delegatedelete: delete!
    var fromcalender = ""

    @IBOutlet weak var drugDose: UILabel!
    
    @IBOutlet weak var drugDate: UILabel!
    
    @IBOutlet weak var lastToken: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drugDate.text = selectedDrug?.dateALL
        drugDose.text = selectedDrug?.drugdose
        
    }
    
    
    @IBAction func schedleCliked(_ sender: Any) {
        
        mz_dismissFormSheetController(animated: true, completionHandler: nil)
        let classBObject = storyboard?.instantiateViewController(withIdentifier: "pickerviewUpdateNotifcation") as! pickerviewUpdateNotifcation
        //        classBObject.delegate = self
//        classBObject.GEN_SERIAL_ITEM = getCurrentMedDTOList[indexPath.row].GEN_SERIAL_ITEM
//        classBObject.selectedDrugName = getCurrentMedDTOList[indexPath.row].ITEMENNAME
        classBObject.selectedDrug = self.selectedDrug
        
        self.present(classBObject, animated:true, completion:nil)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
        self.delegate?.reloadList()
        
    }


    @IBAction func takeCliked(_ sender: Any) {
        mz_dismissFormSheetController(animated: true, completionHandler: nil)

        try! realm.write {
            self.selectedDrug?.take = "1"
            self.presentingViewController!.dismiss(animated: true, completion: nil)

            self.delegate.reloadList()
            realm.add(selectedDrug!)

        }
    }
    
    @IBAction func stopCliked(_ sender: Any) {
        mz_dismissFormSheetController(animated: true, completionHandler: nil)

        let refreshAlert = UIAlertController(title: "Stop", message: "Please Choose This Day Or All Days", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "STOP ALL", style: .default, handler: { (action: UIAlertAction!) in
             
            self.delegatedelete.reloadListallTiemsWithThisDateName(selected: self.allTiemsWithThisDateName!, fromcalender: self.fromcalender)

            self.dismiss(animated: true)
            self.dismiss(animated: true)
        }))

        refreshAlert.addAction(UIAlertAction(title: "STOP This Day", style: .cancel, handler: { (action: UIAlertAction!) in
            self.delegatedelete.reloadList1(selected: self.selectedDrug!, fromcalender: self.fromcalender)
            self.dismiss(animated: true)
            self.dismiss(animated: true)


        }))

        present(refreshAlert, animated: true, completion: nil)
        
    }
 
    @IBAction func skipCliked(_ sender: Any) {
        mz_dismissFormSheetController(animated: true, completionHandler: nil)

        self.delegatedelete.reloadList1(selected: self.selectedDrug!, fromcalender: fromcalender)

        do {
            let realm = try Realm()
            
            
            self.presentingViewController!.dismiss(animated: true, completion: nil)

        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
       

    }
}
