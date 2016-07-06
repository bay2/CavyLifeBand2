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
struct UserProfile: JSONJoy {
    
    var coins: Double
    var phone: String
    var sex: Int
    var height: Double
    var weight: Double
    var birthday: String
    var avatarUrl: String
    var address: String
    var nickName: String
    var stepGoal: Int
    var sleepGoal: Int
    var isNotification: Bool
    var isLocalShare: Bool
    var isOpenBirthday: Bool
    var isOpenHeight: Bool
    var isOpenWeight: Bool
    var awards: [UserAward]
    var signUpDate: NSDate
    
    init(_ decoder: JSONDecoder) throws  {
        
        awards = []
        
        do { coins = try decoder["coins"].getDouble() } catch { coins = 0.0 }
        do { phone = try decoder["phone"].getString() } catch { phone = "" }
        do { sex = try decoder["sex"].getInt() } catch { sex = 0 }
        do { height = try decoder["height"].getDouble() } catch { height = 0.0 }
        do { weight = try decoder["weight"].getDouble() } catch { weight = 0.0 }
        do { avatarUrl = try decoder["avatarUrl"].getString() } catch { avatarUrl = "" }
        do { address = try decoder["address"].getString() } catch { address = "" }
        do { nickName = try decoder["nickname"].getString() } catch { nickName = "" }
        do { stepGoal = try decoder["steps_goal"].getInt() } catch { stepGoal = 0 }
        do { sleepGoal = try decoder["sleep_time_goal"].getInt() } catch { sleepGoal = 0 }
        do { isNotification = decoder["enable_notification"].bool }
        do { isLocalShare = decoder["share_location"].bool }
        do { isOpenBirthday = decoder["share_birthday"].bool }
        do { isOpenHeight = decoder["share_height"].bool }
        do { isOpenWeight = decoder["share_weight"].bool }
        
        do {
            let timeString = try decoder["signupAt"].getString()
            signUpDate = NSDate(fromString: timeString, format: "yyyy-MM-dd HH:mm:ss") ?? NSDate()
            
        } catch {
            signUpDate = NSDate()
        }
        
        do {
            let timeString = try decoder["birthday"].getString()
            
            if let dateB = NSDate(fromString: timeString, format: "yyyy-MM-dd HH:mm:ss") {
                
                let format = NSDateFormatter()
                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                birthday = format.stringFromDate(dateB)
                
            } else {
                
                birthday = ""
                
            }
            
        } catch {
            birthday = ""
        }
        
        guard let awardArr = decoder["awards"].array else {
            return
        }
        
        for award in awardArr {
            
            awards.append(try UserAward(award))
            
        }

    }
    
}

struct UserAward: JSONJoy {
    var date: NSDate
    
    var number: String
    
    init(_ decoder: JSONDecoder) throws {
        
        do {
            let timeString = try decoder["date"].getString()
            date = NSDate(fromString: timeString, format: "yyyy-MM-dd HH:mm:ss") ?? NSDate()
            
        } catch {
            date = NSDate()
        }
        
        do { number = try decoder["number"].getString() } catch { number = "" }
        
    }
}

/**
 *  @author xuemincai
 *
 *  查询用户消息
 */
struct UserProfileMsg: JSONJoy, CommenResponseProtocol {

    var commonMsg: CommenResponse
    var userProfile: UserProfile?
    
    init(_ decoder: JSONDecoder) throws  {

        commonMsg = try CommenResponse(decoder)
        userProfile = try UserProfile(decoder["profile"])
        
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
