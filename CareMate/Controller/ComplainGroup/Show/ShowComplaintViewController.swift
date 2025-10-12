//
//  ShowComplaintViewController.swift
//  CareMate
//
//  Created by m3azy on 05/11/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class ShowComplaintViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelTypeTitle: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelCatTitle: UILabel!
    @IBOutlet weak var labelCat: UILabel!
    @IBOutlet weak var labelCompaintTitle: UILabel!
    @IBOutlet weak var textViewComplaint: UITextView!
    @IBOutlet weak var viewType: UIView!
    @IBOutlet weak var viewCat: UIView!
    @IBOutlet weak var viewNotes: UIView!
    
    var modelComplaint: ComplainsDTO?
    
    init(_ modelComplaint: ComplainsDTO) {
        super.init(nibName: "ShowComplaintViewController", bundle: nil)
        self.modelComplaint = modelComplaint
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(title: UserManager.isArabic ? "تفاصيل الشكوي" : "Complaint Details")
        getData()
        if UserManager.isArabic{
            labelTypeTitle.text = "نوع الشكوي"
            labelCatTitle.text = "اختار نوع الشكوي"
            labelCompaintTitle.text = "الشكوي"
            textViewComplaint.textAlignment = .right
        }
        viewType.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewCat.makeShadow(color: .black, alpha: 0.14, radius: 4)
        viewNotes.makeShadow(color: .black, alpha: 0.14, radius: 4)
    }

    func getData() {
        let urlString = "\(Constants.APIProvider.CRMCOMPLAINTSLOAD)req=\(modelComplaint?.COMPLAIN_SERIAL ?? "")"
        scrollView.isHidden = true
        WebserviceMananger.sharedInstance.makeCall(method: .get, url: urlString, parameters: nil, vc: self) { (data, error) in
            if error == nil {
                if let root = (((data as! [String: AnyObject])["Root"] as! [String:AnyObject])["CRM_COMPLAINTS_NEW"] as? [String:AnyObject])?["CRM_COMPLAINTS_NEW_ROW"] as? [String: AnyObject] {
                    self.scrollView.isHidden = false
                    self.labelType.text = root[UserManager.isArabic ? "COMPLAINTS_TYPE_NAME_AR" : "COMPLAINTS_TYPE_NAME_EN"] as? String ?? ""
                    self.labelCat.text = root[UserManager.isArabic ? "COMPLAINTS_CAT_NAME_AR" : "COMPLAINTS_CAT_NAME_EN"] as? String ?? ""
                    self.textViewComplaint.text = root["COMPLAINT_TEXT"] as? String ?? ""
                }
            }
        }
    }
}
