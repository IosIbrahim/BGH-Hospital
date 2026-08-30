//
//  Identy.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/29/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import Foundation
import Stuff
struct Identy : Decodable {
    

let id : String
    let identyName : String
    let identyNameAR : String
enum CodingKeys: String, CodingKey {
    case id  = "ID"
    case identyName = "NAME_EN"
    case identyNameAR = "NAME_AR"

}
}

extension Identy {
    static func getIdentyTyp(  completion: @escaping (([Identy]?) -> Void)) {
        indicator.sharedInstance.show()
        let urlString = Constants.APIProvider.GetOnlineAppointment
        let url = URL(string: urlString)
        let parseURl = urlString + "?" + Constants.getoAuthValue(url: url!, method: "GET")
        var req = URLRequest(url: URL(string: parseURl)!)
        if let token = UserDefaults.standard.string(forKey: "ACCESS_TOKEN"){
            req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        URLSession.shared.dataTask(with: req) { data, response, error in            indicator.sharedInstance.dismiss()
            if error?._code == 401 {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name("session.ended"), object: nil)
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {completion(nil)}
                return
            }
            guard let json = String.init(data: data, encoding: .utf8), json.contains("IDENTTYPE_ROW") else {
                DispatchQueue.main.async {completion(nil)}
                return
            }
            let identySelect = try? [Identy] (data: data, keyPath: "Root.IDENTTYPE.IDENTTYPE_ROW")
            if let identySelect = identySelect  {
                DispatchQueue.main.async {completion(identySelect)}
            } else {
                DispatchQueue.main.async {completion(nil)}
            }
            }.resume()
    }
}
