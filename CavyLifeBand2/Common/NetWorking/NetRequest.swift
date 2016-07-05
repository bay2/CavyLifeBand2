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

// MARK: Result 扩展
// 由于原来的Request写过，所以暂时注释，等所有接口替换成新接口后，删除原来文件后 放开注释

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

// MARK: - RequestError

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

// MARK: - Request方法

/// 请求的回调
typealias RequestHandler = (Result<AnyObject, RequestError>) -> Void

/// 失败响应的回调
typealias FailureHandler = (CommenResponse) -> Void

protocol NetRequest {
    
    /**
     Post请求
     
     - parameter urlString:
     - parameter para:
     - parameter modelObject:
     - parameter failureHandler:
     - parameter successHandler:
     */
    func netPostRequest<T: JSONJoy where T: CommenResponseProtocol>(urlString: String, para: [String: AnyObject]?, modelObject: T.Type, successHandler: ((T) -> Void)?, failureHandler: FailureHandler?)
    
    /**
     Get请求
     
     - parameter urlString:
     - parameter para:
     - parameter modelObject:
     - parameter failureHandler:
     - parameter successHandler:
     */
    func netGetRequest<T: JSONJoy where T: CommenResponseProtocol>(urlString: String, para: [String: AnyObject]?, modelObject: T.Type, successHandler: ((T) -> Void)?, failureHandler: FailureHandler?)
    
}

extension NetRequest {
    
    func netPostRequest<T: JSONJoy where T: CommenResponseProtocol>(urlString: String, para: [String: AnyObject]? = nil, modelObject: T.Type, successHandler: ((T) -> Void)? = nil, failureHandler: FailureHandler? = nil) {
        
        var parameters: [String: AnyObject] = ["phoneType": "ios", "language": UIDevice.deviceLanguage()]
        
        //发送API请求
        if para != nil {
            parameters = parameters.union(para!)
        }
        
        Log.netRequestFormater(urlString, para: para)
        
        requestByAlamofire(.POST, urlString: urlString, parameters: parameters) { (result) in
            
            guard result.isSuccess else {
                
                let commonMsg = try! CommenResponse(JSONDecoder(["msg": RequestApiCode.NetError.description, "code": RequestApiCode.NetError.rawValue, "time": NSDate().timeIntervalSince1970]))
                
                failureHandler?(commonMsg)
                
                return
                
            }
            
                
            do {
                
                let response = try CommenMsgResponse (JSONDecoder(result.value ?? ""))
                
                guard response.commonMsg.code == RequestApiCode.Success.rawValue else {
                    failureHandler?(response.commonMsg)
                    return
                }
                
                successHandler?(try T(JSONDecoder(result.value ?? "")))
                
            } catch {
                
                let commonMsg = try! CommenResponse(JSONDecoder(["msg": RequestApiCode.NetError.description, "code": RequestApiCode.NetError.rawValue, "time": NSDate().timeIntervalSince1970]))
                
                failureHandler?(commonMsg)
                
            }
            
        }
        
    }
    
    func netGetRequest<T: JSONJoy where T: CommenResponseProtocol>(urlString: String, para: [String: AnyObject]? = nil, modelObject: T.Type, successHandler: ((T) -> Void)? = nil, failureHandler: FailureHandler? = nil) {
        
        var parameters: [String: AnyObject] = ["phoneType": "ios", "language": UIDevice.deviceLanguage()]
        
        //发送API请求
        if para != nil {
            parameters = parameters.union(para!)
        }
        
        Log.netRequestFormater(urlString, para: parameters)
        
        requestByAlamofire(.GET, urlString: urlString, parameters: parameters) { (result) in
            
            guard result.isSuccess else {
                
                let commonMsg = try! CommenResponse(JSONDecoder(["msg": RequestApiCode.NetError.description, "code": RequestApiCode.NetError.rawValue, "time": NSDate().timeIntervalSince1970]))
                
                failureHandler?(commonMsg)
                
                return
                
            }
            
            do {
                
                let response = try CommenMsgResponse (JSONDecoder(result.value ?? ""))
                Log.info("\(result.value)")
                guard response.commonMsg.code == RequestApiCode.Success.rawValue else {
                    failureHandler?(response.commonMsg)
                    return
                }
                
                successHandler?(try T(JSONDecoder(result.value ?? "")))
                
            } catch {
                
                let commonMsg = try! CommenResponse(JSONDecoder(["msg": RequestApiCode.NetError.description, "code": RequestApiCode.NetError.rawValue, "time": NSDate().timeIntervalSince1970]))
                
                failureHandler?(commonMsg)
                
            }
            
            
        }
        
    }
    
    
    func requestByAlamofire(method: Alamofire.Method = .POST, urlString: String, parameters: [String: AnyObject]? = nil, completionHandler: RequestHandler? = nil) -> Request {
        
        let authToken: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginAuthToken ?? ""
        
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

// MARK: - Api Class 定义

class NetWebApi: NetRequest {
    
    static var shareApi = NetWebApi()
    
}

// MARK: - 通用响应的定义

/**
 *  通用响应协议
 *  用于接口Api底层做转换
 */
protocol CommenResponseProtocol {
    //通用消息头
    var commonMsg: CommenResponse { get }
}

/**
 *  通用消息格式
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

/**
 *  通用响应模型
 */
struct CommenMsgResponse: CommenResponseProtocol, JSONJoy {
    //通用消息头
    var commonMsg: CommenResponse
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
    }
    
}






