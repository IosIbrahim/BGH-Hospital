//
//  AmbulanceHistoryTableViewCell.swift
//  CareMate
//
//  Created by m3azy on 25/09/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

protocol AmbulanceCellDelegate {
    func cancelOrder(_ index: Int)
}

class AmbulanceHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelRequesterData: UILabel!
    @IBOutlet weak var labelPatientName: UILabel!
    @IBOutlet weak var labelPatintPhone: UILabel!
    @IBOutlet weak var labelRequesterTitle: UILabel!
    @IBOutlet weak var labelPatintTitl: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewStatus: UIView!
    
    var delegate: AmbulanceCellDelegate?
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.setShadowLight()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.viewBackground.roundCorners([.bottomRight, .bottomLeft], radius: 8)
        }
    }

    func setData(_ model: AmbulanceModel) {
        labelDate.text = model.CAL_DATE.ConvertToDate.withMonthName
        labelStatus.text = UserManager.isArabic ? model.CALL_WF_NAME_AR : model.CALL_WF_NAME_EN
        labelType.text = UserManager.isArabic ? model.CALL_TYPE_NAME_AR : model.CALL_TYPE_NAME_EN
        labelRequesterData.text = model.CALLAR_NAME
        labelPatientName.text = UserManager.isArabic ? model.COMPLETEPATNAME_AR : model.COMPLETEPATNAME_EN
        labelPatientName.text =  model.COMPLETEPATNAME_EN
//        labelPatintPhone.text = model.
        if UserManager.isArabic {
            labelRequesterTitle.text = "بيانات الطالب"
            labelPatintTitl.text = "بيانات المريض"
            btnCancel.setTitle("إلغاء", for: .normal)
        }
        var color: UIColor?
        switch model.ACTION_SER {
        case "1": // new
            btnCancel.isHidden = false
            color = .fromHex(hex: "#323188", alpha: 1)
            break
        case "2": // cancelled
            btnCancel.isHidden = true
            color = .fromHex(hex: "#EE1145", alpha: 1)
            break
        case "3": // accepted
            btnCancel.isHidden = true
            color = .fromHex(hex: "#1A9A8C", alpha: 1)
            break
        default:
            break
        }
        viewStatus.backgroundColor = color
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.cancelOrder(index)
    }
}
