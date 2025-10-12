//
//  AddTimePopupViewController.swift
//  KiddowzNursery
//
//  Created by Mohamed Elmaazy on 4/12/20.
//  Copyright © 2020 Mohamed Hossam Khedr. All rights reserved.
//

import UIKit

@objc protocol DataPickerPopupDelegate {
    func timeDidAdded(day: Int, month: Int, year: Int)
    
    @objc optional func returnDate(date:Date)

}

class DatePickerPopUpVC: BaseViewController {
    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var btnAdd: UIButton!
    
    var delegate: DataPickerPopupDelegate?
    var minimumAge: Int?
    static var operation = false
    
    static var fromRedisteration = false
    
    var minDate: Date?
    var maxDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        picker.backgroundColor = .clear
        picker.datePickerMode = .date
        picker.setDate(Date(), animated: true)
        if minDate != nil {
            picker.minimumDate = minDate
        }
        if maxDate != nil {
            picker.maximumDate = maxDate
        }
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        //        btnAdd.layer.cornerRadius = getRatio(11)
        //        btnAdd.titleLabel?.font = btnAdd.titleLabel?.font.withSize(20)
        //        btnAdd.setTitle(OK.localize, for: .normal)
        
        
        if DatePickerPopUpVC.fromRedisteration == true
        {
            picker.maximumDate = Date()
        }
        else
        {
            if DatePickerPopUpVC.operation ==  true
            {
                //                picker.minimumDate = Date()
                picker.maximumDate = Date()
                
            }
            else
            {
                
            }
            
        }
        
        if LanguageManager.isArabic() {
            btnOk.setTitle("موافق", for: .normal)
        }
        
    }
    
    @IBAction func add(_ sender: Any) {
        let selectedDate = picker.date
        let calendar = Calendar.current
        
        // If minimumAge is set, validate
        if let minAge = minimumAge {
            let cutoffDate = calendar.date(byAdding: .year, value: -minAge, to: Date())!
            if selectedDate > cutoffDate {
              //  showAlert("Invalid Age", message: "You must be at least \(minAge) years old.")
                OPEN_HINT_POPUP(
                    container: self,
                    message: UserManager.isArabic
                        ? "يجب أن يكون عمرك على الأقل \(minAge) سنة."
                        : "You must be at least \(minAge) years old."
                )

                return
            }
        }
        
        let components = calendar.dateComponents([.day, .month, .year], from: selectedDate)
        delegate?.timeDidAdded(day: components.day!, month: components.month!, year: components.year!)
        delegate?.returnDate?(date: selectedDate)
        dismiss(animated: true, completion: nil)
    }
    

    
}
