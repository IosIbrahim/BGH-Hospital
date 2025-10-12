//
//  FilterLabRadViewController.swift
//  CareMate
//
//  Created by Khabber on 17/07/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit
import MZFormSheetController

class FilterLabRadViewController: BaseViewController {
    @IBOutlet weak var viewFilterDate: UIView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewFilterCliked: UIView!
    @IBOutlet weak var viewCancelCliked: UIView!
    @IBOutlet weak var statuesLAbel: UILabel!
    
    @IBOutlet weak var toLAbel: UILabel!

    @IBOutlet weak var viewFrom: UIView!
    @IBOutlet weak var viewTo: UIView!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var labelFilter: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelPeriod: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    
    var listOfFilterStatues = [labStatuesModel]()
    var delegte : labRadFilter?
    var statues = ""
    var DATE_FROM_STR_FORMATED = ""
    var DATE_TO_STR_FORMATED = ""
    var fromOpened = false
    var hideViewStatus = false

    override func viewWillDisappear(_ animated: Bool) {
                listOfFilterStatues.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "تصفيه" : "Filter", hideBack: false)

        let gestureopenopenOperationCliked = UITapGestureRecognizer(target: self, action:  #selector(self.openFilter))
        self.viewFilter.addGestureRecognizer(gestureopenopenOperationCliked)
        
        
//        let viewFilterDateCliked = UITapGestureRecognizer(target: self, action:  #selector(self.openFilterDate))
//        self.viewFilterDate.addGestureRecognizer(viewFilterDateCliked)
        
        
        let viewFilterDateCliked1 = UITapGestureRecognizer(target: self, action:  #selector(self.filterIfCl))
        self.viewFilterCliked.addGestureRecognizer(viewFilterDateCliked1)
        
        let viewCancel = UITapGestureRecognizer(target: self, action:  #selector(self.cancel))
        self.viewCancelCliked.addGestureRecognizer(viewCancel)
        
        viewFrom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openFrom)))
        viewTo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTo)))
        btnFilter.layer.cornerRadius = 11
        btnCancel.layer.cornerRadius = 11
        if UserManager.isArabic {
            labelFilter.text = "تصفية"
            labelStatus.text = "الحالة"
            statuesLAbel.text = "تصفية"
            labelPeriod.text = "المدة"
            labelFrom.text = "من"
            toLAbel.text = "الي"
            btnFilter.setTitle("تصفية", for: .normal)
            btnCancel.setTitle("الغاء", for: .normal)
        }
        viewStatus.isHidden = hideViewStatus
    }
    
    @objc func openFrom() {
        let vc = DatePickerPopUpVC()
        vc.delegate = self
        fromOpened = true
        AppPopUpHandler.instance.openPopup(container: self, vc: vc)
    }
    
    @objc func openTo() {
        let vc = DatePickerPopUpVC()
        vc.delegate = self
        fromOpened = false
        AppPopUpHandler.instance.openPopup(container: self, vc: vc)
    }
    
    @objc func filterIfCl(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
        mz_dismissFormSheetController(animated: true) { _ in
            self.delegte?.labRadFilterProtocal(statusName: self.statues == "" ? "" : self.statuesLAbel.text!, Statues: self.statues, DATE_FROM_STR_FORMATED: self.DATE_FROM_STR_FORMATED, DATE_TO_STR_FORMATED: self.DATE_TO_STR_FORMATED)
        }
    }
    @objc func cancel(sender : UITapGestureRecognizer) {
        statues = ""
        mz_dismissFormSheetController(animated: true) { _ in
            self.delegte?.labRadFilterProtocal(statusName: "", Statues: self.statues, DATE_FROM_STR_FORMATED: self.DATE_FROM_STR_FORMATED, DATE_TO_STR_FORMATED: self.DATE_TO_STR_FORMATED)
        }
    }
    
    @objc func openFilter(sender : UITapGestureRecognizer) {
//        let vc  = FilterLabRadViewController()
//        AppPopUpHandler.instance.openVCPop(vc, height: 400)

        var arr = UserManager.isArabic ?  listOfFilterStatues.map{$0.NAME_AR} : listOfFilterStatues.map{$0.NAME_EN}
        arr.insert(UserManager.isArabic ? "كل الحالات" : "All Requests", at: 0)
        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: arr, title: "Choose", type: "")
    }
   

}
extension FilterLabRadViewController :ListPopupDelegate{
    
    func listPopupDidSelect(index: Int, type: String) {
        if index == 0 {
            statuesLAbel.text = UserManager.isArabic ? "كل الحالات" : "All Requests"
        } else {
            statues = listOfFilterStatues[index].ID
            statuesLAbel.text = UserManager.isArabic ? listOfFilterStatues[index].NAME_AR
            :listOfFilterStatues[index].NAME_EN
        }
    }
}

extension FilterLabRadViewController: DataPickerPopupDelegate {
    
    func timeDidAdded(day: Int, month: Int, year: Int) {
        print("asdasdsa")
        var day = "\(day)"
        if Int(day)! < 10 {
            day = "0\(day)"
        }
        var month = "\(month)"
        if Int(month)! < 10 {
            month = "0\(month)"
        }
        if fromOpened {
            labelFrom.text = "\(day)-\(month)-\(year)"
            DATE_FROM_STR_FORMATED = "\(labelFrom.text!) 00:00:00"
        } else {
            toLAbel.text = "\(day)-\(month)-\(year)"
            DATE_TO_STR_FORMATED = "\(toLAbel.text!) 00:00:00"
        }
    }
    
    func returnDate(date: Date) {
        print("asdasdsa")
    }
}
