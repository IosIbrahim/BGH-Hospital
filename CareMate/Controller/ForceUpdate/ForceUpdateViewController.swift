//
//  ForceUpdateViewController.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 31/03/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class ForceUpdateViewController: UIViewController {
    
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var labelHint: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnUpdate.layer.cornerRadius = 4
        if LanguageManager.isArabic() {
            labelHint.text = "هناك نسخة حديثة من التطبيق من فضلك اضغط على تحديث لتنزيلها"
            btnUpdate.setTitle("تحديث", for: .normal)
        }
        labelHint.textAlignment = .center
    }

    @IBAction func update(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/eg/app/dr-bakhsh-hospital-group/id1590769435") {
            UIApplication.shared.open(url)
        }
    }
}
