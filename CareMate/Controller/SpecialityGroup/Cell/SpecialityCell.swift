//
//  SpecialitiesCell.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/13/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import UIKit

class SpecialityCell: UICollectionViewCell {
  
  @IBOutlet weak var specialityTitle: uilabelCenter!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var image1: UIImageView!


  
  override func awakeFromNib() {
    super.awakeFromNib()
      
      mainView.makeShadow(color: .black, alpha: 0.14, radius: 4)

  }
}
