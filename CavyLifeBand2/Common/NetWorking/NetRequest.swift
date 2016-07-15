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
        
        requestByAlamofire(.POST, urlString: urlString, parameters: para) { (result) in
            
            guard result.isSuccess else {
                
                let commonMsg = try! CommenResponse(JSONDecoder(["msg": RequestApiCode.NetError.description, "code": RequestApiCode.NetError.rawValue, "time": NSDate().timeIntervalSince1970]))
                
                failureHandler?(commonMsg)
                
                return
                
            }
            
                
            do {
                
                let response = try CommenMsgResponse (JSONDecoder(result.value ?? ""))
                
                guard response.commonMsg.code == RequestApiCode.Success.rawValue else {
                    
                    // token失效 重新去登录
                    if response.commonMsg.code == RequestApiCode.InvalidToken.rawValue {
                    
                   self.RequesInvalidToken()
                        
                    }
                    
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
        
        requestByAlamofire(.GET, urlString: urlString, parameters: para) { (result) in
            
            guard result.isSuccess else {
                
                let commonMsg = try! CommenResponse(JSONDecoder(["msg": RequestApiCode.NetError.description, "code": RequestApiCode.NetError.rawValue, "time": NSDate().timeIntervalSince1970]))
                
                failureHandler?(commonMsg)
                
                return
                
            }
            
            do {
                
                let response = try CommenMsgResponse (JSONDecoder(result.value ?? ""))
                Log.info("\(result.value)")
                guard response.commonMsg.code == RequestApiCode.Success.rawValue else {
                    
                    // token失效 重新去登录
                    if response.commonMsg.code == RequestApiCode.InvalidToken.rawValue {
                        
                        self.RequesInvalidToken()
                       
                    }

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
        
        let headers: [String: String] = [NetRequsetKey.PhoneType.rawValue: "ios",
                                            NetRequsetKey.Language.rawValue: UIDevice.deviceLanguage(),
                                            NetRequsetKey.AuthToken.rawValue: authToken]
        
        let request = Alamofire.request(method, urlString, encoding: method == .POST ? .JSON : .URL, parameters: parameters, headers: headers).responseJSON { response -> Void in
            
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
    
    
    /**
     token 失效 重新登录
     */
    
    func RequesInvalidToken() {
        
        
        //清空登录信息
        
        CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = ""
        CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername = ""
        CavyDefine.loginUserBaseInfo.loginUserInfo.loginAuthToken = ""
        LifeBandBle.shareInterface.bleDisconnect()
        
        let alertView = UIAlertController(title: L10n.AlertTipsMsg.string, message: L10n.AlertReloginTitle.string, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: L10n.AlertSureActionTitle.string , style: .Default, handler:{
    
            _ in
            
          let accountVC =  UINavigationController(rootViewController: StoryboardScene.Main.instantiateSignInView())
            
             UIApplication.sharedApplication().keyWindow?.setRootViewController(accountVC, transition: CATransition())
        })
        
        alertView.addAction(defaultAction)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertView, animated: true, completion: nil)
        
        return
   
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






