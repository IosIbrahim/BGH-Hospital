//
//  QuestionaryVC.swift
//  CareMate
//
//  Created by Yo7ia on 2/18/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//



import UIKit
import PopupDialog
import DZNEmptyDataSet
import Alamofire

class QuestionaryVC: BaseViewController ,MainQuestionCellDelagete,UITableViewDelegate,UITableViewDataSource{
    var branches = [QuestionaryModel]()
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    
    var visit_id = ""
    var showOnly = false
    var serialId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

        tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        if showOnly {
            tableView.allowsSelection = false
            btnSave.isHidden = true
        }
        btnSave.setTitle(UserManager.isArabic ? "حفظ" : "Save", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isHidden = false
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "الإستبيان" : "Survey", hideBack: false)
        self.title = UserManager.isArabic ? "الإستبيان" : "Survey"
        UIView.appearance().semanticContentAttribute = !UserManager.isArabic ? .forceLeftToRight : .forceRightToLeft

        let urlString = Constants.APIProvider.GetQuestionary + "?VISIT_ID=\(visit_id)&" + "&SerialID=\(showOnly ? serialId : "0")"
        indicator.sharedInstance.show()
        let urls = URL(string: urlString)
//        let parseUrl = Constants.APIProvider.GetQuestionary + "?VISIT_ID=\(visit_id)&" + "&SerialID=\(showOnly ? "0" : visit_id)" +  Constants.getoAuthValue(url: urls!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if (data as! [String: AnyObject]).keys.contains("Root") {
                if let root = (((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["STP_PAT_SATISFACTION_DETAIL"] as! [String:AnyObject])["STP_PAT_SATISFACTION_DETAIL_ROW"] as? [String:AnyObject] {
                    self.branches = [QuestionaryModel]()
                    
                    self.branches.append(QuestionaryModel(JSON: root)!)
                    self.tableView.reloadData()
                    
                } else {
                    if let root = (((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["STP_PAT_SATISFACTION_DETAIL"] as! [String:AnyObject])["STP_PAT_SATISFACTION_DETAIL_ROW"] as? [[String:AnyObject]] {
                        self.branches = [QuestionaryModel]()
                        for i in root {
                            self.branches.append(QuestionaryModel(JSON: i)!)
                        }
                        self.tableView.reloadData()
                    } else {
                        
                    }
                }
                if self.showOnly {
                    for (i, question) in self.branches.enumerated() {
                        for (j, answer) in (question.dETAILED_ITEMS?.dETAILED_ITEMS_ROW ?? []).enumerated() {
                            for (k, choise) in (answer.iTEM_TYPE_SETUP?.iTEM_TYPE_SETUP_ROW ?? []).enumerated() {
                                if choise.iD_VALUE == choise.dEGREE_VALUE {
                                    self.branches[i].dETAILED_ITEMS!.dETAILED_ITEMS_ROW![j].iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW![k].isSelected = true
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                let x = (data as! [String: AnyObject])["message"] as! String
                Utilities.showAlert(messageToDisplay: x)
            }
        }
       
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

//        var height = 0
//        var heightForiTEM_TYPE_SETUP = 0
//            let x = self.branches[indexPath.row]
//         let screenSize = UIScreen.main.bounds
//         let screenWidth = screenSize.width
         var height = 0
         let x = self.branches[indexPath.row]
         height += 40
         if x.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle != nil {
             height += 60
             height += Int((Double(x.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle!.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW!.count) / 2).rounded(.up) * 50)
         } else {
             for i in x.dETAILED_ITEMS!.dETAILED_ITEMS_ROW! {
                 height += 50
                 height += Int((Double(i.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW!.count) / 2).rounded(.up) * 50)
             }
         }
         return CGFloat(height)
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branches.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainQuestionCell", for: indexPath) as! MainQuestionCell
        cell.delegate = self
         cell.configCell(doctor: branches[indexPath.row], showOnly: showOnly)
        return cell
    }
    
    @IBAction func saveQuestionare()
    {
        if Utilities.sharedInstance.getPatientId() == "" {
            Utilities.showLoginAlert(vc: self.navigationController!)
            return
        }
        var questCount = 0
        var answeredCount = 0
        var STP_PAT_SATISFACTION_DETAIL = [[String:String]]()
        for i in branches {
            if i.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle != nil
            {
                questCount += 1
                 answeredCount += i.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle!.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW!.filter{$0.isSelected}.count
                let d = i.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle!
                
                STP_PAT_SATISFACTION_DETAIL.append(["ITEM_ID":d.iTEM_ID! , "DEGREE_VALUE":d.ID_VALUE ,"BUFFER_STATUS" : "1"])
                
            }
            else
            {
                questCount += i.dETAILED_ITEMS!.dETAILED_ITEMS_ROW!.count
                let x = i.dETAILED_ITEMS!.dETAILED_ITEMS_ROW!.map { (d) -> [String:String] in
                    return ["ITEM_ID":d.iTEM_ID! , "DEGREE_VALUE":d.ID_VALUE ,"BUFFER_STATUS" : "1"]}
                STP_PAT_SATISFACTION_DETAIL.append(contentsOf: x)
                for y in i.dETAILED_ITEMS!.dETAILED_ITEMS_ROW!
                {
                    answeredCount += y.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW!.filter{$0.isSelected}.count
                   
                }
            }
        }
        if questCount != answeredCount {
            Utilities.showAlert(messageToDisplay: "You must answer all questions")
        }
        else
        {
            let pars = ["PATIENT_ID": Utilities.sharedInstance.getPatientId(), "BRANCH_ID": "1", "VISIT_ID":visit_id]
            let parameters = ["api_params": pars , "STP_PAT_SATISFACTION_DETAIL": STP_PAT_SATISFACTION_DETAIL] as [String : Any]
            let urlString = Constants.APIProvider.SaveQuestionary
            let url = URL(string: urlString)
            let parseUrl = Constants.APIProvider.SaveQuestionary + "?" + Constants.getoAuthValue(url: url!, method: "POST")
//            WebserviceMananger.sharedInstance.makeCall(method: .post, url: parseUrl, parameters: parameters, vc: self) { (data, error) in
//                Utilities.showAlert(self, messageToDisplay: UserManager.isArabic ? "تم الارسال" : "Done sucessfully")
//                self.navigationController?.popViewController(animated: true)
//            }
            
            let request = getRequest(url: parseUrl, parameters: parameters, headers: nil)
            AF.request(request).responseJSON { (response:AFDataResponse<Any>) in
                Utilities.showAlert(self, messageToDisplay: UserManager.isArabic ? "تم الارسال" : "Done sucessfully")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func getRequest(url: String, parameters: Any , headers: [String: String]?) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        do {
//            let headers: HTTPHeaders = [
//                "User-Agent": "PostmanRuntime/7.28.4",
//
//            ]
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("PostmanRuntime/7.28.4", forHTTPHeaderField: "User-Agent")
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let decoded = String(data: jsonData, encoding: .utf8)!
            let postData = decoded.data(using: .utf8)
            request.httpBody = postData
            print("JsonRequest: \(decoded)")
            return request
        } catch {
            return URLRequest(url: URL(string: url)!)
        }
    }
    
    func CellClicked(_ data: MainQuestionCell, question: QuestionCell, answer: AnswerCell) {
        var questData = data.data!
        var questDetails = question.itemData!
        var answer = answer.data!
        answer.isSelected = !answer.isSelected
        var ind = 0
        for (index,i) in self.branches.enumerated()
        {
            if i.iTEM_ID! == questData.iTEM_ID!
            {
                if i.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle != nil
                {
                    for (ansIndex,dat) in i.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle!.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW!.enumerated()
                    {
                        if dat.iD! != answer.iD!
                        {
                        self.branches[index].dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle!.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW![ansIndex].isSelected = false
                            ind = index
                            
                        }
                       else if dat.iD! == answer.iD!
                        {
                            self.branches[index].dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle!.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW![ansIndex].isSelected = answer.isSelected
                            self.branches[index].dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle!.ID_VALUE = answer.iD_VALUE!
                            ind = index
                        }
                    }
                }
                else
                {
                    for(quesIndex , ques) in i.dETAILED_ITEMS!.dETAILED_ITEMS_ROW!.enumerated()
                    {
                        if ques.iTEM_ID! == questDetails.iTEM_ID!
                        {
                            for (ansIndex,dat) in ques.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW!.enumerated()
                            {
                                if dat.iD! != answer.iD!
                                {
                                    self.branches[index].dETAILED_ITEMS!.dETAILED_ITEMS_ROW![quesIndex].iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW![ansIndex].isSelected = false
                                    ind = index
                                }
                                else if dat.iD! == answer.iD!
                                {
                                    self.branches[index].dETAILED_ITEMS!.dETAILED_ITEMS_ROW![quesIndex].iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW![ansIndex].isSelected = answer.isSelected
                                     self.branches[index].dETAILED_ITEMS!.dETAILED_ITEMS_ROW![quesIndex].ID_VALUE = answer.iD_VALUE!
                                    ind = index
                                }
                            }
                        }
                    }
                }
            }
        }
        self.tableView.reloadRows(at: [IndexPath(row: ind, section: 0)], with: .automatic)
    }
}


extension QuestionaryVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // ===============================================
    // ==== DZNEmptyDataSet Delegate & Datasource ====
    // ===============================================
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return branches.count == 0
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
//    
//    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
//        let text =  UserManager.isArabic ?  "لا توجد أسئلة" : "No questions found !"
//        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:Color.darkGray]
//        
//        return NSAttributedString(string: text, attributes: attributes)
//    }
}

