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

extension NetRequestAdapter {
    
    /**
     post 网络请求
     
     - parameter urlString:         url
     - parameter para:              参数
     - parameter completionHandler: 回调
     */
    func netPostRequestAdapter(urlString: String, para: [String: AnyObject]? = nil, completionHandler: CompletionHandlernType? = nil) {
        
        var parameters: [String: AnyObject] = ["phoneType": "ios", "language": UIDevice.deviceLanguage()]
        
        
        //发送API请求
        if para != nil {
            parameters = parameters.union(para!)
        }
        
        Log.netRequestFormater(urlString, para: para)
        
        let request = Alamofire.request(.POST, urlString, parameters: parameters).responseJSON { (response) -> Void in
            
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
    
    var msg: String?
    var code: String?
    
    init(_ decoder: JSONDecoder) throws {
        
        msg = try decoder["msg"].getString()
        code = try decoder["code"].getString()
        
    }
    
}





