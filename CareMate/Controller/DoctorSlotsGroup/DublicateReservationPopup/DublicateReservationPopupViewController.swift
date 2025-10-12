//
//  DublicateReservationPopupViewController.swift
//  CareMate
//
//  Created by m3azy on 09/11/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

typealias DublicationPopupClosure = (Int) -> Void

func OPEN_DUBLICATE_POPUP(container: UIViewController, message: String, closure: DublicationPopupClosure? = nil) {
    let vc = DublicateReservationPopupViewController(message)
    vc.closure = { type in
        vc.dismiss(animated: false) {
            closure?(type)
        }
    }
    vc.modalPresentationStyle = .overFullScreen
    container.present(vc, animated: false)
}


class DublicateReservationPopupViewController: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var labelContinue: UILabel!
    @IBOutlet weak var viewContinueAndCancel: UIView!
    @IBOutlet weak var labelContinueAndCancel: UILabel!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var labelCancel: UILabel!
    
    var message = ""
    var closure: DublicationPopupClosure?
    
    init(_ message: String) {
        super.init(nibName: "DublicateReservationPopupViewController", bundle: nil)
        self.message = message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserManager.isArabic {
            labelContinue.text = "استمرار"
            labelContinueAndCancel.text = "استمرار والغاء القديم"
            labelCancel.text = "الغاء"
        }
        viewCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel)))
        viewContinue.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(continueWithOld)))
        viewContinueAndCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(continueAndCancel)))
        self.view.backgroundColor = .fromHex(hex: "000000", alpha: 0.25)
        labelCancel.textAlignment = .center
        labelContinue.textAlignment = .center
        labelContinueAndCancel.textAlignment = .center
        labelMessage.text = message
        viewContinue.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewBackground.popIn()
    }

    @objc func cancel() {
        viewBackground.popOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.closure?(0)
        }
    }
    
    @objc func continueWithOld() {
        viewBackground.popOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.closure?(2)
        }
    }
    
    @objc func continueAndCancel() {
        viewBackground.popOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.closure?(1)
        }
    }
}
