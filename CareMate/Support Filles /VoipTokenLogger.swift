import UIKit
import PushKit

#if canImport(BackgroundTasks)
import BackgroundTasks
#endif
#if canImport(MetricKit)
import MetricKit
#endif

final class VoipTokenLogger: NSObject, PKPushRegistryDelegate {

    static let shared = VoipTokenLogger()

    private var pushRegistry: PKPushRegistry?

    func start() {
        let registry = PKPushRegistry(queue: DispatchQueue.main)
        registry.delegate = self
        registry.desiredPushTypes = [.voIP]
        self.pushRegistry = registry
        registerBGRefresherTask()
    }

    func pushRegistry(_ registry: PKPushRegistry,
                      didUpdate pushCredentials: PKPushCredentials,
                      for type: PKPushType) {

        guard type == .voIP else { return }

        let token = pushCredentials.token
            .map { String(format: "%02x", $0) }
            .joined()

        print("==================================")
        print("VOIP TOKEN: \(token)")
        print("==================================")
        UserDefaults.standard.set(token, forKey: "voipPushToken")

    }

    func pushRegistry(_ registry: PKPushRegistry,
                      didInvalidatePushTokenFor type: PKPushType) {
        print("VOIP TOKEN INVALIDATED")
    }

    func pushRegistry(_ registry: PKPushRegistry,
                      didReceiveIncomingPushWith payload: PKPushPayload,
                      for type: PKPushType,
                      completion: @escaping () -> Void) async {

        print("VOIP PUSH RECEIVED: \(payload.dictionaryPayload)")
        // Configure the recurring date.
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//           
//        // Create the trigger as a repeating event.
//        let trigger = UNCalendarNotificationTrigger(
//                 dateMatching: dateComponents, repeats: true)
//        let uuidString = "New Voip Message"
//        let request = UNNotificationRequest(identifier: uuidString, content: .init(), trigger: trigger)
//
//
//        // Schedule the request with the system.
//        let notificationCenter = UNUserNotificationCenter.current()
//        do {
//            try await notificationCenter.add(request)
//        } catch {
//            // Handle errors that may occur during add.
//        }
        
        var localNotification = UILocalNotification()
        localNotification.fireDate = Date(timeIntervalSinceNow: 3)
        localNotification.alertBody = "This is local notification from Swift 2.0"
        localNotification.timeZone = .current
        localNotification.repeatInterval = NSCalendar.Unit.minute
        localNotification.userInfo = ["Important":"Data"];
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = 5
        localNotification.category = "Message"

        UIApplication.shared.scheduleLocalNotification(localNotification)
        completion()
    }
}


// MARK:- New background task api functions

private extension VoipTokenLogger {
    
    func registerBGRefresherTask() {
            BGTaskScheduler.shared
                .register(
                    forTaskWithIdentifier: Constants.APIProvider.bgRefreshAppId,
                    using: nil) { task in
                        // swiftlint:disable force_cast
                        self.handleAppRefresh(task as! BGAppRefreshTask)
                        // swiftlint:enable force_cast
            }
    }
    
    func handleAppRefresh(_ task: BGAppRefreshTask) {
        self.submitBGRefreshTask()
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        let operation = BlockOperation {
            print(#function, "Task started....")
            Observer.fire(observer: NSNotification.Name.UIApplicationBackgroundRefreshStatusDidChange)
        }
        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
        }
        queue.addOperation(operation)
    }
    
    func submitBGRefreshTask() {
        let request = BGAppRefreshTaskRequest(identifier: Constants.APIProvider.bgRefreshAppId)
            request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60)
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print(#function, "Can't submit app refresh task: \(error)")
            }
    }
    
}

// MARK:- Metric kit delegate functions

extension VoipTokenLogger: MXMetricManagerSubscriber {
    
    func didReceive(_ payloads: [MXMetricPayload]) {
        #if DEBUG
      //  payloads.forEach { print(#function, $0.jsonRepresentation().toJSONString()) }
        #endif
    }
    
}
