//
//  ClinicsServicesReportsVisitsResultsViewControllerResults.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 07/06/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import Foundation

extension ClinicsServicesReportsVisitsResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTable() {
        tableView.register("ClinicsServicesReportsVisitsResultsTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicsServicesReportsVisitsResultsTableViewCell", for: indexPath) as! ClinicsServicesReportsVisitsResultsTableViewCell
        cell.selectionStyle = .none
        cell.setData(model: arrayResults[indexPath.row])
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ClinicsServicesReportsVisitsResultsViewController: CLinicsServicesReportsResultsVisitsDelegate {
    
    func showReports(index: Int) {
        let vc = LabResultController()
        vc.clinicsServiceReportPDFUrl = "\(Constants.APIProvider.IMAGE_BASE)\(arrayResults[index].RESULT_PATH)"
        navigationController?.pushViewController(vc, animated: true)
    }
}
