//
//  Untitled.swift
//  CareMate
//
//  Created by Ibrahim on 25/08/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

import ZoomVideoSDK
import UIKit
import MapKit
import SCLAlertView
import MOLH


extension MedicalRecordVC {
    
    func checkObserver() {
        observer?.when(.startMeeting) { [weak self] notification in
            guard let self = self else {  return }
            let model = notification.object as? VoipCallModel ?? .init()
            let vc = UIToolkitVC()
            vc.callModel = model
            self.present(vc, animated: true)
        }
    }
    
}
