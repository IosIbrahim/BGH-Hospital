//
//  FilterByDateViewController.swift
//  CareMate
//
//  Created by Khabber on 06/04/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit
import PopupDialog

protocol returnTpLab{
    
    func returnTpLabfunc(dateFrom:String ,dateTo:String)
}
class FilterByDateViewController: UIViewController {

    @IBOutlet weak var uiviewComfirm: UIView!
    @IBOutlet weak var uiviewDateFrom: UIView!
    @IBOutlet weak var uilabelDateTo: UILabel!
    @IBOutlet weak var uilabelDateFrom: UILabel!
    @IBOutlet weak var uilabelComfirm: UILabel!
    @IBOutlet weak var UiviewDateTo: UIView!
    var dateFrom = false
    var dateFromDate = ""
    var dateTo = ""

    var delegate :returnTpLab?
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserManager.isArabic
        {
            uilabelDateTo.text = "التاريخ الي"
            uilabelDateFrom.text = "التاريخ من"
            uilabelComfirm.text = "تآكيد"

        }
        else
        {
            uilabelDateTo.text = "Date To"
            uilabelDateFrom.text = "Date From"
            uilabelComfirm.text = "Comfirm"

        }
        setupDate()
    }
    
    func setupDate()  {
        let gestureDateFrom = UITapGestureRecognizer(target: self, action:  #selector(DateCliked))
        self.uiviewDateFrom.addGestureRecognizer(gestureDateFrom)
        let gestureDateTo = UITapGestureRecognizer(target: self, action:  #selector(DateClikedTo))
        self.UiviewDateTo.addGestureRecognizer(gestureDateTo)
        let gestureComfirm = UITapGestureRecognizer(target: self, action:  #selector(comfirmCliked))
        self.uiviewComfirm.addGestureRecognizer(gestureComfirm)

    }
    
    @objc func DateCliked()
    {
        let vc:DatePickerPopUpVC =   DatePickerPopUpVC()
        vc.delegate = self
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  tapGestureDismissal: true)
        dateFrom = true
        self.present(popup, animated: true, completion: nil)
    }
    @objc func DateClikedTo()
    {
        let vc:DatePickerPopUpVC =   DatePickerPopUpVC()
        vc.delegate = self
        dateFrom = false
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  tapGestureDismissal: true)
        self.present(popup, animated: true, completion: nil)
    }
    @objc func comfirmCliked()
    {
        if dateFromDate != "" && dateTo != ""
        {
            delegate?.returnTpLabfunc(dateFrom: dateFromDate, dateTo: dateTo)
            self.mz_dismissFormSheetController(animated: true, completionHandler: nil)
        }
        else
        {
            Utilities.showAlert(self, messageToDisplay : UserManager.isArabic ? " من فضلك ادخل التورايخ" : "Plz Enter All Dates")

        }
    }


 

}
extension FilterByDateViewController :DataPickerPopupDelegate
{
    
    
    func timeDidAdded(day: Int, month: Int, year: Int) {
        if dateFrom == true
        {
            uilabelDateFrom.text = "\(day) - \(month) - \(year)"
        }
        else{
            uilabelDateTo.text = "\(day) - \(month) - \(year)"
        }
    }
    func returnDate(date: Date) {
   
        let formate = date.getFormattedDate(format: "dd-MM-yyyy HH:mm:ss") // Set output formate
   
        if dateFrom == true
        {
            dateFromDate = formate
        }
        else
        {
            dateTo = formate

        }

    }
    
}
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
