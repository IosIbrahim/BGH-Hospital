//
//  SessionCell.swift
//  CareMate
//
//  Created by Ibrahim on 24/05/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

import UIKit

protocol SessionRowProtocol {
    func setlectSession(_ row:SessionRowModel,hospital:String)
}

class SessionCell: UITableViewCell {

    @IBOutlet weak var stkDate: UIStackView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lblFinalStatus: UILabel!
    @IBOutlet weak var stkBranch: UIStackView!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var stkPlace: UIStackView!
    @IBOutlet weak var pickerTime: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var pickerStartDate: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var pickerStatus: UIView!
    @IBOutlet weak var lblDocSessionSpeciality: UILabel!
    @IBOutlet weak var lblDocSession: UILabel!
    @IBOutlet weak var lblSession: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblSession.textAlignment = UserManager.isArabic ? .right:.left
        lblDocSession.textAlignment = UserManager.isArabic ? .right:.left
        lblDocSessionSpeciality.textAlignment = UserManager.isArabic ? .right:.left
        lblStatus.textAlignment = .center
        lblDate.textAlignment = UserManager.isArabic ? .right:.left
        lblTime.textAlignment = UserManager.isArabic ? .right:.left
        lblPlace.textAlignment = UserManager.isArabic ? .right:.left
        lblFinalStatus.textAlignment = .center

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func drawCell(_ session:SessionRowModel?,hospital:String) {
        lblSession.text = session?.getService()
        lblDocSession.text = session?.getDoctorName()
        lblDocSessionSpeciality.text = session?.getDoctorSpecial()
        lblStatus.text = session?.getStatusTitle()
        if session?.canReSchedule == "1" {
            lblStatus.textColor = .white
        }else {
            lblStatus.textColor = .black
        }
        pickerStatus.backgroundColor = session?.getStatusColor()
        if let date = session?.doneDate {
            lblDate.text = date.components(separatedBy: .whitespaces).first
            lblTime.text = date.components(separatedBy: .whitespaces).last
        }else if let date = session?.expectedDoneDate {
            lblDate.text = date.components(separatedBy: .whitespaces).first
            lblTime.text = date.components(separatedBy: .whitespaces).last
        }else {
            lblDate.text = ""
            lblTime.text = ""
        }
        if session?.isWaitingApporve() == true || session?.isCanSchedule() == true {
            lblDocSession.isHidden = true
            lblDocSessionSpeciality.isHidden = true
            stkDate.isHidden = true
            btnAction.isHidden = true
            if session?.isCanSchedule() == true {
                stkBranch.isHidden = true
            }
        }else {
            lblDocSession.isHidden = false
            lblDocSessionSpeciality.isHidden = false
            stkDate.isHidden = false
            btnAction.isHidden = false
            lblFinalStatus.isHidden = false
        }
        lblPlace.text = hospital
        lblFinalStatus.text = session?.getStatus()
        lblFinalStatus.textAlignment = .center
        btnAction.setTitle(session?.getStatusAction(), for: .normal)
        btnAction.isHidden = session?.waitApprove == "1"
    }
    
    @IBAction func sessionActionOnTap(_ sender: Any) {
        
    }
    
}
