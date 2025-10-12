//
//  ResultPopupViewController.swift
//  CareMate
//
//  Created by m3azy on 27/08/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

protocol ResultPopupDelegate {
    func goBack()
}

class ResultPopupViewController: UIViewController {

    @IBOutlet weak var lblOk: UILabel!
    @IBOutlet weak var picker: UIView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var labelSent: UILabel!
    @IBOutlet weak var labelDear: UILabel!
    @IBOutlet weak var lablMessage: UILabel!
    @IBOutlet weak var btnOk: UIView!
    
    var delegate: ResultPopupDelegate?
    var message:String = ""
    var isError:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserManager.isArabic{
            labelSent.text = "تم الإرسال بنجاح"
            labelDear.text = "عملينا العزيز"
            lblOk.text = "موافق"
            lablMessage.text = "يسرنا أن تشاركنا ملاحظاتك/ تجربتك\nتأكد أن فريقنا سيقوم بالتواصل معكم في اقرب وقت"
            labelSent.font = UIFont(name: "Tajawal-Bold", size: 22)
            labelDear.font = UIFont(name: "Tajawal-Regular", size: 17)
            lablMessage.font = UIFont(name: "Tajawal-Regular", size: 17)
        }
        labelSent.text = message
        if isError {
            imgStatus.image = UIImage(named: "exclamation-mark-in-a-circle")
            let msg = UserManager.isArabic ? "فضلا قم بمراجعة شكواك او مقترحاتك ":"Please revise your complaints or suggestions"
            lablMessage.text = msg
            picker.isHidden = true
        }
        btnOk.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePopup)))
        
    }
    
    @objc func closePopup() {
        dismiss(animated: true) {
            self.delegate?.goBack()
        }
    }
}
