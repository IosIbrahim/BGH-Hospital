//
//  AppConnectionsHandler.swift
//  Bahya
//
//  Created by mohamed elmaazy on 5/16/18.
//  Copyright © 2018 mohamed elmaazy. All rights reserved.
//

import Foundation
import Alamofire

import SwiftyJSON



public enum ResponseStatus {
    case sucess
    case error
}

class AppConnectionsHandler {
    
    static func checkConnection() -> Bool {
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")!
        return (reachabilityManager.isReachable)
    }
    
    fileprivate static func getRequest(url: String, parameters: Any , headers: [String: String]?) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        print(decoded)
        let postData = decoded.data(using: .utf8)
        request.httpBody = postData
        return request
    }
    
    static func get<T: Decodable>(url: String, headers: [String:String]? = nil ,type: T.Type, completion: ((ResponseStatus, Decodable?, String?) -> Void)?) {
        print("url: \(url)")
        let newHeader = getHTTpHeader(headers)
       
        if checkConnection() {
            let safeUrl = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            AF.request(safeUrl, method: HTTPMethod.get , encoding: JSONEncoding.default, headers: newHeader).responseJSON {
                response in
                
                let value = JSON(response.value)

                print(value)

                let jsonResponse = String(data: response.data! , encoding: String.Encoding.utf8)

                let result = handlerResponse1(response: response, type: T.self)
                completion?(result.0, result.1, result.2)
            }
        } else {
            completion?(.error, nil, "errorInConnection")
        }
    }
    
    fileprivate static func getHTTpHeader(_ param:[String:Any]?) -> HTTPHeaders? {
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
    
    static func post<T: Decodable>(url: String, params: [String:Any]? = nil, headers: [String:String]? = nil, type: T.Type, completion: ((ResponseStatus, Decodable?, String?) -> Void)?) {
        print("url: \(url)")
        if checkConnection() {
            let newHeader = getHTTpHeader(headers)
            AF.request(url, method: .post, parameters:params , encoding: JSONEncoding.default, headers: newHeader).responseJSON { response in

                let value = JSON(response.value)

                print(value)
                let result = handlerResponse(response: response, type: T.self)
                
                completion?(result.0, result.1, result.2)
            }
        } else {
            
            
            
            completion?(.error, nil, "errorInConnection")
        }
    }
    
    static func raw<T: Decodable>(url: String, params: Any , headers: [String: String]? = nil, type: T.Type, completion: ((ResponseStatus, Decodable?, String?) -> Void)?) {
        print("url: \(url)")
        
        print(params)
        if checkConnection() {
            AF.request(getRequest(url: url, parameters: params, headers: headers)).responseJSON { (response:AFDataResponse<Any>) in
                let value = JSON(response.value)

             print(value)
                let result = handlerResponse(response: response, type: T.self)
                completion?(result.0, result.1, result.2)
            }
        } else {
            completion?(.error, nil, "errorInConnection")
        }
    }
//    form-data; name="file"; filename="magazine-unlock-01-2.3.7642-_862BFCADAB67AEE778F453671871F3E1.jpg"
   
    fileprivate static func handlerResponse1<T: Decodable>(response: AFDataResponse<Any>, type: T.Type) -> (ResponseStatus, Decodable?, String?) {
        switch(response.result) {
        case .success(_):
           
            if response.value != nil {
                let dic = response.value! as? [String : Any] ?? [String: Any]()
                if response.response?.statusCode == 200 {
                    if response.value! is [String : Any] {
                        if dic.count > 0 {
                            let handledDic = handleJSON(dicc: response.value! as? [String : Any] ?? [String: Any]())
                            let jsonData = try? JSONSerialization.data(withJSONObject: handledDic)
                            let model = try! JSONDecoder().decode(T.self, from: jsonData!)
                            return(.sucess, model, nil)
                        } else {
                            return(.error, nil, "")
                        }
                    } else if response.value! is [[String : Any]] {
                        let handledDic = handleJSONArray(dic: response.value! as? [[String : Any]] ?? [[String: Any]]())
                        let jsonData = try? JSONSerialization.data(withJSONObject: handledDic)
                        let model = try! JSONDecoder().decode(T.self, from: jsonData!)
                        return(.sucess, model, nil)
                    } else {
                        return(.error, nil, "errorInConnection")
                    }
                } else if response.response?.statusCode == 401 {
//                    GO_TO_LOGIN()
                    return(.error, nil,  "")
                } else {
                    return(.error, nil,  "")
                }
            } else {
                return(.error, nil, "errorInConnection")
            }
        case .failure(_):
            return(.error, nil, nil)
            
        }
    }

    
    fileprivate static func handlerResponse<T: Decodable>(response: AFDataResponse<Any>, type: T.Type) -> (ResponseStatus, Decodable?, String?) {
        switch(response.result) {
        case .success(_):
            print(response.value)
            if response.value != nil {
                let dic = response.value! as? [String : Any] ?? [String: Any]()
                if response.response?.statusCode == 200 {
                    if response.value! is [String : Any] {
                        
                        let handledDic = handleJSON(dicc: response.value! as? [String : Any] ?? [String: Any]())
                        let jsonData = try? JSONSerialization.data(withJSONObject: handledDic)
                        let model = try! JSONDecoder().decode(T.self, from: jsonData!)
                        return(.sucess, model, nil)

                        
                    } else if response.value! is [[String : Any]] {
                        let handledDic = handleJSONArray(dic: response.value! as? [[String : Any]] ?? [[String: Any]]())
                        let jsonData = try? JSONSerialization.data(withJSONObject: handledDic)
                        let model = try! JSONDecoder().decode(T.self, from: jsonData!)
                        return(.sucess, model, nil)
                    } else {
                        return(.error, nil, "errorInConnection")
                    }
                } else if response.response?.statusCode == 401 {
//                    GO_TO_LOGIN()
                    return(.error, nil,  "")
                } else {
                    return(.error, nil,  "")
                }
            } else {
                return(.error, nil, "errorInConnection")
            }
        case .failure(_):
            return(.error, nil, nil)
            
        }
    }
    
    static func handleJSON(dicc: [String: Any]) -> [String: Any] {
        var dic = dicc
        for (key, value) in dic {
            if value is Int {
                let temp : Int =  value as! Int
                dic[key] = String(temp)
            } else if value is Double {
                let temp : Double = value as! Double
                dic[key] = String(temp)
            } else if value is Bool {
                let temp : Bool = value as! Bool
                dic[key] = String(temp)
            } else if value is [String: Any] {
                dic[key] = handleJSON(dicc: value as! [String : Any])
            } else if value is [[String: Any]] {
                var newValue = [[String: Any]]()
                for val in value as! [[String: Any]] {
                    newValue.append(handleJSON(dicc: val))
                }
                dic[key] = newValue
            }
        }
        return dic
    }
    
    static func handleJSONArray(dic: [[String: Any]]) -> [[String: Any]] {
        var newValue = [[String: Any]]()
        for item in dic{
            newValue.append(handleJSON(dicc: item))
        }
        return newValue
    }
    
    
    static func StopAPICALL()  {
        AF.session.delegateQueue.cancelAllOperations()
//            sessionManager.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
//                dataTasks.forEach { $0.cancel() }
//                uploadTasks.forEach { $0.cancel() }
//                downloadTasks.forEach { $0.cancel() }
//            }
        }

}

