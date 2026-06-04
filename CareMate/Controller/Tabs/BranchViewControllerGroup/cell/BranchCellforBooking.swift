//
//  BranchCellforBooking.swift
//  CareMate
//
//  Created by Khabber on 18/05/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

protocol BranchSessionProtocol {
    func selectSessionBranch(_ index:Int,new:Bool)
}

class BranchCellforBooking: UITableViewCell {
    
    @IBOutlet weak var btnNewSession: UIButton!
    @IBOutlet weak var btnSessions: UIButton!
    @IBOutlet weak var stkAction: UIStackView!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var mainview: UIView!

    var isPhysical:Bool = false
    var selectIndex:Int = .zero
    var delegate:BranchSessionProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stkAction.isHidden = !isPhysical
        let sessions = UserManager.isArabic ? "الجلسات":"Sessions"
        btnSessions.setTitle(sessions, for: .normal)
        let new = UserManager.isArabic ? "جلسة جديدة":"New Session"
        btnNewSession.setTitle(new, for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(branch: Branch)  {
        stkAction.isHidden = !isPhysical
        self.hospitalName.text = UserManager.isArabic ? branch.arabicName : branch.englishName
        stkAction.isHidden = true
    }
    
    @IBAction func sessionsOnTap(_ sender: Any) {
        delegate?.selectSessionBranch(selectIndex, new: false)
    }
    
    @IBAction func newSessionOnTap(_ sender: Any) {
        delegate?.selectSessionBranch(selectIndex, new: true)
    }
    
}
