//
//  ListPopupViewController.swift
//  nasTrends
//
//  Created by Mohamed Elmaazy on 2/5/19.
//  Copyright © 2019 Mohamed Elmaazy. All rights reserved.
//

import UIKit

func OPEN_LIST_POPUP(container: UIViewController, title: String = "", arrayNames: [String], dismiss: Bool = true, closure: ListPopupClosure? = nil) {
    let vc = ListPopupViewController2(arrayNames: arrayNames, header: title, dismiss: dismiss)
    vc.closure = { index in
        vc.dismiss(animated: false) {
            closure?(index)
        }
    }
    vc.modalPresentationStyle = .overFullScreen
    container.present(vc, animated: false)
}

typealias ListPopupClosure = (Int?) -> Void

class ListPopupViewController2: UIViewController {

    @IBOutlet weak var viewClose: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var constraintHeightViewBackground: NSLayoutConstraint!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewBack: UIView!
    
    var arrayNames = [String]()
    var header = ""
    var closure: ListPopupClosure?
    var dismiss = true
    
    init(arrayNames: [String], header: String, dismiss: Bool) {
        super.init(nibName: "ListPopupViewController2", bundle: nil)
        self.arrayNames = arrayNames
        self.header = header
        self.dismiss = dismiss
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        labelTitle.text = header
        if dismiss {
            viewClose.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePopup)))
            viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePopup)))
        } else {
            viewClose.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        constraintHeightViewBackground.constant = UIScreen.main.bounds.height / 2
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func closePopup() {
        constraintHeightViewBackground.constant = 50
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.closure?(nil)
        }
    }
}
