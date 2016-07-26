//
//  UploadAvatarJSON.swift
//  CavyLifeBand2
//
//  Created by JL on 16/7/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import JSONJoy

struct UploadAvatarJSON: JSONJoy, CommenResponseProtocol {
    //通用消息头
    var commonMsg: CommenResponse
    
    //等待列表
    var url: String
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
        do { url = try decoder["data"]["url"].getString() } catch { url = "" }

    }
    
}
