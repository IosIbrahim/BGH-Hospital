//
//  PatientHistoryViewController.swift
//  CareMate
//
//  Created by MAC on 30/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class OperationViewController: BaseViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var uiviewOperation: UIView!
    @IBOutlet weak var uiviewEndoscopies: UIView!
    @IBOutlet weak var uiviewCatheter: UIView!
    
    @IBOutlet weak var uilabelOperation: UILabel!
    @IBOutlet weak var uilabelEndoscopies: UILabel!
    @IBOutlet weak var uilabelCatheter: UILabel!




    var patientId = ""
    var branchId = ""
    var type = ""
    var listOfOperation = [operationDTO]()
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserManager.isArabic{
            uilabelOperation.text = "العمليات"
            uilabelEndoscopies.text = "المناظير"
            uilabelCatheter.text = "القسطره"
        }
        else{
            uilabelOperation.text = "Operations"
            uilabelEndoscopies.text = "Endoscopies"
            uilabelCatheter.text = "Catheter"
        }
        
      
            initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "العمليات" : "Operations", hideBack: false)
        setup()
        getdata()
        uiviewOperation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(operationCliked)))
        uiviewEndoscopies.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endoscopiesCliked)))
        uiviewCatheter.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(catheterCliked)))
        
    }

    @objc func operationCliked(){
        uiviewOperation.backgroundColor = #colorLiteral(red: 0, green: 0.6705882353, blue: 0.7843137255, alpha: 1)
        uiviewEndoscopies.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        uiviewCatheter.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        uilabelOperation.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        uilabelCatheter.textColor = #colorLiteral(red: 0.8039215686, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
        uilabelEndoscopies.textColor = #colorLiteral(red: 0.8039215686, green: 0.7882352941, blue: 0.7882352941, alpha: 1)

        Title = UserManager.isArabic ? "العمليات": "Operations"
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("changeTile"), object: nil)

        type = "1"
        getdata()


        
    }
    @objc func endoscopiesCliked(){
        uiviewOperation.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        uiviewEndoscopies.backgroundColor = #colorLiteral(red: 0, green: 0.6705882353, blue: 0.7843137255, alpha: 1)
        uiviewCatheter.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        uilabelOperation.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        uilabelCatheter.textColor = #colorLiteral(red: 0.8039215686, green: 0.7882352941, blue: 0.7882352941, alpha: 1)
        uilabelEndoscopies.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        type = "2"
        getdata()
        
        Title = UserManager.isArabic ?  "المناظير": "Endoscopies"
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("changeTile"), object: nil)
        
    }
    @objc func catheterCliked(){
        uiviewOperation.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        uiviewEndoscopies.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        uiviewCatheter.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.6039215686, blue: 0.5490196078, alpha: 1)
        uilabelOperation.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        uilabelCatheter.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        uilabelEndoscopies.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        type = "3"
        getdata()
        Title = UserManager.isArabic ?  "القسطره": "Catheter"
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("changeTile"), object: nil)
    }
    
    init(patientId: String,branchId:String,Type:String) {
        super.init(nibName: "OperationViewController", bundle: nil)
        self.patientId = patientId
        self.branchId = branchId
        self.type = Type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

  
}



