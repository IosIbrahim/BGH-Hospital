//
//  LabResultController.swift
//  CareMate
//
//  Created by Yo7ia on 4/2/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//


import UIKit
import DZNEmptyDataSet
import TPPDF
import ObjectMapper
class LabResultController: BaseViewController ,UISearchBarDelegate, showPanicIfon,UIWebViewDelegate{
        
    @IBOutlet weak var pdfView: UIWebView!
    
    var pdfUrl:URL?
   var  aCCESSION_NO = ""
    var listPfPdf = [listPfPdfResult]()
    var pdfBaseUrl = ""
    var clinicsServiceReportPDFUrl: String?
    var data: LabRadDTO?
    var rxModel:RxModel?
    let document = PDFDocument(format: .a4)
    
    func showPanicIfonfunc(_Objc: LabReportDTO?) {
        let pdfFilePath = URL(string:"\(Constants.APIProvider.PrimeCareTempFiles)/\(Constants.APIProvider.SIHORPriceCare) ClaimPDFIOS\(self.aCCESSION_NO)/fileIOS\(self.aCCESSION_NO).pdf")
        print(pdfFilePath?.absoluteString ?? "")
        let pdfData = NSData(contentsOf: pdfFilePath!)
        let activityVC = UIActivityViewController(activityItems: [pdfData!], applicationActivities: nil)

        present(activityVC, animated: true, completion: nil)
    }
   
    func webViewDidFinishLoad(webView: UIWebView) {
    let zoom = webView.bounds.size.width / webView.scrollView.contentSize.width

    webView.scrollView.setZoomScale(zoom, animated: true)
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
        if let clinicsServiceReportPDFUrl {
            let link = URL(string: clinicsServiceReportPDFUrl)!
            let sharedObjects:[AnyObject] = [link as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.mail]
            
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            var pdfURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            pdfURL = pdfURL.appendingPathComponent("LabPDF.pdf") as URL
            
            self.sharePdf(path: pdfURL)
        }
    }
    
    func sharePdf(path:URL) {

        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: path.path) {
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [path], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            print("document was not found")
            let alertController = UIAlertController(title: "Error", message: "Document was not found!", preferredStyle: .alert)
            let defaultAction = UIAlertAction.init(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(defaultAction)
//            UIViewController.hk_currentViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var doctors = [LabReportDTO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("dataFound"), object: nil)
        pdfView.scalesPageToFit = true
        pdfView.contentMode = UIViewContentMode.scaleAspectFit
        UserDefaults.standard.set("IOS\(aCCESSION_NO)", forKey: "folderName")
        UserDefaults.standard.set("fileIOS\(aCCESSION_NO)", forKey: "fileName")
        if let clinicsServiceReportPDFUrl {
            let link = URL(string: clinicsServiceReportPDFUrl)!
            let request = URLRequest(url: link)
            DispatchQueue.main.async {
                self.pdfView.loadRequest(request)
            }
        } else {
            DispatchQueue.main.async {
                self.generatPdfFromUrl()
            }
        }
        
    }
    
    func generatPdfFromUrl(){
        
//
        var urlString = "\(Constants.APIProvider.APIBaseURL)/LaboratoryController/generatePdf?R_LANG=2&USER_ID=KHABEER&SECURITYLEVEL=0&PRINT_DELV_RESULT=1&BRANCH_ID=1&print=undefined&ClearCache=1&SavePDF=1&PDFFOLDERNAME=IOS\(aCCESSION_NO)&PDFFILENAME=fileIOS\(aCCESSION_NO)"
        if data?.mICROBIOLOGY_SERV ?? "" == "1" {
            urlString += "&R_NAME=ReportsDLL.Laboratory.rpt_LABORATORY_WRITE_RESULT_culture_services_result_print&ACCESSION_NO=\(aCCESSION_NO)"
        } else if data?.pATHOLOGY_SERV ?? "" == "1" {
            urlString += "&R_NAME=ReportsDLL.Laboratory.rpt_LABORATORY_WRITE_RESULT_get_services_result_print_patholoyg&P_IDENTFIER=\(aCCESSION_NO)"
        } else {
            urlString += "&R_NAME=ReportsDLL.Laboratory.rpt_LABORATORY_WRITE_RESULT_get_services_result_print&P_IDENTFIER=\(aCCESSION_NO)"
        }
        
        if rxModel != nil {
            aCCESSION_NO = rxModel?.GEN_SERIAL ?? ""
            urlString = "\(Constants.APIProvider.APIBaseURL)LaboratoryController/generatePdf?R_LANG=2&USER_ID=KHABEER&SECURITYLEVEL=0&PRINT_DELV_RESULT=1&BRANCH_ID=1&print=undefined&ClearCache=1&SavePDF=1&PDFFOLDERNAME=\(aCCESSION_NO)&P_GEN_SERIAL=\(rxModel?.GEN_SERIAL ?? "")&R_NAME=ReportsDLL.Stock.rpt_STOCK_PRESCRIPTION_PrescriptionPrint&PDFFILENAME=\(rxModel?.GEN_SERIAL ?? "")"
        }
        print(urlString)
        _ = URL(string: urlString)
        urlString += "&" + Constants.getoAuthValue(url: URL(string: "\(Constants.APIProvider.APIBaseURL)/LaboratoryController/generatePdf")!, method: "GET")
        
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
       
            var link = URL(string:"\(Constants.APIProvider.IMAGE_BASE)/ImagesStore/ReportPDFS/ClaimPDFIOS\(self.aCCESSION_NO)/fileIOS\(self.aCCESSION_NO).pdf")!
            var saveLink = "\(Constants.APIProvider.IMAGE_BASE)/ImagesStore/ReportPDFS/ClaimPDFIOS\(self.aCCESSION_NO)/fileIOS\(self.aCCESSION_NO).pdf"
            if self.rxModel != nil {
           //     https://patientmobapp.alsalamhosp.com/MobileApitest//ImagesStore/ReportPDFS/ClaimPDF738749/891050.pdf
                link = URL(string:"\(Constants.APIProvider.IMAGE_BASE)/ImagesStore/ReportPDFS/ClaimPDF\(self.aCCESSION_NO)/\(self.rxModel?.GEN_SERIAL ?? "").pdf")!
                saveLink = "\(Constants.APIProvider.IMAGE_BASE)/ImagesStore/ReportPDFS/ClaimPDF\(self.aCCESSION_NO)/\(self.rxModel?.GEN_SERIAL ?? "").pdf"
            }
            print(saveLink)
            self.savePdfOnFileMnager(urlString: saveLink)

            let nc = NotificationCenter.default
            self.pdfUrl = link
            let request = URLRequest(url: link)
            DispatchQueue.main.async {
                self.pdfView.loadRequest(request)
            }
            nc.post(name: Notification.Name("dataFound"), object: nil)
        }
    }
    
    func savePdfOnFileMnager(urlString:String){
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "LabPDF.pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
            } catch {
                print("Pdf could not be saved")
            }
        }
    }
    
    func handelPDf(){
        let colors = (fill: UIColor.white, text: UIColor.black)
        let lineStyle = PDFLineStyle(type: .full, color: UIColor.clear, width: 3)
        let borders = PDFTableCellBorders(left: lineStyle, top: lineStyle, right: lineStyle, bottom: lineStyle)
        let font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)!
        let style = PDFTableCellStyle(colors: colors, borders: borders, font: font)
        
        let tableForHeader = PDFTable(rows: 1, columns: 4)
        tableForHeader[0,0].style = style
        tableForHeader[0,1].style = style
        tableForHeader[0,2].style = style
        tableForHeader[0,3].style = style
        
        let tableForHeaderrow0cel01 = tableForHeader[rows: 0,columns:1...2]
        tableForHeaderrow0cel01.merge()
        tableForHeader.content = [
            [UIImage(named: "Al-Salam-Hospital (1)")!, nil, "Al Salam Laboratory Report" ,UIImage(named: "barcode")!],
           ]

        document.add(table: tableForHeader)
        
        // Create Patine Info Table
        let table = PDFTable(rows: 8, columns: 8)
        
        
        let colorsForPatientInfonRow1 = (fill: UIColor.white, text: UIColor.black)
        let lineStyleForPatientInfonRow1 = PDFLineStyle(type: .full, color: UIColor.black, width: 2)
        let bordersForPatientInfonRow1 = PDFTableCellBorders(left: lineStyleForPatientInfonRow1, top: lineStyleForPatientInfonRow1, right: lineStyleForPatientInfonRow1, bottom: lineStyleForPatientInfonRow1)
        let fontForPatientInfonRow1  = UIFont(name:"HelveticaNeue-Bold", size: 15.0)!
        let styleForPatientInfonRow1 = PDFTableCellStyle(colors: colorsForPatientInfonRow1, borders: bordersForPatientInfonRow1, font: fontForPatientInfonRow1)
        for i in 0...7
        {
            for x in 0...7
            {
                table[i,x].style = styleForPatientInfonRow1

            }
        }
        
        // handel row one
        let row0cel25 = table[rows: 0,columns:2...7]
        row0cel25.merge()
        let row0cel01 = table[rows: 0,columns:0...1]
        row0cel01.merge()
        // handel row two
        let row1cel01 = table[rows: 1,columns:0...1]
        row1cel01.merge()
        let row1cel45 = table[rows: 1,columns:4...5]
        row1cel45.merge()
        
        // handel row there
        let row2cel01 = table[rows: 2,columns:0...1]
        row2cel01.merge()
        let row2cel23 = table[rows: 2,columns:2...4]
        row2cel23.merge()
        
        let row2cel67 = table[rows: 2,columns:6...7]
        row2cel67.merge()
        
        // handel row Four
        let row3cel01 = table[rows: 3,columns:0...1]
        row3cel01.merge()
        let row3cel23 = table[rows: 3,columns:2...4]
        row3cel23.merge()
        
        let row3cel67 = table[rows: 3,columns:6...7]
        row3cel67.merge()

        // handel row five
        let row4cel01 = table[rows: 4,columns:0...1]
        row4cel01.merge()
        let row4cel23 = table[rows: 4,columns:2...4]
        row4cel23.merge()
        
        let row4cel67 = table[rows: 4,columns:6...7]
        row4cel67.merge()
        
        
        // handel row six
        let row5cel01 = table[rows: 5,columns:0...1]
        row5cel01.merge()
        let row5cel23 = table[rows: 5,columns:2...4]
        row5cel23.merge()
        
        let row5cel67 = table[rows: 5,columns:6...7]
        row5cel67.merge()
        
        
        // handel row seven
        let row6cel01 = table[rows: 6,columns:0...1]
        row6cel01.merge()
        let row6cel23 = table[rows: 6,columns:2...4]
        row6cel23.merge()
        
        let row6cel67 = table[rows: 6,columns:6...7]
        row6cel67.merge()

        // handel row eight
        let row7cel01 = table[rows: 7,columns:0...1]
        row7cel01.merge()
        let row7cel67 = table[rows: 7,columns:2...7]
        row7cel67.merge()
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {
                table.content = [
                    [nil,  "Patient Name" , nil,nil,nil,nil,nil,"\(loadedPerson.COMPLETEPATNAME_EN)"],
                    [nil,  "Patient MRN" , self.listPfPdf[0].PATIENTID,"Age",nil,self.listPfPdf[0].AGE_DESC_EN,"Gender",self.listPfPdf[0].GENDER_NAME_EN],
                    [nil,  "Request Time" , nil,nil,self.listPfPdf[0].REQ_DATE,"Collection Time",nil,self.listPfPdf[0].SAMPLE_COLL_DATE],
                    [nil,  "Request Reporting" , nil,nil,self.listPfPdf[0].RESULT_DATE,"Order Number",nil,self.listPfPdf[0].REQ_ID],
                    [nil,  "Patient Type" , "d","df",self.listPfPdf[0].VISIT_TYPE_NAME_EN,"Collection Site",nil,self.listPfPdf[0].PLACE_NAME_EN],
                    [nil,  "Ref Doctor DR/" , "d","df",listPfPdf[0].DONEDOC_NAME_EN,"Barcode Number",nil,self.listPfPdf[0].BARCODE_NUMBER],
                    [nil,  "Civil Id" , "d","df",listPfPdf[0].CIVIL_ID,"Mobile Number",nil,listPfPdf[0].PAT_MOBILE],
                    [nil,  "Patient FC" , "d","dfs","ksda","sq",nil,listPfPdf[0].CONTRACT_NAME_EN],
                           ]
                }
        }
        document.add(.contentLeft, text: "unit CLINICAL CHEMISTRY")
        document.add(table: table)
        let generator = PDFGenerator(document: document)
        do {
            self.pdfUrl = try? generator.generateURL(filename: "Example.pdf")
            pdfView.loadRequest(URLRequest(url: self.pdfUrl!))
          } catch {
              print(error)
          }
    }
    
    func getdata() {
 

        var urlString = Constants.APIProvider.loadServiceResult + "P_IDENTFIER=\(aCCESSION_NO)&USER_ID=KHABEER"
        let url = URL(string: urlString)
        
//        urlString =   urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
           
            if error == nil
            {
                let root = (data as! [String: AnyObject])["Root"] as! [[String:AnyObject]]
                
                for item in root
                {
                    print("itemitemitemitem")
                    print(item)
                 
                    self.listPfPdf.append(listPfPdfResult(JSON: item)!)
                    print("listOfPDFCount")
                    print(self.listPfPdf.count)

                }
                self.handelPDf()
            }


           
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.title = UserManager.isArabic ? "المعمل" : "Lab"
        if rxModel != nil {
            initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "الوصفة الطبية" : "Prescription", hideBack: false)
        }else if let clinicsServiceReportPDFUrl {
            initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "التقرير" : "The Report", hideBack: false)
        } else {
            initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "نتائج المعمل" : "Lab Results", hideBack: false)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension LabResultController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabResultCell", for: indexPath) as! LabResultCell
        cell.configCell(slot: doctors[indexPath.section])
        cell.delegate = self
        return cell
    }
}

extension LabResultController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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

//loadServiceResult
extension LabResultController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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

struct listPfPdfResult : Mappable {
    var CONSULTDOC_NAME_AR : String = ""
    var AGE_DESC_EN : String = ""
    var GENDER_NAME_EN : String = ""
    var PATIENTID : String = ""
    var REQ_DATE : String = ""
    var SAMPLE_COLL_DATE : String = ""
    var REQ_ID : String = ""
    var RESULT_DATE : String = ""

    var VISIT_TYPE_NAME_EN : String = ""
    var PLACE_NAME_EN : String = ""

    var DONEDOC_NAME_EN : String = ""
    var BARCODE_NUMBER : String = ""

    var CIVIL_ID : String = ""
    var PAT_MOBILE : String = ""
    var CONTRACT_NAME_EN : String = ""

    
    
    
    
//    var CLINIC_NAME_EN : String = ""
//    var CLINIC_NAME_AR : String = ""
//    var EMP_EN_DATA : String = ""
//    var EMP_AR_DATA : String = ""
//    var NAME_EN : String = ""
//    var NAME_AR : String = ""
//    var VISIT_START_DATE : String = ""
//    var ID : String = ""
//    var VISIT_ID : String = ""

    
    
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        CONSULTDOC_NAME_AR <- map["CONSULTDOC_NAME_AR"]
        AGE_DESC_EN <- map["AGE_DESC_EN"]
        GENDER_NAME_EN <- map["GENDER_NAME_EN"]
        PATIENTID <- map["PATIENTID"]
        REQ_DATE <- map["REQ_DATE"]
        SAMPLE_COLL_DATE <- map["SAMPLE_COLL_DATE"]

        REQ_ID <- map["REQ_ID"]
        RESULT_DATE <- map["RESULT_DATE"]
        PLACE_NAME_EN <- map["PLACE_NAME_EN"]

        VISIT_TYPE_NAME_EN <- map["VISIT_TYPE_NAME_EN"]
        DONEDOC_NAME_EN <- map["DONEDOC_NAME_EN"]
        BARCODE_NUMBER <- map["BARCODE_NUMBER"]
        CIVIL_ID <- map["CIVIL_ID"]
        PAT_MOBILE <- map["PAT_MOBILE"]
        CONTRACT_NAME_EN <- map["CONTRACT_NAME_EN"]

        
        
        
//        CLINIC_NAME_EN <- map["CLINIC_NAME_EN"]
//        CLINIC_NAME_AR <- map["CLINIC_NAME_AR"]
//        EMP_EN_DATA <- map["EMP_EN_DATA"]
//        EMP_AR_DATA <- map["EMP_AR_DATA"]
//        NAME_EN <- map["NAME_EN"]
//        NAME_AR <- map["NAME_AR"]
//        VISIT_START_DATE <- map["VISIT_START_DATE"]
//        ID <- map["ID"]
//        VISIT_ID <- map["VISIT_ID"]
    
    }
    
}
func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}
