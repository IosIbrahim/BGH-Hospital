//
//  VisitsViewController.swift
//  CareMate
//
//  Created by MAC on 07/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

protocol SurveyProtocol {
    func getVisitID(_ id:String)
}

class VisitsViewController: BaseViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var labelsurvey: UILabel!
    
    var listOfVisit = [visitDTO]()
    var type = ""
    var getVistist = true
    var fromDropDown = false
    var gotoSurvery = false
    var isSurvey = false
    var delegade:SurveyProtocol?
    var listPopupDelegate : ListPopupDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var title = UserManager.isArabic ? "الزيارات" :"Visits"
            self.table.delegate = self
            self.table.dataSource = self
            self.table.rowHeight = UITableViewAutomaticDimension
            self.table.reloadData()
        
        if isSurvey {
            viewAdd.isHidden = false
            labelsurvey.isHidden = false
            if UserManager.isArabic {
                labelsurvey.text = "إضافة"
            }
            title = UserManager.isArabic ? "الإستطلاعات السابقة" : "Previous Surveys"
        } else {
            viewAdd.isHidden = true
            labelsurvey.isHidden = true
        }
        viewAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSurvey)))
        table.register("VisitCellTableViewCell")
//        self.navigationController?.navigationBar.isHidden = false

        initHeader(isNotifcation: true, isLanguage: true, title: title, hideBack: false)
    }
    
    @objc func openSurvey() {
        let vc = VisitsViewController()
        vc.gotoSurvery = true
        navigationController?.pushViewController(vc, animated: true)
    }
//    for (key,value) in dic
//    {
//        if value is [String: Any] {
//            if  key.contains("ROW") ||  key.contains("r")
//              {
//                var newValue = [[String: Any]]()
//                newValue.append(value as! [String:Any])
//                dic[key] = newValue
//              }
//        }
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listOfVisit.removeAll()
        table.reloadData()
        if getVistist {
            getdata()
        }
    }
    
    func getdata() {
 

        let urlString = Constants.APIProvider.getVisitDetailsForPatient + "PATIENT_ID=\(Utilities.sharedInstance.getPatientId())&BRANCH_ID=1"
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            
            if error == nil
            {
                 if let root = ((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["VISIT"] as? [String:AnyObject]
                {
                    
               
                    
                    if root["VISIT_ROW"] is [[String:AnyObject]]
                    {
                    
                    let appoins = root["VISIT_ROW"] as! [[String: AnyObject]]
                    for i in appoins
                    {
                        let item = i["PAT_SURVEY_LINK"] as? String ?? ""
                        print(item)
                        print(i)
                    //    if self.gotoSurvery && item == "" {
                       //     print(item)
                     //   } else {
                            self.listOfVisit.append(visitDTO(JSON: i)!)
                     //   }
                      
                        
                    }
                    }
                    else if root["VISIT_ROW"] is [String:AnyObject]
                    {
//                        fixed by Hamdiiiiiiii
if !self                        .gotoSurvery || (self.gotoSurvery && root["VISIT_ROW"]?["PAT_SURVEY_LINK"] as? String ?? "" != "") {

                            self.listOfVisit.append(visitDTO(JSON:root["VISIT_ROW"] as![String:AnyObject] )!)
                        }
                        
                    }
                    self.table.delegate = self
                    self.table.dataSource = self
                    self.table.rowHeight = UITableViewAutomaticDimension
                    self.table.reloadData()
                    
                }
             
                else
                 {
                }
            }


           
        }
    }
    
  

}
extension VisitsViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  listOfVisit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "VisitCellTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! VisitCellTableViewCell
        cell.selectionStyle = .none
        cell.configureString(listOfVisit[indexPath.row], hideEvaluation: !gotoSurvery)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    

    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if fromDropDown == true
        {
            mz_dismissFormSheetController(animated: true) { (_) in
                self.listPopupDelegate?.listPopupDidSelect(index: indexPath.row, type: self.type)
            }
        }
        else
        {
            if gotoSurvery {
                if listOfVisit[indexPath.row].EVAL_STATUS == "1" {
                    OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "تم بالفعل تقييم الزيارة من قبل ، شكرا لك." : "The visit was already evaluated before, thank you.")
                } else {
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "QuestionaryVC") as? QuestionaryVC
//                    nextViewController?.visit_id = listOfVisit[indexPath.row].VISIT_ID
//                    self.navigationController?.pushViewController(nextViewController!, animated: true)
                  //  let url = listOfVisit[indexPath.row].PAT_SURVEY_LINK
                //    let vc = WebViewViewController(url, showShare: false)
                //    vc.pageTitle = UserManager.isArabic ? "التقييم" : "Survey"
                //    navigationController?.pushViewController(vc, animated: true)
//                    
//                    let vc1:SaveViewController = SaveViewController()
//                    vc1.visitId = listOfVisit[indexPath.row].VISIT_ID
//                    vc1.hospID = listOfVisit[indexPath.row].NAME_EN.getBranchID()
//                    self.navigationController?.pushViewController(vc1, animated: true)
                    delegade?.getVisitID(listOfVisit[indexPath.row].VISIT_ID)
                    navigationController?.popViewController(animated: true)
                }
            } else {
                let vc1:SaveViewController = SaveViewController()
                vc1.visitId = listOfVisit[indexPath.row].VISIT_ID
                vc1.hospID = listOfVisit[indexPath.row].NAME_EN.getBranchID()
                self.navigationController?.pushViewController(vc1, animated: true)
            }
        }
    }
}

extension String {
    func getBranchID() -> String {
        var id = "1"
        if self.contains("برج المسيلة الطبي") || self.lowercased().contains("Al-Messila Medical Tower".lowercased()) {
            id = "-6"
        }else if self.contains("مستشفى السلام الأحمدى") || self.lowercased().contains("Al Salam Al-Ahmadi".lowercased()) {
            id = "2"
        }
        return id
    }
}
