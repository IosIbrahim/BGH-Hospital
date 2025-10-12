//
//  SpecialList.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/18/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import Foundation
import Stuff
import SwiftyJSON
//import Alamofire

struct Speciality: Decodable {
    let id: String
    let arabicName: String
    let englishName: String
    let SPEC_TYPE: String?
    let ICON_PATH: String?
    let CLINIC_LOCATION_AR: String?
    let CLINIC_LOCATION_EN: String?
    
    
    
    
    
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case arabicName = "NAME_AR"
        case englishName = "NAME_EN"
        case SPEC_TYPE = "SPEC_TYPE"
        case ICON_PATH = "ICON_PATH"
        case CLINIC_LOCATION_AR = "CLINIC_LOCATION_AR"
        case CLINIC_LOCATION_EN = "CLINIC_LOCATION_EN"
        
        
    }
}


extension Speciality {
    
    
    static func
    getSpecialist(id: String, type: String, completion: @escaping (([Speciality]?) -> Void)) {
        indicator.sharedInstance.show()
        let urlString = Constants.APIProvider.getSpecialities + "barnchId=\(id)&type=\(type)"
        let url = URL(string: urlString)
        let parseURl = urlString + "&" + Constants.getoAuthValue(url: url!, method: "GET")
        
        
        URLSession.shared.dataTask(with: URL(string: parseURl)!) { data, response, error in
            indicator.sharedInstance.dismiss()
            guard let data = data else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            
            guard let json = String.init(data: data, encoding: .utf8), json.contains("SPECIALITY_ROW") else {
                //        Utilities.showAlert(messageToDisplay:"Couldn't connect to server")
                DispatchQueue.main.async {completion(nil)}
                return
            }
            print(json)
            
            let selectSpecialList = try? [Speciality](data: data, keyPath: "Root.SPECIALITY.SPECIALITY_ROW")
            if let selecSpecilList = selectSpecialList {
                DispatchQueue.main.async {completion(selecSpecilList)}
            } else {
                if let spec = try? Speciality(data: data, keyPath: "Root.SPECIALITY.SPECIALITY_ROW") {
                    let arr = [spec]
                    DispatchQueue.main.async {completion(arr)}
                }
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
}
