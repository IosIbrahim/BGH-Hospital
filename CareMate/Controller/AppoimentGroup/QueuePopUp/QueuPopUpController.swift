//
//  QueuPopUpController.swift
//  CareMate
//
//  Created by Ibrahim on 10/03/2025.
//  Copyright © 2025 khabeer Group. All rights reserved.
//

import UIKit
import MZFormSheetController

class QueuPopUpController: UIViewController {
    var current:String = ""
    var myQueue: String = ""
    
    @IBOutlet weak var lblClose: UILabel!
    @IBOutlet weak var pickerClose: UIView!
    @IBOutlet weak var lblMyQueue: UILabel!
    @IBOutlet weak var lblQueue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentStr = UserManager.isArabic ? "رقم قائمة الانتظار \(current)":"Current Queue Num \(current)"
        let my = UserManager.isArabic ? "رقم الانتظار الخاص بك \(myQueue)":"Your Queue Number:\(myQueue)"
        let close = UserManager.isArabic ? "اغلاق":"Close"
        lblClose.text = close
        lblQueue.text = currentStr
        lblMyQueue.restorationIdentifier = my
        lblClose.textAlignment = .center
        lblQueue.textAlignment = UserManager.isArabic ? .right:.left
        lblMyQueue.textAlignment = UserManager.isArabic ? .right:.left
        
        pickerClose.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeClicked)))

        // Do any additional setup after loading the view.
    }

    @objc func closeClicked()
    
    {
        self.mz_dismissFormSheetController(animated: true, completionHandler: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
