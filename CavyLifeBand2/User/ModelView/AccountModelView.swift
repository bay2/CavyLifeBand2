//
//  UserModelView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import Alamofire
import Log
import EZSwiftExtensions


/**
 *  @author xuemincai
 *
 *  邮箱找回密码
 */
struct EmailForgotPwdViewModel: AccountManagerViewDataSource {
    
    var isSignUp: Bool { return false }
    var isEmail: Bool { return true }
    var navTitle: String { return L10n.ForgotTitle.string }
    var itemRightTitle: String { return L10n.SignUpEmailRightItemBtn.string }
    var userNameTextFieldTitle: String { return L10n.SignUpEmailTextField.string }
    var passwdTextFieldTitle: String { return L10n.ForgotPasswdTextField.string }
    var viewMainBtnTitle: String { return L10n.ForgotFinish.string }
    
}

/**
 *  @author xuemincai
 *
 *  手机注册
 */
struct PhoneSignUpViewModel: AccountManagerViewDataSource {
    
    var isSignUp: Bool { return true }
    var isEmail: Bool { return false }
    var navTitle: String { return L10n.SignUpTitle.string }
    var itemRightTitle: String { return L10n.SignUpPhoneRightItemBtn.string }
    var userNameTextFieldTitle: String { return L10n.SignUpPhoneNumTextField.string }
    var passwdTextFieldTitle: String { return L10n.SignInPasswdTextField.string }
    var viewMainBtnTitle: String { return L10n.SignUpSignUpBtn.string }
    
}

/**
 *  @author xuemincai
 *
 *  邮箱注册
 */
struct EmailSignUpViewModel: AccountManagerViewDataSource {
    
    var isSignUp: Bool { return true }
    var isEmail: Bool { return true }
    var navTitle: String { return L10n.SignUpTitle.string }
    var itemRightTitle: String { return L10n.SignUpEmailRightItemBtn.string }
    var userNameTextFieldTitle: String { return L10n.SignUpEmailTextField.string }
    var passwdTextFieldTitle: String { return L10n.SignInPasswdTextField.string }
    var viewMainBtnTitle: String { return L10n.SignUpSignUpBtn.string }
    
}

/**
 *  @author xuemincai
 *
 *  手机找回密码
 */
struct PhoneForgotPwdViewModel: AccountManagerViewDataSource {
    
    var isSignUp: Bool { return false }
    var isEmail: Bool { return false }
    var navTitle: String { return L10n.ForgotTitle.string }
    var itemRightTitle: String { return L10n.SignUpPhoneRightItemBtn.string }
    var userNameTextFieldTitle: String { return L10n.SignUpPhoneNumTextField.string }
    var passwdTextFieldTitle: String { return L10n.ForgotPasswdTextField.string }
    var viewMainBtnTitle: String { return L10n.ForgotFinish.string }
    
}

