import UIKit
import PushKit
import CallKit
import AVFoundation
//import MobileRTC
import PushKit
import ZoomVideoSDK
import MOLH


final class VoipManager: NSObject {

    static let shared = VoipManager()

    private var pushRegistry: PKPushRegistry?
    private var provider: CXProvider?
    private let callController = CXCallController()

    private var currentCallUUID: UUID?
    private var currentCallData: [String: Any] = [:]
    private var callModel:VoipCallModel = .init()
    private var videoSession: ZoomVideoSDKSession?
    var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBfa2V5IjoiNFdXYjFIQjMwQmk0bmhEYUpXdXpOWTNud3lpbHdBSW1oV2FkIiwidHBjIjoiY29uc3VsdC0xNDY5NTI2Iiwicm9sZV90eXBlIjowLCJ1c2VyX2lkZW50aXR5IjoicGF0aWVudC1LSEFCRUVSIiwidmVyc2lvbiI6MSwiaWF0IjoxNzg4MDkzMDgxLCJleHAiOjE3ODgwOTY2ODF9.iLyYOpIuIGhVN8mo372myFbCIr-0mX8VG3Ntn5YYeow"
    var sessionName = "consult-1469526"
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
        
        let session_Name = data["ZOOM_SESSION_NAME"] as? String ?? ""
        self.sessionName = session_Name
        let sessionToken = data["ZOOM_SESSION_TOKEN"] as? String ?? ""
        self.token = sessionToken
        let EMP_NAME_EN = data["EMP_NAME_EN"] as? String ?? ""
        let EMP_NAME_AR = data["EMP_NAME_AR"] as? String ?? ""
        
        let SERIAL = data["SERIAL"] as? String ?? ""
        let HOSP_NAME_AR = data["HOSP_NAME_AR"] as? String ?? ""
        let HOSP_NAME_EN = data["HOSP_NAME_EN"] as? String ?? ""
        let SPECIALITY_NAME_AR = data["SPECIALITY_NAME_AR"] as? String ?? ""
        let SPECIALITY_NAME_EN = data["SPECIALITY_NAME_EN"] as? String ?? ""
        
        let CLINIC_NAME_AR = data["CLINIC_NAME_AR"] as? String ?? ""
        let CLINIC_NAME_EN = data["CLINIC_NAME_EN"] as? String ?? ""
        let SERVICE_NAME_AR = data["SERVICE_NAME_AR"] as? String ?? ""
        let SERVICE_NAME_EN = data["SERVICE_NAME_EN"] as? String ?? ""
        let EXPECTEDDONEDATE = data["EXPECTEDDONEDATE"] as? String ?? ""
        callModel.sessionName = sessionName
        callModel.sessionToken = sessionToken
        callModel.empNameAr = EMP_NAME_AR
        callModel.empNameEn = EMP_NAME_EN
        callModel.serial = SERIAL
        
        callModel.hospNameAr = HOSP_NAME_AR
        callModel.hospNameEn = HOSP_NAME_EN
        callModel.specialityNameAr = SPECIALITY_NAME_AR
        callModel.specialityNameEn = SPECIALITY_NAME_EN
        
        callModel.clinicNameAr = CLINIC_NAME_AR
        callModel.clinicNameEn = CLINIC_NAME_EN
        callModel.serviceNameAr = SERVICE_NAME_AR
        callModel.serviceNameEn = SERVICE_NAME_EN
        
        callModel.expectedDoneDate = EXPECTEDDONEDATE
      
        currentCallData = [
            "sessionName": sessionName,
            "sessionToken": sessionToken,
            "EMP_NAME_EN": EMP_NAME_EN,
            "EMP_NAME_AR": EMP_NAME_AR,
            "SERIAL": SERIAL,
            "HOSP_NAME_AR": HOSP_NAME_AR,
            "HOSP_NAME_EN":HOSP_NAME_EN,
            "SPECIALITY_NAME_AR":SPECIALITY_NAME_AR,
            "SPECIALITY_NAME_EN":SPECIALITY_NAME_EN,
            "CLINIC_NAME_AR":CLINIC_NAME_AR,
            "CLINIC_NAME_EN":CLINIC_NAME_EN,
            "SERVICE_NAME_AR":SERVICE_NAME_AR,
            "SERVICE_NAME_EN":SERVICE_NAME_EN,
            "EXPECTEDDONEDATE":EXPECTEDDONEDATE
        ]
        let uuid = UUID()
        currentCallUUID = uuid
        let doctorName = MOLHLanguage.isArabic() ?  EMP_NAME_AR:EMP_NAME_EN
        let speciality = MOLHLanguage.isArabic() ?  SPECIALITY_NAME_AR:SPECIALITY_NAME_EN
        let status = UIApplication.shared.applicationState
        if status == .inactive || status == .background {
            let update = CXCallUpdate()
            update.remoteHandle = CXHandle(type: .generic, value: doctorName)
            update.localizedCallerName = speciality.isEmpty ? doctorName : "\(doctorName) - \(speciality)"
            update.hasVideo = true
            provider?.reportNewIncomingCall(with: uuid, update: update) { _ in
                completion()
            }
        }else {
            Observer.fire(observer: .startMeeting, with: callModel)
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

struct VoipCallModel:Codable {
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
