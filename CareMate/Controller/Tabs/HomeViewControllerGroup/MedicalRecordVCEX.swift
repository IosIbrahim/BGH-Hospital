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
            self?.joinSession()
        }
        
        observer?.when(.enfMeeting) { [weak self] notification in
            
        }
    }
    
    func joinSession() {
        joinNewSession()
//        let param = ZoomVideoSDKInitParams()
//    //    param.appGroupId = VoipManager.shared.token
//        param.domain = "zoom.us"
//        param.enableLog = true
//        let sessionContext = ZoomVideoSDKSessionContext.init()
//        sessionContext.userName = VoipManager.shared.sessionName
//        sessionContext.sessionName = VoipManager.shared.sessionName
//        sessionContext.token = VoipManager.shared.token
//        
//        ZoomVideoSDK.shareInstance()?.initialize(param)
//        ZoomVideoSDK.shareInstance()?.delegate = self
//        
//        let vc = UIToolkitVC(sessionContext: sessionContext, initParams: param)
//    //    vc.delegate = self
//  //      vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true)
    }
    
    func joinNewSession() {
        let sessionContext = ZoomVideoSDKSessionContext()
        sessionContext.token = VoipManager.shared.token
        sessionContext.sessionName = VoipManager.shared.sessionName
        sessionContext.userName = "Ibrahim Sabry"
        if ZoomVideoSDK.shareInstance()?.joinSession(sessionContext) == nil {
            print("Join session failed")
        //    showError(message: "Failed to join session")
            return
        }
    }
    
    private func showError(message: String) {
        Task { @MainActor in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
             //   self.dismiss(animated: true)
            })
            present(alert, animated: true)
        }
    }
    
}


extension MedicalRecordVC: ZoomVideoSDKDelegate {
    func onError(_ ErrorType: ZoomVideoSDKError, detail details: Int) {
        print("Zoom Details ",details)
        switch ErrorType {
            case .Errors_Success:
              // Your ZoomVideoSDK operation was successful.
              print("Zoom Success")
              default:
              // Your ZoomVideoSDK operation raised an error.
              // Refer to error code documentation.
              print("Zoom Error \(ErrorType) \(details)")
              return
        }
    }
    
    func onSessionJoin() {
        print("Zoom Joined")
    }
    
    func onSessionLeave(_ reason:ZoomVideoSDKSessionLeaveReason) {
        print(reason)
    }
    
     
}
