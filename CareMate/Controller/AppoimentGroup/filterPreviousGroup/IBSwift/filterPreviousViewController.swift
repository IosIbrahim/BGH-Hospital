//
//  filterPreviousViewController.swift
//  CareMate
//
//  Created by MAC on 16/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
import DropDown
import PopupDialog

protocol backAfterFiltered {
    func backAfterFiltered(filterData1:[AppointmentDTO], doctorName: String, clinicName: String, from: String, to: String)
}

class filterPreviousViewController: UIViewController, DataPickerPopupDelegate {
    func timeDidAdded(day: Int, month: Int, year: Int) {
        if dateFrom == true
        {
            uilabelFrom.text = "\(day)-\(month)-\(year)"
            dateFromText = uilabelFrom.text ?? ""
        }
        else{
            uilabelTo.text = "\(day)-\(month)-\(year)"
            dateTo = uilabelTo.text ?? ""
        }
    }
    
    var delegate: backAfterFiltered?
    
    
    @IBOutlet weak var labelDocotrsText: UILabel!
    @IBOutlet weak var labelClinicsText: UILabel!
    @IBOutlet weak var labelPeriodText: UILabel!
    @IBOutlet weak var labelFilter1: UILabel!
    @IBOutlet weak var labelfil: UIButton!

    @IBOutlet weak var labelDel: UIButton!

    
    
    
    @IBOutlet weak var uilabelDoctors: UILabel!
    @IBOutlet weak var uilabelClinics: UILabel!
    @IBOutlet weak var uilabelFrom: UILabel!
    @IBOutlet weak var uilabelTo: UILabel!
    @IBOutlet weak var doctorsView: UIView!
    @IBOutlet weak var clinicsView: UIView!
    @IBOutlet weak var filertView: UIView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!

    var dateFrom = true
    var docName = ""
    var clinicName = ""
    var dateFromText = ""
    var dateTo = ""
    
    init(filterData: [AppointmentDTO]) {
        super.init(nibName: "filterPreviousViewController", bundle: nil)
        self.AllData = filterData
        self.filterData = filterData

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var AllData = [AppointmentDTO]()
    var filterData = [AppointmentDTO]()

    var AllDoctors = [(String, String)]()
    var AllClinics = [(String, String)]()
    var dropDownDoctors = DropDown()
    var dropDownClinics = DropDown()
    var docId = "0"
    var clinicId = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)

        uilabelClinics.text = ""
        uilabelDoctors.text = ""
        uilabelFrom.text = ""
        uilabelTo.text = ""

        
        if UserManager.isArabic
        {
            labelDocotrsText.text = "الاطباء"
            labelClinicsText.text = "العيادات"
            labelPeriodText.text = "المده"
            labelFilter1.text = "تصفية"
            labelfil.setTitle("تصفية", for: .normal)
            labelDel.setTitle("إلغاء", for: .normal)
        }
        else
        {
            labelDocotrsText.text = "Doctors"
            labelClinicsText.text = "Clinics"
            labelPeriodText.text = "Duration"
            labelFilter1.text = "filter"
            labelfil.setTitle("filter", for: .normal)
//            labelDel.setTitle("Clear", for: .normal)
            
            
        }
   
        setupClinic()
        setupDoctor()
        setupDate()
    }

    func setupDoctor()  {
        AllDoctors.removeAll()

        AllDoctors.append(UserManager.isArabic ? ("0", "كل الاطباء") : ("0", "ALL Doctors"))
        for item in AllData {
            var found = false
            for doc in AllDoctors {
                if doc.0 == item.DOC_ID {
                    found = true
                    break
                }
            }
            if !found {
                AllDoctors.append(("\(item.DOC_ID)", UserManager.isArabic ? item.eMP_AR_DATA : item.eMP_EN_DATA))
            }
        }

        let gestureDoctors = UITapGestureRecognizer(target: self, action:  #selector(openDoctors))
        self.doctorsView.addGestureRecognizer(gestureDoctors)
        self.dropDownDoctors.anchorView = doctorsView
        dropDownDoctors.dataSource = AllDoctors.map({$0.1})
    }
    func setupClinic()  {
        AllClinics.removeAll()

        AllClinics.append(UserManager.isArabic ? ("0", "كل العيادات") : ("0", "ALL Clinics"))
        for item in AllData {
            var found = false
            for doc in AllClinics {
                if doc.0 == item.cLINIC_ID {
                    found = true
                    break
                }
            }
            if !found {
                AllClinics.append(("\(item.cLINIC_ID)", UserManager.isArabic ? item.cLINIC_NAME_AR : item.cLINIC_NAME_EN))
            }
        }
        let gestureClinics = UITapGestureRecognizer(target: self, action:  #selector(openClinics))
        self.clinicsView.addGestureRecognizer(gestureClinics)
        self.dropDownClinics.anchorView = clinicsView
        dropDownClinics.dataSource = AllClinics.map({$0.1})
    }
    func setupDate()  {
        let gestureDateFrom = UITapGestureRecognizer(target: self, action:  #selector(DateCliked))
        self.fromView.addGestureRecognizer(gestureDateFrom)
        let gestureDateTo = UITapGestureRecognizer(target: self, action:  #selector(DateClikedTo))
        self.toView.addGestureRecognizer(gestureDateTo)

    }
    @objc func openDoctors(){
        dropDownDoctors.show()
        dropDownDoctors.selectionAction = { [unowned self] (index: Int, item: String) in
            self.docId = AllDoctors[index].0
            self.docName = AllDoctors[index].1
            if index == 0 {
                uilabelDoctors.text = UserManager.isArabic ? "كل الاطباء" : "ALL Doctors"
            } else {
                uilabelDoctors.text = AllDoctors[index].1
            }
        }
    }
    @objc func openClinics(){
        dropDownClinics.show()
        dropDownClinics.selectionAction = { [unowned self] (index: Int, item: String) in
            self.clinicId = AllClinics[index].0
            self.clinicName = AllClinics[index].1
            if index == 0 {
                uilabelClinics.text = UserManager.isArabic ? "كل العيادات" : "ALL Clinics"

            } else {
                uilabelClinics.text = AllClinics[index].1
            }
        }
    }
    @objc func DateCliked()
    {
        let vc:DatePickerPopUpVC =   DatePickerPopUpVC()
        vc.delegate = self
        dateFrom = true
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn,  tapGestureDismissal: true)
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
    
    @IBAction func filterCliked(_ sender: Any) {
        if docId != "0" {
            filterData = filterData.filter{$0.DOC_ID == docId}
        }
        if clinicId != "0" {
            filterData = filterData.filter{$0.cLINIC_ID == clinicId}
        }
        if dateFromText != "" {
            let date = dateFromText.ConvertToDate
            filterData = filterData.filter{$0.eXPECTEDDONEDATE.ConvertToDate > date}
        }
        if dateTo != "" {
            let date = dateTo.ConvertToDate
            filterData = filterData.filter{$0.eXPECTEDDONEDATE.ConvertToDate < date}
        }
        delegate?.backAfterFiltered(filterData1: filterData, doctorName: docName, clinicName: clinicName, from: dateFromText, to: dateTo)
        
        self.mz_dismissFormSheetController(animated: true, completionHandler: nil)

    }
    
    
    @IBAction func clearCliked(_ sender: Any) {
        uilabelClinics.text = ""
        uilabelDoctors.text = ""
        uilabelFrom.text = ""
        uilabelTo.text = ""
        print("AllData.count")

        print(AllData.count)
        delegate?.backAfterFiltered(filterData1: AllData, doctorName: docName, clinicName: clinicName, from: "", to: "")
        self.mz_dismissFormSheetController(animated: true, completionHandler: nil)
    }
    
}
