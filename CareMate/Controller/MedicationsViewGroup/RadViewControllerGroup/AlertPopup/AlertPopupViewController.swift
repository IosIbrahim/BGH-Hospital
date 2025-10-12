//
//  AlertPopupViewController.swift
//  CareMate
//
//  Created by m3azy on 28/07/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class AlertPopupViewController: UIViewController {

    @IBOutlet weak var textViewWarninng: UITextView!
    @IBOutlet weak var imaegViewClose: UIImageView!
    @IBOutlet weak var labelImportant: UILabel!

    
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewWarninng.text = text.replacingOccurrences(of: "/n", with: "\n")
        textViewWarninng.textAlignment = LanguageManager.isArabic() ? .right:.left
        textViewWarninng.isEditable = false
        imaegViewClose.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        labelImportant.text = UserManager.isArabic ? "تعليمات هامة" : "Important Instructions"
        let fontName = UserManager.isArabic  ? "Tajawal-Bold":"cairo_bold"
        let fnt =  UIFont(name: "Tajawal-Bold", size: 18.0)
        let readmoreFont = UIFont(name: fontName, size: 18) ?? fnt
        textViewWarninng.font = readmoreFont
    }

    @objc func close() {
        mz_dismissFormSheetController(animated: true, completionHandler: nil)
    }
}
