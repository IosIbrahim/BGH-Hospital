//
//  RadiologyVC.swift
//  CareMate
//
//  Created by Yo7ia on 1/1/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//


import UIKit
import DZNEmptyDataSet
import SafariServices
import MZFormSheetController

extension RadiologyVC :labRadFilter{
    func labRadFilterProtocal(statusName: String, Statues: String?, DATE_FROM_STR_FORMATED: String?, DATE_TO_STR_FORMATED: String?) {
        self.doctors.removeAll()
        self.statues = Statues ?? ""
        self.dateFrom = DATE_FROM_STR_FORMATED ?? ""
        self.dateTo = DATE_TO_STR_FORMATED ?? ""

        
        callAPI(indexFrom: 0, indexTO: pageSize, Statues: self.statues,dateFRom: DATE_FROM_STR_FORMATED,dateTo: DATE_TO_STR_FORMATED)
        
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
class RadiologyVC: BaseViewController ,UISearchBarDelegate, showInfoProtocal,ListPopupDelegate{
    func listPopupDidSelect(index: Int, type: String) {
        
        doctors.removeAll()
        callAPI(indexFrom: 0, indexTO: pageSize, Statues: listOfFilterStatues[index].ID,dateFRom: nil,dateTo: nil)
        
        statues = listOfFilterStatues[index].ID
        listOfFilterStatues.removeAll()
    }
    
    
    
    func showInfoProtocal(_ doctor: LabRadDTO?) {
   
        let messageVC = UIAlertController(title: "Message Title", message: doctor?.PREPARE_DESC_EN, preferredStyle: .alert)
        messageVC.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,
             handler: nil))
        present(messageVC, animated: true) {
                        Timer.scheduledTimer(withTimeInterval: 10.5, repeats: false, block: { (_) in
                            
                        })
            
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var viewFilterDate: UIView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var imageViewSearch: UIImageView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var labelFilter: UILabel!
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
    var pageSize = 20
    var pageCount = 1
    var pdfUrl:URL?
    var listOfFilterStatues = [labStatuesModel]()

    var statues = ""
 
    var readMore = ""
    var dateFrom = ""
    var dateTo = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
        self.readMore =   UserManager.isArabic ? "....إقرآ المزيد" : "....ReadMore"
        labelFilter.text =   UserManager.isArabic ? "فلتر البحث" : "Filter"
        textFieldSearch.placeholder = UserManager.isArabic ? "البحث بإسم الفحص" : "Search by examination name"
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register("LabsTableViewCell")
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        tableView.keyboardDismissMode = .onDrag
        callAPI(indexFrom: 0 , indexTO: pageSize, Statues: nil,dateFRom: nil,dateTo: nil)
        self.tableView.estimatedRowHeight = 88.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let gestureopenopenOperationCliked = UITapGestureRecognizer(target: self, action:  #selector(self.openFilter))
        self.viewFilter.addGestureRecognizer(gestureopenopenOperationCliked)
        
        let viewFilterDateCliked = UITapGestureRecognizer(target: self, action:  #selector(self.openFilterDate))
//        self.viewFilterDate.addGestureRecognizer(viewFilterDateCliked)
        
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "الاشعة" : "Rad", hideBack: false)
        imageViewSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(search)))
        if UserManager.isArabic {
            scrollView.transform = CGAffineTransform(scaleX: -1, y: 1)
            for sub in stackView.subviews {
                sub.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }
    }
    
    @objc func search() {
        doctors.removeAll()
        callAPI(indexFrom: 0, indexTO: pageSize, Statues: statues, dateFRom: nil, dateTo: nil)
        listOfFilterStatues.removeAll()
    }
    
    @objc func openFilter(sender : UITapGestureRecognizer) {
        
//        AppPopUpHandler.instance.initListPopup(container: self, arrayNames: UserManager.isArabic ?  listOfFilterStatues.map{$0.NAME_AR} : listOfFilterStatues.map{$0.NAME_EN} , title: "Choose", type: "")
//        let vc  = FilterLabRadViewController()
//        vc.listOfFilterStatues = listOfFilterStatues
//        vc.delegte = self
//        self.navigationController?.pushViewController(vc, animated: true)
        listOfFilterStatues.removeAll()
        listOfFilterStatues.append(labStatuesModel(ID: "R", NAME_AR: "يتم جدولتها", NAME_EN: "To be Scheduled"))
        listOfFilterStatues.append(labStatuesModel(ID: "M", NAME_AR: "علي الجهاز(بدأ الفحص)", NAME_EN: "On modality(Started)"))
        listOfFilterStatues.append(labStatuesModel(ID: "F", NAME_AR: "مؤكدة", NAME_EN: "Confirmed"))
        listOfFilterStatues.append(labStatuesModel(ID: "W", NAME_AR: "تحتاج موافقة", NAME_EN: "Waiting for Approval"))
        listOfFilterStatues.append(labStatuesModel(ID: "P", NAME_AR: "تمت المواققة", NAME_EN: "Approved"))
        
        let vc  = FilterLabRadViewController()
        vc.listOfFilterStatues = listOfFilterStatues
        vc.delegte = self
        AppPopUpHandler.instance.openVCPop(vc, height: 500, bottomSheet: true)
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
    
    func callAPI(indexFrom:Int , indexTO:Int,Statues:String?,dateFRom:String?,dateTo:String?){
        if Utilities.sharedInstance.getPatientId() == "" {
            Utilities.showLoginAlert(vc: self.navigationController!)
            return
        }
        let GetSessionInfo = ["STATUS":Statues ?? "",
                              "BranchID":"1",
                              "LanguageID":"1",
                              "ComputerName":"ios",
                              "UserID":"sd"]
        
        var GetRadReqHistoryloadParms = ["STATUS":Statues ?? "",
                                         "PatientId":Utilities.sharedInstance.getPatientId().trimmed,
                                         "Index_To":"\(indexTO)",
                                         "Index_From":"\(indexFrom)"]
        if dateTo ?? "" != "" {
            GetRadReqHistoryloadParms.updateValue(dateTo ?? "", forKey: "ToDate_STR_FORMATED")
        }
        if dateFRom ?? "" != "" {
            GetRadReqHistoryloadParms.updateValue(dateFrom ?? "", forKey: "FromDate_STR_FORMATED")
        }
        let pars = ["GetSessionInfo": GetSessionInfo , "GetRadReqHistoryloadParms": GetRadReqHistoryloadParms]
        print(pars)
        let url = URL(string: Constants.APIProvider.RadReqHistoryload)!
        let session = url.appendingQueryItem("GetSessionInfo", value: GetSessionInfo.toJsonString()).replacingOccurrences(of: Constants.APIProvider.RadReqHistoryload, with: "")
        let history = url.appendingQueryItem("GetRadReqHistoryloadParms", value: GetRadReqHistoryloadParms.toJsonString()).replacingOccurrences(of: Constants.APIProvider.RadReqHistoryload, with: "")
        
        let urlString = Constants.APIProvider.RadReqHistoryload + session + "&" + history
        
     
        indicator.sharedInstance.show()
        let urls = URL(string: urlString)
        let parseUrl = Constants.APIProvider.RadReqHistoryload + Constants.getoAuthValue(url: urls!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: parseUrl, parameters: nil, vc: self, encode: false) { (data, error) in
            if ((data as? [String: AnyObject]) ?? [:]).keys.contains("Root") {
                if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["RAD_PAT_HISTORY"] as? [String:AnyObject]{
                    if let appoins = root["RAD_PAT_HISTORY_ROW"] as? [[String: AnyObject]] {
                        for i in appoins{
                            if i["SERVSTATUS"] as? String ?? "" != "" {
                                self.doctors.append(LabRadDTO(JSON: i)!)
                            }
                        }
                    } else{
                        self.doctors.append(LabRadDTO(JSON: root["RAD_PAT_HISTORY_ROW"] as! [String: AnyObject])!)
                    }
                } else {
                }
            } else {
                if self.doctors.count == 0{
                    self.nc.post(name: Notification.Name("nodataFound"), object: nil)
                } else {
                    let x = (data as! [String: AnyObject])["message"] as! String
                    Utilities.showAlert(messageToDisplay: x)
                }
            }
            self.tableView.reloadData()
            if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["ORDER_STATUS_LIST"] as? [String:AnyObject] {
                if let appoins = root["ORDER_STATUS_LIST_ROW"] as? [[String: AnyObject]] {
                    for i in appoins {
                        self.listOfFilterStatues.append(labStatuesModel(JSON: i)!)
                    }
                } else {
                    self.listOfFilterStatues.append(labStatuesModel(JSON: root["ORDER_STATUS_LIST_ROW"] as! [String: AnyObject])!)
                }
            }
            if self.doctors.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.nc.post(name: Notification.Name("nodataFound"), object: nil)
                }
            } else {
                self.nc.post(name: Notification.Name("dataFound"), object: nil)
            }
            self.pdfDataWithTableView(tableView: self.tableView)
        }
    }
    
    @IBAction func shareWithWhatsapp(_ sender: Any) {
        let whatsappURL = URL(string:"whatsapp://app")!
        // this will make sure WhatsApp it is installed
        if UIApplication.shared.canOpenURL(whatsappURL) {
            let controller = UIActivityViewController(activityItems: [pdfUrl], applicationActivities: nil)
            present(controller, animated: true) {
                print("done")
            }
        }
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = UserManager.isArabic ? "الأشعة" : "Radiology"
//        UIView.appearance().semanticContentAttribute = !UserManager.isArabic ? .forceLeftToRight : .forceLeftToRight

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RadiologyVC: UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabsTableViewCell", for: indexPath) as! LabsTableViewCell
        if self.doctors[indexPath.row].PREPARE_DESC_AR != ""{
            if doctors[indexPath.row].readMore == false{
                let fontName = UserManager.isArabic  ? "Tajawal-Bold":"cairo_bold"
                let fnt = UIFont(name: "Tajawal-Bold", size: 14.0)
                let readmoreFont = UIFont(name: fontName, size: 14.0)
                      let readmoreFontColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                      DispatchQueue.main.async {
                          cell.labelAlert.addTrailing(with: " ", moreText: self.readMore, moreTextFont: readmoreFont ?? fnt!, moreTextColor: readmoreFontColor)
                      }
            }
            else{
                let readmoreFont = UIFont(name: "Tajawal-Medium", size: 13.0)
                      let readmoreFontColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                      DispatchQueue.main.async {
                          cell.labelAlert.addTrailingNoCut(with: " ", moreText: self.readMore, moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
                      }
            }
           
        }
        cell.isLab = false
        cell.delegate = self
        cell.delegateShow = self
        cell.configCell(doctor: doctors[indexPath.row])
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped(_:)))
        tap.numberOfTapsRequired = 1
        cell.labelAlert.tag = indexPath.row
        cell.labelAlert.isUserInteractionEnabled = true
        cell.labelAlert.addGestureRecognizer(tap)
        
      

        return cell
    }
    
    
    

        @objc func doubleTapped(_ recognizer: UITapGestureRecognizer) {

//            if  doctors[recognizer.view!.tag].readMore == true{
//                doctors[recognizer.view!.tag].readMore = false
//                self.readMore =   UserManager.isArabic ? ".....إقرآ المزيد" : ".....ReadMore"
//
//                
//            }
//            else{
//                doctors[recognizer.view!.tag].readMore = true
//                self.readMore =   UserManager.isArabic ? "  إقرآ اقل" : "  ReadLess"
//
//            }
//            tableView.reloadData()
            
            let vc = AlertPopupViewController()
            vc.text = UserManager.isArabic ? doctors[recognizer.view!.tag].PREPARE_DESC_AR : doctors[recognizer.view!.tag].PREPARE_DESC_EN
            let hight = UIScreen.main.bounds.size.height * 0.8
            AppPopUpHandler.instance.openVCPop(vc, height: hight)
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
                if ((tableView.contentOffset.y + tableView.frame.size.height) > tableView.contentSize.height)
                {
//                    if(pageCount * pageSize == doctors.count ){
                    pageCount+=1
                        callAPI(indexFrom: (doctors.count + 1) , indexTO: pageCount * pageSize, Statues: statues ,dateFRom: nil ,dateTo: nil )
                    }
                    
//                }
        }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "report"
        {
            let vc = segue.destination as! WebViewControllerVC
            vc.reportText = sender as! String
        }
    }
}

extension RadiologyVC: UITableViewDelegate ,LabRadCellDelagete{
    
    func CellClickedPacks(_ data: LabsTableViewCell) {
        checkChild(data.data)
        let pars = "Accession_no="+data.data!.aCCESSION_NO+"&BRANCH_ID=1"
        let urlString = Constants.APIProvider.getRadPacsUrl+pars
        print(data.data?.CHILD_ACCESSION_NOS ?? "" )
        if data.data?.CHILD_ACCESSION_NOS.isEmpty == false {
            print(data.data?.CHILD_ACCESSION_NOS ?? "" )
        }
        indicator.sharedInstance.show()
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.getRadPacsUrl + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: parseUrl, parameters: nil, vc: self) { (data, error) in
            let root = (data as? [String: AnyObject])?["result"] as? String ?? ""

//            let vc = WebViewControllerVC()
//            vc.reportText = root
//            self.navigationController?.pushViewController(vc, animated: true)
//            self.openWebsite(url: root)
//            let vc = WebViewViewController(root, showShare: false)
//            vc.pageTitle = UserManager.isArabic ? "النتيجة" : "Result"
//            self.navigationController?.pushViewController(vc, animated: true)
            
            let safariVC = SFSafariViewController(url: URL(string: root)!)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    func openRad(_ data: LabsTableViewCell) {
        checkChild(data.data)
        let pars = "Accession_no="+data.data!.aCCESSION_NO+"&BRANCH_ID=1"
        let urlString = Constants.APIProvider.getPacsUrl+pars
        indicator.sharedInstance.show()
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.getPacsUrl + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: parseUrl, parameters: nil, vc: self) { (data, error) in
            let root = (data as? [String: AnyObject])?["result"] as? String ?? ""
            
//            let vc = WebViewControllerVC()
//            vc.reportText = root
//            self.navigationController?.pushViewController(vc, animated: true)
//            self.openWebsite(url: root)
//            let vc = WebViewViewController(root, showShare: false)
//            vc.pageTitle = UserManager.isArabic ? "النتيجة" : "Result"
//            self.navigationController?.pushViewController(vc, animated: true)
            
           // guard let url = URL(string: root) else { return }
           // UIApplication.shared.open(url)
            let safariVC = SFSafariViewController(url: URL(string: root)!)
            self.present(safariVC, animated: true, completion: nil)
        }
        
    }
    
    
    func CellClicked(_ data: LabsTableViewCell) {
        checkChild(data.data)
        let pars = "Accession_no="+data.data!.aCCESSION_NO+"&BRANCH_ID=1" + "&SERVICE_ID=" + data.data!.sERVICE_ID
            + "&REQ_ID=" + data.data!.rEQ_ID + "&USER_ID=khabeer"

        let urlString = Constants.APIProvider.getPacsUrlPatient+pars
        indicator.sharedInstance.show()
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.getPacsUrlPatient + Constants.getoAuthValue(url: url!, method: "GET")
        let safariVC = SFSafariViewController(url: URL(string: parseUrl)!)
        self.present(safariVC, animated: true, completion: nil)
     //   navigationController?.pushViewController(WebViewViewController(parseUrl), animated: true)
    }
    
    private func checkChild(_ data:LabRadDTO?) {
//        if data?.CHILD_ACCESSION_NOS.isEmpty == false {
//            let child = data?.CHILD_ACCESSION_NOS.components(separatedBy: ",") ?? []
//            let check = child.first?.components(separatedBy: "-") ?? []
//            if check.last == "1" {
//                let vc = OutLabController()
//                vc.data = data
//               // vc.pdfBaseUrl = pdfBaseUrl
//                vc.isLab = false
//                navigationController?.pushViewController(vc, animated: true)
//                return
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if doctors[indexPath.row].readMore  == false{
//         return 300
//        }
//        else{
//            return UITableViewAutomaticDimension
//        }
//    }
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
extension RadiologyVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
//        let text =  UserManager.isArabic ?  "لم يتم العثور على نتائج الأشعة" : "No radiology results found !"
//        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:Color.darkGray]
//        
//        return NSAttributedString(string: text, attributes: attributes as [NSAttributedStringKey : Any])
//    }
}


extension RadiologyVC :returnTpLab
{
    func returnTpLabfunc(dateFrom: String, dateTo: String) {
        self.doctors.removeAll()

        callAPI(indexFrom: 0 , indexTO: pageSize, Statues: nil,dateFRom: dateFrom,dateTo: dateTo)
        
    }
    
    
}
extension UILabel {

        func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
            let readMoreText: String =   moreText

            let lengthForVisibleString: Int = self.vissibleTextLength
            let mutableString: String = self.text!
            
            print("lengthForVisible")
            print(lengthForVisibleString)
//
            let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.characters.count)! - lengthForVisibleString)), with: "")
            print("trimmedString")
            print(trimmedString)
            let readMoreLength: Int = (readMoreText.characters.count)
            print("readMoreLength")
            print(readMoreLength)
            let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.characters.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
            print("trimmedForReadMore")
            print(trimmedForReadMore)
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }
    
    func addTrailingNoCut(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
       



        let lengthForVisibleString: Int = self.vissibleTextLength
        print("lengthForVisibleString Arabbic ArabbicArabbicArabbic")

        print(lengthForVisibleString)
        let mutableString: String = self.text!
        
//
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.unicodeScalars.count)! - lengthForVisibleString)), with: "")
     
    
        let answerAttributed = NSMutableAttributedString(string: trimmedString ?? "", attributes: [NSAttributedString.Key.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }

        var vissibleTextLength: Int {
            let font: UIFont = self.font
            let mode: NSLineBreakMode = self.lineBreakMode
            let labelWidth: CGFloat = self.frame.size.width
            let labelHeight: CGFloat = self.frame.size.height
            let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

            let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
            let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int = 0
                print(CharacterSet.whitespacesAndNewlines)
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == NSLineBreakMode.byCharWrapping {
                        index += 1
                    } else {
                        index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.unicodeScalars.count - index - 1)).location
                    }
                } while index != NSNotFound && index < self.text!.unicodeScalars.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
                return prev
            }
            return self.text!.unicodeScalars.count
        }
    }

extension UIViewController {
    
    func openWebsite(url:String) {
        if let mobileCallUrl = URL(string: url) {
            let application = UIApplication.shared
            if application.canOpenURL(mobileCallUrl) {
                UIApplication.shared.open(URL(string : url)!, options: [:], completionHandler: { (status) in
                })
            } else {
                let alert = UIAlertController(title: "Alert", message: "Can't open this site", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "Can't open this site", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
