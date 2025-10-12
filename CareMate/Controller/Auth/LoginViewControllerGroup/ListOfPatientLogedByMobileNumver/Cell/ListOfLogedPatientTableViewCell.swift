//
//  ListOfLogedPatientTableViewCell.swift
//  CareMate
//
//  Created by Khabber on 09/01/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class ListOfLogedPatientTableViewCell: UITableViewCell {

    @IBOutlet public weak var personName: UILabel!
    @IBOutlet public weak var avterPerson: UIImageView!
    @IBOutlet public weak var rightSign: UIImageView!
    @IBOutlet public weak var mainView: RoundUIView!
    @IBOutlet public weak var innerView: RoundUIView!
    @IBOutlet public weak var OuterView: RoundUIView!
    @IBOutlet weak var labelPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.setShadowLight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setData(_ model:listOfTherPatient,
                 _index:Int,_ selectedIndex:Int)
    {
        if _index == selectedIndex
        {
            self.innerView.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.5137254902, blue: 0.7921568627, alpha: 1)
        }
        else
        {
            self.innerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }

//        if UserManager.isArabic
//        {
//            self.personName.text = model.COMPLETEPATNAME_AR
//        }
//        else
//        {
            self.personName.text = model.COMPLETEPATNAME_EN
//        }

        labelPhone.text = model.PATIENTID
    }
}
