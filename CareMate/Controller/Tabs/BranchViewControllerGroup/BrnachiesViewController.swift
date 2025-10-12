//
//  ClincViewController.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/11/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//


import UIKit
import PopupDialog
import DZNEmptyDataSet
import SCLAlertView
import MZFormSheetController

class BrnachiesViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var fromMedicalRecord = false
    
    
    var branches = [Branch]()
    var specialityFilterPopup: PopupDialog?
    var selectedBranch: Branch?
    var vcType:listOfOtherScreenTypeBrnach?
    var branchesDic: [[String: Any]]?
    var arrBranchDetailsDic = [[String: Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register("BranchCellforBooking")
        
        
        initHeader(isNotifcation: false, isLanguage: true, title: UserManager.isArabic ? "اختر الفرع" : "Choose Branch", hideBack: false)
//        loadData()
    }
    
    
    
    
    func loadData(){
        Branch.getOnlineAppointment() { onlineAppointments, branchesDic  in
            guard let onlineAppointments = onlineAppointments else {
                OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "خطأ في الاتصال" : "Error in connection") {
                    self.loadData()
                }
                return
                
            }
            self.branchesDic = branchesDic
            self.branches = onlineAppointments
            self.selectedBranch = self.branches[0]
            
            // Create a custom view controller
            let specialityFilter = SpecialityFilter(nibName: "SpecialityFilter", bundle: nil)
            //        specialityFilter.delegate = self
            // Create the dialog
            //            let popup = PopupDialog(viewController: specialityFilter, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: false)
            //            self.specialityFilterPopup = popup
            //            // Create first button
            //                let Cancelbutton = CancelButton(title: "CANCEL", height: 40, action: {
            ////                    NotificationCenter.default.post(name: NSNotification.Name("GoToHome"), object: nil)
            //                    popup.dismiss()
            //                })
            //            // Add buttons to dialog
            //            popup.addButtons([Cancelbutton])
            //            // Present dialog
            //            self.present(popup, animated: true, completion: nil)
            self.tableView.reloadData()
        }
    }
    
    
    //    @objc override func showLanguage ()
    //    {
    //
    //        let alertView = SCLAlertView()
    //        alertView.addButton("English") {
    //            alertView.dismissAnimated()
    //            UserManager.language = "en"
    //            self.GoToHomeView()
    //        }
    //        alertView.addButton("Arabic") {
    //            alertView.dismissAnimated()
    //            UserManager.language = "ar"
    //            self.GoToHomeView()
    //        }
    //        alertView.showTitle("Note", subTitle:  "Choose language ", style: .notice, timeout: nil, colorStyle: 0x3788B0, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
    //    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        nc.post(name: Notification.Name("showBack"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if sucessResrve {
            self.tabBarController?.selectedIndex = 0
            sucessResrve = false
            return
        }
        tabBarController?.tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let defaults = UserDefaults.standard
        
        if fromMedicalRecord == false
        {
            if  defaults.bool(forKey: "loginOrNO") ==  true
            {
                //             self.navigationController?.navigationBar.isHidden = true
                nc.post(name: Notification.Name("hideBack"), object: nil)
                
                
                
            }
            else
            {
                
                nc.post(name: Notification.Name("hideBack"), object: nil)
                
                
                //             self.navigationController?.navigationBar.isHidden = false
                
            }
        }
        else
        {
            
            //           self.navigationController?.navigationBar.isHidden = false
            nc.post(name: Notification.Name("showBack"), object: nil)
            
            
        }
        
        //
        //       UIView.appearance().semanticContentAttribute = !UserManager.isArabic ? .forceLeftToRight : .forceRightToLeft
        
        self.tabBarController?.title = UserManager.isArabic ? "الحجز" : "Reservation"
        loadData()
//        if !isFromOrder
//        {
//            Branch.getOnlineAppointment() { onlineAppointments in
//                guard let onlineAppointments = onlineAppointments else {
//                    return
//                    
//                }
//                self.branches = onlineAppointments
//                self.selectedBranch = self.branches[0]
//                
//                // Create a custom view controller
//                let specialityFilter = SpecialityFilter(nibName: "SpecialityFilter", bundle: nil)
//                //           specialityFilter.delegate = self
//                // Create the dialog
//                //            let popup = PopupDialog(viewController: specialityFilter, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: false)
//                //            self.specialityFilterPopup = popup
//                //            // Create first button
//                //                let Cancelbutton = CancelButton(title: "CANCEL", height: 40, action: {
//                ////                    NotificationCenter.default.post(name: NSNotification.Name("GoToHome"), object: nil)
//                //                    popup.dismiss()
//                //                })
//                //            // Add buttons to dialog
//                //            popup.addButtons([Cancelbutton])
//                //            // Present dialog
//                //            self.present(popup, animated: true, completion: nil)
//                //            self.tableView.reloadData()
//            }
//        }
    }
    
    
    
}

extension BrnachiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branches.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BranchCellforBooking", for: indexPath) as! BranchCellforBooking
        cell.configCell(branch: branches[indexPath.row])
//        if indexPath.row == 1 {
//            cell.imageViewBranch.image = UIImage.init(named: "IMG-20220425-WA0122 (1)")
//        } else {
//            cell.imageViewBranch.image = UIImage.init(named: "Al-Salam-Hospital (1)")
//        }
        return cell
    }
    
}

extension BrnachiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBranch = branches[indexPath.row]
        if vcType == .fromReservation {
            if let branch = hasChild(branchesDic?[indexPath.row]) {
                let vc = SpecialityFilter()
                vc.selectedBranch = branch
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
//                let vc = SpecialityFilter()
//                vc.selectedBranch = selectedBranch
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if vcType == .fromOUrLocation {
            if indexPath.row == 0 {
                openMap(lat: 29.36945, lng: 48.008099)
            } else if indexPath.row == 1 {
                openMap(lat: 29.368741, lng: 48.009607)
            } else {
                openMap(lat: 29.147021, lng: 48.113566)
            }
        } else {
            UserDefaults.standard.set(branches[indexPath.row].id, forKey: "branchIdOForEmer") //setObject
            self.mz_dismissFormSheetController(animated: true, completionHandler: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func hasChild(_ selectedBrachDic: [String: Any]?) -> Branch? {
//        var branch = Branch()
        arrBranchDetailsDic.removeAll()
        if let selectedBrachDic = selectedBrachDic {
            if selectedBrachDic["BRANCH_TYPE"] as? String ?? "" == "2" {
                if selectedBrachDic["CLINIC_GROUPS"] is [String: Any] {
                    if (selectedBrachDic["CLINIC_GROUPS"] as? [String: Any])?["CLINIC_GROUPS_ROW"] is [[String: Any]] {
                        arrBranchDetailsDic = (selectedBrachDic["CLINIC_GROUPS"] as? [String: Any])?["CLINIC_GROUPS_ROW"] as? [[String: Any]] ?? [[:]]
                        if arrBranchDetailsDic.count > 0 {
                            let arr = arrBranchDetailsDic.map({UserManager.isArabic ? $0["NAME_AR"] as? String ?? "" : $0["NAME_EN"] as? String ?? ""})
                            AppPopUpHandler.instance.initListPopup(container: self, arrayNames: arr, title: "", type: "branches")
                            return nil
                        }
                    } else if (selectedBrachDic["CLINIC_GROUPS"] as? [String: Any])?["CLINIC_GROUPS_ROW"] is [String: Any] {
                        if let model = (selectedBrachDic["CLINIC_GROUPS"] as? [String: Any])?["CLINIC_GROUPS_ROW"] as? [String: Any] {
//                            branch.id = model["ID"] as? String ?? ""
//                            branch.arabicName = model["NAME_AR"] as? String ?? ""
//                            branch.englishName = model["NAME_EN"] as? String ?? ""
//                            branch.BRANCH_TYPE = model["BRANCH_TYPE"] as? String ?? ""
//                            return branch
                            arrBranchDetailsDic.append(model)
                            let arr = arrBranchDetailsDic.map({UserManager.isArabic ? $0["NAME_AR"] as? String ?? "" : $0["NAME_EN"] as? String ?? ""})
                            AppPopUpHandler.instance.initListPopup(container: self, arrayNames: arr, title: "", type: "branches")
                            return nil
                        }
                    }
                }
            }
        }
        return selectedBranch
    }
    
    func openMap(lat:Double,lng:Double) {
        let latitude = lat
        let longitude = lng
        let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
        let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
        
        let googleItem = ("Google Map", URL(string:googleURL)!)
        let wazeItem = ("Waze", URL(string:wazeURL)!)
        var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
        
        if UIApplication.shared.canOpenURL(googleItem.1) {
            installedNavigationApps.append(googleItem)
        }
        
        if UIApplication.shared.canOpenURL(wazeItem.1) {
            installedNavigationApps.append(wazeItem)
        }
        
        let alert = UIAlertController(title: "Selection", message: "Select Navigation App", preferredStyle: .actionSheet)
        for app in installedNavigationApps {
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
}

//extension BrnachiesViewController: SpecialityFilterDelegate {
// func specialityFilter(_ specialityFilter: SpecialityFilter, didSelectSpeciality speciality: Speciality) {
//   specialityFilterPopup?.dismiss()
//     self.mz_dismissFormSheetController(animated: true, completionHandler: nil)
//   let doctorsVC = self.storyboard?.instantiateViewController(withIdentifier: "DoctorsViewController") as! DoctorsViewController
//   doctorsVC.branchId = selectedBranch?.id
//   doctorsVC.branch = selectedBranch!
//   doctorsVC.specialityId = speciality.id
//   isReschedule = false
//   self.navigationController?.pushViewController(doctorsVC, animated: true)
// }
//}


extension BrnachiesViewController: ListPopupDelegate {
    
    func listPopupDidSelect(index: Int, type: String) {
        if type == "branches" {
            let model = arrBranchDetailsDic[index] as [String: Any]
            var branch = Branch()
            branch.id = model["ID"] as? String ?? ""
            branch.arabicName = model["NAME_AR"] as? String ?? ""
            branch.englishName = model["NAME_EN"] as? String ?? ""
            branch.BRANCH_TYPE = model["BRANCH_TYPE"] as? String ?? ""
            let vc = SpecialityFilter()
            vc.selectedBranch = branch
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
