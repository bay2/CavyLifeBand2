//
//  LoginJSON.swift
//  CavyLifeBand2
//
//  Created by JL on 16/6/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import JSONJoy


struct LoginResponse: CommenResponseProtocol, JSONJoy {
    //通用消息头
    var commonMsg: CommenResponse
    
    var userId: String
    
    var userName: String
    
    var authToken: String
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
        do { userId    = try decoder["user_id"].getString() } catch { userId = "" }
        do { userName  = try decoder["username"].getString() } catch { userName = "" }
        do { authToken = try decoder["auth_token"].getString() } catch { authToken = "" }
        
    }
    
}

struct SignUpResponse: CommenResponseProtocol, JSONJoy {
    //通用消息头
    var commonMsg: CommenResponse
    
    var userId: String
    
    var userName: String
    
    var authToken: String
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenResponse(decoder)
        
        do { userId    = try decoder["user_id"].getString() } catch { userId = "" }
        do { userName  = try decoder["username"].getString() } catch { userName = "" }
        do { authToken = try decoder["auth_token"].getString() } catch { authToken = "" }
        
    }
    
}


