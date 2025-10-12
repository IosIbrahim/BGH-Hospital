//
//  CancelPopupViewController.swift
//  CareMate
//
//  Created by m3azy on 25/09/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

typealias CancelPopupClosure = (Bool, String?, AmbulanceReasonModel?) -> Void

func OPEN_CANCEL_POPUP(container: UIViewController, arrayReasons: [AmbulanceReasonModel], message: String, closure: CancelPopupClosure? = nil) {
    let vc = CancelPopupViewController(message: message, arrayReasons: arrayReasons)
    vc.closure = { (isOk, reason, reasonModel) in
        vc.dismiss(animated: false) {
            closure?(isOk, reason, reasonModel)
        }
    }
    vc.modalPresentationStyle = .overFullScreen
    container.present(vc, animated: false)
}


class CancelPopupViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var textViewReason: UITextView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewChooseReason: UIView!
    @IBOutlet weak var labelReasons: UILabel!
    
    var closure: CancelPopupClosure?
    var message = ""
    var arrayReasons = [AmbulanceReasonModel]()
    var selectedReason: AmbulanceReasonModel?
    
    init(message: String, arrayReasons: [AmbulanceReasonModel]) {
        self.message = message
        self.arrayReasons = arrayReasons
        super.init(nibName: "CancelPopupViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserManager.isArabic {
            btnYes.setTitle("تأكيد", for: .normal)
            btnNo.setTitle("الرجوع", for: .normal)
            labelReasons.text = "اختر السبب"
        }
        labelTitle.text = message
        self.view.backgroundColor = .fromHex(hex: "000000", alpha: 0.25)
        viewChooseReason.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openReasons)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewBackground.popIn()
    }
    
    @objc func openReasons() {
        OPEN_LIST_POPUP(container: self, arrayNames: arrayReasons.map({UserManager.isArabic ? $0.NAME_AR : $0.NAME_EN})) { index in
            guard let index else { return }
            self.selectedReason = self.arrayReasons[index]
            self.labelReasons.text = UserManager.isArabic ? self.selectedReason?.NAME_AR : self.selectedReason?.NAME_EN
        }
    }

    @IBAction func no(_ sender: Any) {
        viewBackground.popOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.closure?(false, nil, nil)
        }
    }
    
    @IBAction func yes(_ sender: Any) {
        if selectedReason == nil {
            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "من فضلك اختر سبب الالغاء" : "Please choose the cancellation reason")
            return
        }
        if textViewReason.text == "" && selectedReason?.NEED_TEXT ?? "" == "1" {
            OPEN_HINT_POPUP(container: self, message: UserManager.isArabic ? "من فضلك اكتب سبب الالغاء" : "Please enter the cancellation reason")
            return
        }
        viewBackground.popOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.closure?(true, self.textViewReason.text!, self.selectedReason)
        }
    }
}
