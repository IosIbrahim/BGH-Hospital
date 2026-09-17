import UIKit
import PushKit
import CallKit
import AVFoundation
//import MobileRTC
import PushKit
import ZoomVideoSDK
import MOLH
import AVFoundation


final class VoipManager: NSObject {

    static let shared = VoipManager()

    private var pushRegistry: PKPushRegistry?
    private var provider: CXProvider?
    private let callController = CXCallController()

    /// Calls reported to CallKit that haven't ended, keyed by CallKit UUID.
    private var calls: [UUID: VoipCallModel] = [:]
    /// Call screens, each in its own window above the app, keyed by call UUID.
    private var callWindows: [UUID: UIWindow] = [:]
    /// Answered call whose screen waits for CallKit to activate the audio session.
    private var callAwaitingAudio: UUID?
    private var videoSession: ZoomVideoSDKSession?
    // MARK: - Setup
    func start() {
        setupCallKit()
        registerForVoipPush()
    }

    private func registerForVoipPush() {
        let registry = PKPushRegistry(queue: DispatchQueue.main)
        registry.delegate = self
        registry.desiredPushTypes = [.voIP]
        self.pushRegistry = registry
    }

    private func setupCallKit() {
        let config = CXProviderConfiguration()
        config.supportsVideo = true
        config.maximumCallsPerCallGroup = 1
        config.supportedHandleTypes = [.generic]
        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: nil)
        self.provider = provider
    }
}

// MARK: - PKPushRegistryDelegate

extension VoipManager: PKPushRegistryDelegate {

    func pushRegistry(_ registry: PKPushRegistry,
                      didUpdate pushCredentials: PKPushCredentials,
                      for type: PKPushType) {
        guard type == .voIP else { return }
        let token = pushCredentials.token
            .map { String(format: "%02x", $0) }
            .joined()
        print("VoIP device token: \(token)")
        UserDefaults.standard.set(token, forKey: "voipToken")
    }

    func pushRegistry(_ registry: PKPushRegistry,
                      didInvalidatePushTokenFor type: PKPushType) {
        UserDefaults.standard.removeObject(forKey: "voipToken")
    }

    func pushRegistry(_ registry: PKPushRegistry,
                      didReceiveIncomingPushWith payload: PKPushPayload,
                      for type: PKPushType,
                      completion: @escaping () -> Void) {

        let data = payload.dictionaryPayload
        let uuid = UUID()

        var call = VoipCallModel()
        call.callUUID = uuid
        call.sessionName = data["ZOOM_SESSION_NAME"] as? String ?? ""
        call.sessionToken = data["ZOOM_SESSION_TOKEN"] as? String ?? ""
        call.empNameEn = data["EMP_NAME_EN"] as? String ?? ""
        call.empNameAr = data["EMP_NAME_AR"] as? String ?? ""
        call.serial = data["SERIAL"] as? String ?? ""
        call.hospNameAr = data["HOSP_NAME_AR"] as? String ?? ""
        call.hospNameEn = data["HOSP_NAME_EN"] as? String ?? ""
        call.specialityNameAr = data["SPECIALITY_NAME_AR"] as? String ?? ""
        call.specialityNameEn = data["SPECIALITY_NAME_EN"] as? String ?? ""
        call.clinicNameAr = data["CLINIC_NAME_AR"] as? String ?? ""
        call.clinicNameEn = data["CLINIC_NAME_EN"] as? String ?? ""
        call.serviceNameAr = data["SERVICE_NAME_AR"] as? String ?? ""
        call.serviceNameEn = data["SERVICE_NAME_EN"] as? String ?? ""
        call.expectedDoneDate = data["EXPECTEDDONEDATE"] as? String ?? ""

        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: call.doctorName)
        update.localizedCallerName = call.callerName
        update.hasVideo = true
        // The provider delegate doesn't handle DTMF, hold or group actions, so don't offer them.
        update.supportsDTMF = false
        update.supportsHolding = false
        update.supportsGrouping = false

        // iOS 13+ requires every VoIP push to be reported to CallKit, whatever the app state.
        // Skipping it makes iOS kill the app and eventually stop delivering VoIP pushes
        // when the app is closed.
        guard let provider = provider else {
            completion()
            return
        }
        calls[uuid] = call
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if let error = error {
                print("reportNewIncomingCall failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.calls[uuid] = nil
                    self.offerCallInApp(call, rejectedWith: error)
                }
            }
            completion()
        }
    }
}

// MARK: - CXProviderDelegate

extension VoipManager: CXProviderDelegate {

    func providerDidReset(_ provider: CXProvider) {
        // CallKit has ended every call; close their screens too.
        let endedCalls = Array(calls.values)
        calls.removeAll()
        callAwaitingAudio = nil
        endedCalls.forEach { Observer.fire(observer: .endMeeting, with: $0) }
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard calls[action.callUUID] != nil else {
            action.fail()
            return
        }
        // Set up audio for a video call; CallKit activates the session once the answer is fulfilled.
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord,
                                    with: [.defaultToSpeaker, .allowBluetooth])
            try session.setMode(AVAudioSessionModeVideoChat)
        } catch {
            print("Failed to configure call audio session: \(error.localizedDescription)")
        }

        // Open the call screen, which starts Zoom, only after CallKit activates the audio session,
        // so Zoom doesn't set up audio underneath CallKit. Fall back after 2 s if activation never comes.
        let uuid = action.callUUID
        callAwaitingAudio = uuid
        action.fulfill()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showCallScreenIfAwaitingAudio(uuid)
        }
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        let uuid = action.callUUID
        if callAwaitingAudio == uuid {
            callAwaitingAudio = nil
        }
        if let call = calls.removeValue(forKey: uuid) {
            Observer.fire(observer: .endMeeting, with: call)
        }
        action.fulfill()
    }

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        if let uuid = callAwaitingAudio {
            showCallScreenIfAwaitingAudio(uuid)
        }
    }
}

// MARK: - Call screen

extension VoipManager {

    /// Called by the call screen when it closes: ends the CallKit call if it's still active
    /// and removes the call's window.
    func callScreenDidClose(_ call: VoipCallModel) {
        guard let uuid = call.callUUID else { return }
        if calls[uuid] != nil {
            let action = CXEndCallAction(call: uuid)
            callController.request(CXTransaction(action: action)) { error in
                if let error = error {
                    print("Failed to end call: \(error.localizedDescription)")
                    DispatchQueue.main.async { self.calls[uuid] = nil }
                }
            }
        }
        hideCallWindow(for: uuid)
    }

    private func showCallScreenIfAwaitingAudio(_ uuid: UUID) {
        guard callAwaitingAudio == uuid, let call = calls[uuid] else { return }
        callAwaitingAudio = nil
        showCallScreen(for: call)
    }

    private func showCallScreen(for call: VoipCallModel) {
        let screen = UIToolkitVC()
        screen.callModel = call
        showInCallWindow(screen, for: call)
    }

    /// CallKit refused the call (e.g. Focus / Do Not Disturb). If the patient is using the app, ask
    /// in-app instead of silently missing the doctor's call, but respect blocked callers.
    private func offerCallInApp(_ call: VoipCallModel, rejectedWith error: Error) {
        guard UIApplication.shared.applicationState == .active,
              let uuid = call.callUUID else { return }
        if let callError = error as? CXErrorCodeIncomingCallError, callError.code == .filteredByBlockList {
            return
        }
        let arabic = MOLHLanguage.isArabic()
        let alert = UIAlertController(title: call.callerName,
                                      message: arabic ? "مكالمة فيديو واردة" : "Incoming video call",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: arabic ? "رفض" : "Decline", style: .cancel) { _ in
            self.hideCallWindow(for: uuid)
        })
        alert.addAction(UIAlertAction(title: arabic ? "رد" : "Answer", style: .default) { _ in
            self.hideCallWindow(for: uuid)
            self.showCallScreen(for: call)
        })
        showInCallWindow(alert, for: call)
    }

    /// Shows `viewController` in its own window above the app, so the call appears whatever the app
    /// is showing (splash, login or home), including right after a cold launch.
    private func showInCallWindow(_ viewController: UIViewController, for call: VoipCallModel) {
        guard let uuid = call.callUUID, callWindows[uuid] == nil else { return }
        let root = UIViewController()
        root.view.backgroundColor = .clear
        let window = UIWindow(frame: UIScreen.main.bounds)
        // Above the app's own windows, e.g. HUDs and form sheet popups.
        window.windowLevel = UIWindowLevelAlert
        window.rootViewController = root
        window.makeKeyAndVisible()
        callWindows[uuid] = window
        // Present on the next run loop, once the root view is in the window.
        DispatchQueue.main.async {
            root.present(viewController, animated: true, completion: nil)
        }
    }

    private func hideCallWindow(for uuid: UUID) {
        guard let window = callWindows.removeValue(forKey: uuid) else { return }
        window.isHidden = true
        let nextKeyWindow = callWindows.values.first ?? (UIApplication.shared.delegate as? AppDelegate)?.window
        nextKeyWindow?.makeKey()
    }
}

extension VoipManager: ZoomVideoSDKDelegate {
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
}

struct VoipCallModel:Codable {
    var callUUID: UUID?
    var sessionName:String = ""
    var sessionToken:String = ""
    var empNameAr:String = ""
    var empNameEn:String = ""
    var serial:String = ""
    var hospNameAr:String = ""
    var hospNameEn:String = ""
    var specialityNameAr:String = ""
    var specialityNameEn:String = ""
    var clinicNameAr:String = ""
    var clinicNameEn:String = ""
    var serviceNameAr:String = ""
    var serviceNameEn:String = ""
    var expectedDoneDate:String = ""
}

extension VoipCallModel {
    var doctorName: String {
        return MOLHLanguage.isArabic() ? empNameAr : empNameEn
    }

    /// Doctor name with speciality, as shown on the incoming call.
    var callerName: String {
        let speciality = MOLHLanguage.isArabic() ? specialityNameAr : specialityNameEn
        return speciality.isEmpty ? doctorName : "\(doctorName) - \(speciality)"
    }
}
