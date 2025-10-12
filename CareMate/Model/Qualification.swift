//
//  Qualification.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/20/17.
//  Copyright © 2017 khabeer Group. All rights reserved.
//

import Foundation
import Stuff

struct Qualification: Decodable {
    let qualificationName: String
    let qualificationNameAR: String
    let HREMPLOYEELANGUAGE_AR: String
    let HREMPLOYEELANGUAGE_EN: String
    
  enum CodingKeys: String, CodingKey {
    case qualificationName = "QUALIFICATIONS_EN"
    case qualificationNameAR = "QUALIFICATIONS_AR"
      case HREMPLOYEELANGUAGE_AR = "HREMPLOYEELANGUAGE_AR"
      case HREMPLOYEELANGUAGE_EN = "HREMPLOYEELANGUAGE_EN"
 // case qualificationName = "SECTION_NAME_EN"
    }
}

extension Qualification {
  static func getQualifications(forDoctorWithId doctorId: String,
                                completion: @escaping ((Qualification?) -> Void)) {
    indicator.sharedInstance.show()
    let urlString = Constants.APIProvider.GetDoctorProfile + doctorId
    let url = URL(string: urlString)
    let parseURl = urlString + "&" + Constants.getoAuthValue(url: url!, method: "GET")
    URLSession.shared.dataTask(with: URL(string: parseURl)!) { data, response, error in
        indicator.sharedInstance.dismiss()
        guard let data = data else {
//        Utilities.showAlert(messageToDisplay:"Couldn't connect to server")
        DispatchQueue.main.async {completion(nil)}
        return
      }
      guard let json = String.init(data: data, encoding: .utf8), json.contains("EMP_DATA_ROW") else {
        DispatchQueue.main.async {completion(nil)}
        return
      }
      let qualificat = try? Qualification (data: data, keyPath: "Root.EMP_DATA.EMP_DATA_ROW")
      if let qualificat = qualificat  {
        DispatchQueue.main.async {completion(qualificat)}
      } else {
        DispatchQueue.main.async {completion(nil)}
      }
      }.resume()
  }
}
