//
//  GuideBluetoothModelView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit
import EZSwiftExtensions
import Gifu


/**
 *  @author xuemincai
 *
 *  打开蓝牙
 */
struct GuideBandBluetooth: GuideViewDataSource, GuideViewDelegate {
    
    var title: String { return L10n.GuideLinkCavy.string }
    var centerView: UIView
    
    init() {
        
        self.centerView = PictureView(title: L10n.GuideOpenBluetooth.string, titleInfo: L10n.GuideOpenBluetoothInfo.string, midImage: UIImageView(image: UIImage(asset: .GuideBluetooth)))
        
    }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        let nextVC = StoryboardScene.Guide.instantiateGuideView()
        let openBandVM = GuideBandOpenBand()
        
        nextVC.configView(openBandVM, delegate: openBandVM)
        
        viewController.pushVC(nextVC)
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  打开手环
 */
struct GuideBandOpenBand: GuideViewDataSource, GuideViewDelegate {
    
    var title: String { return L10n.GuideLinkCavy.string }
    var centerView: UIView { return PictureView(title: L10n.GuideOpenCavy.string, titleInfo: L10n.GuideOpenCavyInfo.string, bottomInfo: L10n.GuideOpenCavySugg.string, midImage: AnimatableImageView(image: UIImage(asset: .GuideOpenBand))) }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        let nextVC = StoryboardScene.Guide.instantiateGuideView()
        let linkingVM = GuideBandLinking()
        
        nextVC.configView(linkingVM, delegate: linkingVM)
        
        viewController.pushVC(nextVC)
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  手环连接中
 */
struct GuideBandLinking: GuideViewDataSource, GuideViewDelegate {
    
    var title: String { return L10n.GuideLinkCavy.string }
    var centerView: UIView
    
    init() {
        
        let imageView = AnimatableImageView()
        imageView.animateWithImage(named: "GuideLinking.gif")
        centerView = PictureView(title: L10n.GuideLinking.string, midImage: imageView)
        
    }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        let nextVC = StoryboardScene.Guide.instantiateGuideView()
        let bandSuccessVM = GuideBandSuccess()
        
        nextVC.configView(bandSuccessVM, delegate: bandSuccessVM)
        
        viewController.pushVC(nextVC)
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  绑定成功
 */
struct GuideBandSuccess: GuideViewDataSource, GuideViewDelegate, QueryUserInfoRequestsDelegate {
    
    var title: String { return L10n.GuideLinkCavy.string }
    var centerView: UIView { return PictureView(title: L10n.GuidePairSuccess.string, titleInfo: L10n.GuidePairSuccessInfo.string, midImage: AnimatableImageView(image: UIImage(asset: .GuidePairSeccuss))) }
    var queryUserId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        if queryUserId.isEmpty {
            
            // 登录的ID为空，则走的的注册流程
            let nextVC = StoryboardScene.Guide.instantiateGuideView()
            let genderVM = GuideGenderViewModel()
            
            nextVC.configView(genderVM, delegate: genderVM)
            
            viewController.pushVC(nextVC)
            
            return
        }
        
        let queryUserInfoProc: (UserProfile? -> Void) = {
            
            guard let userInfo = $0 else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(message: L10n.UserModuleErrorCodeNetError.string)
                return
            }
            
            // 没有目标值信息
            guard userInfo.sleepTime?.isEmpty == true else {
                
                UIApplication.sharedApplication().keyWindow?.setRootViewController(StoryboardScene.Home.instantiateRootView(), transition: CATransition())
                
                return
            }
            
            let guideView = StoryboardScene.Guide.instantiateGuideView()
            let guideVM = GuideGenderViewModel()
            
            guideView.configView(guideVM, delegate: guideVM)
            
            viewController.pushVC(guideView)
            
        }
        
        queryUserInfoByNet(queryUserInfoProc)
        
    }
    
}


/**
 *  @author xuemincai
 *
 *  连接失败
 */
struct GuideBandFail: GuideViewDataSource, GuideViewDelegate {
    
    var title: String { return L10n.GuideLinkCavy.string }
    var centerView: UIView { return PictureView(title: L10n.GuidePairFail.string, titleInfo: L10n.GuidePairFailInfo.string, midImage: AnimatableImageView(image: UIImage(asset: .GuidePairFail))) }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
    }
    
}
