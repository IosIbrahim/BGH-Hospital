//
//  Observer.swift
//  LutfiDriver
//
//  Created by Jamal Alayq on 3/21/19.
//  Copyright © 2019 Jamal Alayq. All rights reserved.
//

import Foundation

final class Observer {
    
    private var observers: Array<NSObjectProtocol> = .init()
    private let center = NotificationCenter.default
    private let queue: OperationQueue
    
    required init(queue: OperationQueue = .main) {
        self.queue = queue
    }
    
    deinit {
        observers.forEach(center.removeObserver)
        observers.removeAll()        
    }
    
    func when(_ name: Notification.Name, object: Any? = .none, perform handler: @escaping(Notification) -> Void) {
        let observer = center.addObserver(forName: name, object: object, queue: queue, using: handler)
        observers.append(observer)
    }
    
    static func fire(observer name: Notification.Name, with object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }
    
    func remove() {
        observers.forEach(center.removeObserver)
        observers.removeAll()
    }
    
}

extension Notification.Name {
    static var dataConnect: Self {.init("data.connect")}
    static var becomeActive: Self { .init("become.active")}
    static var inBackground: Self { .init("in.background")}
    static var startMeeting: Self { .init("start.meeting")}
    static var enfMeeting: Self { .init("end.meeting")}

}
