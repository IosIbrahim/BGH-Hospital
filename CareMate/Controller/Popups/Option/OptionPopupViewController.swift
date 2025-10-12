//
//  OptionPopupViewController.swift
//  nasTrends
//
//  Created by Ahmed gamal on 1/31/19.
//  Copyright © 2019 Mohamed Elmaazy. All rights reserved.
//

import UIKit

typealias OptionPopupClosure = (Bool) -> Void

func OPEN_OPTION_POPUP(container: UIViewController, message: String, dismiss: Bool = true, closure: OptionPopupClosure? = nil) {
    let vc = OptionPopupViewController(message: message, dismiss: dismiss)
    vc.closure = { isOk in
        vc.dismiss(animated: false) {
            closure?(isOk)
        }
    }
    vc.modalPresentationStyle = .overFullScreen
    container.present(vc, animated: false)
}

class OptionPopupViewController: BaseViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    var message = ""
    var closure: OptionPopupClosure?
    
    init(message: String, dismiss: Bool) {
        self.message = message
        super.init(nibName: "OptionPopupViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelMessage.text = message
        if UserManager.isArabic {
            btnOk.setTitle("نعم", for: .normal)
            btnCancel.setTitle("لا", for: .normal)
        }
        self.view.backgroundColor = .fromHex(hex: "000000", alpha: 0.25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewBackground.popIn()
    }

    @IBAction func ok(_ sender: Any) {
        viewBackground.popOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.closure?(true)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        viewBackground.popOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.closure?(false)
        }
    }
}
