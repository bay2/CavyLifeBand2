//
//  AccountSettingViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/23.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit
import RealmSwift


typealias AccountSettingModelPotocols = protocol<GuideViewDataSource, GuideViewDelegate, SetUserInfoRequestsDelegate, UserInfoRealmOperateDelegate>

/**
 *  性别view model
 */
struct AccountGenderViewModel: AccountSettingModelPotocols {
    
    var realm: Realm = try! Realm()
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView = GenderView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight)) 
    var userInfoPara: [String: AnyObject] = [UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId]
    
    mutating func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let genderView = centerView as? GenderView else {
            return
        }
        
        let gender = genderView.MOrG ? 0 : 1
        
        userInfoPara[UserNetRequsetKey.Sex.rawValue] = gender
        
        setUserInfo {
            
            if $0 {
                
                self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                    
                        $0.sex = gender
                        return $0
                }
                
                viewController.popVC()
            }
            
        }
        
    }
    
}

/**
 *  生日 view model
 */
struct AccountBirthdayViewModel: AccountSettingModelPotocols {
    
    var realm: Realm = try! Realm()
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView = BirthdayView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight))
    var userInfoPara: [String: AnyObject] = [UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId]
    
    mutating func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let birthdayView = centerView as?  BirthdayView else {
            return
        }
        
        userInfoPara[UserNetRequsetKey.Birthday.rawValue] = birthdayView.birthdayString
        
        setUserInfo {
            
            if $0 {
                
                self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                    
                    $0.birthday = birthdayView.birthdayString
                    return $0
                    
                }
                
                viewController.popVC()
            }
            
        }
        
    }
    
}

/**
 *  身高 view model
 */
struct AccountHeightViewModel: AccountSettingModelPotocols {
    
    var realm: Realm = try! Realm()
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView = HightView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight))
    var userInfoPara: [String: AnyObject] = [UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId]
    
    mutating func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let heightView = centerView as? HightView else {
            return
        }
        
        userInfoPara[UserNetRequsetKey.Height.rawValue] = heightView.heightString
        
        setUserInfo {
            
            if $0 {
                
                self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                    
                    $0.height = heightView.heightString
                    return $0
                    
                }
                
                viewController.popVC()
            }
            
        }
    }
    
}

/**
 *  体重 view model
 */
struct AccountWeightViewModel: AccountSettingModelPotocols {
    
    var realm: Realm = try! Realm()
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView = WeightView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight))
    var userInfoPara: [String: AnyObject] = [UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId]
    
    mutating func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let weightView = centerView as? WeightView else {
            return
        }
        
        userInfoPara[UserNetRequsetKey.Weight.rawValue] = weightView.weightString
        
        setUserInfo {
            
            if $0 {
                
                self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                    
                    $0.weight = weightView.weightString
                    return $0
                    
                }
                
                viewController.popVC()
            }
            
        }

        
    }
    
}
