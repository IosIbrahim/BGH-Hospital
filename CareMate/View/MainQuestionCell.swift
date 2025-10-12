//
//  MainQuestionCell.swift
//  CareMate
//
//  Created by Yo7ia on 2/18/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//


import UIKit
import DZNEmptyDataSet
protocol MainQuestionCellDelagete {
    func CellClicked(_ data: MainQuestionCell,question: QuestionCell,answer: AnswerCell)
    
}
class MainQuestionCell: UITableViewCell {
    @IBOutlet weak var titleLbl: uilabelCenter!
    @IBOutlet weak var questionsCollectionView: UICollectionView!
    var data: QuestionaryModel?
    
    var delegate: MainQuestionCellDelagete?
    
    func configCell(doctor: QuestionaryModel, showOnly: Bool) {
        self.questionsCollectionView.dataSource = self
        self.questionsCollectionView.delegate = self
        self.questionsCollectionView.isScrollEnabled = false
        self.questionsCollectionView.emptyDataSetSource = self
        self.questionsCollectionView.emptyDataSetDelegate = self
        self.data = doctor
        self.titleLbl.text = UserManager.isArabic ? self.data?.iTEM_AR_NAME : self.data!.iTEM_EN_NAME
        self.questionsCollectionView.reloadData()
        if showOnly {
            self.questionsCollectionView.isUserInteractionEnabled = false
        }
        
    }
}
extension MainQuestionCell: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,QuestionCellDelagete {
    
    func CellClicked(_ data: QuestionCell, answer: AnswerCell) {
        self.delegate?.CellClicked(self, question: data, answer: answer)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize.zero
        // collection view size minus the section inset spacing and in between spacing each of 10
        size.width = (collectionView.bounds.size.width) - 10
        var height = 0
        if self.data!.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle != nil {
            height += 45
            height += Int((Double(self.data!.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle!.iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW!.count) / 2).rounded(.up)*50)
        } else {
            height += 45
            height += Int((Double(self.data!.dETAILED_ITEMS!.dETAILED_ITEMS_ROW![indexPath.row].iTEM_TYPE_SETUP!.iTEM_TYPE_SETUP_ROW!.count) / 2).rounded(.up)*50)
            
        }
        size.height =  CGFloat(height)
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
        if self.data!.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle != nil
        {
            return 1
        }
        return self.data!.dETAILED_ITEMS!.dETAILED_ITEMS_ROW!.count
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.delegate = self
        if self.data!.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle != nil
        {
            cell.configCell(slot: self.data!.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle!)
        }
        else
        {
            cell.configCell(slot: self.data!.dETAILED_ITEMS!.dETAILED_ITEMS_ROW![indexPath.row])
        }
        return cell
    }
    
}

extension MainQuestionCell: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // ===============================================
    // ==== DZNEmptyDataSet Delegate & Datasource ====
    // ===============================================
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        if self.data!.dETAILED_ITEMS!.dETAILED_ITEMS_ROWSingle != nil
        {
            return false
        }
        return self.data!.dETAILED_ITEMS!.dETAILED_ITEMS_ROW!.count == 0
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
//        let text =  UserManager.isArabic ?  "لا توجد أسئلة" : "No questions found !"
//        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor:Color.darkGray]
//        
//        return NSAttributedString(string: text, attributes: attributes)
//    }
    
}



