//
//  viewAllHospital.swift
//  CareMate
//
//  Created by MAC on 01/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit
import WebKit

class viewAllHospital: BaseViewController ,WKNavigationDelegate{

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var labelDescription: UILabel!
    
    var url = ""
    var titleFRom = ""

    
    init(Url: String,title:String?) {
        super.init(nibName: "viewAllHospital", bundle: nil)
        self.url = Url
        self.titleFRom = title ?? ""
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        indicator.sharedInstance.show()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
//        setupTabBar.instance.setuptabBar(vc: self)
//        self.navigationController?.navigationBar.isHidden = false
        initHeader(isNotifcation: true, isLanguage: true, title: titleFRom, hideBack: false)

        print(self.url)
        let url = URL(string: self.url)!
        
        webView.load(URLRequest(url: url))
        
        // Do any additional setup after loading the view.
        if UserManager.isArabic {
            labelDescription.text = "إذا كنت بحاجة إلي المساعدة أو مزيد من الإستفسارات يمكنك التواصل معنا عن طريق الهاتف"
        }
    }
    @IBAction func phoneCiked(_ sender: Any) {
        if let url = NSURL(string: "tel://+9651830003"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    

    @IBAction func openWhatsApp(_ sender: Any) {
        let phoneNumber =  "+9651830003" // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            // WhatsApp is not installed
        }
        
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.sharedInstance.dismiss()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }


}
