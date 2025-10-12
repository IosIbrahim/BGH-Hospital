//
//  doseReminderCell.swift
//  CareMate
//
//  Created by khabeer on 11/24/19.
//  Copyright © 2019 khabeer Group. All rights reserved.
//

import UIKit

class DoseTimesTableViewCell: UITableViewCell {
    @IBOutlet weak var getCurrentMed: UILabel!
    @IBOutlet weak var ItemDose: UILabel!
    @IBOutlet weak var TakeImage: UIImageView!


    var getCurrentMedDto:getCurrentMedDTO!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(getCurrentMed: getCurrentMedDTO)  {
        
        print(getCurrentMed)
        self.getCurrentMedDto = getCurrentMed
        self.getCurrentMed.text = UserManager.isArabic ? getCurrentMedDto?.ITEMARNAME :getCurrentMedDto?.ITEMENNAME
        self.ItemDose.text = UserManager.isArabic ? getCurrentMedDto?.NOTES :getCurrentMedDto?.NOTES_EN

    }
}


