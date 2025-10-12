//
//  BreakFastCell.swift
//  CareMate
//
//  Created by khabeer on 2/2/20.
//  Copyright © 2020 khabeer Group. All rights reserved.
//

import UIKit
protocol BreakFastCellDelagete {
    func CellClicked(_ data: BreakFastCell)
    
}

class BreakFastCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var colorView: UIView!

    var delegate: BreakFastCellDelagete?
    @IBAction func CellClicked(sender: UIButton)
    {
        self.delegate!.CellClicked(self)
    }
}

