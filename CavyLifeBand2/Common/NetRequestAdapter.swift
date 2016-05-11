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

typealias CompletionHandlernType = (Result<AnyObject, UserRequestErrorType>) -> Void

protocol NetRequestAdapter {
    
    func netPostRequestAdapter(urlString: String, para: [String: AnyObject]?, completionHandler: CompletionHandlernType?)
}

extension ParameterEncoding {
    
     public func queryComponentsEx(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
}

extension NetRequestAdapter {
    
    
    /**
     post 网络请求
     
     - parameter urlString:         url
     - parameter para:              参数
     - parameter completionHandler: 回调
     */
    func netPostRequestAdapter(urlString: String, para: [String: AnyObject]? = nil, completionHandler: CompletionHandlernType? = nil) {
        
        var parameters: [String: AnyObject] = ["phoneType": "ios", "language": UIDevice.deviceLanguage()]
        
        func query(parameters: [String: AnyObject]) -> String {
            var components: [(String, String)] = []
            
            for key in parameters.keys.sort(<) {
                let value = parameters[key]!
                components += ParameterEncoding.URL.queryComponentsEx(key, value)
            }
            
            return (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
        }
        
        
        // 自定义消息结构
        let closure: ((URLRequestConvertible, [String: AnyObject]?) -> (NSMutableURLRequest, NSError?)) = {URLRequest, parameters in
            
            let mutableURLRequest = URLRequest.URLRequest
            guard let parameters = parameters else { return (mutableURLRequest, nil) }
            

            if mutableURLRequest.valueForHTTPHeaderField("Content-Type") == nil {
                mutableURLRequest.setValue(
                    "application/x-www-form-urlencoded; charset=utf-8",
                    forHTTPHeaderField: "Content-Type"
                )
            }
            
            mutableURLRequest.HTTPBody = query(parameters).dataUsingEncoding(
                NSUTF8StringEncoding,
                allowLossyConversion: false
            )
            
            return (mutableURLRequest, nil)
        
        }
        
        //发送API请求
        if para != nil {
            parameters = parameters.union(para!)
        }
        
        Log.netRequestFormater(urlString, para: para)
        
        let request = Alamofire.request(.POST, urlString, encoding: .JSON, parameters: parameters).responseJSON { (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
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
        }
        
        if Log.enabled {
            debugPrint(request)
        }
        
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





