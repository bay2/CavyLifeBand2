//
//  NetRequestAdapter.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Alamofire
import Log
import EZSwiftExtensions
import JSONJoy


extension Result {
    
    func success(@noescape closure: (Value -> Void)) -> Result {
        
        switch self {
        case .Success(let value):
            closure(value)
        default:
            break
        }
        
        return self
    }
    
    func failure(@noescape closure: (Error -> Void)) -> Result {
        
        switch self {
        case .Failure(let error):
            closure(error)
        default:
            break
        }
        
        return self
    }
    
}

typealias CompletionHandlernType = (Result<AnyObject, UserRequestErrorType>) -> Void

protocol NetRequestAdapter {
    
    func netPostRequestAdapter(urlString: String, para: [String: AnyObject]?, completionHandler: CompletionHandlernType?) -> Request
    
    func netGetRequestAdapter(urlString: String, para: [String: AnyObject]?, completionHandler: CompletionHandlernType?)
}

extension NetRequestAdapter {
    
    
    /**
     post 网络请求
     
     - parameter urlString:         url
     - parameter para:              参数
     - parameter completionHandler: 回调
     */
    func netPostRequestAdapter(urlString: String, para: [String: AnyObject]? = nil, completionHandler: CompletionHandlernType? = nil) -> Request {
        
        var parameters: [String: AnyObject] = ["phoneType": "ios", "language": UIDevice.deviceLanguage()]
        
        //发送API请求
        if para != nil {
            parameters = parameters.union(para!)
        }
        
        Log.netRequestFormater(urlString, para: para)
        
        return requestByAlamofire(.POST, urlString: urlString, parameters: parameters) { result in
            completionHandler?(result)
            
            
        }
        
    }
    
    
    /**
     get 网络请求
     
     - parameter urlString:         url
     - parameter para:              参数
     - parameter completionHandler: 回调
     */
    func netGetRequestAdapter(urlString: String, para: [String: AnyObject]? = nil, completionHandler: CompletionHandlernType? = nil) {
        
        var parameters: [String: AnyObject] = ["phoneType": "ios", "language": UIDevice.deviceLanguage()]

        //发送API请求
        if para != nil {
            parameters = parameters.union(para!)
        }
        
        Log.netRequestFormater(urlString, para: parameters)
        
        requestByAlamofire(.GET, urlString: urlString, parameters: parameters) { result in
            completionHandler?(result)
        }
        
    }
    
    /**
     网络请求
     
     - parameter method:            请求方法
     - parameter urlString:         url
     - parameter parameters:        参数
     - parameter completionHandler: 回调
     */
    func requestByAlamofire(method: Alamofire.Method = .POST, urlString: String, parameters: [String: AnyObject]? = nil, completionHandler: CompletionHandlernType? = nil) -> Request {
        
        let request = Alamofire.request(method, urlString, encoding: method == .POST ? .JSON : .URL, parameters: parameters).responseJSON { response -> Void in
            
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

/**
 *  @author xuemincai
 *
 *  通用回应消息
 */
struct CommenMsg: JSONJoy {
    
    var msg: String
    var code: String
    
    init(_ decoder: JSONDecoder) throws {
        
        msg = try decoder["msg"].getString()
        code = try decoder["code"].getString()
        
    }
    
}





