//
//  PackageThirdCell.swift
//  careMatePatient
//
//  Created by khabeer on 12/13/20.
//  Copyright © 2020 khabeer. All rights reserved.
//
import UIKit

class medicationsViewCell: UICollectionViewCell {
    @IBOutlet public weak var image123: UIImageView!
    @IBOutlet public weak var LabName: uilabelCenter!
    @IBOutlet weak var main: RoundUIView!
    @IBOutlet weak var cymain: RoundUIView!

    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageViewTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottom: NSLayoutConstraint!
    @IBOutlet weak var imageViewTri: NSLayoutConstraint!
    @IBOutlet weak var imageViewleading: NSLayoutConstraint!
    @IBOutlet weak var mainViewTop: NSLayoutConstraint!
    @IBOutlet weak var mainViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainViewTri: NSLayoutConstraint!
    @IBOutlet weak var mainViewleading: NSLayoutConstraint!
    @IBOutlet weak var LabelTop: NSLayoutConstraint!

    var fromHos = false

    override func awakeFromNib() {
        super.awakeFromNib()
        main.makeShadow(color: .black, alpha: 0.14, radius: 4)
        
        // cymain as circle with your specified color and opacity
        cymain.backgroundColor = UIColor(red: 198/255, green: 215/255, blue: 238/255, alpha: 0.13)
        cymain.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Make cymain a circle
        cymain.layer.cornerRadius = cymain.frame.height / 2
    }

    func handelCEll() {
        let width = UIScreen.main.bounds.width

        imageHeight.constant = width * 0.5 - 30
        imageWidth.constant = width * 0.5 - 30

        // Keep cymain as circle with color
        cymain.backgroundColor = UIColor(red: 198/255, green: 215/255, blue: 238/255, alpha: 1)
        cymain.layer.cornerRadius = cymain.frame.height / 2
        cymain.clipsToBounds = true

        imageViewBottom.constant = 10
        imageViewTri.constant = 0
        imageViewleading.constant = 0
        mainViewTop.constant = 0
        mainViewBottom.constant = 0
        mainViewTri.constant = 0
        mainViewleading.constant = 0
        LabelTop.constant = 0
    }
}

extension UIView {
    func makeShadow(color: UIColor, alpha: Float, radius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = alpha
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: 0, height: radius * UIScreen.main.bounds.width / 360)
    }
}
