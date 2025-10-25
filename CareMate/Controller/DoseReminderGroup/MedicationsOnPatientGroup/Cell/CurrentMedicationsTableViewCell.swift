//
//  CurrentMedCell.swift
//  CareMate
//
//  Created by khabeer on 11/27/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import UIKit

class CurrentMedicationsTableViewCell: UITableViewCell {

    @IBOutlet weak var drugName: UILabel!
    @IBOutlet weak var drugDose: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var imageViewMed: UIImageView!
    
    var getCurrentMedDto:getCurrentMedDTO?
    var delegate: DrugCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewMed.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImage)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(getCurrentMed: getCurrentMedDTO)  {
        
        print(getCurrentMed)
        self.getCurrentMedDto = getCurrentMed
        self.drugName.text = UserManager.isArabic ? getCurrentMedDto?.ITEMARNAME : getCurrentMedDto?.ITEMENNAME
        self.drugDose.text = UserManager.isArabic ? getCurrentMedDto?.NOTES :getCurrentMedDto?.NOTES_EN
        imageViewMed.loadFromUrl(url: "\(Constants.APIProvider.IMAGE_BASE)/\(getCurrentMed.DRUG_IMAGE)", placeHolder: "BHG-medicineBottel")
      
//        self.startDate.text = UserManager.isArabic ? getCurrentMedDto?.STARTDATE :getCurrentMedDto?.STARTDATE
//        self.endDate.text = UserManager.isArabic ? getCurrentMedDto?.ENDDATE :getCurrentMedDto?.ENDDATE

        
    }

    @objc func openImage() {
        delegate?.openImage(imageViewMed)
    }
}

