//
//  FirmwareUpdateJSON.swift
//  CavyLifeBand2
//
//  Created by JL on 16/6/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import JSONJoy

struct FirmwareUpdateResponse: JSONJoy, CommenResponseProtocol {
    
    //通用消息头
    var commonMsg: CommenResponse
    
    //版本信息
    var data: FWVersionInfo
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
        data = try FWVersionInfo(decoder["data"])
        
    }
    
}

struct FWVersionInfo: JSONJoy {
    
    // 版本名稱 如 "0.0.1"
    var version: String
    
    // 版本號
    var reversion: Int
    
    // 版本描述
    var description: String
    
    // 版本下載链接
    var url: String
    
    // 版本日期
    var publishDate: String
    
    init(_ decoder: JSONDecoder) throws {
        
        do { version = try decoder["version"].getString() } catch { version = "" }
        do { reversion = try decoder["reversion"].getInt() } catch { reversion = 0 }
        do { description = try decoder["description"].getString() } catch { description = "" }
        do { url = try decoder["url"].getString() } catch { url = "" }
        do { publishDate = try decoder["publish_date"].getString() } catch { publishDate = "" }
        
    }
    
}