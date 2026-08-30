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
        setUpZoomMetting()
    }
    
    func setUpZoomMetting()  {
        let initZoomParams = ZoomVideoSDKInitParams()
            debugPrint("call View Didload")
            initZoomParams.domain = "https://zoom.us"
            initZoomParams.enableLog = true
            let sdkInitReturnStatus =
            ZoomVideoSDK.shareInstance()?.initialize(initZoomParams)

            switch sdkInitReturnStatus {
            case .Errors_Success:
                debugPrint(" *** SDK initialized successfully")
                ZoomVideoSDK.shareInstance()?.delegate = self
                assignTokenAndDetailForJoinSession()

            default:
                if let error = sdkInitReturnStatus {
                    debugPrint("*** SDK failed to initialize: \(error)")
                }
            }
        }
    
    func  assignTokenAndDetailForJoinSession () {

            let sessionContext = ZoomVideoSDKSessionContext()
            sessionContext.token = VoipManager.shared.token
            sessionContext.sessionName = VoipManager.shared.sessionName
            sessionContext.userName = "Ibrahim Sabry"
            if let session = ZoomVideoSDK.shareInstance()?.joinSession(sessionContext) {
                debugPrint("Session joined successfully.")
             //   startPreview()
            } else {
                debugPrint("joinSession: failed.")
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
        print("Zoom Details ",ErrorType)
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
