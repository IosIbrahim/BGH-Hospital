//
//  BranchCellforBooking.swift
//  CareMate
//
//  Created by Khabber on 18/05/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class BranchCellforBooking: UITableViewCell {
    @IBOutlet weak var hospitalNumber: UILabel!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var hospitalDescropation: UILabel!
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var imageViewBranch: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(branch: Branch)  {


        
        self.hospitalName.text = UserManager.isArabic ? branch.arabicName : branch.englishName
        self.hospitalDescropation.text = UserManager.isArabic ? "مستشفي السلام الدولي" : "el Salam Hospital"
        let imageUrl = "\(Constants.APIProvider.IMAGE_BASE)images/branch_\(branch.id).png"
        print("branchImage: \(imageUrl)")
        imageViewBranch.loadFromUrl(url: imageUrl, placeHolder: "Al-Salam-Hospital (1)")
    }
    
}
