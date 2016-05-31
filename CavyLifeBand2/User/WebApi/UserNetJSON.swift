//
//  UserNetJSON.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import JSONJoy

struct UserSignUpMsg: JSONJoy {
    
    var commonMsg: CommenMsg?
    var userId: String?
    
    init(_ decoder: JSONDecoder) throws {

        do { userId = try decoder["userId"].getString() } catch { userId = "" }
        commonMsg = try CommenMsg(decoder)

    }
    
}

/**
 *  @author xuemincai
 *
 *  用户信息
 */
struct UserProfile {
    
    var sex: String
    var height: String
    var weight: String
    var birthday: String
    var avatarUrl: String
    var address: String
    var nickName: String
    var stepNum: Int
    var sleepTime: String
    var isNotification: Bool
    var isLocalShare: Bool
    var isOpenBirthday: Bool
    var isOpenHeight: Bool
    var isOpenWeight: Bool
    var achievementType: String
    
    init(_ decoder: JSONDecoder) throws  {
        
        do { sex = try decoder["sex"].getString() } catch { sex = "0" }
        do { height = try decoder["height"].getString() } catch { height = "" }
        do { weight = try decoder["weight"].getString() } catch { weight = "" }
        do { birthday = try decoder["birthday"].getString() } catch { birthday = "" }
        do { avatarUrl = try decoder["avatarUrl"].getString() } catch { avatarUrl = "" }
        do { address = try decoder["address"].getString() } catch { address = "" }
        do { nickName = try decoder["nickname"].getString() } catch { nickName = "" }
        do { stepNum = try decoder["stepNum"].getInt() } catch { stepNum = 0 }
        do { sleepTime = try decoder["sleepTime"].getString() } catch { sleepTime = "" }
        do { isNotification = decoder["isNotification"].bool }
        do { isLocalShare = decoder["isLocalShare"].bool }
        do { isOpenBirthday = decoder["isLocalShare"].bool }
        do { isOpenHeight = decoder["isOpenHeight"].bool }
        do { isOpenWeight = decoder["isOpenWeight"].bool }
        do { achievementType = try decoder["achievementType"].getString() } catch { achievementType = "0" }

    }
    
}

/**
 *  @author xuemincai
 *
 *  查询用户消息
 */
struct UserProfileMsg {

    var commonMsg: CommenMsg?
    var userProfile: UserProfile?
    
    init(_ decoder: JSONDecoder) throws  {

        commonMsg = try CommenMsg(decoder)
        userProfile = try UserProfile(decoder)
        
    }

}

struct UplodPictureMsg: JSONJoy {
    
    var commonMsg: CommenMsg
    var iconUrl: String
    
    init(_ decoder: JSONDecoder) throws {
        
        commonMsg = try CommenMsg(decoder)
        do { iconUrl = try decoder["iconUrl"].getString() } catch { iconUrl = "" }
        
    }
    
}
