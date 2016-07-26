//
//  HelpFeedbackWebApi.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/10.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Alamofire
import Log
import JSONJoy

class HelpFeedbackWebApi: NetRequestAdapter, NetRequest {

    static var shareApi = HelpFeedbackWebApi()
    
    /**
     获取帮助与反馈列表
     
     - parameter callBack:
     
     - throws:
     */
    func getHelpFeedbackList(successBack: (HelpFeedbackResponse -> Void)? = nil, failBack: (CommenResponse -> Void)? = nil) {
        
        netGetRequest(WebApiMethod.Helps.description, modelObject: HelpFeedbackResponse.self, successHandler: {
            successBack?($0)
        }) {
            failBack?($0)
        }
        
    }
    
    /**
     提交意见反馈
     
     - parameter feedback:    意见反馈内容
     - parameter successBack:
     - parameter failBack:
     */
    func submitFeedback(feedback: String, successBack: (CommenResponse -> Void)? = nil, failBack: (CommenResponse -> Void)? = nil) {
        
        let parameters: [String: AnyObject] = [NetRequestKey.Question.rawValue: "Title",
                                               NetRequestKey.Detail.rawValue: feedback]
      
        netPostRequest(WebApiMethod.Issues.description, para: parameters, modelObject: CommenMsgResponse.self, successHandler: {
            
            successBack?($0.commonMsg)
            
        }) {
            
            failBack?($0)
            
        }
        
    }
    
}
