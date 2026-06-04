//
//  PhysicalController.swift
//  CareMate
//
//  Created by Ibrahim on 05/05/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

import UIKit
enum SessionFilter {
    case all
    case schedule
    case reschedule
}

class PhysicalController: BaseViewController {

    @IBOutlet weak var tblSessions: UITableView!
    @IBOutlet weak var clcTabs: UICollectionView!
    
    private var dataSources = [ServiceSessionRowModel]()
    private var tabIndex:Int = .zero
    private var tabsDataSources = [String]()
    var branch:Branch?
    var filter:SessionFilter = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        getSessions()
        let titl = UserManager.isArabic ? "العلاج الطبيعي" : "Physical Therapy"
        initHeader(isNotifcation: true, isLanguage: true, title: titl, hideBack: false)
        // Do any additional setup after loading the view.
    }
    
    func initTable() {
        tblSessions.register("PhysGroubCell")
        clcTabs.register("HeaderTabCell")
        let all = UserManager.isArabic ? "الكل":"All"
        let scheduled = UserManager.isArabic ? "مجدولة":"Scheduled"
        let rescheduled = UserManager.isArabic ? "تجتاج جدولة":"Need Schedule"
        tabsDataSources = [all,scheduled,rescheduled]
        clcTabs.reloadData()
    }
    
     func getSessions() {
         let id = Utilities.sharedInstance.getPatientId()
         let urlString = "\(Constants.APIProvider.GetPhysicalSessions)bRANCH_ID=\(branch?.id ?? "")&pATIENT_ID=\(id)"
         var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
     //    request.addValue("Bearer \()", forHTTPHeaderField: "Authorization")

         request.httpMethod = "GET"
         indicator.sharedInstance.show()
//    let url = URL(string: urlString)
//    let parseUrl = urlString + "?" + Constants.getoAuthValue(url: url!, method: "GET")
    print(urlString)
    URLSession.shared.dataTask(with: request) { data, response, error in
        indicator.sharedInstance.dismiss()
        if error != nil {//Has error for request
          if error?._code == -1001 {
           //Domain=NSURLErrorDomain Code=-1001 "The request timed out."
              DispatchQueue.main.async {
                  print(error?.localizedDescription ?? "")
              }
            return
          }
            DispatchQueue.main.async {
                print(error?.localizedDescription ?? "")
            }
        }
        guard let data = data else {
//        Utilities.showAlert(messageToDisplay:"Couldn't connect to server")
            DispatchQueue.main.async {
                print("Empty Data")
            }
        return
      }
        
      guard let json = String.init(data: data, encoding: .utf8), json.contains("PAT_SERVICES") else {
//        Utilities.showAlert(messageToDisplay:"No branches found")
          DispatchQueue.main.async {
              print("Empty Data")
          }
        return
      }
        
        print(json)
        
        let sessions = try? SessionResponseModel(data: data, keyPath: "PAT_SERVICES")
        self.dataSources = sessions?.services?.rows ?? []
        DispatchQueue.main.async {
            self.tblSessions.reloadData()
        }
      }.resume()
  }

}


extension PhysicalController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhysGroubCell", for: indexPath) as! PhysGroubCell
        cell.drawCell(dataSources[indexPath.row],filter: filter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       dataSources[indexPath.row].isSelected = !(dataSources[indexPath.row].isSelected ?? false)
       if indexPath.row == .zero {
           filter = .all
       }else if indexPath.row == 1 {
           filter = .schedule
       }else {
           filter = .reschedule
       }
       tblSessions.reloadRows(at: [indexPath], with: .automatic)
   }
   
}


extension PhysicalController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabsDataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderTabCell", for: indexPath) as! HeaderTabCell
        cell.cellSelected = indexPath.row == tabIndex
        cell.drawCell(tabsDataSources[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tabIndex = indexPath.row
        clcTabs.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenSize = UIScreen.main.bounds
            var screenWidth = screenSize.width
            screenWidth = screenWidth - 30
            let cellSize = screenWidth / 3
            var size = CGSize.zero
            size.width = cellSize
            size.height =  55
            return size
    }
}
