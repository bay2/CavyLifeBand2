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

class HelpFeedbackWebApi: NetRequestAdapter {

    static var shareApi = HelpFeedbackWebApi()
    
    /**
     获取帮助与反馈列表
     
     - parameter callBack:
     
     - throws:
     */
    func getHelpFeedbackList(callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.GetHelpList.rawValue]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
    /**
     提交意见反馈
     
     - parameter userId:   用户ID
     - parameter feedback: 意见反馈内容
     - parameter callBack:
     
     - throws: 
     */
    func submitFeedback(userId: String, feedback: String, callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.SubmitFeedback.rawValue,
                                               UserNetRequsetKey.UserID.rawValue: userId,
                                               UserNetRequsetKey.FeedbackContent.rawValue: feedback]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
}
