//
//  HelpFeedbackJSON.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/10.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import JSONJoy

struct HelpFeedbackResponse: JSONJoy, CommenResponseProtocol {
    //通用消息头
    var commonMsg: CommenResponse
    
    //等待列表
    var helpList: [HelpFeedback]
    
    init(_ decoder: JSONDecoder) throws {
        commonMsg = try CommenResponse(decoder)
        
        helpList = [HelpFeedback]()
        
        if let helpArray = decoder["data"].array {
            
            for help in helpArray {
                
                helpList.append(try HelpFeedback(help))
                
            }
        }
        
        
    }
}

struct HelpFeedback: JSONJoy {

    var title: String
    
    var number: Int
    
    var webUrl: String
    
    init(_ decoder: JSONDecoder) throws {
        
        do { title = try decoder["title"].getString() } catch { title = "" }
        do { webUrl = try decoder["url"].getString() } catch { webUrl = "" }
        do { number = try decoder["number"].getInt() } catch { number = 0 }
        
    }
    
}

