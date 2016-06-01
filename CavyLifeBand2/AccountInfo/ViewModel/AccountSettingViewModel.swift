//
//  AccountSettingViewModel.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/23.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit
import JSONJoy
import RealmSwift
import EZSwiftExtensions

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

/**
 *  登录用户修改昵称
 */
class UserChangeNicknameVM: ContactsReqFriendPortocols, SetUserInfoRequestsDelegate, UserInfoRealmOperateDelegate {
    
    var realm: Realm = try! Realm()
    
    var navTitle: String = L10n.AccountInfoTitle.string
    
    var textFieldTitle: String {
        didSet {
            userInfoPara[UserNetRequsetKey.NickName.rawValue] = textFieldTitle
        }
    }
    
    var placeholderText: String {
        return L10n.AccountInfoChangeNicknamePlaceholder.string
    }
    
    var bottonTitle: String {
        return L10n.ContactsRequestSureButton.string
    }
    
    var friendId: String = ""
    
    weak var viewController: UIViewController?
    
    var userInfoPara: [String: AnyObject] = [UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId]
    
    //点击发送请求成功回调
    var onClickButtonCellBack: (String -> Void)?
    
    init(viewController: UIViewController, onClickButtonCellBack: (String -> Void)? = nil) {
        
        self.viewController = viewController
        self.onClickButtonCellBack = onClickButtonCellBack
        self.textFieldTitle = ""
    }
    
    func onClickButton() {
        
        setUserInfo { [unowned self] in
            
            if $0 {
                
                self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) { [unowned self] in
                    $0.nickname = self.textFieldTitle
                    return $0
                }
                
                self.viewController?.popVC()
            }
            
        }
        
    }
    
    
}

/**
 *  登录用户修改地址
 */
class UserChangeAddressVM: ContactsReqFriendPortocols, SetUserInfoRequestsDelegate, UserInfoRealmOperateDelegate {
    
    var realm: Realm = try! Realm()
    
    var navTitle: String = L10n.AccountInfoTitle.string
    
    var textFieldTitle: String {
        didSet {
            userInfoPara[UserNetRequsetKey.Address.rawValue] = textFieldTitle
        }
    }
    
    var placeholderText: String {
        return L10n.AccountInfoChangeAddressPlaceholder.string
    }
    
    var bottonTitle: String {
        return L10n.ContactsRequestSureButton.string
    }
    
    var friendId: String = ""
    
    weak var viewController: UIViewController?
    
    var userInfoPara: [String: AnyObject] = [UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId]
    
    //点击发送请求成功回调
    var onClickButtonCellBack: (String -> Void)?
    
    init(viewController: UIViewController, onClickButtonCellBack: (String -> Void)? = nil) {
        
        self.viewController = viewController
        self.onClickButtonCellBack = onClickButtonCellBack
        self.textFieldTitle = ""
    }
    
    func onClickButton() {
        
        setUserInfo { [unowned self] in
            
            if $0 {
                
                self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) { [unowned self] in
                    $0.address = self.textFieldTitle
                    return $0
                }
                
                self.viewController?.popVC()
            }
            
        }
        
    }
    
    
}


