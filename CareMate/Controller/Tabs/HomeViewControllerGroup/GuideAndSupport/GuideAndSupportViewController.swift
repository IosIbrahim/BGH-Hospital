//
//  GuideAndSupportViewController.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 18/04/2024.
//  Copyright © 2024 khabeer Group. All rights reserved.
//

import UIKit

class GuideAndSupportViewController: BaseViewController {

    @IBOutlet weak var viewGuide: UIView!
    @IBOutlet weak var labelGuide: UILabel!
    @IBOutlet weak var viewSupport: UIView!
    @IBOutlet weak var labelSupport: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LanguageManager.isArabic() {
            initHeader(title: "المساعدة و الدعم")
            labelGuide.text = "دليل المستخدم"
            labelSupport.text = "الدعم عبر الإنترنت"
        } else {
            initHeader(title: "Help And Support")
        }
        viewGuide.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openGuide)))
        viewSupport.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSupport)))
    }
    
    @objc func openGuide() {
        let url = LanguageManager.isArabic() ? UserDefaults.standard.string(forKey: "UserGuideAr") : UserDefaults.standard.string(forKey: "UserGuideEn")
        guard let url else { return }
//        let vc = WebViewViewController(url, showShare: false)
//        vc.pageTitle = LanguageManager.isArabic() ? "دليل المستخدم" : "User Guide"
//        navigationController?.pushViewController(vc, animated: true)
        openWebsite(url: url)
    }
    
    @objc func openSupport() {
        openUrl(LanguageManager.isArabic() ? "https://api.whatsapp.com/send/?phone=96594032241&text=مرحبا،+أرجو+المساعدة" : "https://api.whatsapp.com/send/?phone=96594032241&text=Hello,+please+help")
    }
    

    // fix by hamdi
//    func openUrl(_ url: String) {
//        guard let urlEncoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//              let finalUrl = URL(string: urlEncoded) else {
//            print("Invalid URL")
//            return
//        }
//        
//        if UIApplication.shared.canOpenURL(finalUrl) {
//            UIApplication.shared.open(finalUrl, options: [:], completionHandler: nil)
//        } else {
//            print("Can't open URL: \(finalUrl)")
//        }
//    }

}
