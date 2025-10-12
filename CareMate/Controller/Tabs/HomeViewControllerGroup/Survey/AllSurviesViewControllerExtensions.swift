//
//  AllSurviesViewControllerExtensions.swift
//  CareMate
//
//  Created by m3azy on 24/09/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import Foundation
import UIKit

extension AllSurviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView() {
        let nib = UINib(nibName: "AllServeyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AllServeyTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySurvey.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "AllServeyTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AllServeyTableViewCell
        cell.selectionStyle = .none
        cell.setData(arraySurvey[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionaryVC") as? QuestionaryVC
        nextViewController?.serialId = arraySurvey[indexPath.row].TRANSSERIAL
        nextViewController?.showOnly = true
        self.navigationController?.pushViewController(nextViewController!, animated: true)
    }
}
