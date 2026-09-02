//
//  UIToolkitVC.swift
//  CareMate
//
//  Created by Ibrahim on 25/08/2026.
//  Copyright © 2026 khabeer Group. All rights reserved.
//

import UIKit
import MOLH
import ZoomVideoSDK

class UIToolkitVC: UIViewController {
    
    @IBOutlet weak var pickerCamera: UIView!
    var session:ZoomVideoSDKSession?
    var callModel = VoipCallModel()
    @Published var remoteUsers: [ZoomVideoSDKUser] = []
    @Published var shouldJoin = false
    @Published var joinSessionFailed: Bool = false
    @Published var inJWTInput: Bool = true
    @Published var inSession: Bool = false
    @Published var leftSession: Bool = false
    @Published var videoOn: Bool = false
    @Published var audioOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpZoomMetting(callModel)
        // Do any additional setup after loading the view.
    }
    
    func setUpZoomMetting(_ model:VoipCallModel)  {
        let initZoomParams = ZoomVideoSDKInitParams()
        debugPrint("call View Didload")
        initZoomParams.domain = "https://zoom.us"
        initZoomParams.enableLog = true
        let sdkInitReturnStatus = ZoomVideoSDK.shareInstance()?.initialize(initZoomParams)
        switch sdkInitReturnStatus {
            case .Errors_Success:
                debugPrint(" *** SDK initialized successfully")
                ZoomVideoSDK.shareInstance()?.delegate = self
                assignTokenAndDetailForJoinSession(model)
            default:
                if let error = sdkInitReturnStatus {
                    debugPrint("*** SDK failed to initialize: \(error)")
                }
        }
    }
    
    func  assignTokenAndDetailForJoinSession (_ model:VoipCallModel) {
        let sessionContext = ZoomVideoSDKSessionContext()
        sessionContext.token = VoipManager.shared.token
        sessionContext.sessionName = VoipManager.shared.sessionName
        sessionContext.userName = isArabic() ? model.empNameAr:model.empNameEn
        if let session = ZoomVideoSDK.shareInstance()?.joinSession(sessionContext) {
            self.session = session
            debugPrint("Session joined successfully.")
             //   startPreview()
        } else {
            debugPrint("joinSession: failed.")
        }
    }
    
    private func showError(message: String) {
        Task { @MainActor in
            let alert = UIAlertController(title: isArabic() ? "خطآ":"Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: isArabic() ? "موافق":"OK", style: .default) { _ in
             //   self.dismiss(animated: true)
            })
            present(alert, animated: true)
        }
    }
    

}

extension UIToolkitVC: ZoomVideoSDKDelegate {
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
        // Session joined successfully.
        print("Session joined")
        inSession = true
    }

    func onUserJoin(_: ZoomVideoSDKUserHelper?, users: [ZoomVideoSDKUser]?) {
        // Get remote user
        if let userArray = users, let myself = ZoomVideoSDK.shareInstance()?.getSession()?.getMySelf() {
            for user in userArray {
                if user.getID() != myself.getID() {
                    remoteUsers.append(user)
                }
            }
        }
    }

    func onUserLeave(_: ZoomVideoSDKUserHelper?, users: [ZoomVideoSDKUser]?) {
        // Get remote user
        if let userArray = users, let myself = ZoomVideoSDK.shareInstance()?.getSession()?.getMySelf() {
            for user in userArray {
                if user.getID() != myself.getID() {
                    remoteUsers.removeAll { remoteUser in
                        remoteUser.getID() == user.getID()
                    }
                }
            }
        }
    }

    func onUserVideoStatusChanged(_: ZoomVideoSDKVideoHelper?, user: [ZoomVideoSDKUser]?) {
        if let userArray = user, let myself = ZoomVideoSDK.shareInstance()?.getSession()?.getMySelf() {
            for user in userArray {
                if user.getID() == myself.getID() {
                    if let myUserVideoCanvas = ZoomVideoSDK.shareInstance()?.getSession()?.getMySelf()?.getVideoCanvas(), let myVideoIsOn = myUserVideoCanvas.videoStatus()?.on {
                        if myVideoIsOn {
                            Task(priority: .background) {
                                await MainActor.run {
                                    self.videoOn = true
                                }
                            }
                        } else {
                            Task(priority: .background) {
                                await MainActor.run {
                                    videoOn = false
                                }
                            }
                        }
                    }
                }

                // Get remote user
                if user.getID() != myself.getID(), let remoteUserIndex = remoteUsers.firstIndex(where: { currentUser in
                    currentUser.getID() == user.getID()
                }) {
                    remoteUsers[remoteUserIndex] = user
                }
            }
        }
    }

    func onSessionLeave() {
        leftSession = true
    }

    // Local user - toggle video on/off
    func toggleVideo() {
        if let usersVideoCanvas = ZoomVideoSDK.shareInstance()?.getSession()?.getMySelf()?.getVideoCanvas(),
           // Get ZoomVideoSDKVideoHelper to control video
           let videoHelper = ZoomVideoSDK.shareInstance()?.getVideoHelper()
        {
            if let myVideoIsOn = usersVideoCanvas.videoStatus()?.on,
               myVideoIsOn == true
            {
                Task(priority: .background) {
                    await MainActor.run {
                        let error = videoHelper.stopVideo()
                        print("Stop error: \(error.rawValue)")
                    }
                }
            } else {
                Task(priority: .background) {
                    await MainActor.run {
                        let error = videoHelper.startVideo()
                        print("Start error: \(error.rawValue)")
                    }
                }
            }
        }
    }

    // Local user - toggle audio mic unmute/mute
    func toggleAudio() {
        let myUser = ZoomVideoSDK.shareInstance()?.getSession()?.getMySelf()
        // Get the user's audio status
        if let audioStatus = myUser?.audioStatus(),
           // Get ZoomVideoSDKAudioHelper to control audio
           let audioHelper = ZoomVideoSDK.shareInstance()?.getAudioHelper()
        {
            // Check if the user's audio type is none - Not connected yet
            if audioStatus.audioType == .none {
                Task(priority: .background) {
                    await MainActor.run {
                        audioHelper.startAudio()
                        audioOn = true
                    }
                }
            } else {
                // Audio is connected - Toggle audio based on mute status
                if audioStatus.isMuted {
                    Task(priority: .background) {
                        await MainActor.run {
                            let error = audioHelper.unmuteAudio(myUser)
                            print("Unmute error: \(error.rawValue)")
                            audioOn = true
                        }
                    }
                } else {
                    Task(priority: .background) {
                        await MainActor.run {
                            let error = audioHelper.muteAudio(myUser)
                            print("Mute error: \(error.rawValue)")
                            audioOn = false
                        }
                    }
                }
            }
        }
    }

    func leaveSession() {
        ZoomVideoSDK.shareInstance()?.leaveSession(true)
    }
    
     
}


func isArabic() -> Bool {
    return MOLHLanguage.isArabic()
}
