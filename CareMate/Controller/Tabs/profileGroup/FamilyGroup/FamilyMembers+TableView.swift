//
//  FamilyMembers+TableView.swift
//  CareMate
//
//  Created by Khabber on 09/05/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import Foundation
import UIKit
extension FamilyMembersViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listOfFamilies.count
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyTableViewCell", for: indexPath) as! FamilyTableViewCell
        cell.configure(listOfFamilies[indexPath.row])
        return cell
        
    }
    
    
    func setup()  {
        let cellNib = UINib(nibName: "FamilyTableViewCell", bundle: nil)
        table.register(cellNib, forCellReuseIdentifier: "FamilyTableViewCell")
        table.rowHeight = 250

    }

  
    
}
