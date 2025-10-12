//
//  DrugHomeViewController.swift
//  CareMate
//
//  Created by MAC on 18/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//


import Foundation
import UIKit
import PopupDialog
class reportRequestsViewController: BaseViewController, DataPickerPopupDelegate {
    func timeDidAdded(day: Int, month: Int, year: Int) {
//        if To == true
//        {
//            labelDateTo.text = "\(day)/\(month)/\(year)"
//            dateTo = "\(day)/\(month)/\(year)"
//            getdata(DateTo: dateTo, DateFrom: dateFrom)
//            
//        }
//        else
//        {
//            labelDateFrom.text = "\(day)/\(month)/\(year)"
//            dateFrom = "\(day)/\(month)/\(year)"
//            getdata(DateTo: dateTo, DateFrom: dateFrom)
//
//
//        }
    }
    
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var labelFilter: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var plusCliked: UIView!
    @IBOutlet weak var labelHint: UILabel!
    


    var To = false
    var patientId = ""
    var branchId = ""
    var dateTo = "18/08/2020"
    var dateFrom = "18/08/2020"

    var listOfReportRequest = [ReportRequestsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "التقارير" :"Reports", hideBack: false)

        let gestureReports = UITapGestureRecognizer(target: self, action:  #selector(plusClikedFunc))
        self.plusCliked.addGestureRecognizer(gestureReports)
        
        labelFilter.text =   UserManager.isArabic ? "فلتر البحث" : "Filter"
        let gestureopenopenOperationCliked = UITapGestureRecognizer(target: self, action:  #selector(self.openFilter))
        self.viewFilter.addGestureRecognizer(gestureopenopenOperationCliked)
        if UserManager.isArabic {
            labelHint.text = "إضافة طلب تقرير طبي"
        }
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listOfReportRequest.removeAll()
        setup()
    }
    
    
   
    
    @objc func plusClikedFunc(sender : UITapGestureRecognizer) {
//        let vc1:SaveViewController = SaveViewController()
//        self.navigationController?.pushViewController(vc1, animated: true)
//        let vc1:SaveCompliansViewController = SaveCompliansViewController(VisitId: listOfReportRequest[0].VISIT_ID)
//        self.navigationController?.pushViewController(vc1, animated: true)
        
        let vc:VisitsViewController = VisitsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
    init(patientId: String,branchId:String) {
        super.init(nibName: "reportRequestsViewController", bundle: nil)
        self.patientId = patientId
        self.branchId = branchId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func openSave(sender : UITapGestureRecognizer) {
        let vc1:SaveViewController = SaveViewController()
        vc1.hospID = self.branchId
        self.navigationController?.pushViewController(vc1, animated: true)
    }
    @objc func DateForm()
    {
        let vc:DatePickerPopUpVC =   DatePickerPopUpVC()
        vc.delegate = self
        To = false
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  tapGestureDismissal: true)
        self.present(popup, animated: true, completion: nil)
    }
    @objc func DateTo()
    {
        let vc:DatePickerPopUpVC =   DatePickerPopUpVC()
        vc.delegate = self
        To = true

        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  tapGestureDismissal: true)
        self.present(popup, animated: true, completion: nil)
    }

    @objc func openFilter(sender : UITapGestureRecognizer) {
//        listOfFilterStatues.removeAll()
//        listOfFilterStatues.append(labStatuesModel(ID: "R", NAME_AR: "تم الطلب", NAME_EN: "For Sampling"))
//        listOfFilterStatues.append(labStatuesModel(ID: "F", NAME_AR: "تم التأكيد", NAME_EN: "Confirmed"))
//        listOfFilterStatues.append(labStatuesModel(ID: "W", NAME_AR: "تحتاج موافقة", NAME_EN: "Wait for Approval"))
//        listOfFilterStatues.append(labStatuesModel(ID: "P", NAME_AR: "تمت الموافقة", NAME_EN: "Approved"))
//        listOfFilterStatues.append(labStatuesModel(ID: "I", NAME_AR: "تم تسليم العينة (للكميائي)", NAME_EN: "Sample received (lab. doctor)"))
        
        let vc  = FilterLabRadViewController()
        vc.hideViewStatus = true
//        vc.listOfFilterStatues = listOfFilterStatues
        vc.delegte = self
//        self.navigationController?.pushViewController(vc, animated: true)
        AppPopUpHandler.instance.openVCPop(vc, height: 500, bottomSheet: true)
//        AppPopUpHandler.instance.openPopup(container: self, vc: vc)
        
//        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: UserManager.isArabic ?  listOfFilterStatues.map{$0.NAME_AR} : listOfFilterStatues.map{$0.NAME_EN} , title: "Choose", type: "")
    }
}

extension reportRequestsViewController :labRadFilter{
    
    func labRadFilterProtocal(statusName: String, Statues: String?, DATE_FROM_STR_FORMATED: String?, DATE_TO_STR_FORMATED: String?) {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd/MM/yyyy"
//
//        labelDateFrom.text = formatter3.string(from: Date())
//        labelDateTo.text = formatter3.string(from: Date())

        dateTo = formatter3.string(from: Date())
        dateFrom = formatter3.string(from: Date())

        getdata(DateTo: DATE_TO_STR_FORMATED?.ConvertToDate.asStringDMYEN ?? dateTo, DateFrom: DATE_FROM_STR_FORMATED?.ConvertToDate.asStringDMYEN ?? dateFrom)
    }
    
    
}
