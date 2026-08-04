import UIKit
import PushKit

#if canImport(BackgroundTasks)
import BackgroundTasks
#endif
#if canImport(MetricKit)
import MetricKit
#endif

final class VoipTokenLogger:NSObject{

    static let shared = VoipTokenLogger()

    func startTask() {
        registerBGRefresherTask()
    }
        
    func sendPush() {
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
