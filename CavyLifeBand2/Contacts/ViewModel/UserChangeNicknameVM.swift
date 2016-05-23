//
//  UserChangeNicknameVM.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/23.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import RealmSwift
import EZSwiftExtensions

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
        return L10n.AccountInofChangeNicknamePlaceholder.string
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
    
    func updateUser(userModel: UserInfoModel) -> UserInfoModel {
        userModel.nickname = textFieldTitle
        return userModel
    }
    
    func onClickButton() {
                            
        setUserInfo { [unowned self] in
            
            if $0 {
                
                self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) { [unowned self] in
                    self.updateUser($0)
                }
                
                self.viewController?.popVC()
            }
            
        }
        
    }

    
}
