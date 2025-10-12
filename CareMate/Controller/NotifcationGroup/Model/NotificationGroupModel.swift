//
//  NotificationFroupModel.swift
//  CareMate
//
//  Created by Ibrahim on 24/02/2025.
//  Copyright © 2025 khabeer Group. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct NotificationGroupModel: Codable {
    let root: RootNotifcstion?

    enum CodingKeys: String, CodingKey {
        case root = "Root"
    }
}

// MARK: - Root
struct RootNotifcstion: Codable {
    let decisionList: DecisionList?
    let alertsCounts: AlertsCounts?
    let alertsStp: AlertsStp?

    enum CodingKeys: String, CodingKey {
        case decisionList = "DECISION_LIST"
        case alertsCounts = "ALERTS_COUNTS"
        case alertsStp = "ALERTS_STP"
    }
}

// MARK: - AlertsCounts
struct AlertsCounts: Codable {
    let alertsCountsRow: [AlertsCountsRow]?

    enum CodingKeys: String, CodingKey {
        case alertsCountsRow = "ALERTS_COUNTS_ROW"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let single = try? container.decode(AlertsCountsRow.self, forKey: .alertsCountsRow) {
            alertsCountsRow = [single]
        } else if let array = try? container.decode([AlertsCountsRow].self, forKey: .alertsCountsRow) {
            alertsCountsRow = array
        } else {
            alertsCountsRow = nil
        }
    }
}

//struct AlertsCounts: Codable {
//    let alertsCountsRow: [AlertsCountsRow]?
//
//    enum CodingKeys: String, CodingKey {
//        case alertsCountsRow = "ALERTS_COUNTS_ROW"
//    }
//}

// MARK: - AlertsCountsRow
struct AlertsCountsRow: Codable {
    let maxDate, alertDescEn, alertID, alertType: String?
    let alertDescAr, countUnread, countUndescion, countAll: String?

    enum CodingKeys: String, CodingKey {
        case maxDate = "MAX_DATE"
        case alertDescEn = "ALERT_DESC_EN"
        case alertID = "ALERT_ID"
        case alertType = "ALERT_TYPE"
        case alertDescAr = "ALERT_DESC_AR"
        case countUnread = "COUNT_UNREAD"
        case countUndescion = "COUNT_UNDESCION"
        case countAll = "COUNT_ALL"
    }
    
    func getDes() -> String {
        return UserManager.isArabic ? alertDescAr ?? "":alertDescEn ?? ""
    }
}

// MARK: - AlertsStp
struct AlertsStp: Codable {
    let alertsStpRow: [Row]?

    enum CodingKeys: String, CodingKey {
        case alertsStpRow = "ALERTS_STP_ROW"
    }
}



// MARK: - DecisionList
struct DecisionList: Codable {
    let decisionListRow: [Row]?

    enum CodingKeys: String, CodingKey {
        case decisionListRow = "DECISION_LIST_ROW"
    }
}

// MARK: - Row
struct Row: Codable {
    let id, nameAr, nameEn: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case nameAr = "NAME_AR"
        case nameEn = "NAME_EN"
    }
}
