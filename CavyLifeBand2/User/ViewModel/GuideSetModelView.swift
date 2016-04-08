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

/**
 *  @author xuemincai
 *
 *  设置通知提醒
 */
struct GuideSetNoticeViewModel: GuideViewDataSource, GuideViewDelegate {
    
    var title: String { return L10n.GuideSetting.string }
    var rightItemBtnTitle: String { return L10n.GuidePassButton.string }
    var bgColor: UIColor { return UIColor(named: .GuideSetPermission) }
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
struct GuideSetLocationShare: GuideViewDataSource, GuideViewDelegate {
    
    var title: String { return L10n.GuideSetting.string }
    var rightItemBtnTitle: String { return L10n.GuidePassButton.string }
    var bgColor: UIColor { return UIColor(named: .GuideSetPermission) }
    var centerView: UIView { return PictureView(title: L10n.GuideOpenNotice.string, titleInfo: L10n.GuideOpenLocationShare.string, midImage: AnimatableImageView(image: UIImage(asset: .GuideLocation))) }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        GuideUserInfo.userInfo.isLocalShare = true
        
        pushNextView(viewController)
        
    }
    
    func onClickRight(viewController: UIViewController) {
        
        GuideUserInfo.userInfo.isLocalShare = false
        
        pushNextView(viewController)
    }
    
    func pushNextView(viewController: UIViewController) {
        
        if GuideUserInfo.userInfo.userId.isEmpty {
            
            let accountVC = StoryboardScene.Main.instantiateAccountManagerView()
            
            accountVC.configView(PhoneSignUpViewModel())
            
            viewController.pushVC(accountVC)
            
            return
        }
        
        viewController.pushVC(StoryboardScene.Home.instantiateRootView())
        
    }
    
}