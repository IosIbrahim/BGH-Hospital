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
    
    @IBOutlet weak var pickerAction: UIView!
    @IBOutlet weak var clcUsers: UICollectionView!
    @IBOutlet weak var btnMice: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnCameraMode: UIButton!
    @IBOutlet weak var pickerCamera: UIView!
    @IBOutlet weak var pickerUsers: UIView!
    
    var session:ZoomVideoSDKSession?
    var callModel = VoipCallModel()
    var observer: Observer? = .init()

    @Published var remoteUsers: [ZoomVideoSDKUser] = []
    @Published var shouldJoin = false
    @Published var joinSessionFailed: Bool = false
    @Published var inJWTInput: Bool = true
    @Published var inSession: Bool = false
    @Published var leftSession: Bool = false
    @Published var videoOn: Bool = false
    @Published var audioOn: Bool = false
    private var didLeaveSession = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpZoomMetting(callModel)
        clcUsers.register("ZoomUserCell")
        pickerAction.setPhysShadow()
        pickerAction.layer.cornerRadius = 12
        checkObserver()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Swiped away or closed because the call ended: leave Zoom, end the CallKit call and remove the window.
        guard isBeingDismissed else { return }
        leaveSession()
        VoipManager.shared.callScreenDidClose(callModel)
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
        sessionContext.token = model.sessionToken
        sessionContext.sessionName = model.sessionName
        sessionContext.userName = isArabic() ? model.empNameAr:model.empNameEn
        if let session = ZoomVideoSDK.shareInstance()?.joinSession(sessionContext) {
            self.session = session
            debugPrint("Session joined successfully.")
            self.updateLocalVideo()
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
    
    func checkObserver() {
        observer?.when(.endMeeting) { [weak self] notification in
            // Only close for this call; declining another incoming call must not end this one.
            guard let self = self,
                  let endedCall = notification.object as? VoipCallModel,
                  endedCall.callUUID == self.callModel.callUUID else { return }
            self.closeCallScreen()
        }
    }

    private func closeCallScreen() {
        guard presentingViewController != nil, !isBeingDismissed else { return }
        // Leave now rather than after the dismiss animation, so a call answered meanwhile isn't affected.
        leaveSession()
        session = nil
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func changeCamera(_ sender: Any) {
        ZoomVideoSDK.shareInstance()?.getVideoHelper()?.switchCamera()
    }
    
    @IBAction func cameraOnTap(_ sender: Any) {
        toggleVideo()
    }

    @IBAction func miceOnTap(_ sender: Any) {
        toggleAudio()
    }
}


extension UIToolkitVC {
   
    @MainActor func updateLocalVideo() {
        guard let myUserVideoCanvas = ZoomVideoSDK.shareInstance()?.getSession()?.getMySelf()?.getVideoCanvas(), let myVideoIsOn = myUserVideoCanvas.videoStatus()?.on else { return }
        if myVideoIsOn {
            myUserVideoCanvas.subscribe(with: pickerCamera, aspectMode: .panAndScan, andResolution: ._Auto)
        } else {
            myUserVideoCanvas.unSubscribe(with: pickerCamera)
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
         //   self.updateLocalVideo()
        //    if self.remoteUsers.isEmpty {
                self.remoteUsers.append(myself)
           // }
            clcUsers.isHidden = remoteUsers.isEmpty
            DispatchQueue.main.async {
                self.clcUsers.reloadData()
            }
          //  self.attachRemoteUserVideo(index: <#T##Int#>)
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
    //    self.updateLocalVideo()
        clcUsers.isHidden = remoteUsers.isEmpty
        DispatchQueue.main.async {
            self.clcUsers.reloadData()
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
        // A previous call's session can report leaving after this screen became the SDK delegate; ignore it.
        guard inSession else { return }
        inSession = false
        // The session is over (e.g. the doctor ended it): close the screen, which also ends the CallKit call.
        DispatchQueue.main.async {
            self.closeCallScreen()
        }
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
                    self.btnCamera.setImage(UIImage(named:"photo-camera-interface-symbol-for-button"), for: .normal)
                }
            } else {
                Task(priority: .background) {
                    await MainActor.run {
                        let error = videoHelper.startVideo()
                        print("Start error: \(error.rawValue)")
                        
                    }
                    self.btnCamera.setImage(UIImage(named: "icons8-no-camera-52"), for: .normal)
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
                        self.btnMice.setImage(UIImage(named:"microphone-black-shape"), for: .normal)
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
                            self.btnMice.setImage(UIImage(named:"microphone-black-shape"), for: .normal)
                        }
                    }
                } else {
                    Task(priority: .background) {
                        await MainActor.run {
                            let error = audioHelper.muteAudio(myUser)
                            print("Mute error: \(error.rawValue)")
                            audioOn = false
                            self.btnMice.setImage(UIImage(named: "mute-microphone"), for: .normal)
                        }
                    }
                }
            }
        }
    }

    func leaveSession() {
        guard !didLeaveSession else { return }
        didLeaveSession = true
        // false: leave without ending the session for the doctor.
        ZoomVideoSDK.shareInstance()?.leaveSession(false)
    }
    
     
}

extension UIToolkitVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return remoteUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZoomUserCell", for: indexPath) as! ZoomUserCell
        cell.drawCell(remoteUsers[indexPath.row])
        cell.contentView.setPhysShadow()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenSize = UIScreen.main.bounds
            var screenWidth = screenSize.width
            screenWidth = screenWidth - 30
            let cellSize = screenWidth / 2
            var size = CGSize.zero
            size.width = cellSize
            size.height =  150
            return size
    }
}



func isArabic() -> Bool {
    return MOLHLanguage.isArabic()
}
