//
//  ListPopupViewControllerExtensions.swift
//  nasTrends
//
//  Created by Mohamed Elmaazy on 2/5/19.
//  Copyright © 2019 Mohamed Elmaazy. All rights reserved.
//

import Foundation
import UIKit

extension ListPopupViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView() {
        tableView.register("ListPopupTableViewCell2")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "ListPopupTableViewCell2"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ListPopupTableViewCell2
        cell.selectionStyle = .none
        cell.setData(name: arrayNames[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        constraintHeightViewBackground.constant = 50
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.closure?(indexPath.row)
        }
    }
}


