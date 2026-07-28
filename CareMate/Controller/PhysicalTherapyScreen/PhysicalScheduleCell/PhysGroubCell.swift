//
//  PhysGroubCell.swift
//  CareMate
//
//  Created by Ibrahim on 24/05/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

import UIKit

class PhysGroubCell: UITableViewCell {

    @IBOutlet weak var imgDrop: UIImageView!
    @IBOutlet weak var sessionConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var tblSessions: UITableView!
    @IBOutlet weak var pickerShow: UIView!
    @IBOutlet weak var lblShow: UILabel!
    @IBOutlet weak var lblRequestDate: UILabel!
    @IBOutlet weak var lblDocSpeciality: UILabel!
    @IBOutlet weak var lblDocName: UILabel!
    @IBOutlet weak var imgDoc: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    private var dataSource = [SessionRowModel]()
    private var hospitalTitle:String = ""
    var delegate:SessionRowProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.textAlignment = UserManager.isArabic ? .right:.left
        lblDocName.textAlignment = UserManager.isArabic ? .right:.left
        lblDocSpeciality.textAlignment = UserManager.isArabic ? .right:.left
        lblRequestDate.textAlignment = UserManager.isArabic ? .right:.left
        tblSessions.dataSource = self
        tblSessions.delegate = self
        tblSessions.register("SessionCell")
        contentView.layer.cornerRadius = 12
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func drawCell(_ session:ServiceSessionRowModel?,filter:SessionFilter) {
        lblTitle.text = UserManager.isArabic ? "طلب جلسات علاج طبيعي":"Booking Physical Therapy Sessions"
        lblDocName.text =  session?.getDoctorName()
        lblDocSpeciality.text = session?.getDoctorSpecial()
        lblRequestDate.text = session?.startDate
        lblShow.text = UserManager.isArabic ? "عرض الجلسات":"Show Sessions"
        sessionConstraintHeight.constant = .zero
        tblSessions.isHidden = true
        if session?.isSelected == true {
            lblShow.text = UserManager.isArabic ? "اخفاء الجلسات":"Hide Sessions"
            var count:Int = .zero
          
            for item in session?.sessions?.rows ?? [] {
                count += item.getRowHieght()
            }
            
              sessionConstraintHeight.constant = CGFloat(count)
            tblSessions.isHidden = false
            imgDrop.image?.imageRotated(byDegrees: 90)
            imgDrop.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }else {
            imgDrop.image?.imageRotated(byDegrees: 0)
            imgDrop.transform = CGAffineTransform(rotationAngle: 0)
        }
        tblSessions.updateConstraints()
        hospitalTitle = session?.getHospital() ?? ""
        if filter == .all {
            dataSource = session?.sessions?.rows ?? []
        }else {
            dataSource = session?.sessions?.getFiltered(filter) ?? []
        }
        tblSessions.reloadData()
    }
    
}

extension PhysGroubCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCell", for: indexPath) as! SessionCell
        cell.drawCell(dataSource[indexPath.row], hospital: hospitalTitle)
        return cell
    }
   
}

extension PhysGroubCell: UITableViewDelegate {
    
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return CGFloat(dataSource[indexPath.row].getRowHieght())
  }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let model = dataSource[indexPath.row]
     if !model.isWaitingApporve() {
         delegate?.setlectSession(dataSource[indexPath.row],hospital: hospitalTitle)
     }
 }


}
