//
//  NetRequest.swift
//  CavyLifeBand2
//
//  Created by JL on 16/6/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import Alamofire
import EZSwiftExtensions
import JSONJoy

//extension Result {
//    
//    func success(@noescape closure: (Value -> Void)) -> Result {
//        
//        switch self {
//        case .Success(let value):
//            closure(value)
//        default:
//            break
//        }
//        
//        return self
//    }
//    
//    func failure(@noescape closure: (Error -> Void)) -> Result {
//        
//        switch self {
//        case .Failure(let error):
//            closure(error)
//        default:
//            break
//        }
//        
//        return self
//    }
//    
//}

enum RequestError: ErrorType {
   case NetErr
}

extension RequestError: CustomStringConvertible {
    
    var description: String {
        
        switch self {
        case .NetErr:
            return L10n.UserModuleErrorCodeNetError.string
        }
        
    }
    
}

typealias RequestHandler = (Result<AnyObject, RequestError>) -> Void

typealias ResponseHandler = (Any) -> Void

typealias FailureHandler = (String) -> Void

protocol NetRequest {
    
    func netPostRequest<T: JSONJoy where T: CommenResponseProtocol>(urlString: String, para: [String: AnyObject]?, modelObject: T.Type?, failureHandler: FailureHandler?, successHandler: ResponseHandler?)
    
    func netGetRequest<T: JSONJoy where T: CommenResponseProtocol>(urlString: String, para: [String: AnyObject]?, modelObject: T.Type?, failureHandler: FailureHandler?, successHandler: ResponseHandler?)
    
}

extension NetRequest {
    
    func netPostRequest<T: JSONJoy where T: CommenResponseProtocol>(urlString: String, para: [String: AnyObject]? = nil, modelObject: T.Type? = nil, failureHandler: FailureHandler? = nil, successHandler: ResponseHandler? = nil) {
        
        var parameters: [String: AnyObject] = ["phoneType": "ios", "language": UIDevice.deviceLanguage()]
        
        //发送API请求
        if para != nil {
            parameters = parameters.union(para!)
        }
        
        Log.netRequestFormater(urlString, para: para)
        
        requestByAlamofire(.GET, urlString: urlString, parameters: parameters) { (result) in
            
            guard result.isSuccess else {
                
                failureHandler?(RequestError.NetErr.description)
                
                return
                
            }
            
            if modelObject != nil {
                
                
                do {
                    
                    let resultResponse = try T(JSONDecoder(result.value ?? ""))
                    
                    guard resultResponse.commonMsg.code == RequestApiCode.Success.rawValue else {
                        failureHandler?(RequestError.NetErr.description)
                        return
                    }
                    
                    successHandler?(resultResponse)
                    
                } catch {
                    
                    failureHandler?(RequestError.NetErr.description)
                    
                }
                
            } else {
                
                successHandler?(result.value)
                
            }
            
        }

        
    }
    
    func netGetRequest<T: JSONJoy where T: CommenResponseProtocol>(urlString: String, para: [String: AnyObject]? = nil, modelObject: T.Type? = nil, failureHandler: FailureHandler? = nil, successHandler: ResponseHandler?) {
        
        var parameters: [String: AnyObject] = ["phoneType": "ios", "language": UIDevice.deviceLanguage()]
        
        //发送API请求
        if para != nil {
            parameters = parameters.union(para!)
        }
        
        Log.netRequestFormater(urlString, para: parameters)
        
        requestByAlamofire(.GET, urlString: urlString, parameters: parameters) { (result) in
            
            guard result.isSuccess else {
                
                failureHandler?(RequestError.NetErr.description)
                
                return
                
            }
            
            if modelObject != nil {
                
                
                do {
                
                    let resultResponse = try T(JSONDecoder(result.value ?? ""))
                    
                    guard resultResponse.commonMsg.code == RequestApiCode.Success.rawValue else {
                        failureHandler?(RequestError.NetErr.description)
                        return
                    }
                    
                    successHandler?(resultResponse)
                    
                } catch {
                    
                    failureHandler?(RequestError.NetErr.description)
                    
                }
                
            }
//            else {
//                
//                successHandler?(result.value)
//            
//            }
            
        }
        
    }
    
    
    func requestByAlamofire(method: Alamofire.Method = .POST, urlString: String, parameters: [String: AnyObject]? = nil, completionHandler: RequestHandler? = nil) -> Request {
        
        let authToken: String = "oQnuAhizJ4bJhzkNJ"//CavyDefine.loginUserBaseInfo.loginUserInfo.loginAuthToken ?? ""
        
        let request = Alamofire.request(method, urlString, encoding: method == .POST ? .JSON : .URL, parameters: parameters, headers: [UserNetRequsetKey.AuthToken.rawValue: authToken]).responseJSON { response -> Void in
            
            if response.result.isFailure {
                completionHandler?(.Failure(.NetErr))
                Log.error("Network error")
                return
            }
            
            guard let responseResult = response.result.value else {
                completionHandler?(.Failure(.NetErr))
                Log.error("Network error")
                return
            }
            
            completionHandler?(.Success(responseResult))
            
        }
        
        if Log.enabled {
            debugPrint(request)
        }
        
        return request
        
    }

}


protocol CommenResponseProtocol {
    //通用消息头
    var commonMsg: CommenResponse { get }
}

/**
 *  通用响应格式
 */
struct CommenResponse: JSONJoy {
    
    var msg: String
    var code: Int
    var time: Double
    
    init(_ decoder: JSONDecoder) throws {
        
        msg = try decoder["msg"].getString()
        code = try decoder["code"].getInt()
        time = try decoder["time"].getDouble()
        
    }
    
}

struct CommenTest: CommenResponseProtocol, JSONJoy {
    //通用消息头
    var commonMsg: CommenResponse
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
    }
}


class NetWebApi: NetRequest {
    
    static var shareApi = NetWebApi()
    
}



