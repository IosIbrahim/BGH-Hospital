//
//  MedicationsViewViewController.swift
//  CareMate
//
//  Created by MAC on 08/09/2021.
//  Copyright © 2021 khabeer Group. All rights reserved.
//

import UIKit


struct medicalViewModel {
    var imagee:UIImage?
    var NameAr:String?
    var NameEn:String?
    var Url:String?
    var type: ScreenType?
    
    init(NameAr:String?, NameEn:String?,Url:String?) {
        self.NameAr = NameAr
        self.NameEn = NameEn
        self.Url = Url
    }
    
    init(imagee:UIImage?,NameAr:String?, NameEn:String?, type: ScreenType?) {
        self.NameAr = NameAr
        self.NameEn = NameEn
        self.imagee = imagee
        self.type = type
    }

}


class MedicationsViewViewController: BaseViewController {

    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var uilabelName: UILabel!
    @IBOutlet weak var uilabelNumber: UILabel!
    @IBOutlet weak var uilabelAge: UILabel!

    var list = [medicalViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "الملف الطبي" : "Medical Overview", hideBack: false)
        setup()
        setPatientInfo()
    }
    func setPatientInfo(){
        let defaults = UserDefaults.standard

        if let savedPerson = defaults.object(forKey: "SavedPerson") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginedUser.self, from: savedPerson) {
//                cellOne.isHidden = false
//                cellOne.isHidden = false

//                self.navigationController?.navigationBar.isHidden = true

//                if UserManager.isArabic == true
//                {
//                    uilabelName.text = loadedPerson.COMPLETEPATNAME_AR
//
//                }
//                else
//                {
                    uilabelName.text = loadedPerson.COMPLETEPATNAME_EN

//                }
                uilabelName.textAlignment = .center
                uilabelNumber.text = loadedPerson.PATIENTID
//                uilabelAge.text = loadedPerson.

                uilabelAge.text = loadedPerson.PAT_TEL


            }
        }
        else
        {
//            cellOne.isHidden = true
//            self.navigationController?.navigationBar.isHidden = true

        }
    }

    
    

}
