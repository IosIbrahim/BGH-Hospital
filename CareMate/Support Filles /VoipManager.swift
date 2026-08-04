import UIKit
import PushKit
import CallKit
import AVFoundation
import MobileRTC
import PushKit

final class VoipManager: NSObject {

    static let shared = VoipManager()

    private var pushRegistry: PKPushRegistry?
    private var provider: CXProvider?
    private let callController = CXCallController()

    private var currentCallUUID: UUID?
    private var currentCallData: [String: Any] = [:]

    private let tokenApiUrl = "https://your-api.com/api/device/token"

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
   //     var config = CXProviderConfiguration(localizedName: "PrimeCare")
        let config = CXProviderConfiguration()
        config.supportsVideo = true
        config.maximumCallsPerCallGroup = 1
        config.supportedHandleTypes = [.generic]

        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: nil)
        self.provider = provider
    }

    // MARK: - Send token to backend

    private func sendTokenToServer(_ token: String) {
        guard let url = URL(string: tokenApiUrl) else { return }

        let body: [String: Any] = [
            "deviceToken": token,
            "platform": "ios"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let authToken = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("VoIP token upload failed: \(error.localizedDescription)")
                return
            }
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            print("VoIP token uploaded, status: \(code)")
        }.resume()
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
        sendTokenToServer(token)
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
        MobileRTC.shared()
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
