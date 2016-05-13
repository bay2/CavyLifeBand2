//
//  LaunchScreenViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import CoreBluetooth

class LaunchScreenViewController: UIViewController, LifeBandBleDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Log.error("viewDidLoad")
        LifeBandBle.shareInterface.lifeBandBleDelegate = self
        
    }
    
    func setRootViewController() {
        
        Log.error("setRootViewController")
        
        LifeBandBle.shareInterface.startScaning()
        
        if CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId.isEmpty {
            UIApplication.sharedApplication().keyWindow?
                .setRootViewController(StoryboardScene.Main.instantiateMainPageView(),
                                                                               transition: CATransition())
            return
        }
        
        let rootViewController = StoryboardScene.Guide.instantiateGuideView()
        
        var guideVM: GuideViewModelPotocols
        
        if LifeBandBle.shareInterface.centraManager?.state == .PoweredOn {
            guideVM = GuideBandLinking()
        } else {
            guideVM = GuideBandBluetooth()
        }
        
        rootViewController.configView(guideVM, delegate: guideVM)
        
        UIApplication.sharedApplication().keyWindow?
            .setRootViewController(UINavigationController(rootViewController: rootViewController),
                                                                           transition: CATransition())
        
    }
    
    func bleMangerState(bleState: CBCentralManagerState) {
        
        setRootViewController()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
