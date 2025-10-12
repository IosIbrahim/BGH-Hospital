//
//  NotificationGroupDetailsModel.swift
//  CareMate
//
//  Created by Ibrahim on 24/02/2025.
//  Copyright © 2025 khabeer Group. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct NotificationGroupDetailsModel: Codable {
    let alertsResult: AlertsResult?

    enum CodingKeys: String, CodingKey {
        case alertsResult = "ALERTS_RESULT"
    }
}

// MARK: - AlertsResult
struct AlertsResult: Codable {
    var alertsResultRow: [AlertsResultRow]?

    enum CodingKeys: String, CodingKey {
        case alertsResultRow = "ALERTS_RESULT_ROW"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        alertsResultRow = []
        if let singleAlert = try? values.decode(AlertsResultRow.self, forKey: CodingKeys.alertsResultRow) {
            alertsResultRow?.append(singleAlert)
        } else if let multiVenue = try? values.decode([AlertsResultRow].self, forKey: CodingKeys.alertsResultRow) {
            alertsResultRow = multiVenue
        }
    }
}

// MARK: - AlertsResultRow
struct AlertsResultRow: Codable {
    let bodyAr, rowNum, decisionID, bodyEn: String?
    let pagesCount, decisionNameEn: String?
    let escalatedDate: String?
    let headerEn, transdate, alertURL: String?
    let decisiondate: String?
    let alertSerial: String?
    let decisionUserid: String?
    let readFlag: String?
    let escalated: String?
    let serial, lastuser, decisionNameAr, alertID: String?
    let headerAr, decision: String?
    let newTransdate: String?

    enum CodingKeys: String, CodingKey {
        case bodyAr = "BODY_AR"
        case rowNum = "ROW_NUM"
        case decisionID = "DECISION_ID"
        case bodyEn = "BODY_EN"
        case pagesCount = "PAGES_COUNT"
        case decisionNameEn = "DECISION_NAME_EN"
        case escalatedDate = "ESCALATED_DATE"
        case headerEn = "HEADER_EN"
        case transdate = "TRANSDATE"
        case alertURL = "ALERT_URL"
        case decisiondate = "DECISIONDATE"
        case alertSerial = "ALERT_SERIAL"
        case decisionUserid = "DECISION_USERID"
        case readFlag = "READ_FLAG"
        case escalated = "ESCALATED"
        case serial = "SERIAL"
        case lastuser = "LASTUSER"
        case decisionNameAr = "DECISION_NAME_AR"
        case alertID = "ALERT_ID"
        case headerAr = "HEADER_AR"
        case decision = "DECISION"
        case newTransdate = "NEW_TRANSDATE"
    }
    
    func getHeader() -> String {
        return UserManager.isArabic ? headerAr ?? "":headerEn ?? ""
    }
    
    func getBody() -> String {
        return UserManager.isArabic ? bodyAr ?? "":bodyEn ?? ""
    }
}
