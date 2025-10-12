//
//  SaveViewController.swift
//  CareMate
//
//  Created by MAC on 18/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class SaveViewController: BaseViewController ,ListPopupDelegate{
    func listPopupDidSelect(index: Int, type: String) {
     
     
        
        if type == "Report"
        {
            labelVisitChosseText.text = UserManager.isArabic ?  listOfReports[index].NAME_AR : listOfReports[index].NAME_EN
            reportId = listOfReports[index].ID
            objectSave?.flReportPrintRequest?[0].reportTemplateCode = listOfReports[index].ID
            
            objectSave?.flReportPrintRequest?[0].repType = listOfReports[index].REP_TYPE
            
        }
        else
        {
            labelVisit.text = UserManager.isArabic ?  listOfVisit[index].NAME_AR : listOfVisit[index].NAME_EN
            visitId = listOfVisit[index].ID
            objectSave?.flReportPrintRequest?[0].visitID = listOfVisit[index].ID
            objectSave?.flReportPrintRequest?[0].visitIDForReport = listOfVisit[index].ID

            visitId = listOfVisit[index].ID
        }
    }
    
    let group = DispatchGroup()
    
    @IBOutlet weak var labelVisitText: UILabel!
    @IBOutlet weak var labelVisitChosseText: UILabel!
    @IBOutlet weak var labelReportText: UILabel!
    @IBOutlet weak var labelAuthText: UILabel!
    @IBOutlet weak var labelVisitReqieusText: UILabel!
    @IBOutlet weak var labelNotesText: UILabel!
    @IBOutlet weak var viewSave: UIView!
    @IBOutlet weak var labelVisit: UILabel!
    @IBOutlet weak var textFieldNotes: UITextField!
    @IBOutlet weak var textFieldAuthrized: UITextField!
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var viewVisit: UIView!
    @IBOutlet weak var viewAuthrized: UIView!
    @IBOutlet weak var viewAPerson: UIView!
    @IBOutlet weak var labelNeddSupport: UILabel!
    @IBOutlet weak var labelNext: UILabel!
    @IBOutlet weak var uiswitch: UISwitch!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelPhoto: UILabel!
    @IBOutlet weak var imageViewAccept: UIImageView!
    @IBOutlet weak var labelAgree: UILabel!
    @IBOutlet weak var labelTerms: UILabel!
    
    var visitId = ""
    var hospID = ""
    var image: UIImage?


    var listOfVisit = [visitDTO]()
    var listOfReports = [REPORTSDTO]()
    var objectSave:saveReportRequest?
   
    var reportId = ""
    var yesOrNo:String?
    var needSign = "0"

    var policyAccepted = false

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
        viewReport.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewAPerson.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewAuthrized.makeShadow(color: .black, alpha: 0.14, radius: 4)
     
        uiswitch.onTintColor = #colorLiteral(red: 0.1346794665, green: 0.5977677703, blue: 0.5819112062, alpha: 1)
        uiswitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)

        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "طلب تقرير" :"Request Report" , hideBack: false)
        indicator.sharedInstance.show()
        getdata()
        getdataREPORTREQUEST()
        group.notify(queue: .main) {
            indicator.sharedInstance.dismiss()
     
        }
        if UserManager.isArabic
        {
            labelReportText.text = "نوع التقرير"
            labelVisitText.text = "زياره"
            labelAuthText.text = "الشخص الموفوض الاستلام"
            labelVisitReqieusText.text = "الشخص المفوض لاستلام التقرير"
            labelNotesText.text = "الملاحظات"
            labelVisitChosseText.text = "اختار التقرير"
            textFieldNotes.placeholder = "اكتب ملاحظاتك"
            textFieldAuthrized.placeholder = "اكتب اسم الشخص"
            labelNeddSupport.text = "يحتاج توقيع"
            labelNext.text = "حفظ"
            labelPhoto.text = "صورة الهوية للشخص المفوض لاستلام التقرير"
            labelTerms.text = " على الشروط والأحكام"
            labelAgree.text = "انا اوفق"
        }
        else{
            labelReportText.text = "Report"
            labelVisitText.text = "Visit"
            labelAuthText.text = "Person Authorized to receive"
            labelVisitReqieusText.text = "The Person Who is Authorized to Get The Report"
            labelNotesText.text = "Notes"
            labelVisitChosseText.text = "Choose Report"
            textFieldNotes.placeholder = "Write Your Notes"
            textFieldAuthrized.placeholder = "Write Person Name"
            labelNeddSupport.text = "Need Sign"
            labelNext.text = "Next"
            labelTerms.text = "the Terms and Conditions"
            labelAgree.text = "I Accept"
        }
   
     
        
        let gestureReport = UITapGestureRecognizer(target: self, action:  #selector(self.openReport))
        self.viewReport.addGestureRecognizer(gestureReport)
        
        let gestureVisit = UITapGestureRecognizer(target: self, action:  #selector(self.openVisitfunc))
        self.viewVisit.addGestureRecognizer(gestureVisit)
        
        imageViewPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addImage)))
        
        let gestureSave = UITapGestureRecognizer(target: self, action:  #selector(self.saveVisit))
        self.viewSave.addGestureRecognizer(gestureSave)
        
        
        objectSave = saveReportRequest(flParms: FLParms(), flReportPrintRequest: [FLReportPrintRequest()])
        
        objectSave?.flReportPrintRequest?[0].patientid = Utilities.sharedInstance.getPatientId()
        
        objectSave?.flReportPrintRequest?[0].hospID = "1"
        objectSave?.flReportPrintRequest?[0].bufferStatus = "1"
        
        objectSave?.flParms?.branchID = "1"
        objectSave?.flParms?.computerName = "DESKTOP-LR3BK6G"
        objectSave?.flParms?.userID = "KHABEER"
        
        imageViewAccept.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(acceptPolicy)))
        labelTerms.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTerms)))
    }
    
    @objc func openTerms() {
        let vc = termsAndConditionVC()
        vc.typeTerms2 = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func acceptPolicy() {
        if policyAccepted == false {
            policyAccepted =  true
            imageViewAccept.image = UIImage(named: "dignosisSelected.png")
        } else {
            policyAccepted =  false
            imageViewAccept.image = UIImage(named: "additinakDataDiagnosisSeleected.png")
        }
    }
    
    @IBAction func switchChagned(_ sender: Any) {
        print("switch Changed")
        if needSign == "0"
        {
            needSign = "1"
        }
        else if needSign == "1"{
            needSign = "0"
        }
    }
    
    @objc func openVisit(sender : UITapGestureRecognizer) {
        AppPopUpHandler.instance.initListPopup( container: self, arrayNames: UserManager.isArabic ? self.listOfVisit.map{$0.NAME_AR} :self.listOfVisit.map{$0.NAME_EN}, title: UserManager.isArabic ? "اختار الزيارة" : "Choose Visit", type: "Visit")
    }
    @objc func openReport(sender : UITapGestureRecognizer) {
        AppPopUpHandler.instance.initListPopup( container: self, arrayNames: UserManager.isArabic ? self.listOfReports.map{$0.NAME_AR} :self.listOfReports.map{$0.NAME_EN}, title: UserManager.isArabic ?  "اختار التقرير":"Choose Report", type: "Report")
        
    }
    
    @objc func saveVisit(sender : UITapGestureRecognizer) {
        if reportId == "" {
            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "من فضلك اختر نوع التقرير" : "Please choose report type")
            return
        } else if textFieldAuthrized.text?.trimmed != "" && image == nil {
//            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "من فضلك اكتب اسم الشخص المفوض" : "Please write the name of the authorized person")
            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "من فضلك اختر صورة الشخص المفوض" : "Please choose the image of the authorized person")
            return
        } else if !policyAccepted {
            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "الرجاء الموافقة علي الشروط والاحكام" : "Please accept terms and conditions")
            return
        }
        let branchID = hospID.isEmpty ? objectSave?.flParms?.branchID ?? "":hospID
        var pars: [String: Any] = ["_FL_PARMS": ["PATIENT_ID": Utilities.sharedInstance.getPatientId(),
                                                 "USER_ID": objectSave?.flParms?.userID ?? "",
                                                 "COMPUTER_NAME": objectSave?.flParms?.computerName ?? "",
                                                 "BRANCH_ID":branchID]]
        let dic: [String: Any] = ["REPORT_TEMPLATE_CODE":  objectSave?.flReportPrintRequest?[0].reportTemplateCode ?? "",
                   "BUFFER_STATUS": 1,
                   "REP_TYPE": objectSave?.flReportPrintRequest?[0].repType ?? "",
                   "VISIT_ID_FOR_REPORT": visitId,
                   "NOTES": objectSave?.flReportPrintRequest?[0].notes ?? "",
                  "NEED_SIGN": self.needSign,
                   "HOSP_ID": objectSave?.flReportPrintRequest?[0].hospID ?? "",
                   "PATIENTID": objectSave?.flReportPrintRequest?[0].patientid ?? "",
                   "VISIT_ID": visitId,
                    "BRANCH_ID": branchID,
                   "SERIAL": "721",
                                  "DELIGATED_PERSON": textFieldAuthrized.text!]
        pars.updateValue([dic], forKey: "_FL_REPORT_PRINT_REQUEST")
//                    "_FL_REPORT_PRINT_REQUEST": [["REPORT_TEMPLATE_CODE": objectSave?.flReportPrintRequest?[0].reportTemplateCode ?? "",
//                                                  "BUFFER_STATUS": 1,
//                                                  "REP_TYPE":objectSave?.flReportPrintRequest?[0].repType ?? "",
//                                                  "VISIT_ID_FOR_REPORT": visitId,
//                                                  "NOTES": objectSave?.flReportPrintRequest?[0].notes ?? "",
//                                                 "NEED_SIGN": self.needSign,
//                                                  "HOSP_ID": objectSave?.flReportPrintRequest?[0].hospID ?? "",
//                                                  "PATIENT_ID": objectSave?.flReportPrintRequest?[0].patientid ?? "",
//                                                  "VISIT_ID": visitId,
//                                                  "BRANCH_ID": objectSave?.flParms?.branchID ?? "",
//                                                  "SERIAL": "721"]]] as [String : Any]
        if image != nil {
            pars.updateValue("\(image!.getBase64())", forKey: "signBase64")
        }
            let urlString = Constants.APIProvider.PRINTREPORTSUBMIT
            let url = URL(string: urlString)
    //        let parseUrl = Constants.APIProvider.SubmitStepNew + Constants.getoAuthValue(url: url!, method: "POST",parameters: pars)
        print(pars)
            WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self) { (data, error) in
//                let root = data as! [String:Any]
//                print(root)
//                if "\(root["Code"] ?? 0)" == "1" {
//                    self.nc.post(name: Notification.Name("dataFound"), object: nil)
//                    OPEN_HINT_POPUP(container: self, message: "\(root["message"] ?? "")", dismiss: false) {
//                        if let nav = self.navigationController {
//                            nav.popToViewController(nav.viewControllers[nav.viewControllers.count - 3], animated: true)
//                        }
//                    }
//                } else {
//                    OPEN_HINT_POPUP(container: self, message: "\(root["message"] ?? "")")
//                }
                self.nc.post(name: Notification.Name("dataFound"), object: nil)
                OPEN_HINT_POPUP(container: self, message: "\(UserManager.isArabic ? "تم الحفظ بنجاح" : "Save sucess")", dismiss: false) {
                    if let nav = self.navigationController {
                        nav.popToViewController(nav.viewControllers[nav.viewControllers.count - 3], animated: true)
                    }
                }
            }
    }
    @objc func openVisitfunc(sender : UITapGestureRecognizer) {
        AppPopUpHandler.instance.initListPopup( container: self, arrayNames: UserManager.isArabic ? self.listOfVisit.map{$0.NAME_AR} :self.listOfVisit.map{$0.NAME_EN}, title: UserManager.isArabic ? "Choose Visit" : "اختار الزيازه", type: "Visit")
    }
  
    @IBAction func noCliked(_ sender: Any) {
        objectSave?.flReportPrintRequest?[0].needSign = "1"
    
        
        
    }
    @IBAction func yesCliked(_ sender: Any) {
        objectSave?.flReportPrintRequest?[0].needSign = "2"
       
    }
    

    func getdata() {
        
        group.enter()
        let urlString = Constants.APIProvider.getVisitForPatient + "PATIENT_ID=986"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self, showIndicator: false) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["VISIT"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["VISIT_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["VISIT_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.listOfVisit.append(visitDTO(JSON: i)!)
                      
                        
                    }
                    }
                    else if root["VISIT_ROW"] is [String:AnyObject]
                    {
                        self.listOfVisit.append(visitDTO(JSON:root["VISIT_ROW"] as![String:AnyObject] )!)
                     
                        
                    }
                  
                    
                }
                else
                 {
                }
            }

            self.group.leave()

           
        }
    }

    func getdataREPORTREQUEST() {
        
        group.enter()
        let urlString = Constants.APIProvider.LOADPRINTREPORTREQUEST + "PATIENT_ID=986&BRANCH_ID=1&VISIT_ID=1&USER_ID=KHABEER"
        let url = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.PatInvoices + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self, showIndicator: false) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["REPORTS"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["REPORTS_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["REPORTS_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.listOfReports.append(REPORTSDTO(JSON: i)!)
                      
                        
                    }
                    }
                    else if root["REPORTS_ROW"] is [String:AnyObject]
                    {
                        self.listOfReports.append(REPORTSDTO(JSON:root["REPORTS_ROW"] as![String:AnyObject] )!)
                     
                        
                    }
                  
                    
                }
                else
                 {
                }
            }

            self.group.leave()

           
        }
    }
    
    @objc func addImage() {
        let alert = UIAlertController(title: "", message: UserManager.isArabic ? "اختر الطريقة" : "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: UserManager.isArabic ? "الكاميرا" : "Camera", style: .default , handler:{ (UIAlertAction)in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: UserManager.isArabic ? "المعرض" : "Gallery", style: .default , handler:{ (UIAlertAction)in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: UserManager.isArabic ? "إلغاء" : "Cancel", style: .cancel , handler:{ (UIAlertAction)in
            
        }))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
        }
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

extension SaveViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            imageViewPhoto.image = image
            self.image = image
        }
    }
}

extension UILabel{
    
    open override func awakeFromNib() {
        if UserManager.isArabic{
            self.textAlignment = .right
        } else {
            self.textAlignment = .left
        }
    }
}

extension UIImage {
    
    func getBase64() -> String {
        let imageData:NSData = self.getThumbnial().jpeg(.highest)! as NSData
        let imageBase64 = imageData.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        var imageString = String(data: imageBase64 as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        imageString = imageString.replacingOccurrences(of: " ", with: "")
        imageString = imageString.replacingOccurrences(of: "\n", with: "")
//        imageString = "data:image/png;base64," + imageString
        return imageString
    }
    
    func getThumbnial() -> UIImage {
        var width:CGFloat = 0.0
        var height:CGFloat = 0.0
        if self.size.width > 512 {
            width = 512
            let ratio = self.size.width / width
            height = self.size.height / ratio
        } else {
            width = self.size.width
            height = self.size.height
        }
        let originalImage = self
        let destinationSize = CGSize.init(width: width, height: height)
        UIGraphicsBeginImageContext(destinationSize)
        originalImage.draw(in: CGRect.init(x: 0, y: 0, width: destinationSize.width, height: destinationSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
