//
//  PhysicalController.swift
//  CareMate
//
//  Created by Ibrahim on 05/05/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

import UIKit

class PhysicalController: BaseViewController {

    @IBOutlet weak var tblSessions: UITableView!
    @IBOutlet weak var clcTabs: UICollectionView!
    
    private var dataSources = [ServiceSessionRowModel]()
    private var tabIndex:Int = .zero
    private var tabsDataSources = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
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

}


extension PhysicalController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhysGroubCell", for: indexPath) as! PhysGroubCell
        cell.drawCell(dataSources[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       dataSources[indexPath.row].isSelected = !(dataSources[indexPath.row].isSelected ?? false)
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
