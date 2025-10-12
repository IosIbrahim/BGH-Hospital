//
//  Choose365HospitalViewController.swift
//  CareMate
//
//  Created by Mohamed Elmaazy on 04/10/2023.
//  Copyright © 2023 khabeer Group. All rights reserved.
//
//initNotDataShape
import UIKit

class Choose365HospitalViewController: BaseViewController {

    @IBOutlet weak var viewElsalam: RoundUIView!
    @IBOutlet weak var imageViewElsalam: UIImageView!
    @IBOutlet weak var labelElsalam: UILabel!
    @IBOutlet weak var viewAhmady: RoundUIView!
    @IBOutlet weak var imageViewAhmady: UIImageView!
    @IBOutlet weak var labelAhmady: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(title: UserManager.isArabic ? "جولة إفتراضيه (360)" : "Virtual Tour (360)")
        //Fixed By HAMDI ......
        imageViewElsalam.loadFromUrl(url: "https://dec35x714wl62.cloudfront.net/assets/uploads/default/_535x475_crop_center-center_75_none/assima-contact.jpg")
        labelElsalam.text = UserManager.isArabic ? "مستشفي السلام العاصمة" : "Al-Salam Al-Assima Hospital"
        viewElsalam.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openELsalam)))
        imageViewAhmady.loadFromUrl(url: "https://dec35x714wl62.cloudfront.net/assets/uploads/default/_535x475_crop_center-center_75_none/ahmadi-contact.jpg")
        labelAhmady.text = UserManager.isArabic ? "مستشفى السلام الأحمدي" : "Al-Salam Al-Ahmadi Hospital"
        viewAhmady.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAhmady)))
    }

    @objc func openELsalam() {
        let vc1:HospitalViewsHomeViewController = HospitalViewsHomeViewController()
        self.navigationController?.pushViewController(vc1, animated: true)
    }
//Fixed By HAMDI ......
    @objc func openAhmady() {
        let vc = viewAllHospital(Url: "https://dec35x714wl62.cloudfront.net/vtour/sah-tour1/index.html", title: UserManager.isArabic ? "مستشفى السلام الأحمدي" : "Al-Salam Al-Ahmadi Hospital")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
