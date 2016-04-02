//
//  UserInfoModelView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit
import Log
import JSONJoy
import EZSwiftExtensions

struct UserInfoModelView {

    var userInfo: UserInfoModel?
    static var shareInterface = UserInfoModelView()

    /**
     初始化
     
     - parameter viewController: 当前的viewController
     - parameter userId:         用户id
     - parameter callback:       回调
     
     - returns:
     */
    init() {

        self.userInfo = UserInfoModel()

    }

    func queryInfo(viewController: UIViewController? = nil, userId: String? = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, callback: ((Bool) -> Void)? = nil) {
        
        if userId != nil {
            self.userInfo!.userId = userId!
        }

        let netPara = [UserNetRequsetKey.UserID.rawValue: self.userInfo!.userId]

        userNetReq.queryProfile(netPara) { (result) in

            if result.isFailure {

                callback?(false)
                CavyLifeBandAlertView.sharedIntance.showViewTitle(viewController, userErrorCode: result.error!)
                return

            }

            do {

                let profileMsg = try UserProfileMsg(JSONDecoder(result.value!))

                if profileMsg.commonMsg!.code != WebApiCode.Success.rawValue {

                    callback?(false)
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(viewController, webApiErrorCode: profileMsg.commonMsg!.code!)
                    return

                }

                self.userInfo!.sex = profileMsg.sex!.toInt()!
                self.userInfo!.height = profileMsg.height!
                self.userInfo!.weight = profileMsg.weight!
                self.userInfo!.birthday = profileMsg.birthday!
                self.userInfo!.avatarUrl = profileMsg.avatarUrl!
                self.userInfo!.address = profileMsg.address!
                self.userInfo!.nickname = profileMsg.nickName!
                self.userInfo!.sleepTime = profileMsg.sleepTime!
                self.userInfo!.stepNum = profileMsg.stepNum!

                callback?(true)

            } catch {

                callback?(false)
                CavyLifeBandAlertView.sharedIntance.showViewTitle(viewController, webApiErrorCode: L10n.UserModuleErrorCodeNetError.string)

            }

        }

    }

    /**
     更新信息
     
     - parameter successCallback: 更新成功回调
     */
    func updateInfo(viewController: UIViewController? = nil, userId: String? = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, successCallback: (Void -> Void)? = nil) {
        
        if userId != nil {
            self.userInfo!.userId = userId!
        }

        let netPara: [String: AnyObject] = [UserNetRequsetKey.UserID.rawValue: self.userInfo!.userId,
        UserNetRequsetKey.Sex.rawValue: "\(self.userInfo!.sex)",
        UserNetRequsetKey.Height.rawValue: self.userInfo!.height,
        UserNetRequsetKey.Weight.rawValue: self.userInfo!.weight,
        UserNetRequsetKey.Birthday.rawValue: self.userInfo!.birthday,
        UserNetRequsetKey.Address.rawValue: self.userInfo!.address,
        UserNetRequsetKey.NickName.rawValue: self.userInfo!.nickname,
        UserNetRequsetKey.StepNum.rawValue: self.userInfo!.stepNum,
        UserNetRequsetKey.SleepTime.rawValue: self.userInfo!.sleepTime]

        userNetReq.setProfile(netPara) { (result) in
            
            if result.isFailure {

                CavyLifeBandAlertView.sharedIntance.showViewTitle(viewController, userErrorCode: result.error!)
                return
            }
            
            do {
                
                let resultMsg = try CommenMsg(JSONDecoder(result.value!))
                
                if resultMsg.code != WebApiCode.Success.rawValue {

                    CavyLifeBandAlertView.sharedIntance.showViewTitle(viewController, webApiErrorCode: resultMsg.code!)
                    return

                }

                if UserInfoOperate().isUserExist(self.userInfo!.userId) {

                    UserInfoOperate().updateUserInfo(self.userInfo!)

                } else {

                    UserInfoOperate().addUserInfo(self.userInfo!)

                }

                successCallback?()

            } catch {

                CavyLifeBandAlertView.sharedIntance.showViewTitle(viewController, userErrorCode: UserRequestErrorType.NetErr)

            }

        }

    }


}
