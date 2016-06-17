//
//  FirmwareUpdateJSON.swift
//  CavyLifeBand2
//
//  Created by JL on 16/6/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import JSONJoy

struct FirmwareUpdateResponse: JSONJoy {
    //通用消息头
    var commonMsg: CommenMsg?
    
    //版本列表
    var versionList: [Version]?
    
    init(_ decoder: JSONDecoder) throws {
        commonMsg = try CommenMsg(decoder)
        
        versionList = [Version]()
        
        if let versionArray = decoder["versionList"].array {
            
            for version in versionArray {
                
                versionList?.append(try Version(version))
                
            }
        }
        
    }
    
}

struct Version: JSONJoy {
    
    var version: String
    
    var url: String
    
    init(_ decoder: JSONDecoder) throws {
        
        do { version = try decoder["version"].getString() } catch { version = "" }
        do { url = try decoder["url"].getString() } catch { url = "" }
        
    }
    
}