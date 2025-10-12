//
//  AppPopUpHandler.swift
//  CareMate
//
//  Created by MAC on 22/08/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import Foundation
//


import Foundation
import PopupDialog
import MZFormSheetController

class AppPopUpHandler {
    
    static let instance = AppPopUpHandler()
    private init () {}
    
    func initListPopup(container: UIViewController, arrayNames: [String], title: String, type: String, dismiss: Bool = true) {
        let vc = ListPopupViewController(arrayNames: arrayNames, header: title, type: type)
        print("type")

        print(type)
        vc.listPopupDelegate = container as? ListPopupDelegate
        let formSheet = MZFormSheetController.init(viewController: vc)
        formSheet.shouldDismissOnBackgroundViewTap = dismiss
        formSheet.transitionStyle = .slideFromBottom
        formSheet.cornerRadius = 20
        formSheet.portraitTopInset = UIScreen.main.bounds.height * 0.5
        formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
        formSheet.present(animated: true, completionHandler: nil)
    }
    
    func initListPopupVisit(container: UIViewController,type: String,listOfVisits:[visitDTO], getVisits: Bool = true) {
//        let vc = ListPopupViewController(arrayNames: arrayNames, header: title, type: type)
//        print("type")
        let vc =   VisitsViewController()

        print(type)
        vc.type = type
        vc.fromDropDown = true
        vc.listOfVisit = listOfVisits
        vc.getVistist = getVisits
        vc.listPopupDelegate = container as? ListPopupDelegate
        let formSheet = MZFormSheetController.init(viewController: vc)
        formSheet.shouldDismissOnBackgroundViewTap = true
        formSheet.transitionStyle = .slideFromBottom
        formSheet.cornerRadius = 20
        formSheet.portraitTopInset = UIScreen.main.bounds.height * 0.5
        formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
        formSheet.present(animated: true, completionHandler: nil)
    }
    

    func openPopup(container: UIViewController, vc: UIViewController) {
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .zoomIn)
        container.present(popup, animated: true, completion: nil)
    }

    func openVCPop(_ vc: UIViewController, height: CGFloat, bottomSheet: Bool = false, dismiss: Bool = true) {
        let formSheet = MZFormSheetController.init(viewController: vc)
        formSheet.shouldDismissOnBackgroundViewTap = dismiss
        formSheet.transitionStyle = .slideFromBottom
        if bottomSheet {
            if height == 0 {
                formSheet.portraitTopInset = UIScreen.main.bounds.height * 0.5
                formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
            } else {
                formSheet.portraitTopInset = UIScreen.main.bounds.height - height
                formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width, height: height)
            }
        } else {
            formSheet.presentedFormSheetSize = CGSize.init(width: UIScreen.main.bounds.width * 0.9, height: height)
            formSheet.shouldCenterVertically = true
        }
        formSheet.present(animated: true, completionHandler: nil)
    }


}
