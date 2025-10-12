//
//  OutLabController.swift
//  CareMate
//
//  Created by Ibrahim on 23/12/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class OutLabController: BaseViewController {

    @IBOutlet weak var clcChilds: UICollectionView!
    
    var data: LabRadDTO?
    var isLab:Bool = true
    var isOudsideResult:Bool = false
    var pdfBaseUrl:String = ""
    private var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "التقارير" : "Reports", hideBack: false)
        let nib = UINib(nibName: "OutCell", bundle: nil)
        clcChilds.register(nib, forCellWithReuseIdentifier: "OutCell")
        if isLab {
            let items = data?.CHILD_ACCESSION_NOS.components(separatedBy: ",") ?? []
            for item in items {
                let acc = item.components(separatedBy: "-")
                if acc.last == "1" {
                    
                        dataSource.append(item)
                    
                }
//                else {
//                    if isOudsideResult {
//                        dataSource.append(item)
//                    }
//                }
            }
        }
        
        clcChilds.reloadData()
        // Do any additional setup after loading the view.
    }

}


extension OutLabController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width  , height: collectionView.frame.width * 0.15)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OutCell", for: indexPath) as! OutCell
        let titl = UserManager.isArabic ? "النتيجة المرفقة ":"Attached Result"
        cell.drawCell("\(titl) \(indexPath.row + 1)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        let acc = item.components(separatedBy: "-")
        if acc.last ?? "" == "1" {
            if isLab {
                showReport(item)
           }else {
                showRadReport(item)
            }
        } else {
            if isLab {
                let vc =  LabResultController()
                vc.pdfBaseUrl = pdfBaseUrl
                vc.data = data
                vc.aCCESSION_NO = acc.first ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let pars = "Accession_no=\(item)&BRANCH_ID=1&SERVICE_ID=\(data?.sERVICE_ID ?? "")&REQ_ID=\(data?.rEQ_ID ?? "")&USER_ID=khabeer"
                let urlString = Constants.APIProvider.getPacsUrlPatient+pars
                indicator.sharedInstance.show()
                let url = URL(string: urlString)
                let parseUrl = Constants.APIProvider.getPacsUrlPatient + Constants.getoAuthValue(url: url!, method: "GET")
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(WebViewViewController(parseUrl), animated: true)
                }
            }
        }
    }
    
    func showRadReport(_ key:String) {
        let acc = key.components(separatedBy: "-")
        let pars = "Accession_no=\(acc.first ?? "")&BRANCH_ID=1"
        let urlString = Constants.APIProvider.getPacsUrl+pars
        indicator.sharedInstance.show()
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.getPacsUrl + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: parseUrl, parameters: nil, vc: self) { (data, error) in
            let root = (data as? [String: AnyObject])?["result"] as? String ?? ""
            let vc = WebViewViewController(root, showShare: false)
            vc.pageTitle = UserManager.isArabic ? "النتيجة" : "Result"
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func showReport(_ key:String) {
        let acc = key.components(separatedBy: "-")
        var urlString = Constants.APIProvider.loadReport + "INIT=1&BRANCH_ID=1&USER_ID=KHABEER&REF_CODE=\(acc.first ?? "")&OWNER_TYPE=1&ALL_CATEGORIES=0&OWNER_ID=\(Utilities.sharedInstance.getPatientId())&PROCESS_ID=2644"
        if data?.mICROBIOLOGY_SERV ?? "" == "1" {
            urlString += "&R_NAME=ReportsDLL.Laboratory.rpt_LABORATORY_WRITE_RESULT_culture_services_result_print&ACCESSION_NO=\(acc.first ?? "")"
        } else if data?.pATHOLOGY_SERV ?? "" == "1" {
            urlString += "&R_NAME=ReportsDLL.Laboratory.rpt_LABORATORY_WRITE_RESULT_get_services_result_print_patholoyg&P_IDENTFIER=\(acc.first ?? "")"
        } else {
            urlString += "&R_NAME=ReportsDLL.Laboratory.rpt_LABORATORY_WRITE_RESULT_get_services_result_print&P_IDENTFIER=\(acc.first ?? "")"
        }
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            let root = (data as! [String: AnyObject])
            if let val = root["BLOB"] as? [String: AnyObject] {
                if let blobRaw = val["BLOB_ROW"] as? [String: AnyObject] {
                    let model = LabResultModel()
                    model.BLOB_PATH = blobRaw["BLOB_PATH"] as? String ?? ""
                    model.BLOB_TYPE = blobRaw["BLOB_TYPE"] as? String ?? ""
                    model.DATE_ENTER = blobRaw["DATE_ENTER"] as? String ?? ""
                    if model.BLOB_TYPE == "1" {
                        let url = "\(Constants.APIProvider.IMAGE_BASE2)/\(model.BLOB_PATH)"
                        let vc = LabResultController()
                        vc.clinicsServiceReportPDFUrl = url
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        let url = "\(Constants.APIProvider.IMAGE_BASE2)/\(model.BLOB_PATH)"
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(WebViewViewController(url), animated: true)
                        }
                    }
                } else if let blobArray = val["BLOB_ROW"] as? [[String: AnyObject]] {
                    var array = [LabResultModel]()
                    for blobRaw in blobArray {
                        let model = LabResultModel()
                        model.BLOB_PATH = blobRaw["BLOB_PATH"] as? String ?? ""
                        model.BLOB_TYPE = blobRaw["BLOB_TYPE"] as? String ?? ""
                        model.DATE_ENTER = blobRaw["DATE_ENTER"] as? String ?? ""
                        array.append(model)
                    }
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(LabResultsViewController(arrayResults: array), animated: true)
                    }
                }
            } else {
                print("key is not present in dict")
            }
        }
    }
}
