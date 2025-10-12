//
//  CurrentMedVC.swift
//  CareMate
//
//  Created by khabeer on 11/27/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import UIKit
import MZFormSheetController
protocol popToDoseHome{
    func popToDoseHome()
}

class MedicationOnPatientViewControoler: BaseViewController {

    var getCurrentMedDTOList = [getCurrentMedDTO]()
    @IBOutlet weak var tabelviewList: UITableView!
    var delegate:popToDoseHome?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "الادوية الحالية" : "Current Drugs", hideBack: false)
        let urlString = Constants.APIProvider.getCurrentMed+"pat_id=\(Utilities.sharedInstance.getPatientId())"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            print(data as! [String:AnyObject])
            
            if error == nil
            {
                
                if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["PATIENT"] as? [String:AnyObject]
                {
                    
                 
                    
                    if root["PATIENT_ROW"] is [[String:AnyObject]]
                    {
                        
                        let appoins = root["PATIENT_ROW"] as! [[String: AnyObject]]
                        for i in appoins
                        {
                            print(i)
                            self.getCurrentMedDTOList.append(getCurrentMedDTO(JSON: i)!)
                        }
                    }
                    else if root["PATIENT_ROW"] is [String:AnyObject]
                    {
                        self.getCurrentMedDTOList.append(getCurrentMedDTO(JSON:root["PATIENT_ROW"] as![String:AnyObject] )!)
                    }
                    
                }
                else
                {
                    //                    self.filteredData.removeAll()
                }
            }
            self.setup()

        }
        
     
    }
    
    
    func setup()  {
        let cellNib = UINib(nibName: "CurrentMedicationsTableViewCell", bundle: nil)
        tabelviewList.register(cellNib, forCellReuseIdentifier: "CurrentMedicationsTableViewCell")

        tabelviewList.delegate = self
        tabelviewList.dataSource = self
        tabelviewList.rowHeight = 95
        self.tabelviewList.reloadData()

    }
    
    

   

}
extension MedicationOnPatientViewControoler:UITableViewDelegate,UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let classBObject =  PickerDateViewController()
        

        classBObject.GEN_SERIAL_ITEM = getCurrentMedDTOList[indexPath.row].GEN_SERIAL_ITEM
        classBObject.selectedDrugName = getCurrentMedDTOList[indexPath.row].ITEMARNAME
        classBObject.selectedDrugNameEn = getCurrentMedDTOList[indexPath.row].ITEMENNAME
        classBObject.selectedDrugDoseNAme = getCurrentMedDTOList[indexPath.row].NOTES
        classBObject.selectedDrugDoseNAmeEn = getCurrentMedDTOList[indexPath.row].NOTES_EN
        classBObject.delegate = self
        let formSheet = MZFormSheetController.init(viewController: classBObject)
        formSheet.shouldDismissOnBackgroundViewTap = true
        formSheet.transitionStyle = .slideFromBottom
        formSheet.cornerRadius = 20
        formSheet.portraitTopInset = UIScreen.main.bounds.height * 0.45
        formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
        formSheet.present(animated: true, completionHandler: nil)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCurrentMedDTOList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell( withIdentifier: "CurrentMedicationsTableViewCell") as? CurrentMedicationsTableViewCell
        cell?.selectionStyle = .none
        cell?.configCell(getCurrentMed: getCurrentMedDTOList[indexPath.row])
        cell?.delegate = self
        return cell!
        
    }
    
    
    
}
extension MedicationOnPatientViewControoler:popToDoseHome{
    func popToDoseHome() {
        self.navigationController?.popViewController(animated: true)
        nc.post(name: Notification.Name("refreshAfterAddDose"), object: nil)
    }
    
    
    
    
}

extension MedicationOnPatientViewControoler: DrugCellDelegate {
    
    func addReminder(_ index: Int) {
        
    }
    
    func openImage(_ image: UIImageView) {
        OPEN_IMAGE_VIEW(imageView: image, vc: self)
    }
}
