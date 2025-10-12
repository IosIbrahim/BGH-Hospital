//
//  QuestionareWebVC.swift
//  CareMate
//
//  Created by mostafa gabry on 3/22/21.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
import WebKit
class QuestionareWebVC: BaseViewController {

    @IBOutlet weak var webViewKit: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.sharedInstance.show()

        let link = URL(string:"https://docs.google.com/forms/d/e/1FAIpQLSdgiGLhseY3psI05hsNR0DWYtUru96I4Rko5vZXZw9eBxLzSQ/viewform")!
        let request = URLRequest(url: link)
        webViewKit.load(request)
        indicator.sharedInstance.dismiss()
//        setupTabBar.instance.setuptabBar(vc: self)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
