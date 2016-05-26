//
//  EmergencyJSON.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/20.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import JSONJoy

/**
 *  紧急联系人响应结构
 */
struct EmergencyListResponse: JSONJoy {
    
    //通用消息头
    var commonMsg: CommenMsg
    
    //紧急联系人信息列表
    var phoneList: [EmergencyRecord] = []
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenMsg(decoder)
        
        guard let phoneArray =  decoder["phoneList"].array else {
            return
        }
        
        for phone in phoneArray {
            
            phoneList.append(try EmergencyRecord(phone))
            
        }
        
    }
    
}


struct EmergencyRecord: JSONJoy {
    
    var name: String
    var phoneNum: String
    
    init(_ decoder: JSONDecoder) throws {
        do { name = try decoder["name"].getString() } catch { name = "" }
        do { phoneNum = try decoder["phoneNum"].getString() } catch { phoneNum = "" }
    }

}