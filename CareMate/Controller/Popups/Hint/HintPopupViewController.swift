//
//  HintPopupViewController.swift
//  Youveta
//
//  Created by m3azy on 12/02/2022.
//

import UIKit

typealias HintPopupClosure = () -> Void

func OPEN_HINT_POPUP(container: UIViewController, message: String, dismiss: Bool = true, closure: HintPopupClosure? = nil) {
    let vc = HintPopupViewController(message: message, dismiss: dismiss)
    vc.closure = {
        vc.dismiss(animated: false) {
            closure?()
        }
    }
    vc.modalPresentationStyle = .overFullScreen
    container.present(vc, animated: false)
}

class HintPopupViewController: BaseViewController {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var btnOk: UIButton!
//    @IBOutlet weak var constraintWidthViewBackground: NSLayoutConstraint!
    
    var message = ""
    var closure: HintPopupClosure?
    var dismiss = true
    
    init(message: String, dismiss: Bool) {
        super.init(nibName: "HintPopupViewController", bundle: nil)
        self.message = message
        self.dismiss = dismiss
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .fromHex(hex: "000000", alpha: 0.25)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePopup)))
        viewBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        labelMessage.text = message
        labelMessage.font = UIFont(name: "Tajawal-Regular", size: 20)
        btnOk.titleLabel?.font = UIFont(name: "Tajawal-Regular", size: 20)
        if UserManager.isArabic {
            btnOk.setTitle("حسنا", for: .normal)
        }
        labelMessage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyMessage)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewBackground.popIn()
    }
    
    @objc func closePopup() {
        if dismiss {
            viewBackground.popOut()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    @IBAction func ok(_ sender: Any) {
        UIPasteboard.general.string = labelMessage.text!
        viewBackground.popOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.closure?()
        }
    }
    
    @objc func copyMessage() {
        UIPasteboard.general.string = labelMessage.text!
    }
}
