//
//  RxOfPatientDetailsExtentsions.swift
//  CareMate
//
//  Created by MAC on 28/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

//
//  RxOfPatientExtension.swift
//  CareMate
//
//  Created by MAC on 28/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation
import UIKit
import MZFormSheetController
import RealmSwift

extension RXOfPatientDetails:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfDrugsRelatedTORX.count
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DRugsInRXCell", for: indexPath) as! DRugsInRXCell
        cell.configure(listOfDrugsRelatedTORX[indexPath.row])
        cell.index = indexPath.row
        cell.delegate = self
        return cell
        
    }
    
    
    func setup()  {
        let cellNib = UINib(nibName: "DRugsInRXCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "DRugsInRXCell")
    
        table.rowHeight = UITableViewAutomaticDimension

    }
    
    func getdata() {
        let urlString = Constants.APIProvider.getPatPrescHistoryItems+"MEDPLANCD=\(MEDPLANCD)&patient_id=\(Utilities.sharedInstance.getPatientId())&INDEX_TO=1000&INDEX_FROM=1&branch_id=1"
    //    let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil{
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["PRESC_ITEM"] as? [String:AnyObject]{
                    if root["PRESC_ITEM_ROW"] is [[String:AnyObject]]{
                    
                    let appoins = root["PRESC_ITEM_ROW"] as! [[String: AnyObject]]
                    for i in appoins{
                        print(i)
//                       if  i["APPROVE_NAME_EN"] as? String == ""
//                        {
                           self.listOfDrugsRelatedTORX.append(RxModelDetails(JSON: i)!)

//                       }
                        if  i["APPROVE_NAME_EN"] as? String == "Approved"
                            {
                                self.listOfDrugsRelatedTORXCountApproved.append(RxModelDetails(JSON: i)!)

                        }
                        
                    }
                    }
                    else if root["PRESC_ITEM_ROW"] is [String:AnyObject]{
                        
                       let dic = root["PRESC_ITEM_ROW"] as! [String: AnyObject]
                        
                       if  dic["APPROVE_NAME_EN"] as? String == "Approved"
                        {
                           
                           self.listOfDrugsRelatedTORXCountApproved.append(RxModelDetails(JSON:root["PRESC_ITEM_ROW"] as![String:AnyObject] )!)
                       }
//
                        self.listOfDrugsRelatedTORX.append(RxModelDetails(JSON:root["PRESC_ITEM_ROW"] as![String:AnyObject] )!)

                        
                        

                        
                    }
                     
                    self.itemCount.text = "\(self.listOfDrugsRelatedTORXCountApproved.count)"
                    self.table.delegate = self
                    self.table.dataSource = self
                    self.table.reloadData()
                }
                else
                 {
                }
            }
        }
    }
    

    
    
}
extension UIViewController
{

    open override  func awakeFromNib() {
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1346794665, green: 0.5977677703, blue: 0.5819112062, alpha: 1)
    }
}


extension RXOfPatientDetails: DrugCellDelegate {
    func addReminder(_ index: Int) {
        let model = listOfDrugsRelatedTORX[index]
        let realm = try! Realm()
//        let data = realm.objects(reminderDrug.self).toArray()
        let data = (realm.objects(reminderDrug.self).distinct(by: ["drugName"]).value(forKeyPath: "drugName") ) as?[String]
        for item in data ?? [] {
            if item ==  model.ITEM_NAME_AR {
                OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "هذا الدواء تم اضافته من قبل" : "This medicine added before")
                return
            }
        }
        let classBObject =  PickerDateViewController()
         classBObject.GEN_SERIAL_ITEM = model.GEN_SERIAL_ITEM
         classBObject.selectedDrugName = model.ITEM_NAME_AR
         classBObject.selectedDrugNameEn = model.ITEM_NAME_EN
         classBObject.selectedDrugDoseNAme = model.NOTES_AR
         classBObject.selectedDrugDoseNAmeEn = model.NOTES_EN
         classBObject.delegate = self
         let formSheet = MZFormSheetController.init(viewController: classBObject)
         formSheet.shouldDismissOnBackgroundViewTap = true
         formSheet.transitionStyle = .slideFromBottom
         formSheet.cornerRadius = 20
         formSheet.portraitTopInset = UIScreen.main.bounds.height * 0.45
         formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
         formSheet.present(animated: true, completionHandler: nil)
    }
    
    func openImage(_ image: UIImageView) {
        OPEN_IMAGE_VIEW(imageView: image, vc: self)
    }
}

func OPEN_IMAGE_VIEW(imageView: UIImageView, vc: UIViewController) {
    let imageInfo = JTSImageInfo()
    imageInfo.image = imageView.image
    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = imageView.superview;
    imageInfo.referenceContentMode = imageView.contentMode;
    imageInfo.referenceCornerRadius = imageView.layer.cornerRadius;
    
    let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode:.image, backgroundStyle: .scaled)
    
    imageViewer?.show(from: vc, transition: .fromOriginalPosition)
}

extension RXOfPatientDetails:popToDoseHome{
    
    func popToDoseHome() {
    }
}

class RealmHelper {
    static func saveObject<T:Object>(object: T) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    static func getObjects()->[reminderDrug] {
        let realm = try! Realm()
        let realmResults = realm.objects(reminderDrug.self)
        return Array(realmResults)

    }
    static func getObjects<T:Object>(filter:String)->[T] {
        let realm = try! Realm()
        let realmResults = realm.objects(T.self).filter(filter)
        return Array(realmResults)

    }
}
