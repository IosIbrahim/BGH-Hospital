//
//  ClinicsServicesReportsVisitsExtensions.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 06/06/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import Foundation

extension ClinicsServicesReportsVisitsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTable() {
        tableView.register("ClinicsServicesReportsVisitsTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayVisits.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicsServicesReportsVisitsTableViewCell", for: indexPath) as! ClinicsServicesReportsVisitsTableViewCell
        cell.selectionStyle = .none
        cell.setData(model: arrayVisits[indexPath.row])
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ClinicsServicesReportsVisitsViewController: CLinicsServicesReportsVisitsDelegate {
    
    func showReports(index: Int) {
        let vc = ClinicsServicesReportsVisitsResultsViewController()
        vc.ser = ser
        vc.visitId = arrayVisits[index].VISIT_ID
        navigationController?.pushViewController(vc, animated: true)
    }
}
