//
//  NotificationDetailsViewControllerExtensions.swift
//  CareMate
//
//  Created by m3azy on 24/10/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import Foundation
import UIKit

extension NotificationDetailsViewController :UITableViewDelegate ,UITableViewDataSource {
    
    func initTableView() {
        tableView.register("NotificationMedicineTableViewCell")
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrayMedicine.count
    }
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "NotificationMedicineTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NotificationMedicineTableViewCell
        cell.selectionStyle = .none
        cell.setData(arrayMedicine[indexPath.row])
        return cell
    }

    
}

