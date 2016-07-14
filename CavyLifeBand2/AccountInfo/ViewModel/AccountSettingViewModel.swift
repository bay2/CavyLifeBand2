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

extension GuideViewDataSource {
    
    func getLoadingView() -> UIActivityIndicatorView {
        let loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
        
        loadingView.hidesWhenStopped = true
        
        loadingView.activityIndicatorViewStyle = .Gray
        
        centerView.addSubview(loadingView)
        
        loadingView.snp_makeConstraints { make in
            make.center.equalTo(centerView)
            make.width.equalTo(50.0)
            make.height.equalTo(50.0)
        }
        
        return loadingView
    }

}

extension SetUserInfoRequestsDelegate {
    
    func getLoadingView() -> UIActivityIndicatorView? {
        let loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
        
        loadingView.hidesWhenStopped = true
        
        loadingView.activityIndicatorViewStyle = .Gray
        
        guard viewController != nil else {
            return nil
        }
        
        viewController!.view.addSubview(loadingView)
        
        loadingView.snp_makeConstraints { make in
            make.center.equalTo(viewController!.view)
            make.width.equalTo(50.0)
            make.height.equalTo(50.0)
        }
        
        return loadingView
    }
}


/**
 *  性别view model
 */
struct AccountGenderViewModel: AccountSettingModelPotocols {
    
    var realm: Realm = try! Realm()
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView = GenderView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight)) 
    var userInfoPara: [String: AnyObject] = [String: AnyObject]()
    
    var loadingView: UIActivityIndicatorView?
    
    init(gender: Int) {
        
        guard let genderView = centerView as? GenderView else {
            return
        }
        
        genderView.MOrG = gender == 0 ? false : true 
        
        genderView.updateGender()
        
    }
    
    mutating func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let genderView = centerView as? GenderView else {
            return
        }
        
        let gender = genderView.MOrG ? 0 : 1
        
        userInfoPara[NetRequsetKey.Sex.rawValue] = gender
        
        if loadingView == nil {
            loadingView = getLoadingView()
        }
        
        self.loadingView?.startAnimating()
        
        setUserInfo {
            
            self.loadingView?.stopAnimating()
            
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
    var userInfoPara: [String: AnyObject] = [String: AnyObject]()
    
    var loadingView: UIActivityIndicatorView?
    
    mutating func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let birthdayView = centerView as?  BirthdayView else {
            return
        }
        
        userInfoPara[NetRequsetKey.Birthday.rawValue] = birthdayView.birthdayString
        
        if loadingView == nil {
            loadingView = getLoadingView()
        }
        
        self.loadingView?.startAnimating()
        
        setUserInfo {
            
            self.loadingView?.stopAnimating()
            
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
    var userInfoPara: [String: AnyObject] = [String: AnyObject]()
    
    var loadingView: UIActivityIndicatorView?
    
    init(height: String) {
        
        guard height.isEmpty == false else {
            return
        }
        
        guard let heightView = centerView as? HightView else {
            return
        }
        
        heightView.setHeightValue(height)
    
    }
    
    mutating func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let heightView = centerView as? HightView else {
            return
        }
        
        userInfoPara[NetRequsetKey.Height.rawValue] = heightView.heightValue
        
        if loadingView == nil {
            loadingView = getLoadingView()
        }
        
        self.loadingView?.startAnimating()
        
        setUserInfo {
            
            self.loadingView?.stopAnimating()
            
            if $0 {
                
                self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                    
                    $0.height = heightView.heightValue.toDouble
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
    var userInfoPara: [String: AnyObject] = [String: AnyObject]()
    
    var loadingView: UIActivityIndicatorView?
    
    init(weight: String = "") {
        
        guard weight.isEmpty == false else {
            return
        }
        
        guard let weightView = centerView as? WeightView else {
            return
        }
        
        weightView.setWeightValue(weight.toFloat() ?? 0.0)
        
    }
    
    mutating func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let weightView = centerView as? WeightView else {
            return
        }
        
        userInfoPara[NetRequsetKey.Weight.rawValue] = weightView.weightString
        
        if loadingView == nil {
            loadingView = getLoadingView()
        }
        
        self.loadingView?.startAnimating()
        
        setUserInfo {
            
            self.loadingView?.stopAnimating()
            
            if $0 {
                
                self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                    
                    $0.weight = weightView.weightString.toDouble() ?? 0.0
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
struct UserChangeNicknameVM: ContactsReqFriendPortocols, SetUserInfoRequestsDelegate, UserInfoRealmOperateDelegate {
    
    var realm: Realm = try! Realm()
    
    var navTitle: String = L10n.ContactsChangeNickNameNavTitle.string
    
    var textFieldTitle: String {
        didSet {
            userInfoPara[NetRequsetKey.Nickname.rawValue] = textFieldTitle
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
    
    var loadingView: UIActivityIndicatorView?
    
    var userInfoPara: [String: AnyObject] = [String: AnyObject]()
    
    //点击发送请求成功回调
    var onClickButtonCellBack: (String -> Void)?
    
    init(viewController: UIViewController, textFeildText: String? = nil, onClickButtonCellBack: (String -> Void)? = nil) {
        
        self.viewController = viewController
        self.onClickButtonCellBack = onClickButtonCellBack
        self.textFieldTitle = textFeildText ?? ""
    }
    
    mutating func onClickButton() {
        
        if loadingView == nil {
            loadingView = getLoadingView()
        }
        
        self.loadingView?.startAnimating()
        
        setUserInfo {
            
            self.loadingView?.stopAnimating()
            
            if $0 {
                
                self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) { 
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
struct UserChangeAddressVM: ContactsReqFriendPortocols, SetUserInfoRequestsDelegate, UserInfoRealmOperateDelegate {
    
    var realm: Realm = try! Realm()
    
    var navTitle: String = L10n.ContactsChangeAddressNavTitle.string
    
    var textFieldTitle: String {
        didSet {
            userInfoPara[NetRequsetKey.Address.rawValue] = textFieldTitle
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
    
    var loadingView: UIActivityIndicatorView?
    
    var userInfoPara: [String: AnyObject] = [String: AnyObject]()
    
    //点击发送请求成功回调
    var onClickButtonCellBack: (String -> Void)?
    
    init(viewController: UIViewController, textFieldText: String? = nil, onClickButtonCellBack: (String -> Void)? = nil) {
        
        self.viewController = viewController
        self.onClickButtonCellBack = onClickButtonCellBack
        self.textFieldTitle = textFieldText ?? ""
        
    }
    
    mutating func onClickButton() {
        
        if loadingView == nil {
            loadingView = getLoadingView()
        }
        
        self.loadingView?.startAnimating()
        
        setUserInfo {
            
            self.loadingView?.stopAnimating()
            
            if $0 {
                
                self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                    $0.address = self.textFieldTitle
                    return $0
                }
                
                self.viewController?.popVC()
            }
            
        }
        
    }
    
    
}


