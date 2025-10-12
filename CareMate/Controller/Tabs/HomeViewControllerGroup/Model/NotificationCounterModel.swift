//
//  NotificationCounterModel.swift
//  PrimeCareHR
//
//  Created by Ibrahim on 11/02/2025.
//


struct NotificationCounterResponseModel:Codable {
    let Root:NotificationCounterRootModel?
}


struct NotificationCounterRootModel:Codable {
    let ALERT_COUNTS:NotificationCounterAlertModel?
}

struct NotificationCounterAlertModel:Codable {
    let ALERT_COUNTS_ROW:NotificationCounterAlertRowModel?
}

struct NotificationCounterAlertRowModel:Codable {
    let ALERT_COUNTS_RESULT:String?
}
