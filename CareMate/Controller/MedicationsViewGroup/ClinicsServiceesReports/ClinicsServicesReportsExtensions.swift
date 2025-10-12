//
//  ClinicsServicesReportsExtensions.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 06/06/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import Foundation

extension ClinicsServiceesReportsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTable() {
        tableView.register("ClinicsServiceesReportsTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayReports.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicsServiceesReportsTableViewCell", for: indexPath) as! ClinicsServiceesReportsTableViewCell
        cell.selectionStyle = .none
        cell.setData(model: arrayReports[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ClinicsServicesReportsVisitsViewController()
        vc.ser = arrayReports[indexPath.row].ID
        navigationController?.pushViewController(vc, animated: true)
    }
}
