//
//  RXOfPatientDetails.swift
//  CareMate
//
//  Created by MAC on 28/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit

class RXOfPatientDetails: BaseViewController {
    
  
    @IBOutlet weak var rxTypeText: UILabel!
    @IBOutlet weak var rxTypeHeader: UILabel!

    @IBOutlet weak var visitTypeText: UILabel!
    @IBOutlet weak var visitDateText: UILabel!
    @IBOutlet weak var RXDate: UILabel!
    @IBOutlet weak var itemAprrovel: UILabel!
    @IBOutlet weak var itemCount: UILabel!
//    @IBOutlet weak var rxType: UILabel!
    @IBOutlet weak var doctor: UILabel!
    @IBOutlet weak var visitType: UILabel!
    @IBOutlet weak var visitDate: UILabel!
    @IBOutlet weak var addedItems: UILabel!
    @IBOutlet weak var ItemCount1: UILabel!

    
    @IBOutlet weak var imageRx: UIImageView!


    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var labelItemTitle: UILabel!
    @IBOutlet weak var table: UITableView!
    var MEDPLANCD = ""
    var NumberOf = ""
    var  object:RxModel?
    var listOfDrugsRelatedTORX = [RxModelDetails]()
    var listOfDrugsRelatedTORXCountApproved = [RxModelDetails]()

    
    init(MEDPLANCD: String,object:RxModel,nuberOfItems:String?) {
        super.init(nibName: "RXOfPatientDetails", bundle: nil)
        self.MEDPLANCD = MEDPLANCD
        self.object = object
        self.NumberOf = nuberOfItems ?? ""
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTabBar.instance.setuptabBar(vc: self)
        mainView.makeShadow(color: .black, alpha: 0.14, radius: 4)
        imageRx.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)

        addedItems.text =  UserManager.isArabic ? "الادويه المضافه" : "added Items"
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "تفاصيل الوصفة" :"Rx Details", hideBack: false)

        setup()
        getdata()
        visitType.text = UserManager.isArabic ? object?.VISIT_TYPE_AR :object?.VISIT_TYPE_EN
        doctor.text = UserManager.isArabic ? object?.DOC_NAME_AR :object?.DOC_NAME_EN
        RXDate.text  = object?.MEDPLANDATE.formateDAte(dateString: object?.MEDPLANDATE, formateString: "dd MMMM yyyy")
//        rxType.text = UserManager.isArabic ? object?.PRESC_TYPE_AR :object?.PREC_TYPE_EN
        rxTypeHeader.text = UserManager.isArabic ? object?.PRESC_TYPE_AR :object?.PREC_TYPE_EN
        
        
        ItemCount1.text =  self.NumberOf

    
    
        if UserManager.isArabic{
            itemAprrovel.text = "تم الموافقه"
            labelItemTitle.text = "عنصر"
        }
        else{
            itemAprrovel.text = "APPROVED"
        }
        visitDate.text =  object?.VISIT_START_DATE.formateDAte(dateString: object?.VISIT_START_DATE, formateString: "dd MMMM yyyy")
        if UserManager.isArabic
        {
            rxTypeText.text = "نوع الروشيته"
            visitTypeText.text = "نوع الزيارة"
            visitDateText.text = "تاريخ الزيارة"
        }
        else
        {
            rxTypeText.text = "Rx Type"
            visitTypeText.text = "Visit Type"
            visitDateText.text = "Visit Date"
        }
       
    }


}
