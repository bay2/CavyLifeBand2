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
import RealmSwift
import CoreBluetooth

private extension BindScene {
    
    var hiddeBackBtn: Bool {
        
        switch self {
            
        case .SignInBind:
            return false
        case .SignUpBind:
            return false
        case .Rebind:
            return false
        }
    }
    
}


/**
 *  @author xuemincai
 *
 *  打开蓝牙
 */
struct GuideBandBluetooth: GuideViewModelPotocols, LifeBandBleDelegate {
    
    var title: String { return L10n.GuideLinkCavy.string }
    var centerView: UIView
    var hiddeBackBtn: Bool { return BindBandCtrl.bindScene.hiddeBackBtn }
    
    var hiddeGuideBtn: Bool { return true }
    
    init() {
        
        self.centerView = PictureView(title: L10n.GuideOpenBluetooth.string, titleInfo: L10n.GuideOpenBluetoothInfo.string, midImage: UIImageView(image: UIImage(asset: .GuideBluetooth)))
        
    }
    
    func onLoadView() {
        
        LifeBandBle.shareInterface.lifeBandBleDelegate = self
        gotoBindBand()
        
    }
    
    private func gotoBindBand() {
        
        if LifeBandBle.shareInterface.centraManager?.state != .PoweredOn {
            return
        }
        
        let rootVC = StoryboardScene.Guide.instantiateGuideView()
        let openBandVM = GuideBandOpenBand()
        
        rootVC.configView(openBandVM, delegate: openBandVM)
        
        CavyDefine.bluetoothPresentViewController(UINavigationController(rootViewController: rootVC))
        
        Log.info("GuideBandBluetooth")
        
    }
    
    func bleMangerState(bleState: CBCentralManagerState) {
        
        if bleState != .PoweredOn {
            return
        }
        
        gotoBindBand()
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  打开手环
 */
struct GuideBandOpenBand: GuideViewModelPotocols, LifeBandBleDelegate {
    
    var title: String { return L10n.GuideLinkCavy.string }
    var centerView: UIView { return PictureView(title: L10n.GuideOpenCavy.string, titleInfo: L10n.GuideOpenCavyInfo.string, bottomInfo: L10n.GuideOpenCavySugg.string, midImage: AnimatableImageView(image: UIImage(asset: .GuideOpenBand))) }
    var hiddeBackBtn: Bool { return false }//BindBandCtrl.bindScene.hiddeBackBtn }
    var queryUserId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    var hiddeGuideBtn: Bool { return true }
    
    func onLoadView() {
        
        LifeBandBle.shareInterface.lifeBandBleDelegate = self
        
        LifeBandBle.shareInterface.bleBinding {
            
                BindBandCtrl.bandMacAddress = $1
            
            let rootViewController = StoryboardScene.Guide.instantiateGuideView()
            let linkingVM = GuideBandLinking()
            
            rootViewController.configView(linkingVM, delegate: linkingVM)
            
            CavyDefine.bluetoothPresentViewController(UINavigationController(rootViewController: rootViewController))
            
            Log.info("GuideBandOpenBand")
            LifeBandBle.shareInterface.lifeBandBleDelegate = nil
            
        }
        
    }
    
    func onCilckBack(viewController: UIViewController) {
        
        // 注册流程时候 返回注册登录首页
        if queryUserId.isEmpty {
            
            let vc = ez.topMostVC?.presentingViewController as? UINavigationController
            
            // 从登录页面 点击右上角注册按钮 进入的注册流程
            // 因返回到登录页面
            if vc?.viewControllers[0] is SignInViewController {
                vc!.popToRootViewControllerAnimated(false)
                vc!.dismissVC(completion: nil)
            } else {
                
                // 直接走的注册流程
                
                ez.topMostVC?.presentingViewController?.presentingViewController?.dismissVC(completion: nil)
            }
            
        } else if BindBandCtrl.bindScene == .Rebind {
            
            viewController.dismissVC(completion: nil)
            
            guard let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController as? RootViewController else {
                return
            }
            
            rootVC.homeVC?.popToRootViewControllerAnimated(false)
            
        } else {
        // 登录流程 返回登录页面
            // TODO: 没有新的注册的号码 进行测试
            viewController.navigationController?.popToRootViewControllerAnimated(true)
            
        }
        
    }
    
    func bleMangerState(bleState: CBCentralManagerState) {
        
        if bleState == .PoweredOn {
            return
        }
        
        CavyDefine.bluetoothDismisViewController()
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  手环连接中
 */
struct GuideBandLinking: GuideViewModelPotocols, LifeBandBleDelegate  {
    
    var title: String { return L10n.GuideLinkCavy.string }
    var centerView: UIView
    var hiddeGuideBtn: Bool { return true }
    var realm: Realm = try! Realm()
    var hiddeBackBtn: Bool { return true }
    
    init() {
        
        let imageView = AnimatableImageView()
        imageView.animateWithImage(named: "GuideLinking@3x.gif")
        centerView = PictureView(title: L10n.GuideLinking.string, midImage: imageView)
        
    }
    
    func onLoadView() {
        
        LifeBandBle.shareInterface.lifeBandBleDelegate = self
        
        LifeBandBle.shareInterface.bleConnect(BindBandCtrl.bandMacAddress) {
            
            let rootViewController = StoryboardScene.Guide.instantiateGuideView()
            let bandVM = GuideBandSuccess()
            
            rootViewController.configView(bandVM, delegate: bandVM)
            
            Log.info("GuideBandLinking")
            
            CavyDefine.bluetoothPresentViewController(UINavigationController(rootViewController: rootViewController))
            
        }
        
    }
    
    func bleMangerState(bleState: CBCentralManagerState) {
        
        if bleState == .PoweredOn {
            return
        }
        
        CavyDefine.bluetoothDismisViewController()
        
        UIApplication.sharedApplication().keyWindow?.layer.addAnimation(CATransition(), forKey: kCATransition)
        
        UIView.animateWithDuration(0.5) {
            ez.topMostVC?.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
        }
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  绑定成功
 */
struct GuideBandSuccess: GuideViewModelPotocols, QueryUserInfoRequestsDelegate, LifeBandBleDelegate {
    
    var title: String { return L10n.GuideLinkCavy.string }
    var centerView: UIView { return PictureView(title: L10n.GuidePairSuccess.string, titleInfo: L10n.GuidePairSuccessInfo.string, midImage: AnimatableImageView(image: UIImage(asset: .GuidePairSeccuss))) }
    var queryUserId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    var hiddeBackBtn: Bool { return BindBandCtrl.bindScene != .SignUpBind }
    
//    let viewController: UIViewController?
    
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
            
            // 有目标值信息
            guard userInfo.sleepGoal == 0 else {
                
                UIApplication.sharedApplication().keyWindow?.setRootViewController(StoryboardScene.Home.instantiateRootView(), transition: CATransition())
                
                return
            }
            
            let guideView = StoryboardScene.Guide.instantiateGuideView()
            let guideVM = GuideGenderViewModel()
            
            guideView.configView(guideVM, delegate: guideVM)
            
            viewController.pushVC(guideView)
            
        }
        
        // 重新绑定手环在这里设置信息，其他在RootViewController 
         //设置 保存 MacAddress
        if BindBandCtrl.bindScene == .Rebind {
            
            
            saveMacAddress()
            
            UIApplication.sharedApplication().keyWindow?.setRootViewController(StoryboardScene.Home.instantiateRootView())
            UIApplication.sharedApplication().keyWindow?.setRootViewController(StoryboardScene.Home.instantiateRootView())
            return
            
        }
        
        queryUserInfoByNet(completeHeadle: queryUserInfoProc)
        
    }
    
    func onCilckBack(viewController: UIViewController) {
        LifeBandBle.shareInterface.bleDisconnect()

        ez.topMostVC?.presentingViewController?.presentingViewController?.dismissVC(completion: nil)
        
    }
    
}


/**
 *  @author xuemincai
 *
 *  连接失败
 */
struct GuideBandFail: GuideViewModelPotocols {
    
    var title: String { return L10n.GuideLinkCavy.string }
    var hiddeGuideBtn: Bool { return true }
    var centerView: UIView { return PictureView(title: L10n.GuidePairFail.string, titleInfo: L10n.GuidePairFailInfo.string, midImage: AnimatableImageView(image: UIImage(asset: .GuidePairFail))) }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        LifeBandBle.shareInterface.bleConnect(BindBandCtrl.bandMacAddress)
        
    }
    
}

