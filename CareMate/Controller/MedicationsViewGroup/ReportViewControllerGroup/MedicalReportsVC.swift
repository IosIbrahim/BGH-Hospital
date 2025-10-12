//
//  MedicalReportsVC.swift
//  CareMate
//
//  Created by Khabeer on 2/1/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MedicalReportsVC: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    var reports = [PatientReportDTO]()
    var webViewText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "التقارير الطبية" : "Medical Reports", hideBack: false)
        tableView.backgroundColor = .clear
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dataSource = self
        tableView.delegate  = self
        tableView.register("ReportTableViewCell")
        tableView.keyboardDismissMode = .onDrag
        getMedicalReports()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    func getMedicalReports(){
        
        if Utilities.sharedInstance.getPatientId() == "" {
            Utilities.showLoginAlert(vc: self.navigationController!)
            return
        }
        let pars = "PATIENT_ID="+Utilities.sharedInstance.getPatientId().trimmed+"&BRANCH_ID=1" + "&LanguageID=1" + "&ComputerName=IOS" + "&USER_ID=khabeer"
        
        let urlString = Constants.APIProvider.MedicalReports+pars
        indicator.sharedInstance.show()
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.MedicalReports + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: parseUrl, parameters: nil, vc: self) { (data, error) in
            if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["REPORT_PAT"] as? [String:AnyObject] {
                if let appoins = root["REPORT_PAT_ROW"] as? [[String: AnyObject]] {
                    for i in appoins {
                        if i["ACTION_SER"] as? String ?? "" != "5" {
                            let code = i["TEMP_CODE"] as? String ?? ""
                            if code == "150" || code == "285" || code == "308" {
                                self.reports.append(PatientReportDTO(JSON: i)!)
                            }
                        }
                    }
                } else {
                    let object = root["REPORT_PAT_ROW"] as! [String: AnyObject]
                    if root["ACTION_SER"] as? String ?? "" != "5" {
                        let code = object["TEMP_CODE"] as? String ?? ""
                        if code == "150" || code == "285" || code == "308" {
                            self.reports.append(PatientReportDTO(JSON: root["REPORT_PAT_ROW"] as! [String: AnyObject])!)
                        }
                    }
                }
            } else {
                self.reports.removeAll()
            }
            self.tableView.reloadData()
            if self.reports.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.nc.post(name: Notification.Name("nodataFound"), object: nil)
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "report"
        {
            let vc = segue.destination as! WebViewControllerVC
            vc.reportText = sender as! String
//            vc.
        }
    }


}


extension MedicalReportsVC: UITableViewDataSource , UITableViewDelegate, ReportCellDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        cell.configCell(report: reports[indexPath.row])
//        cell.viewLoad.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
//        cell.viewLoad.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(connected(sender:))))
//        cell.viewLoad.tag = indexPath.row
        cell.delegate = self
        cell.index = indexPath.row
        return cell
    }
    
    func showReport(_ index: Int) {
        let pars = "PATIENT_ID="+Utilities.sharedInstance.getPatientId().trimmed+"&BRANCH_ID=1" + "&LanguageID=1" + "&ComputerName=IOS" + "&USER_ID=khabeer" + "&SER=" + self.reports[index].SER

        let urlString = Constants.APIProvider.MedicalReportDetails+pars
        indicator.sharedInstance.show()
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.MedicalReportDetails + Constants.getoAuthValue(url: url!, method: "GET")
        navigationController?.pushViewController(WebViewViewController(parseUrl), animated: true)
//        WebserviceMananger.sharedInstance.makeCall(method: .get, url: parseUrl, parameters: nil, vc: self) { (data, error) in
//            if let root = (data as! [String: AnyObject])["result"] as? String {
//                print("Root: \(root)")
//                var replaced = root.replacingOccurrences(of: "\\n", with: "")
//                replaced = replaced.replacingOccurrences(of: "\\t", with: "")
//                replaced = replaced.replacingOccurrences(of: "\\", with: "")
//
//                self.webViewText = replaced
////                let Vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewControllerVC") as! WebViewControllerVC
//                let Vc = WebViewControllerVC()
//                Vc.reportText = replaced
//
//                self.navigationController?.pushViewController(Vc, animated: true)
//            }
//        }
    }
    
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      

    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 285
    }
}

extension MedicalReportsVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // ===============================================
    // ==== DZNEmptyDataSet Delegate & Datasource ====
    // ===============================================
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return reports.count == 0
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "error")
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "transform")
        
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 0.0, 1.0))
        
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        
        return animation
    }
    
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text =  UserManager.isArabic ?  "لم يتم العثور على تقارير" : "No reports found !"
//        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:Color.darkGray]
//        return NSAttributedString(string: text, attributes: attributes)
//    }
}
