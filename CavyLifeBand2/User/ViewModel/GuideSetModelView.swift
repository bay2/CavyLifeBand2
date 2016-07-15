//
//  GuideSetModelView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/7.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit
import EZSwiftExtensions
import Gifu
import RealmSwift

typealias GuideViewModelPotocols = protocol<GuideViewDataSource, GuideViewDelegate>

/**
 *  @author xuemincai
 *
 *  设置通知提醒
 */
struct GuideSetNoticeViewModel: GuideViewModelPotocols {
    
    var title: String { return L10n.GuideSetting.string }
    var rightItemBtnTitle: String { return L10n.GuidePassButton.string }
    var centerView: UIView { return PictureView(title: L10n.GuideOpenNotice.string, titleInfo: L10n.GuideOpenNoticeInfo.string, midImage: AnimatableImageView(image: UIImage(asset: .GuideNotice))) }
    
    func pushNextView(viewController: UIViewController) {
        
        let nextVC = StoryboardScene.Guide.instantiateGuideView()
        let setLocationVM = GuideSetLocationShare()
        
        nextVC.configView(setLocationVM, delegate: setLocationVM)
        
        viewController.pushVC(nextVC)
        
    }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        GuideUserInfo.userInfo.isNoitfication = true
        
        pushNextView(viewController)
        
    }
    
    func onClickRight(viewController: UIViewController) {
        
        GuideUserInfo.userInfo.isNoitfication = false
        
        pushNextView(viewController)
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  设置位置共享
 */
struct GuideSetLocationShare: GuideViewModelPotocols, UserInfoRealmOperateDelegate {
    
    var title: String { return L10n.GuideSetting.string }
//    var rightItemBtnTitle: String { return L10n.GuidePassButton.string }
    var centerView: UIView { return PictureView(title: L10n.GuideOpenLocationShare.string, titleInfo: L10n.GuideOpenLocationShareInfo.string, midImage: AnimatableImageView(image: UIImage(asset: .GuideLocation))) }
    
    var realm: Realm  = try! Realm()
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        GuideUserInfo.userInfo.isLocalShare = true
        
        pushNextView(viewController)
        
    }
    
    func onClickRight(viewController: UIViewController) {
        
        GuideUserInfo.userInfo.isLocalShare = false
        
        pushNextView(viewController)
    }
    
    func pushNextView(viewController: UIViewController) {
        
        if CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId.isEmpty {
            
            let accountVC = StoryboardScene.Main.instantiateAccountManagerView()
            
            accountVC.configView(PhoneSignUpViewModel())
            
            viewController.pushVC(accountVC)
            
            return
        }
        
        GuideUserInfo.userInfo.userId = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
        let userInfoModel = UserInfoModel(guideUserinfo: GuideUserInfo.userInfo)
        userInfoModel.isSync = false
        
        if let _: UserInfoModel = queryUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
            
            updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) { _ in
                return userInfoModel
            }
            
        } else {
            addUserInfo(userInfoModel)
        }
                
        UIApplication.sharedApplication().keyWindow?.setRootViewController(StoryboardScene.Home.instantiateRootView(), transition: CATransition())
        UIApplication.sharedApplication().keyWindow?.setRootViewController(StoryboardScene.Home.instantiateRootView(), transition: CATransition())
        
    }
    
}