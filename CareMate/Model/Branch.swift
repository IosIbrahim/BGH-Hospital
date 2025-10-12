//
//  OnlineAppointment.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/12/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import Foundation
import Stuff
import Alamofire
import SwiftyJSON
import MOLH

struct Branch: Decodable {
    var id: String
    var arabicName: String
    var englishName: String
    var BRANCH_TYPE: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case arabicName = "NAME_AR"
        case englishName = "NAME_EN"
        case BRANCH_TYPE = "BRANCH_TYPE"
    }
    
    init() {
        id = ""
        arabicName = ""
        englishName = ""
        BRANCH_TYPE = ""
    }
    
    func getName() -> String {
        MOLHLanguage.isArabic() ? arabicName  : englishName
    }
}


struct IdenttypeRow: Codable {
    let id, acceptValidation, nameAr, nameEn: String?
    let regularExpression: String?
    let identtypeRowDefault: String?
    let validationType: String?
    let noIdentityFlag: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case acceptValidation = "ACCEPT_VALIDATION"
        case nameAr = "NAME_AR"
        case nameEn = "NAME_EN"
        case regularExpression = "REGULAR_EXPRESSION"
        case identtypeRowDefault = "DEFAULT"
        case validationType = "VALIDATION_TYPE"
        case noIdentityFlag = "NO_IDENTITY_FLAG"
    }
    
    func getName() -> String? {
        MOLHLanguage.isArabic() ? nameAr : nameEn
    }
}

extension Branch {
    static func getOnlineAppointment(completion: @escaping (([Branch]?, [[String: Any]]?) -> Void)) {
    var urlString = Constants.APIProvider.GetOnlineAppointment
    indicator.sharedInstance.show()
//    let url = URL(string: urlString)
//    let parseUrl = urlString + "?" + Constants.getoAuthValue(url: url!, method: "GET")
    print(urlString)
    URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
        indicator.sharedInstance.dismiss()
        if error != nil {//Has error for request
          if error?._code == -1001 {
           //Domain=NSURLErrorDomain Code=-1001 "The request timed out."
            DispatchQueue.main.async {completion(nil, nil)}
            return
          }
            
        }
        guard let data = data else {
//        Utilities.showAlert(messageToDisplay:"Couldn't connect to server")
        DispatchQueue.main.async {completion(nil, nil)}
        return
      }
      guard let json = String.init(data: data, encoding: .utf8), json.contains("BRANCH_ROW") else {
//        Utilities.showAlert(messageToDisplay:"No branches found")
        DispatchQueue.main.async {completion(nil, nil)}
        return
      }
        
        print(json)
        
      let onlineAppointments = try? Branch(data: data, keyPath: "Root.BRANCH.BRANCH_ROW")
        
        
        print("IDENTTYPE_ROW")
        
        let json1 = try? JSON(data: data)
        
//        case id = "ID"
//        case acceptValidation = "ACCEPT_VALIDATION"
//        case nameAr = "NAME_AR"
//        case nameEn = "NAME_EN"
//        case regularExpression = "REGULAR_EXPRESSION"
//        case identtypeRowDefault = "DEFAULT"
//        case validationType = "VALIDATION_TYPE"
//        case noIdentityFlag = "NO_IDENTITY_FLAG"
     
        
       var identityArray = [IdenttypeRow]()
        
        for (key, subJson) in json1!["Root"]["IDENTTYPE"]["IDENTTYPE_ROW"] {
            let user1 =  IdenttypeRow(id: subJson["ID"].string ?? "", acceptValidation: subJson["ACCEPT_VALIDATION"].string ?? "", nameAr: subJson["NAME_AR"].string ?? "", nameEn: subJson["NAME_EN"].string ?? "", regularExpression: subJson["REGULAR_EXPRESSION"].string ?? "", identtypeRowDefault: subJson["DEFAULT"].string ?? "", validationType: subJson["VALIDATION_TYPE"].string ?? "", noIdentityFlag: subJson["NO_IDENTITY_FLAG"].string ?? "")
            identityArray.append(user1)

        }
        
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(identityArray) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "identityArray")
        }
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let onlineAppointments = onlineAppointments {
                    DispatchQueue.main.async {
                        completion([onlineAppointments], (((json["Root"] as? [String: Any])? ["BRANCH"] as? [String: Any])? ["BRANCH_ROW"]) as? [[String : Any]])
                    }
                } else {
                    let onlineAppointmentss = try? [Branch](data: data, keyPath: "Root.BRANCH.BRANCH_ROW")
                    if let onlineAppointmentss = onlineAppointmentss {
                        DispatchQueue.main.async {
                            completion(onlineAppointmentss, (((json["Root"] as? [String: Any])? ["BRANCH"] as? [String: Any])? ["BRANCH_ROW"]) as? [[String : Any]])
                        }
                    } else {
                        DispatchQueue.main.async {completion(nil, nil)}
                    }
                }
            }
        } catch  {
            DispatchQueue.main.async {completion(nil, nil)}
        }
      }.resume()
  }
    
    static func getOnlineAppointment(getBranchesOnly: Bool = false, completion: @escaping (([Branch]?, [[String: Any]]?) -> Void)) {
    var urlString = Constants.APIProvider.getBranchesOnly
    indicator.sharedInstance.show()
    let url = URL(string: urlString)
    let parseUrl = urlString + "?" + Constants.getoAuthValue(url: url!, method: "GET")
    print(url)
    URLSession.shared.dataTask(with: URL(string: parseUrl)!) { data, response, error in
        indicator.sharedInstance.dismiss()
        if error != nil {//Has error for request
          if error?._code == -1001 {
           //Domain=NSURLErrorDomain Code=-1001 "The request timed out."
            DispatchQueue.main.async {completion(nil, nil)}
            return
          }
            
        }
        guard let data = data else {
//        Utilities.showAlert(messageToDisplay:"Couldn't connect to server")
        DispatchQueue.main.async {completion(nil, nil)}
        return
      }
      guard let json = String.init(data: data, encoding: .utf8), json.contains("BRANCHES_ROW") else {
//        Utilities.showAlert(messageToDisplay:"No branches found")
        DispatchQueue.main.async {completion(nil, nil)}
        return
      }
        
        print(json)
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                let branches = json["BRANCHES"] as? [String: Any]
                var arrBranches = [Branch]()
                if branches?["BRANCHES_ROW"] is [String: Any] {
                    let branchJson = branches?["BRANCHES_ROW"] as? [String: Any]
                    var branch = Branch()
                    branch.id = branchJson?["ID"] as? String ?? ""
                    branch.englishName = branchJson?["NAME_EN"] as? String ?? ""
                    branch.arabicName = branchJson?["NAME_AR"] as? String ?? ""
                    arrBranches.append(branch)
                    completion(arrBranches, nil)
                } else if branches?["BRANCHES_ROW"] is [[String: Any]] {
                    let branchJson = branches?["BRANCHES_ROW"] as? [[String: Any]] ?? [[:]]
                    for item in branchJson {
                        var branch = Branch()
                        branch.id = item["ID"] as? String ?? ""
                        branch.englishName = item["NAME_EN"] as? String ?? ""
                        branch.arabicName = item["NAME_AR"] as? String ?? ""
                        arrBranches.append(branch)
                    }
                    completion(arrBranches, nil)
                }
            } else {
                DispatchQueue.main.async {completion(nil, nil)}
            }
        } catch {
            DispatchQueue.main.async {completion(nil, nil)}
        }
        
      let onlineAppointments = try? Branch(data: data, keyPath: "BRANCHES.BRANCHES_ROW")
        
        
        print("IDENTTYPE_ROW")
        
        let json1 = try? JSON(data: data)
        
//        case id = "ID"
//        case acceptValidation = "ACCEPT_VALIDATION"
//        case nameAr = "NAME_AR"
//        case nameEn = "NAME_EN"
//        case regularExpression = "REGULAR_EXPRESSION"
//        case identtypeRowDefault = "DEFAULT"
//        case validationType = "VALIDATION_TYPE"
//        case noIdentityFlag = "NO_IDENTITY_FLAG"
     
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let onlineAppointments = onlineAppointments {
                    DispatchQueue.main.async {
                        completion([onlineAppointments], ((json["BRANCHES"] as? [String: Any])? ["BRANCHES_ROW"]) as? [[String : Any]])
                    }
                } else {
                    let onlineAppointmentss = try? [Branch](data: data, keyPath: "BRANCHES.BRANCHES_ROW")
                    if let onlineAppointmentss = onlineAppointmentss {
                        DispatchQueue.main.async {
                            completion(onlineAppointmentss, ((json["BRANCHES"] as? [String: Any])? ["BRANCHES_ROW"]) as? [[String : Any]])
                        }
                    } else {
                        DispatchQueue.main.async {completion(nil, nil)}
                    }
                }
            }
        } catch  {
            DispatchQueue.main.async {completion(nil, nil)}
        }
      }.resume()
  }
}
