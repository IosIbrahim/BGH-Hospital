//
//  PatProfileViewControllerExtensions.swift
//  CareMate
//
//  Created by m3azy on 26/06/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import Foundation
import UIKit

extension PatProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initTable() {
        let cellNib = UINib(nibName: "FamilyTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "FamilyTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFamilies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyTableViewCell", for: indexPath) as! FamilyTableViewCell
        cell.configure(listOfFamilies[indexPath.row])
        return cell
        
    }
    
    
    

  
    
}
