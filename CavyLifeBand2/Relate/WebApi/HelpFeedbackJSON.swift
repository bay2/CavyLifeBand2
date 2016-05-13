//
//  HelpFeedbackJSON.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/10.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import JSONJoy

struct HelpFeedbackResponse: JSONJoy {
    //通用消息头
    var commonMsg: CommenMsg?
    
    //等待列表
    var helpList: [HelpFeedback]?
    
    init(_ decoder: JSONDecoder) throws {
        commonMsg = try CommenMsg(decoder)
        
        helpList = [HelpFeedback]()
        
        if let helpArray = decoder["helpList"].array {
            
            for help in helpArray {
                
                helpList?.append(try HelpFeedback(help))
                
            }
        }
        
        
    }
}

struct HelpFeedback: JSONJoy {

    var title: String
    
    var webUrl: String
    
    init(_ decoder: JSONDecoder) throws {
        
        do { title = try decoder["title"].getString() } catch { title = "" }
        do { webUrl = try decoder["webUrl"].getString() } catch { webUrl = "" }
        
    }
    
}

