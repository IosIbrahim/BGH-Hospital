//
//  QuestionCell.swift
//  CareMate
//
//  Created by Yo7ia on 2/18/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//




import UIKit
import DZNEmptyDataSet

protocol QuestionCellDelagete {
    func CellClicked(_ data: QuestionCell,answer: AnswerCell)
    
}
class QuestionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: uilabelCenter!
    @IBOutlet weak var answersCollectionView: UICollectionView!
    var itemData: DETAILED_ITEMS_ROW?
    var delegate: QuestionCellDelagete?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(slot: DETAILED_ITEMS_ROW)
    {
        self.answersCollectionView.dataSource = self
        self.answersCollectionView.delegate = self
        self.answersCollectionView.emptyDataSetSource = self
        self.answersCollectionView.emptyDataSetDelegate = self
        self.itemData = slot
        self.titleLbl.text = UserManager.isArabic ? slot.iTEM_AR_NAME : slot.iTEM_EN_NAME!
        self.answersCollectionView.reloadData()
    }
    
}
extension QuestionCell: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,AnswerCellDelagete {
    
    func CellClicked(_ data: AnswerCell) {
        self.delegate?.CellClicked(self, answer: data)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize.zero
        // collection view size minus the section inset spacing and in between spacing each of 10
        size.width = (collectionView.bounds.size.width/2) - 10
        size.height =  (itemData!.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW![indexPath.row].nAME_EN?.height(constraintedWidth: (collectionView.bounds.size.width/2) - 10, font:   UIFont(name: "Tajawal-Bold", size: 14.0)!) ?? 40) + 20
        
//        size.height = 40
//        
       
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemData!.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return  CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
        cell.delegate = self
        cell.configCell(slot: itemData!.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW![indexPath.row])
     
        return cell
    }
    
}

extension QuestionCell: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // ===============================================
    // ==== DZNEmptyDataSet Delegate & Datasource ====
    // ===============================================
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return itemData!.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW!.count == 0
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
//        let text =  UserManager.isArabic ? "لا توجد إجابات" : "No answers found !"
//        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:Color.darkGray]
//        
//        return NSAttributedString(string: text, attributes: attributes)
//    }
    
}


extension String {
func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.text = self
    label.font = font
    label.sizeToFit()

    return label.frame.height
 }
}
