//
//  InvoicesAndReceiptsViewController.swift
//  CareMate
//
//  Created by MAC on 17/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
import SwiftyJSON
class InvoicesAndReceiptsViewController: BaseViewController {

    @IBOutlet weak var  invocisText: UILabel!
    @IBOutlet weak var recepationText: UILabel!
    
    
    @IBOutlet weak var recepationCliked: UIView!
    
    @IBOutlet weak var invocisCliked: UIView!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var viewBackgroundHeader: UIView!
    
    let group = DispatchGroup()

    var PatReceiptsList = [RECEIPTSDTO]()
    var  invociesList = [invociesDTO]()

   var reloadreci = true
    var loadOneTime = true

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

//        self.navigationController?.navigationBar.isHidden = false
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "الماليات" :"Invoices And Receipts", hideBack: false)
        setup()
        indicator.sharedInstance.show()
        recepationCliked.backgroundColor = .fromHex(hex: "#1A9A8C", alpha: 1)
        invocisCliked.backgroundColor = .clear
        recepationText.textColor = .white
        invocisText.textColor = .fromHex(hex: "#CDC9C9", alpha: 1)
        reloadreci = true
        getdatakaskas()
//        group.notify(queue: .main) {
//
//            self.tableview.reloadData()
//            indicator.sharedInstance.dismiss()
//
//        }
//
        if UserManager.isArabic
        {
            invocisText.text = "إقامة داخلية"
            recepationText.text = "عيادات"
        }
        else
        {
            invocisText.text = "Invoices"
            recepationText.text = "Receipts"
        }
//        recieptionCliked(UIButton())
        viewBackgroundHeader.setBorder(color: .lightGray, radius: 16, borderWidth: 1)
        recepationCliked.layer.cornerRadius = 16
        invocisCliked.layer.cornerRadius = 16
        recepationText.font = UIFont(name: "Tajawal-Bold", size: 17)
        invocisText.font = UIFont(name: "Tajawal-Bold", size: 17)
    }
  

    func getdatakaskas() {
        
//        group.enter()
        PatReceiptsList.removeAll()
        let urlString = Constants.APIProvider.PatReceipts+"PATIENTID=\(Utilities.sharedInstance.getPatientId())&INDEX_TO=1000&INDEX_FROM=1"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["RECEIPTS"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["RECEIPTS_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["RECEIPTS_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.PatReceiptsList.append(RECEIPTSDTO(JSON: i)!)
                      
                        
                    }
                    }
                    else if root["RECEIPTS_ROW"] is [String:AnyObject]
                    {
                        self.PatReceiptsList.append(RECEIPTSDTO(JSON:root["RECEIPTS_ROW"] as![String:AnyObject] )!)
                     
                        
                    }
                     self.tableview.reloadData()
                    
                }
                else
                 {
                }
            }
//            self.group.leave()

           
        }
    }
    
    func getdataInvoi() {
        
        invociesList.removeAll()
//        group.enter()
        let urlString = Constants.APIProvider.PatInvoices+"PATIENTID=\(Utilities.sharedInstance.getPatientId())&INDEX_TO=1000&INDEX_FROM=1"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
                    
           
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["INVOICE"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["INVOICE_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["INVOICE_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.invociesList.append(invociesDTO(JSON: i)!)
                      
                        
                    }
                    }
                    else if root["INVOICE_ROW"] is [String:AnyObject]
                    {
                        self.invociesList.append(invociesDTO(JSON:root["INVOICE_ROW"] as![String:AnyObject] )!)
                     
                        
                    }
               
                    self.tableview.reloadData()

                    
                }
                else
                 {
                }
            }
//            self.group.leave()

           
        }
    }
    
    @IBAction func recieptionCliked(_ sender: Any) {
        recepationCliked.backgroundColor = .fromHex(hex: "#1A9A8C", alpha: 1)
        invocisCliked.backgroundColor = .clear
        recepationText.textColor = .white
        invocisText.textColor = .fromHex(hex: "#CDC9C9", alpha: 1)
        reloadreci = true
        getdatakaskas()
        tableview.reloadData()
    }
    
    
    @IBAction func invoceisCliked(_ sender: Any) {
        invocisCliked.backgroundColor = .fromHex(hex: "#1A9A8C", alpha: 1)
        recepationCliked.backgroundColor = .clear
        invocisText.textColor = .white
        recepationText.textColor = .fromHex(hex: "#CDC9C9", alpha: 1)
        reloadreci = false
//        if loadOneTime == true{
            getdataInvoi()
            loadOneTime = false
//        }
        tableview.reloadData()

    }
    
}

extension UIView {
    
    func setBorder(color:UIColor, radius:CGFloat, borderWidth:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
    }
}
