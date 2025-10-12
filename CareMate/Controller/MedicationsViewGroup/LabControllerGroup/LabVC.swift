//
//  LabVC.swift
//  CareMate
//
//  Created by Yo7ia on 1/1/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//


import UIKit
import DZNEmptyDataSet
import PopupDialog
import MZFormSheetController

protocol labRadFilter {
    func labRadFilterProtocal(statusName: String, Statues: String?,DATE_FROM_STR_FORMATED: String?,DATE_TO_STR_FORMATED: String?)
}

class LabVC: BaseViewController, UISearchBarDelegate, ListPopupDelegate, DataPickerPopupDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewFilterDate: UIView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var labelFilter: UILabel!
//    @IBOutlet weak var labelRitt: UILabel!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var imageViewSearch: UIImageView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var viewFilterType: UIView!
    @IBOutlet weak var labelFilterType: UILabel!
    @IBOutlet weak var viewFilterFrom: UIView!
    @IBOutlet weak var labelFilterFrom: UILabel!
    @IBOutlet weak var viewFilterTo: UIView!
    @IBOutlet weak var labelFilterTo: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    var branchId: String?
    var specialityId: String?
    var doctors = [LabRadDTO]()
    var fullDoctors = [LabRadDTO]()
    var listOfFilterStatues = [labStatuesModel]()
    var statues = ""
    var pageSize = 20
    var pageCount = 1
    var readMore = ""
    var pdfUrl:URL?
    var pdfBaseUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.readMore =   UserManager.isArabic ? "إقرآ المزيد" : "ReadMore"
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        self.tableView.allowsSelection = false
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        labelFilter.text =   UserManager.isArabic ? "فلتر البحث" : "Filter"
        textFieldSearch.placeholder = UserManager.isArabic ? "البحث بإسم الإختبار" : "Search by name of the test"
//        labelRitt.text =   UserManager.isArabic ? "زتب" : "Sort"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register("LabsTableViewCell")
        tableView.keyboardDismissMode = .onDrag
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
//        self.tableView.rowHeight = 300
        callAPI(indexFrom: 0 , indexTO: pageSize, Statues: nil,DATE_FROM_STR_FORMATED: nil,DATE_TO_STR_FORMATED: nil)
//        setupTabBar.instance.setuptabBar(vc: self)

        let gestureopenopenOperationCliked = UITapGestureRecognizer(target: self, action:  #selector(self.openFilter))
        self.viewFilter.addGestureRecognizer(gestureopenopenOperationCliked)
        
        let viewFilterDateCliked = UITapGestureRecognizer(target: self, action:  #selector(self.openFilterDate))
//        self.viewFilterDate.addGestureRecognizer(viewFilterDateCliked)
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "المختبر" : "Lab", hideBack: false)
        imageViewSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(search)))
        if UserManager.isArabic {
            scrollView.transform = CGAffineTransform(scaleX: -1, y: 1)
            for sub in stackView.subviews {
                sub.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    @objc func search() {
        doctors.removeAll()
        callAPI(indexFrom: 0, indexTO: pageSize, Statues: statues, DATE_FROM_STR_FORMATED: nil, DATE_TO_STR_FORMATED: nil)
        listOfFilterStatues.removeAll()
    }
    
    @objc func openFilterDate(sender : UITapGestureRecognizer) {
        
//        vc.delegate = self
//
        
        let vc  = FilterByDateViewController()
        vc.delegate = self
        let formSheet = MZFormSheetController.init(viewController: vc)
        formSheet.shouldDismissOnBackgroundViewTap = true
        formSheet.transitionStyle = .slideFromBottom
        formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: 550)
        formSheet.shouldCenterVertically = true
        formSheet.present(animated: true, completionHandler: nil)
        
   
    }
    
    @objc func openFilter(sender : UITapGestureRecognizer) {
        listOfFilterStatues.removeAll()
        listOfFilterStatues.append(labStatuesModel(ID: "R", NAME_AR: "تم الطلب", NAME_EN: "For Sampling"))
        listOfFilterStatues.append(labStatuesModel(ID: "F", NAME_AR: "تم التأكيد", NAME_EN: "Confirmed"))
        listOfFilterStatues.append(labStatuesModel(ID: "W", NAME_AR: "تحتاج موافقة", NAME_EN: "Waiting for Approval"))
        listOfFilterStatues.append(labStatuesModel(ID: "P", NAME_AR: "تمت الموافقة", NAME_EN: "Approved"))
        listOfFilterStatues.append(labStatuesModel(ID: "I", NAME_AR: "تم تسليم العينة (للكميائي)", NAME_EN: "Sample received (lab. doctor)"))
        
        let vc  = FilterLabRadViewController()
        vc.listOfFilterStatues = listOfFilterStatues
        vc.delegte = self
//        self.navigationController?.pushViewController(vc, animated: true)
        AppPopUpHandler.instance.openVCPop(vc, height: 500, bottomSheet: true)
//        AppPopUpHandler.instance.openPopup(container: self, vc: vc)
        
//        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: UserManager.isArabic ?  listOfFilterStatues.map{$0.NAME_AR} : listOfFilterStatues.map{$0.NAME_EN} , title: "Choose", type: "")
    }
    func pdfDataWithTableView(tableView: UITableView) {
            let priorBounds = tableView.bounds
            let fittedSize = tableView.sizeThatFits(CGSize(width:priorBounds.size.width, height:tableView.contentSize.height))
            tableView.bounds = CGRect(x:0, y:0, width:fittedSize.width, height:fittedSize.height)
            let pdfPageBounds = CGRect(x:0, y:0, width:tableView.frame.width, height:self.view.frame.height)
            let pdfData = NSMutableData()
            UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds,nil)
            var pageOriginY: CGFloat = 0
            while pageOriginY < fittedSize.height {
                UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
                UIGraphicsGetCurrentContext()!.saveGState()
                UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
                tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
                UIGraphicsGetCurrentContext()!.restoreGState()
                pageOriginY += pdfPageBounds.size.height
            }
            UIGraphicsEndPDFContext()
            tableView.bounds = priorBounds
            var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            docURL = docURL.appendingPathComponent("myDocument.pdf")
            pdfData.write(to: docURL as URL, atomically: true)
        
        if #available(iOS 10.0, *) {
            
                  do {
                      let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                      let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
            for url in contents {
                if
                        url.description.contains("myDocument.pdf") {
                             // its your file! do what you want with it!
                    pdfUrl = url

                      }
                  }
              } catch {
                  print("could not locate pdf file !!!!!!!")
              }
        }
    }
    
    
    @IBAction func shareWithWhatsapp(_ sender: Any) {
//        let whatsappURL = URL(string:"whatsapp://app")!
//        // this will make sure WhatsApp it is installed
//        if UIApplication.shared.canOpenURL(whatsappURL) {
//            let controller = UIActivityViewController(activityItems: [pdfUrl], applicationActivities: nil)
//            present(controller, animated: true) {
//                print("done")
//            }
//        }
        let objectsToShare = [pdfUrl] as [Any]
           let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
           activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
           
        activityVC.popoverPresentationController?.sourceView = sender as! UIView
           
           self.present(activityVC, animated: true, completion: nil)
    }
    
    
    func sharePdfWhatsApp(url: URL) {
       
    }
    func callAPI(indexFrom: Int, indexTO: Int, Statues: String?, DATE_FROM_STR_FORMATED: String?, DATE_TO_STR_FORMATED: String?){

        if Utilities.sharedInstance.getPatientId() == "" {
            Utilities.showLoginAlert(vc: self.navigationController!)
            return
        }
        let pars = "USER_ID=2&PATIENT_ID=" + Utilities.sharedInstance.getPatientId() + "&STATUS=" + "\(Statues ?? "")" + "&INDEX_FROM=" + "\(indexFrom)" + "&INDEX_TO=" + "\(indexTO)" + "&SERVICE_NAME=" + textFieldSearch.text! + "&DATE_FROM_STR_FORMATED=\(DATE_FROM_STR_FORMATED ?? "")" + "&DATE_TO_STR_FORMATED=\(DATE_TO_STR_FORMATED ?? "")"
  
        let urlString = Constants.APIProvider.LabReqHistoryload+pars
//        if doctors.isEmpty {
//            indicator.sharedInstance.show()
//        }
 //       let url = URL(string: urlString)
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self,showIndicator: doctors.isEmpty) { (data, error) in
            self.pdfBaseUrl = (data as? [String: AnyObject])?["PrimeCareBaseUrl"] as? String ?? ""
            if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["LAB_PAT_HISTORY"] as? [String:AnyObject] {
                if let appoins = root["LAB_PAT_HISTORY_ROW"] as? [[String: AnyObject]] {
                    for i in appoins {
                        if i["SERVSTATUS"] as? String ?? "" != "" {
                            self.doctors.append(LabRadDTO(JSON: i)!)
                        }
                    }
                } else {
                    if (root["LAB_PAT_HISTORY_ROW"] as? [String: AnyObject] ?? [String: AnyObject]())["SERVSTATUS"] as? String ?? "" != "" {
                        self.doctors.append(LabRadDTO(JSON: root["LAB_PAT_HISTORY_ROW"] as! [String: AnyObject])!)
                    }
                }
            } else {
           
            }
            self.tableView.reloadData()
            
            if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["ORDER_STATUS_LIST"] as? [String:AnyObject] {
                if let appoins = root["ORDER_STATUS_LIST_ROW"] as? [[String: AnyObject]] {
                    for i in appoins {
                        if i["SERVSTATUS"] as? String ?? "" != "" {
                            self.listOfFilterStatues.append(labStatuesModel(JSON: i)!)
                        }
                    }
                } else {
                    if root["SERVSTATUS"] as? String ?? "" != "" {
                        self.listOfFilterStatues.append(labStatuesModel(JSON: root["ORDER_STATUS_LIST_ROW"] as! [String: AnyObject])!)
                    }
                }
            }
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
 
    func timeDidAdded(day: Int, month: Int, year: Int) {
        
    }
    
    func listPopupDidSelect(index: Int, type: String) {
        
        doctors.removeAll()
        callAPI(indexFrom: 0, indexTO: pageSize, Statues: listOfFilterStatues[index].ID,DATE_FROM_STR_FORMATED: nil,DATE_TO_STR_FORMATED: nil)
        
        statues = listOfFilterStatues[index].ID
        listOfFilterStatues.removeAll()
    }
}

extension LabVC:InOutResultProtocol {
    func openInResult(_ model: LabRadDTO?) {
        let vc =  LabResultController()
        vc.pdfBaseUrl = pdfBaseUrl
        vc.data = model
        vc.aCCESSION_NO = model?.aCCESSION_NO ?? ""
        self.navigationController?.pushViewController(vc, animated: true)

      //
//        let vc = OutLabController()
//        vc.data = model
//        vc.pdfBaseUrl = pdfBaseUrl
//        vc.isLab = true
//        vc.isOudsideResult = false
//        navigationController?.pushViewController(vc, animated: true)
 }
    
    func openOutResult(_ model: LabRadDTO?) {
        
        let vc = OutLabController()
        vc.data = model
        vc.pdfBaseUrl = pdfBaseUrl
        vc.isLab = true
        vc.isOudsideResult = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LabVC: UITableViewDataSource ,LabRadCellDelagete{
    func openRad(_ data: LabsTableViewCell) {
        
    }
    
    func CellClickedPacks(_ data: LabsTableViewCell) {
        let model  = data.data
        if model?.CHILD_ACCESSION_NOS.isEmpty == false {
            let child = model?.CHILD_ACCESSION_NOS.components(separatedBy: ",") ?? []
            let check = child.first?.components(separatedBy: "-") ?? []
            var isIn = false
            var isOut = false
            for item in child {
                let acc = item.components(separatedBy: "-")
                if acc.last == "1" {
                    isOut = true
                }
                if acc.last == "0" {
                    isIn = true
                }
            }
            if isIn && isOut {
                // show popup
                let vc = InOutPopController()
                vc.data = model
                vc.delegade = self
                AppPopUpHandler.instance.openVCPop(vc, height: 240)
                
            }else {
                if isIn {
                    let vc =  LabResultController()
                    vc.pdfBaseUrl = pdfBaseUrl
                    vc.data = model
                    vc.aCCESSION_NO = model?.aCCESSION_NO ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    let vc = OutLabController()
                    vc.data = model
                    vc.pdfBaseUrl = pdfBaseUrl
                    vc.isLab = true
                    navigationController?.pushViewController(vc, animated: true)
                }
              
            }

        }else
        if model?.EXT_SCAN ?? "" == "1" {
            showReport(data)
        } else {
            let vc =  LabResultController()
            vc.pdfBaseUrl = pdfBaseUrl
            vc.data = model
            vc.aCCESSION_NO = model?.aCCESSION_NO ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showReport(_ data: LabsTableViewCell) {
        var urlString = Constants.APIProvider.loadReport + "INIT=1&BRANCH_ID=1&USER_ID=KHABEER&REF_CODE=\(data.data?.aCCESSION_NO ?? "")&OWNER_TYPE=1&ALL_CATEGORIES=0&OWNER_ID=\(Utilities.sharedInstance.getPatientId())&PROCESS_ID=2644"
        if data.data?.mICROBIOLOGY_SERV ?? "" == "1" {
            urlString += "&R_NAME=ReportsDLL.Laboratory.rpt_LABORATORY_WRITE_RESULT_culture_services_result_print&ACCESSION_NO=\(data.data?.aCCESSION_NO ?? "")"
        } else if data.data?.pATHOLOGY_SERV ?? "" == "1" {
            urlString += "&R_NAME=ReportsDLL.Laboratory.rpt_LABORATORY_WRITE_RESULT_get_services_result_print_patholoyg&P_IDENTFIER=\(data.data?.aCCESSION_NO ?? "")"
        } else {
            urlString += "&R_NAME=ReportsDLL.Laboratory.rpt_LABORATORY_WRITE_RESULT_get_services_result_print&P_IDENTFIER=\(data.data?.aCCESSION_NO ?? "")"
        }
        print(urlString)
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            let root = (data as! [String: AnyObject])
            print(root)
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
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let url = "\(Constants.APIProvider.IMAGE_BASE2)/\(model.BLOB_PATH)"
                        self.navigationController?.pushViewController(WebViewViewController(url), animated: true)
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
                    self.navigationController?.pushViewController(LabResultsViewController(arrayResults: array), animated: true)
                }
            } else {
                print("key is not present in dict")
            }
        }
    }
   
    func CellClicked(_ data: LabsTableViewCell) {
        let vc =  LabResultController()
        vc.pdfBaseUrl = pdfBaseUrl
        vc.aCCESSION_NO = data.data?.aCCESSION_NO ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabsTableViewCell", for: indexPath) as! LabsTableViewCell
        if self.doctors[indexPath.row].PREPARE_DESC_AR != ""{
            if doctors[indexPath.row].readMore == false{
                let readmoreFont = UIFont(name: "Tajawal-Medium", size: 13.0)
                      let readmoreFontColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                      DispatchQueue.main.async {
//                          cell.labelAlert.addTrailing(with: " ", moreText: self.readMore, moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
                      }
            }
            else{
                let readmoreFont = UIFont(name: "Tajawal-Medium", size: 13.0)
                      let readmoreFontColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                      DispatchQueue.main.async {
//                          cell.labelAlert.addTrailingNoCut(with: " ", moreText: self.readMore, moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
                      }
            }
           
        }
       
        cell.isLab = true
        cell.delegate = self
        cell.configCell(doctor: doctors[indexPath.row])
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped(_:)))
             tap.numberOfTapsRequired = 1
         cell.labelAlert.tag = indexPath.row
         cell.labelAlert.isUserInteractionEnabled = true
         cell.labelAlert.addGestureRecognizer(tap)
       

    return cell
    }
    
    
    @objc func doubleTapped(_ recognizer: UITapGestureRecognizer) {

     if  doctors[recognizer.view!.tag].readMore == true{
         doctors[recognizer.view!.tag].readMore = false
         self.readMore =   UserManager.isArabic ? "إقرآ افل" : "ReadLess"
         
     }
     else{
         doctors[recognizer.view!.tag].readMore = true
         self.readMore =   UserManager.isArabic ? "إقرآ المزيد" : "ReadMore"
     }
 





 tableView.reloadData()

}


    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

            print("scrollViewWillBeginDragging")
        }



        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            print("scrollViewDidEndDecelerating")
        }
        //Pagination
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

                print("scrollViewDidEndDragging")
                if ((tableView.contentOffset.y + tableView.frame.size.height) > tableView.contentSize.height) {
//                    if(pageCount * pageSize == doctors.count) {
                        pageCount += 1
                        callAPI(indexFrom: (doctors.count + 1) , indexTO: pageCount * pageSize, Statues: statues ,DATE_FROM_STR_FORMATED: nil,DATE_TO_STR_FORMATED: nil)
//                    }
                }
        }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "report"
//        {
//            let vc = segue.destination as! LabResultController
//            vc.aCCESSION_NO = sender as! String
//        }
//    }
}

extension LabVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(5)
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}
extension LabVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // ===============================================
    // ==== DZNEmptyDataSet Delegate & Datasource ====
    // ===============================================
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return doctors.count == 0
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
//        let text =  UserManager.isArabic ?  "لم يتم العثور على نتائج مختبرات" : "No labs results found !"
//        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:Color.darkGray]
//        
//        return NSAttributedString(string: text, attributes: attributes)
//    }
}


extension LabVC :returnTpLab
{
    func returnTpLabfunc(dateFrom: String, dateTo: String) {
        self.doctors.removeAll()

        callAPI(indexFrom: 0 , indexTO: pageSize, Statues: nil,DATE_FROM_STR_FORMATED: dateFrom,DATE_TO_STR_FORMATED: dateTo)
        
    }
    
    
}
extension LabVC :labRadFilter{
    func labRadFilterProtocal(statusName: String, Statues: String?, DATE_FROM_STR_FORMATED: String?, DATE_TO_STR_FORMATED: String?) {
        self.doctors.removeAll()
        self.statues = Statues ?? ""
        callAPI(indexFrom: 0, indexTO: pageSize, Statues: self.statues,DATE_FROM_STR_FORMATED: DATE_FROM_STR_FORMATED,DATE_TO_STR_FORMATED: DATE_TO_STR_FORMATED)
        
        var dateFrom = ""
        var dateTo = ""
        var filterString = ""
        if statusName != "" {
//            filterString += "\(statusName)"
            viewFilterType.isHidden = false
            labelFilterType.text = statusName
        } else {
            viewFilterType.isHidden = true
        }
        if DATE_FROM_STR_FORMATED != nil && DATE_FROM_STR_FORMATED != "" {
            dateFrom = DATE_FROM_STR_FORMATED!.components(separatedBy: " ")[0]
            if filterString != "" {
                filterString += ", "
            }
//            filterString += "\(UserManager.isArabic ? "من" : "From"): \(dateFrom)"
            viewFilterFrom.isHidden = false
            labelFilterFrom.text = "\(UserManager.isArabic ? "من" : "From"): \(dateFrom)"
        } else {
            viewFilterFrom.isHidden = true
        }
        if DATE_TO_STR_FORMATED != nil && DATE_TO_STR_FORMATED != "" {
            dateTo = DATE_TO_STR_FORMATED!.components(separatedBy: " ")[0]
            if filterString != "" {
                filterString += ", "
            }
//            filterString += "\(UserManager.isArabic ? "الى" : "To"): \(dateTo)"
            viewFilterTo.isHidden = false
            labelFilterTo.text = "\(UserManager.isArabic ? "الى" : "To"): \(dateTo)"
        } else {
            viewFilterTo.isHidden = true
        }
//        labelFilterData.text = filterString
    }
    
    
}

class LabResultModel {
    var BLOB_PATH = ""
    var BLOB_TYPE = ""
    var DATE_ENTER = ""
}
