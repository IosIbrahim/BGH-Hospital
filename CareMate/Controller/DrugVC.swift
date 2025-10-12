//
//  DrugVC.swift
//  CareMate
//
//  Created by Yo7ia on 1/1/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//


import UIKit
import DZNEmptyDataSet
class DrugVC: BaseViewController ,UISearchBarDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    var branchId: String?
    var specialityId: String?
    var doctors = [DrugDTO]()
    var fullDoctors = [DrugDTO]()
    var pageSize = 10
    var pageCount = 1
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        tableView.keyboardDismissMode = .onDrag
        callAPI(indexFrom: 0, indexTO: pageSize)
        }

    
    func callAPI(indexFrom:Int , indexTO:Int){
        if Utilities.sharedInstance.getPatientId() == "" {
            Utilities.showLoginAlert(vc: self.navigationController!)
            return
        }
        let pars = "P_VIEW_NO=3&PATIENT_ID="+Utilities.sharedInstance.getPatientId()+"&Branch_ID=1" + "&INDEX_FROM=" + "\(indexFrom)" + "&INDEX_TO=" + "\(indexTO)"
        let urlString = Constants.APIProvider.getDrugHistory+pars
        indicator.sharedInstance.show()
        let url = URL(string: urlString)
        let parseUrl = Constants.APIProvider.getDrugHistory + Constants.getoAuthValue(url: url!, method: "GET")
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: parseUrl, parameters: nil, vc: self) { (data, error) in
            if error != nil {
                return
            }
            guard let data = data else {
            return
          }
            
            if let root = (data as! [String:AnyObject])["DRUG_DETAILS"] as? [String: AnyObject]{
            if root.keys.contains("DRUG_DETAILS_ROW")
            {
                if let appoins = root["DRUG_DETAILS_ROW"] as? [[String: AnyObject]]
                {
                    for i in appoins
                    {
                        self.doctors.append(DrugDTO(JSON: i)!)
                    }
                }
                else
                {
                    self.doctors.append(DrugDTO(JSON: root["DRUG_DETAILS_ROW"] as! [String: AnyObject])!)
                }
                
               
            }
            else
            {
                self.doctors.removeAll()
            }
            self.tableView.reloadData()
        }
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.appearance().semanticContentAttribute = !UserManager.isArabic ? .forceLeftToRight : .forceRightToLeft

        
        self.title = UserManager.isArabic ? "الأدوية" : "Medications"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
   
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
}

extension DrugVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return doctors.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrugCell", for: indexPath) as! DrugCell
        cell.configCell(doctor: doctors[indexPath.section])
        return cell
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
                if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
                {
                    if(pageCount * pageSize == doctors.count ){
                    pageCount+=1
                    callAPI(indexFrom: doctors.count + 1 , indexTO: pageCount * pageSize )
                    }
                    
                }


        }

}

extension DrugVC: UITableViewDelegate {
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
extension DrugVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
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
//        let text =  UserManager.isArabic ?  "لم يتم العثور على أدوية" : "No medications found !"
//        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:Color.darkGray]
//        return NSAttributedString(string: text, attributes: attributes)
//    }
}


