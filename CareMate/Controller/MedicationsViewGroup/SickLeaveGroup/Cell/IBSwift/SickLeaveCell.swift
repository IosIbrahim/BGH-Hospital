//
//  SickLeaveCell.swift
//  CareMate
//
//  Created by MAC on 01/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
protocol goToPrintSickLeve {
    func goToPrintSickLevefunc( _model :sickLeaveDTO)
}
class SickLeaveCell: UITableViewCell {
    
    @IBOutlet weak var imageViewDoctor: UIImageView!
    @IBOutlet weak var labelDoctorNAme: UILabel!
    @IBOutlet weak var labelSpeciality: UILabel!
    @IBOutlet weak var labelVisitDateTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelVisitType: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelClinic: UILabel!
    @IBOutlet weak var labelPlaceTitle: UILabel!
    @IBOutlet weak var viewShowReport: UIView!
    @IBOutlet weak var labelShowReport: UILabel!
    
    var model: sickLeaveDTO?
    var delegate: goToPrintSickLeve?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserManager.isArabic {
            labelVisitDateTitle.text = "تاريخ الزيارة"
            labelVisitType.text = "نوع الزيارة"
            labelPlaceTitle.text = "الفرع"
            labelShowReport.text = "عرض التقرير"
        }
        viewShowReport.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openReport)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ Object: sickLeaveDTO) {
        self.model = Object
        labelDoctorNAme.text = UserManager.isArabic ? Object.EMP_NAME_AR : Object.EMP_NAME_EN
        labelSpeciality.text = UserManager.isArabic ? Object.SPECIALITY_NAME_AR : Object.SPECIALITY_NAME_EN
        labelDate.text = Object.VISIT_START_DATE.ConvertToDate.withMonthName
        labelType.text = UserManager.isArabic ? Object.VISIT_TYPE_AR : Object.VISIT_TYPE_EN
        labelClinic.text = UserManager.isArabic ? Object.HOSP_NAME_AR : Object.HOSP_NAME_EN
    }
    
    
    
    @objc func openReport() {
        delegate?.goToPrintSickLevefunc(_model: self.model!)
    }
    
}
