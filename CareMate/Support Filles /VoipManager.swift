import UIKit
import PushKit
import CallKit
import AVFoundation
//import MobileRTC
import PushKit
import ZoomVideoSDK

final class VoipManager: NSObject {

    static let shared = VoipManager()

    private var pushRegistry: PKPushRegistry?
    private var provider: CXProvider?
    private let callController = CXCallController()

    private var currentCallUUID: UUID?
    private var currentCallData: [String: Any] = [:]
    private var videoSession: ZoomVideoSDKSession?
    var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBfa2V5IjoiNFdXYjFIQjMwQmk0bmhEYUpXdXpOWTNud3lpbHdBSW1oV2FkIiwidHBjIjoiY29uc3VsdC0xNDcwMDE4Iiwicm9sZV90eXBlIjoxLCJ1c2VyX2lkZW50aXR5IjoiZG9jdG9yLUtIQUJFRVIiLCJ2ZXJzaW9uIjoxLCJpYXQiOjE3ODc2NDgwMjAsImV4cCI6MTc4NzY1MTYyMH0.e8aDUQW4LWuGoKc177J-7eMuGubN3VMPNY-WhdKPr6o"
    var sessionName = "consult-1470018"
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
        let doctorName = data["doctorName"] as? String ?? "Doctor"
        let speciality = data["speciality"] as? String ?? ""
        currentCallData = [
            "doctorId": data["doctorId"] as? String ?? "",
            "doctorName": doctorName,
            "speciality": speciality,
            "zoomMeetingNumber": data["zoomMeetingNumber"] as? String ?? "",
            "zoomMeetingPassword": data["zoomMeetingPassword"] as? String ?? "",
            "zoomJoinUrl": data["zoomJoinUrl"] as? String ?? ""
        ]
        let uuid = UUID()
        currentCallUUID = uuid
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: doctorName)
        update.localizedCallerName = speciality.isEmpty ? doctorName : "\(doctorName) - \(speciality)"
        update.hasVideo = true
        provider?.reportNewIncomingCall(with: uuid, update: update) { _ in
            completion()
        }
    }
}

// MARK: - CXProviderDelegate

extension VoipManager: CXProviderDelegate {

    func providerDidReset(_ provider: CXProvider) {
        currentCallUUID = nil
        currentCallData = [:]
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        Observer.fire(observer: .startMeeting, with: currentCallData)
      //  MobileRTC.shared()
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {

        Observer.fire(observer: .enfMeeting)
        currentCallUUID = nil
        action.fulfill()
    }

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        
    }

    func endCurrentCall() {
        guard let uuid = currentCallUUID else { return }
        let action = CXEndCallAction(call: uuid)
        callController.request(CXTransaction(action: action)) { _ in }
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
