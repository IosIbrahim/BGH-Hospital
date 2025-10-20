

import UIKit
import Alamofire
import Reachability
import SwiftyJSON

class WebserviceMananger: NSObject {
    struct Singleton {
        static let instance = WebserviceMananger()
    }
    
    class var sharedInstance: WebserviceMananger {
        return Singleton.instance
    }
    var callURL = ""
    func makeCall(method: Alamofire.HTTPMethod, url : String, parameters: [String: Any]? , vc:UIViewController? = nil, showIndicator: Bool = true, encode: Bool = true, completionHandler : @escaping (AnyObject?,String?) -> ()) -> Void
    {
        
        var safeUrl = url
        if encode {
            safeUrl = safeUrl.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            safeUrl = safeUrl.replacingOccurrences(of: "+", with: "%2B")
        }
        print(safeUrl)
        
        
        if showIndicator {
            indicator.sharedInstance.show()
        }
//        if Reachability.isConnectedToNetwork() {
          var parss = parameters
            AF.request(safeUrl, method: method, parameters: parss, encoding: JSONEncoding.default, headers: nil) .responseJSON
                { response in
                    if showIndicator {
                        indicator.sharedInstance.dismiss()
                    }
                    print(JSON(response.value))
                    print("response.response!.statusCode ")
                    print(response)
                    if response.response == nil || response.response!.statusCode == 500
                    {
                        Utilities.showAlert(vc, messageToDisplay: UserManager.isArabic ? "لا يمكن الإتصال بالخادم في الوقت الحالي" : "The server cannot be contacted at this time")
                        
                        return
                    }
                    if response.response!.statusCode == 404
                    {

                        Utilities.showAlert(vc, messageToDisplay: UserManager.isArabic ? "لا يمكن الإتصال بالخادم في الوقت الحالي" : "The server cannot be contacted at this time")
                        return
                    }
                    
                
                    
                    switch response.result {
                    case .success (let value):
              
                        if let data = value as? [String: AnyObject]
                        {
                            print(data)
                            if data.keys.contains("Root")
                            {
                            let root = data["Root"] as? [String: AnyObject]
                                if ((root?.keys.contains("MESSAGE")) != nil)
                            {
                                    let messageRow = (root?["MESSAGE"] as? [String: AnyObject])?["MESSAGE_ROW"] as? [String : AnyObject]
                                    let englishMsg = messageRow?["NAME_EN"] as? String
                                    let arabicMsg = messageRow?["NAME_AR"] as? String
                                    completionHandler(data as AnyObject?, nil)
                            }
                            else
                            {
                                completionHandler(data as AnyObject?, nil)

                            }
                            }
                            else
                            {
                                completionHandler(data as AnyObject?, nil)
                            }
                            
                        }
                        else
                        {
                          
                            if let dat = value as? [[String:AnyObject]]
                            {
                              
                                completionHandler(value as AnyObject?, nil)
                            }
                            else if let x = value as? String
                            {
                              
                                completionHandler(["result":x] as AnyObject, nil)
                            }
                            else
                            {
                               
                                Utilities.showAlert(vc, messageToDisplay: UserManager.isArabic ? "لا يمكن الإتصال بالخادم في الوقت الحالي" : "The server cannot be contacted at this time")
                            }
                        }
                    case .failure(let error):
                        completionHandler(nil, nil)
                      
                    }
            }
                .responseString { response in
                     switch(response.result) {
                     case .success(_):
                       var  respnse = ""
                          respnse = response.value as? String ?? ""
                         if respnse.contains("ROW")  || respnse.contains("div") || respnse.contains("Tel_Types")  || respnse.contains("Save Success"){
                             let nc = NotificationCenter.default
                             nc.post(name: Notification.Name("dataFound"), object: nil)
                             if url.contains("LabReqHistoryload") {
                                 if   respnse.contains("LAB_PAT_HISTORY_ROW"){
                                     let nc = NotificationCenter.default
                                     nc.post(name: Notification.Name("dataFound"), object: nil)
                                 }
                                   else  {
                                       if url.contains("INDEX_FROM") {
                                           if url.contains("INDEX_FROM=0") {
                                               let nc = NotificationCenter.default
                                            //   nc.post(name: Notification.Name("nodataFound"), object: nil)
                                           }
                                       }else {
                                           let nc = NotificationCenter.default
                                        //   nc.post(name: Notification.Name("nodataFound"), object: nil)
                                       }
                                    }
                             }
                             
                         }
                         else{
                          
                             if method == .post{
                                 let nc = NotificationCenter.default
                                 nc.post(name: Notification.Name("dataFound"), object: nil)
                             }

                             if url.contains("Reporting/Pages/dxReportViewe") || url.contains("verifyQuestNumber") || url.contains("MedicalRecordController/PRINTREPORTSUBMIT") || url.contains("validate_update_mobile_no") || url.contains("submit_appointment") || url.contains("SubmitStepNew") || url.contains("patient_signup") || url.contains("load_patient_data") || url.contains("load_patient_family") || url.contains("verify_patient_identity_sms") || url.contains("get_govs_by_country") || url.contains("get_cities") || url.contains("get_villages") || url.contains("submit_online_survey") || url.contains("validateCode") || url.contains("patient_login")  || url.contains("DoctorController/getVisitForPatient?") || url.contains("MedicalRecord/LOADPRINTREPORTREQUEST?") || url.contains("StockController/schedule_items") || url.contains("Hr/loadImage") || url.contains("PersonalController/loadEmplyeeBiography") || url.contains("getPacsUrlMob") || url.contains("RadiologyController/getPacsReportUrlMob") || url.contains("LaboratoryController/generatePdf") {
                                 let nc = NotificationCenter.default
                                 nc.post(name: Notification.Name("dataFound"), object: nil)

                             }
                             else{
                              //   let nc = NotificationCenter.default
                               //  nc.post(name: Notification.Name("nodataFound"), object: nil)
                             }
                             
                         }
                              
                     case .failure(_):
                         print("Error message:\(String(describing: response.error))")
                         break
                      }
                }
//        } else {
//            Utilities.showAlert(vc, messageToDisplay : "No Internet Connection")
//        }
    }
    
    func makeCall(method: Alamofire.HTTPMethod, urlString : String, parameters: [String: Any]? , vc:UIViewController , headers :[String:String] , completionHandler : @escaping (AnyObject?,String?) -> ()) -> Void
    {
//        indicator.sharedInstance.show(vc)
//        if Reachability.isConnectedToNetwork() {

            print(urlString)
        let new = getHTTpHeader(headers)
            AF.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: new).responseJSON
                { response in
                    
                    switch response.result {
                    case .success (let value):
//                        indicator.sharedInstance.dismiss()
                        let data = value as! [String: AnyObject]
                        if let succ = data["key"]
                        {
                            if(data["key"] as! Bool == true ){ //Temp case
                                print(value)
                                
                                
                                completionHandler(value as AnyObject?, nil)
                            }
                            else
                            {
//                                indicator.sharedInstance.dismiss()
                                Utilities.showAlert(vc, messageToDisplay : "API Error "+data.description)
                                
                            }
                        }
                        
                    case .failure(let error):
//                        indicator.sharedInstance.dismiss()
                        
                        completionHandler(nil, error.localizedDescription)
                    }
            }
            
//        } else {
//            indicator.sharedInstance.dismiss()
//            Utilities.showAlert(vc, messageToDisplay : "No Internet Connection")
//            //            completionHandler(nil, nil)
//        }
    }
    
    
    func getHTTpHeader(_ param:[String:Any]?) -> HTTPHeaders? {
        var newHeader : HTTPHeaders?
        if param != nil {
            newHeader = .init()
            var htpHeaders = [HTTPHeader]()
            let keys = param?.keys
            for (i,item) in keys!.enumerated() {
                for (j,val) in param!.values.enumerated() {
                    if i == j {
                        let head :HTTPHeader = .init(name: item, value: "\(val)")
                        htpHeaders.append(head)
                    }
                }
            }
            newHeader = .init(htpHeaders)
        }
        return newHeader
    }
    
    func makeCallText(method: Alamofire.HTTPMethod, urlString : String, parameters: String , vc:UIViewController , headers :[String:String] , completionHandler : @escaping (AnyObject?,NSError?,Int) -> ()) -> Void
    {
//        indicator.sharedInstance.show(vc)
//        if Reachability.isConnectedToNetwork() {
        let new = getHTTpHeader(headers)
            
        AF.request(urlString, method: method, parameters: [:], encoding: parameters , headers: new ).responseJSON
                { response in
                    //                   response.resultc
                    switch response.result {
                    case .success (let value):
//                        indicator.sharedInstance.dismiss()
                        completionHandler(value as AnyObject?, nil , response.response!.statusCode)
                    case .failure(let error):
//                        indicator.sharedInstance.dismiss()
                        
                        completionHandler(nil, error as NSError?, response.response!.statusCode)
                        
                    }
            }
            
//        } else {
//            indicator.sharedInstance.dismiss()
//            Utilities.showAlert(vc, messageToDisplay : "No Internet Connection")
//            //            completionHandler(nil, nil)
//        }
    }
    
    
    
}


extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

