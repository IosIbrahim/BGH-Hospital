//
//  UIToolkitVC.swift
//  CareMate
//
//  Created by Ibrahim on 25/08/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

import UIKit
import ZoomVideoSDK
class UIToolkitVC: UIViewController {
    var session:ZoomVideoSDKSessionContext?
    var params:ZoomVideoSDKInitParams?
    
    
    init(sessionContext:ZoomVideoSDKSessionContext,initParams:ZoomVideoSDKInitParams){
       super.init(nibName: "UIToolkitVC", bundle: nil)
       self.session = sessionContext
       self.params = initParams
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
