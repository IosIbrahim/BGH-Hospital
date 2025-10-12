//
//  InvoicesAndRecepits+tableview.swift
//  CareMate
//
//  Created by MAC on 17/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation

extension InvoicesAndReceiptsViewController :UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reloadreci == true
        {
        return PatReceiptsList.count
        }
        else
        {
            return invociesList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if    reloadreci == true
        {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "receptionCell") as? receptionCell
        cell?.configure(PatReceiptsList[indexPath.row])
        return cell!
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "invoiceCell") as? invoiceCell
            cell?.configure(invociesList[indexPath.row])
            return cell!
        }
        
    }
  
    

    
    func setup()  {
        title = UserManager.isArabic ? "الفواتير والإيصالات" : "Invoices and Receipts"
        let cellNib = UINib(nibName: "receptionCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "receptionCell")
        
        let cellNibinvoiceCell = UINib(nibName: "invoiceCell", bundle: nil)
        tableview.register(cellNibinvoiceCell, forCellReuseIdentifier: "invoiceCell")
        
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.delegate = self
        tableview.dataSource = self
//        recepationCliked.isHidden = false
//        invocisCliked.isHidden = true

    }
}
