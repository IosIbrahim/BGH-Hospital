//
//  OperationTableViewCell.swift
//  CareMate
//
//  Created by MAC on 04/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

protocol OperationCellDelegate {
    func showReport(_ index: Int)
    func showInstructions(_ index: Int)
}

class OperationTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSRVNAME: UILabel!
    @IBOutlet weak var labelOPER_DURATION_DESC_AR: UILabel!
    @IBOutlet weak var labelSURGEON_NAME_EN: uilabelCenter!
    @IBOutlet weak var labelANTHESIA_NAME_AR: uilabelCenter!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var labelReport: UILabel!
    @IBOutlet weak var labelSURGEON_NAME_ENText: UILabel!
    @IBOutlet weak var labelANTHESIA_NAME_ARText: UILabel!
    @IBOutlet weak var labelBranchTitle: UILabel!
    @IBOutlet weak var labelBranch: UILabel!
    @IBOutlet weak var viewinstructions: UIView!
    @IBOutlet weak var labelInstructions: UILabel!
    
    var delegate: OperationCellDelegate?
    var index = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        viewReport.isHidden = true
        labelReport.text = UserManager.isArabic ? "طلب تقرير" : "Request report"
        viewReport.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openReport)))
        viewinstructions.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openInstructions)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ object:operationDTO)  {
        
        labelSRVNAME.text = UserManager.isArabic ? object.SRV_AR_NAME :
            object.SRV_EN_NAME
        labelOPER_DURATION_DESC_AR.text = UserManager.isArabic ? object.SERV_STATUS_AR :
            object.SERV_STATUS_EN
        
        labelSURGEON_NAME_EN.text = UserManager.isArabic ? object.SURGEON_NAME_AR :
            object.SURGEON_NAME_EN
        labelANTHESIA_NAME_AR.text = UserManager.isArabic ? object.DOC_NAME_AR :
            object.DOC_NAME_EN
        labelDate.text = object.EXPECTEDDONEDATE.ConvertToDate.withMonthNameWithTime
        labelBranch.text = UserManager.isArabic ? object.BRANCH_NAME_AR : object.BRANCH_NAME_EN
        if UserManager.isArabic
        {
            labelBranchTitle.text = "الفرع:"
            labelSURGEON_NAME_ENText.text = "الجراح"
            labelANTHESIA_NAME_ARText.text = "طبيب الحالة"
            labelInstructions.text = "تعليمات الإجراء الجراحي"
        }
        else{
            labelSURGEON_NAME_ENText.text = "Surgeon name"
            labelANTHESIA_NAME_ARText.text = "Treatment doctor"
        }
        if object.OPERATION_INSTRUCTIONS == nil {
            viewinstructions.isHidden = true
        } else {
            viewinstructions.isHidden = false
        }
    }
    
    @objc func openReport() {
        delegate?.showReport(index)
    }
    
    @objc func openInstructions() {
        delegate?.showInstructions(index)
    }
}


