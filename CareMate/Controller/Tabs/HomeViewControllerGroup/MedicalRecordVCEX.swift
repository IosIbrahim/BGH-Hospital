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
            _ = VoipManager.shared.consumePendingCall()
            let model = notification.object as? VoipCallModel ?? .init()
            self.presentCall(model)
        }
    }

    /// Shows a call answered while the app was closed, once this screen is on screen.
    func presentPendingCallIfNeeded() {
        guard presentedViewController == nil,
              let model = VoipManager.shared.consumePendingCall() else { return }
        presentCall(model)
    }

    private func presentCall(_ model: VoipCallModel) {
        guard presentedViewController == nil else { return }
        let vc = UIToolkitVC()
        vc.callModel = model
        present(vc, animated: true)
    }

}
