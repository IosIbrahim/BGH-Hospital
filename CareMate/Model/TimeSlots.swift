//
//  SlotsTime.swift
//  CareMate
//
//  Created by Eng Nour Hegazy on 11/20/17.
//  Copyright © 2017 khabeer Group. All rights reserved.


import Foundation
import Stuff
import Alamofire
import ObjectMapper
//-------------------------------------------------------------------------------
struct Slot: Decodable {
  let id: String
  let placeID : String
  let shiftID : String
  let schedual : String
  let statuse : String
  let TIME_SLOT_END : String

  enum CodingKeys : String ,CodingKey {
    case id = "ID"
    case placeID = "PLACE_ID"
    case shiftID =  "SHIFT_ID"
    case schedual = "SCHED_SER"
    case statuse = "SLOT_STATUS"
    case TIME_SLOT_END = "TIME_SLOT_END"
    
//    ID = "14/03/2021 16:45:00";
//                               "NAME_AR" = 45;
//                               "NAME_EN" = 45;
//                               "PLACE_ID" = 7;
//                               "QUE_SYS_SER" = 16;
//                               "SCHED_SER" = 54620;
//                               "SHIFT_ID" = 3;
//                               "SLOT_STATUS" = empty;
//                               "TIME_SLOT_END" = "14/03/2021 17:00:00";
    
  }
}
//-----------------------------------------------------------------------------//
struct TimeSlots : Decodable {
    var id: String = ""
    //let slots :String
    var slotsarray: SINGLE_HOUR_SLOTS?
    enum CodingKeys : String ,CodingKey {
        case id = "ID"
        case slotsarray = "SINGLE_HOUR_SLOTS"
    }
}
//---------------------------------------------------------------

struct SINGLE_HOUR_SLOTS: Decodable {
    var SINGLE_HOUR_SLOTS_ROW: [Slot]?
    
    enum CodingKeys: String, CodingKey {
        case SINGLE_HOUR_SLOTS_ROW = "SINGLE_HOUR_SLOTS_ROW"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        SINGLE_HOUR_SLOTS_ROW = []
        if let singleAlert = try? values.decode(Slot.self, forKey: CodingKeys.SINGLE_HOUR_SLOTS_ROW) {
            SINGLE_HOUR_SLOTS_ROW?.append(singleAlert)
        } else if let multiVenue = try? values.decode([Slot].self, forKey: CodingKeys.SINGLE_HOUR_SLOTS_ROW) {
            SINGLE_HOUR_SLOTS_ROW = multiVenue
        }
    }
}

extension TimeSlots {

    static func getSlotsTimes(branchID : String , clincID :String ,docID :String ,date: String,isPhysical:Bool = false,  completion: @escaping (([TimeSlots]?,String, String)->Void)) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: date.ConvertToDate)
        var physdate = ""
        if isPhysical {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            physdate = dateFormatter.string(from: date.ConvertToDate)
        }
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let nextdate = dateFormatter.string(from: date.ConvertToDate)

        indicator.sharedInstance.show()
        
        var urlString = Constants.APIProvider.GetDoctorTimeSlots+"Branch_ID=" + branchID + "&DOC_ID=" + docID + "&CLINIC_ID=" + clincID + "&Web_FromDate=" + date
        if isPhysical {
            urlString = "\(Constants.APIProvider.GetDoctorPhysicalTimeSlots)bRANCH_ID=\(branchID)&mODALITY_ID=\(docID)&SCHED_DATE_FORMATED=\(nextdate)&SCHED_DATE=\(physdate)"
        }
        print(urlString)
        let url = URL(string: urlString)
        let pars = isPhysical ? Constants.APIProvider.GetDoctorPhysicalTimeSlots:Constants.APIProvider.GetDoctorTimeSlots
        var parseURl = pars + "&" + Constants.getoAuthValue(url: url!, method: "GET")
//        if isPhysical {
//            parseURl = urlString
//        }
        URLSession.shared.dataTask(with: URL(string: parseURl)!) { data, response, error in
        indicator.sharedInstance.dismiss()
        guard let data = data else {
            DispatchQueue.main.async {completion(nil,"", "")}
        return
      }
            do {
                
                
            let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                let d = (json as? [String: Any]  ?? .init())
                var avSlots = [TimeSlots]()
                let slots = try? [TimeSlots](data: data, keyPath: "Root.HOURS_SLOTS.HOURS_SLOTS_ROW")
                
                let slotsObj = try? TimeSlots(data: data, keyPath: "Root.HOURS_SLOTS.HOURS_SLOTS_ROW")
                
                let slotsTime = ((d["Root"] as? [String : AnyObject])?["HOURS_SLOTS"] as? [String: AnyObject])?["DAY_DATE"] as? String
                
                if slots != nil
                {
                    avSlots.append(contentsOf: slots!)
                }
                if slotsObj != nil
                {
                    avSlots.append(slotsObj!)
                }
                if let dd = (d["Root"] as? [String : AnyObject])?["next_available_time"] as? String {
                    var nextAv = ""
                    
                    if dd.isEmpty == false
                    {
                        nextAv = dd
                    }
                    else
                    {
                        nextAv = nextdate
                    }
                    
                    //   i  want  to  change to  the  # Comment  link  there
                    //              let slots = try? [SlotsTime](data: data, keyPath: "Root.HOURS_SLOTS.HOURS_SLOTS_ROW.SINGLE_HOUR_SLOTS.SINGLE_HOUR_SLOTS_ROW")
                    //            //.SINGLE_HOUR_SLOTS_ROW
                    if  avSlots.count != 0 {
                        DispatchQueue.main.async {completion(avSlots,nextAv, slotsTime ?? "")}
                    } else {
                        DispatchQueue.main.async {completion(nil,"", "")}
                    }
                }else {
                    if let msg = d["Message"] as? String {
                        DispatchQueue.main.async {completion(nil,msg, msg)}
                    }else {
                        DispatchQueue.main.async {completion(nil,"", "")}

                    }

                }
               
            }
            catch {
                print(error.localizedDescription)
            }
      
      }.resume()
  }


  static func submitReservation(docId: String, patientId: String, branchId: String, clinicId: String, shiftId: String, selectedDate: String, SCHED_SER: String, specialId: String, completion: @escaping (String?) -> Void) {
    let urlString = Constants.APIProvider.SubmitAppointment
    let url = URL(string: urlString)!

    var params = [String: String]()
    params["BRANCH_ID"] = branchId
    params["COMPUTER_NAME"] = "iOS"
    params["SERV_TYPE"] = "1"
    params["CLINIC_ID"] = clinicId
    params["SHIFT_ID"] = shiftId
    params["SCHED_SERIAL"] = SCHED_SER
    params["DOC_ID"] = docId
    params["PATIENT_ID"] = patientId
    params["dateDone"] = selectedDate
    params["GENDER"] = ""
    params["PATIENT_ID"] = patientId
    params["SPEC_ID"] = specialId
    params["buffer_status"] = "1"

    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
      .responseJSON { response in
        print(response.value)
        DispatchQueue.main.async {completion("reservation id")}
    }
  }

}









