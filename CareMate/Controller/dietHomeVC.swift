//
//  dietHomeVC.swift
//  CareMate
//
//  Created by khabeer on 2/1/20.
//  Copyright © 2020 khabeer Group. All rights reserved.
//

import UIKit

class dietHomeVC: BaseViewController ,BreakFastCellDelagete{
   
    
    
    var indexPathForBreakFast = 0
    var indexPathForLunch = 0
    var indexPathForDinner = 0


    @IBOutlet weak var mealCollectionView: UICollectionView!
    
    @IBOutlet weak var dinnerCollectionView: UICollectionView!
    @IBOutlet weak var dinnerView: UIView!
    @IBOutlet weak var breakFastView: UIView!
    @IBOutlet weak var mealsView: UIView!
    @IBOutlet weak var calender: FSCalendar!
    
    @IBOutlet weak var lunchView: UIView!
    
    @IBOutlet weak var lunchCollectionView: UICollectionView!
    @IBOutlet weak var BreakFastCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = UserManager.isArabic ? "حمية غذائية" : "Diet"
//        setupTabBar.instance.setuptabBar(vc: self)

        screenConfiguration()

    }
    

}

extension dietHomeVC :UICollectionViewDelegate,UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == BreakFastCollectionView
        {
            
            self.indexPathForBreakFast = indexPath.row
            BreakFastCollectionView.reloadData()
        }
        else if collectionView == lunchCollectionView
        {
            self.indexPathForLunch = indexPath.row
            lunchCollectionView.reloadData()
            
        }
        else{
            
            self.indexPathForDinner = indexPath.row
            dinnerCollectionView.reloadData()
        }
        
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == self.lunchCollectionView
        {
            return 10

        }
        else if collectionView == self.BreakFastCollectionView{
            return 5

        }
        else {
            
            return 5
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == self.BreakFastCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreakFastCell", for: indexPath) as! BreakFastCell
            if indexPathForBreakFast == indexPath.row
            {
                
                self.collectionViewConfigurationForSelectedCell(cell: cell)
            }
            else{
         
                self.collectionViewConfigurationForUnSelectedCell(cell: cell)
            }
            return cell
            
        }
        else if collectionView == self.lunchCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreakFastCell", for: indexPath) as! BreakFastCell
            
            if indexPathForLunch == indexPath.row
            {
                
                self.collectionViewConfigurationForSelectedCell(cell: cell)
            }
            else{
              
                self.collectionViewConfigurationForUnSelectedCell(cell: cell)
            }
            return cell
            
            
        }
        else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreakFastCell", for: indexPath) as! BreakFastCell
            
            if indexPathForDinner == indexPath.row
            {
                
                self.collectionViewConfigurationForSelectedCell(cell: cell)
            }
            else{
               
                self.collectionViewConfigurationForUnSelectedCell(cell: cell)
            }
            return cell
            
        }
        
      

    }
    
    func CellClicked(_ data: BreakFastCell) {
        
    }
    
    func screenConfiguration()  {
        
        
        BreakFastCollectionView.delegate = self
        BreakFastCollectionView.dataSource = self
        
        dinnerCollectionView.delegate = self
        dinnerCollectionView.dataSource = self
        
        
        lunchCollectionView.delegate = self
        lunchCollectionView.dataSource = self
        
        mealsView.layer.masksToBounds = false
        mealsView.layer.shadowRadius = 4
        mealsView.layer.shadowOpacity = 1
        mealsView.layer.shadowColor = UIColor.gray.cgColor
        mealsView.layer.shadowOffset = CGSize(width: 0 , height:2)
        
        
        breakFastView.layer.masksToBounds = false
        breakFastView.layer.shadowRadius = 4
        breakFastView.layer.shadowOpacity = 1
        breakFastView.layer.shadowColor = UIColor.gray.cgColor
        breakFastView.layer.shadowOffset = CGSize(width: 0 , height:2)
        
        lunchView.layer.masksToBounds = false
        lunchView.layer.shadowRadius = 4
        lunchView.layer.shadowOpacity = 1
        lunchView.layer.shadowColor = UIColor.gray.cgColor
        lunchView.layer.shadowOffset = CGSize(width: 0 , height:2)
        
        
        dinnerView  .layer.masksToBounds = false
        dinnerView.layer.shadowRadius = 4
        dinnerView.layer.shadowOpacity = 1
        dinnerView.layer.shadowColor = UIColor.gray.cgColor
        dinnerView.layer.shadowOffset = CGSize(width: 0 , height:2)
        self.calender.scope = .week
    }
    
}
class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "01")! as UIImage
    let uncheckedImage = UIImage(named: "pluscircle")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                
                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
extension dietHomeVC
{
    
    func collectionViewConfigurationForSelectedCell(cell:BreakFastCell)   {
        cell.mainView.backgroundColor = #colorLiteral(red: 0.9568411708, green: 0.956818521, blue: 0.9610616565, alpha: 1)
        
        cell.mainView.layer.borderColor = #colorLiteral(red: 0.7685508132, green: 0.768681109, blue: 0.7685337067, alpha: 1)
        cell.colorView.isHidden = false
    }
    func collectionViewConfigurationForUnSelectedCell(cell:BreakFastCell)   {
//        cell.mainView.isHidden = true
        cell.mainView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        cell.mainView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        cell.colorView.isHidden = true

    }

}
