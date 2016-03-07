//
//  UserNetJSON.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import JSONJoy

struct UserSignUpMsg {
    
    var commonMsg: CommenMsg?
    var userId: String?
    
    init(_ decoder: JSONDecoder) throws {

        userId = try decoder["userId"].getString()
        commonMsg = try CommenMsg(decoder)

    }
    
}

struct UserProfileMsg {

    var commonMsg: CommenMsg?
    var sex: String?
    var height: String?
    var weight: String?
    var birthday: String?
    var avatarUrl: String?
    var address: String?
    var nickName: String?

    init(_ decoder: JSONDecoder) throws  {

        commonMsg = try CommenMsg(decoder)
        
        do { sex = try decoder["sex"].getString() } catch { sex = "" }
        do { height = try decoder["height"].getString() } catch { height = "" }
        do { weight = try decoder["weight"].getString() } catch { weight = "" }
        do { birthday = try decoder["birthday"].getString() } catch { birthday = "" }
        do { avatarUrl = try decoder["avatarUrl"].getString() } catch { avatarUrl = "" }
        do { address = try decoder["address"].getString() } catch { address = "" }
        do { nickName = try decoder["nickname"].getString() } catch { nickName = "" }
        
    }

}