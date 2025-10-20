//
//  SaveCompliansViewController.swift
//  CareMate
//
//  Created by MAC on 06/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class SaveCompliansViewController: BaseViewController,ListPopupDelegate {
    func listPopupDidSelect(index: Int, type: String) {
        if type == "Visit"
        {
            viewHideVisit.isHidden = true
            visitId = listOfVisit[index].ID
            let object = listOfVisit[index]
            visitType.text = UserManager.isArabic ? object.CLASSNAME_AR : object.CLASSNAME_EN
            if visitType.text == "" {
                visitType.text = object.CLASSNAME
            }
            date.text = object.VISIT_START_DATE
            healer.text = UserManager.isArabic ?  object.EMP_AR_DATA  : object.EMP_EN_DATA
            place.text =       UserManager.isArabic ?  object.SPECIALITY_NAME_AR  : object.SPECIALITY_NAME_EN
        }
        else if type == "complaintTypeList"
        {
            labelcomplaintType.text =  UserManager.isArabic ?  complaintTypeList[index].NAME_AR : complaintTypeList[index].NAME_EN
            COMPLAINT_TYPE = complaintTypeList[index].ID
        }
        else
        {
            labelcomplaintCategoty.text =  UserManager.isArabic ?  complaintCategoryList[index].NAME_AR : complaintCategoryList[index].NAME_EN
            categoryId = complaintCategoryList[index].ID
        }
        
        
    }
    
    let group = DispatchGroup()
    var listOfVisit = [visitDTO]()
    var complaintTypeList = [visitDTO]()
    var complaintCategoryList = [visitDTO]()
    
    var categoryId:String?
    var visitId:String?
    var COMPLAINT_TYPE:String?
    var COMPLAINT_PRIORITY:String?

    
    @IBOutlet weak var selectedComplainTypeLabel: UILabel!
    @IBOutlet weak var complaintType: UIView!
    @IBOutlet weak var complaintCategoty: UIView!
    @IBOutlet weak var uiviewNotes: UIView!

    @IBOutlet weak var save: UIView!

    @IBOutlet weak var viewVisit: UIView!
    @IBOutlet weak var labelVisit: UILabel!
    @IBOutlet weak var labelcomplaintType: UILabel!
    @IBOutlet weak var labelcomplaintCategoty: UILabel!
  
    @IBOutlet weak var imageNormal: UIImageView!
    @IBOutlet weak var imageUrgent: UIImageView!
    @IBOutlet weak var notes: UITextField!
    
    @IBOutlet weak var labelComplaintTypeText: UILabel!
    @IBOutlet weak var labelComplaintTypeChooseText: UILabel!
    
    @IBOutlet weak var labelComplaintCategoryText: UILabel!
    @IBOutlet weak var labelComplaintCategoryChooseText: UILabel!

    @IBOutlet weak var labelComplaintNoteText: UILabel!
    @IBOutlet weak var labelComplaintNoteChooseText: UITextView!
    
    @IBOutlet weak var viewHideVisit: UIView!
    
    @IBOutlet weak var labelComplaintVisitText: UILabel!
//    @IBOutlet weak var labelComplaintVisitChooseText: UILabel!
    @IBOutlet weak var uilabelSave: UILabel!

    @IBOutlet weak var visitTypeText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var healer: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var visitType: UILabel!

    init(VisitId: String) {
        super.init(nibName: "SaveCompliansViewController", bundle: nil)
        self.visitId = VisitId
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if UserManager.isArabic{
            labelComplaintTypeText.text = "نوع الشكوي"
            labelComplaintTypeChooseText.text = "اختار نوع الشكوي"
            labelComplaintCategoryText.text = "تصنيف الشكوي"
            labelComplaintCategoryChooseText.text = "اختار تصنيف الشكوي"
            labelComplaintNoteText.text = "الشكوي و الاقتراح"
//            labelComplaintNoteChooseText.placeholder = "اكتب الشكوي بالتفاصيل "
            labelComplaintVisitText.text = " الزيارة"
//            labelComplaintVisitChooseText.text = " اختار الزياره"
            uilabelSave.text = "حفظ الشكوي او الاقتراح"
            labelComplaintNoteChooseText.textAlignment = .right
            visitTypeText.text = "نوع الزيارة"
            dateText.text = "التاريخ"
        }
        else{
            labelComplaintTypeText.text = "Compliant Type"
            labelComplaintTypeChooseText.text = "Choose Complaint Type"
            labelComplaintCategoryText.text = "Complaint Category"
            labelComplaintCategoryChooseText.text = "Choose Complaint Category"
            labelComplaintNoteText.text = "Complaint or Suggestion"
//            labelComplaintNoteChooseText.placeholder = "Write Complaint In Details"
            labelComplaintVisitText.text = "Visit"
//            labelComplaintVisitChooseText.text = "Chosse Visit"
            uilabelSave.text = "Save Complaint or Suggestion"
            visitTypeText.text = "Visit Type"
//            visitNumberText.text = "Visit Number"
            dateText.text = "Date"

        }
//        setupTabBar.instance.setuptabBar(vc: self)
        complaintType.makeShadow(color: .black, alpha: 0.14, radius: 4)
        complaintCategoty.makeShadow(color: .black, alpha: 0.14, radius: 4)
        uiviewNotes.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewVisit.makeShadow(color: .black, alpha: 0.14, radius: 4)
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "الشكاوي و الاقتراحات" : "Complaints & Suggestions", hideBack: false)
        indicator.sharedInstance.show()
        getdata()
        loadData()
        view.isUserInteractionEnabled = false
        group.notify(queue: .main) {
            indicator.sharedInstance.dismiss()
            self.view.isUserInteractionEnabled = true
        }
        
        let gestureVisit = UITapGestureRecognizer(target: self, action:  #selector(self.openVisitfunc))
        self.viewVisit.addGestureRecognizer(gestureVisit)
        viewHideVisit.addGestureRecognizer(gestureVisit)
        
        
        let gestureComplaintType = UITapGestureRecognizer(target: self, action:  #selector(self.opencompalintType))
        self.complaintType.addGestureRecognizer(gestureComplaintType)
       
        let gestureCategoryType = UITapGestureRecognizer(target: self, action:  #selector(self.opencompalintCategory(sender:)))
        self.complaintCategoty.addGestureRecognizer(gestureCategoryType)
        
        
         let gestureviewVisit = UITapGestureRecognizer(target: self, action:  #selector(self.saveVisit(sender:)))
         self.save.addGestureRecognizer(gestureviewVisit)
        
    }
    
    @objc func saveVisit(sender : UITapGestureRecognizer) {
        if labelComplaintNoteChooseText.text.trimmed.count < 20 {
            Utilities.showAlert(messageToDisplay: UserManager.isArabic ? "يجب أن تكون البيانات المدخلة أن تحتوي علي الأقل 20 حرف" : "The entered data must contain at least 20 characters")
            return
        }

        let pars = ["BUFFER_STATUS": "1",
                    "COMPLAINT_PRIORITY": COMPLAINT_PRIORITY ?? "1",
                    "COMPLAINT_CAT": "55",
                    "TYPE_OF_PATIONT": "1",
                    "USERID": "KHABEER",
                    "VISITID": visitId ?? "1",
                    "COMPLAINT_STATUS": COMPLAINT_PRIORITY ?? "1",
                    "COMPLAINT_TEXT": labelComplaintNoteChooseText.text ?? "",
                    "COMPLAINT_TYPE": "56",
                    "BENEFICIARY_CODE": Utilities.sharedInstance.getPatientId(),
                    "BENEFICIARY_TYPE": "1",
                    "BRANCH_ID": "1",
                    "RECEPT_BY": "16",
                    "CONTACT_NO": UserDefaults.standard.object(forKey: "PAT_TEL") as? String ?? "",
                    "P_SAVE_SUBMIT": "1"]
                      
             as [String : Any]
            let urlString = Constants.APIProvider.CrmControllerCOMPLAINTSSAVE
            print(pars)
            WebserviceMananger.sharedInstance.makeCall(method: .post, url: urlString, parameters: pars, vc: self) { (data, error) in


                let root = data as! [String:Any]
               
                print(root)
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("dataFound"), object: nil)
                if let code = root["Code"] as? Int {
                    if var message = root["message"] as? String {
                        
                        let vc = ResultPopupViewController()
                        vc.delegate = self

                        if code == 1 {
                            message = UserManager.isArabic ? "تم الإرسال بنجاح":"Sent sucssfully"
                            
                        }else {
                            vc.isError = true
                        }
                        vc.message = message
                        AppPopUpHandler.instance.openPopup(container: self, vc: vc)

                   //     let newMessage = UserManager.isArabic ? "عميلنا العزيز،\nيسرنا أن تشاركنا ملاحظاتك و تجربتك و تأكد أن فريقنا سيقوم بالتواصل معكم في أقرب وقت ممكن." : "Dear Valued customer\nWe would like to share your suggestion/ experience.\nRest assured that our team will contact you as soon as possible.\nThank you"
    //                    Utilities.showAlert(messageToDisplay: newMessage)
    //                    self.navigationController?.popViewController(animated: true)
                      
                    }
                }
             
//                let nc = NotificationCenter.default
//                nc.post(name: Notification.Name("dataFound"), object: nil)
              
            }
    }

    @IBAction func UrgentCliked(_ sender: Any) {
        
        COMPLAINT_PRIORITY = "2"
        
        imageUrgent.image = UIImage(named: "dignosisSelected")
        imageNormal.image = UIImage(named: "cheacked")
            
    }
    
    @IBAction func NormalCliked(_ sender: Any) {
        
        COMPLAINT_PRIORITY = "1"
        imageUrgent.image = UIImage(named: "cheacked")
        imageNormal.image = UIImage(named: "dignosisSelected")
    }
    
    @objc func openVisitfunc(sender : UITapGestureRecognizer) {
//        AppPopUpHandler.instance.initListPopup( container: self, arrayNames: UserManager.isArabic ? self.listOfVisit.map{$0.NAME_AR} :self.listOfVisit.map{$0.NAME_EN}, title: UserManager.isArabic ? "Chosse Visit" : "اختار الزيازه", type: "Visit")
//        
        AppPopUpHandler.instance.initListPopupVisit(container: self, type: "Visit", listOfVisits: listOfVisit, getVisits: true)
        
    }
  
    @objc func opencompalintType(sender : UITapGestureRecognizer) {
        AppPopUpHandler.instance.initListPopup( container: self, arrayNames: UserManager.isArabic ? self.complaintTypeList.map{$0.NAME_AR} :self.complaintTypeList.map{$0.NAME_EN}, title: UserManager.isArabic ? "اختار نوع الشكوي" : "Choose Complaint Type", type: "complaintTypeList")
    }
    
    @objc func opencompalintCategory(sender : UITapGestureRecognizer) {
        AppPopUpHandler.instance.initListPopup( container: self, arrayNames: UserManager.isArabic ? self.complaintCategoryList.map{$0.NAME_AR} :self.complaintCategoryList.map{$0.NAME_EN}, title: UserManager.isArabic ? "اختار نوع الشكوي" : "Choose Complaint Category", type: "complaintCateggoryList")
    }

    func loadData() {
        group.enter()
        let urlString = Constants.APIProvider.CRMCOMPLAINTSLOAD + "patient_id=\(Utilities.sharedInstance.getPatientId())"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self, showIndicator: false) { (data, error) in
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["CRM_COMPLAINTS_TYPES"] as? [String:AnyObject]
                {

                    if root["CRM_COMPLAINTS_TYPES_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["CRM_COMPLAINTS_TYPES_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        print(i)
                        self.complaintTypeList.append(visitDTO(JSON: i)!)
                    }
                    }
                    else if root["CRM_COMPLAINTS_TYPES_ROW"] is [String:AnyObject]
                    {
                        self.complaintTypeList.append(visitDTO(JSON:root["CRM_COMPLAINTS_TYPES_ROW"] as![String:AnyObject] )!)
                    }
                }
                if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["CRM_COMPLAINTS_CAT"] as? [String:AnyObject]
               {
                   if root["CRM_COMPLAINTS_CAT_ROW"] is [[String:AnyObject]]
                   {
                   
                   let appoins = root["CRM_COMPLAINTS_CAT_ROW"] as! [[String: AnyObject]]
                   for i in appoins
                   {
                       print(i)
                       self.complaintCategoryList.append(visitDTO(JSON: i)!)
                   }
                   }
                   else if root["CRM_COMPLAINTS_CAT_ROW"] is [String:AnyObject]
                   {
                       self.complaintCategoryList.append(visitDTO(JSON:root["CRM_COMPLAINTS_CAT_ROW"] as![String:AnyObject] )!)
                   }
               }
            }
            self.group.leave()
        }
    }
    func getdata() {
        //if visitId?.isEmpty == false && visitId != "nil" {
            let urlString = Constants.APIProvider.getVisitDetailsForPatient + "PATIENT_ID=\(Utilities.sharedInstance.getPatientId())&BRANCH_ID=1"
            WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self, showIndicator: false) { (data, error) in
                if error == nil
                {
                    if let root = ((data as? [String: AnyObject])?["Root"] as? [String:AnyObject])?["VISIT"] as? [String:AnyObject]
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
                }
            }
   //     }
        
    }
    

    

}

extension SaveCompliansViewController: ResultPopupDelegate {
    
    func goBack() {
        self.viewNoDAta.isHidden = true
        navigationController?.popViewController(animated: true)
    }
}
