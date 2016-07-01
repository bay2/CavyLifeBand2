//
//  AppDelegate.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/5.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Log
import EZSwiftExtensions
import RealmSwift
#if UITEST
import OHHTTPStubs
#endif

var realm: Realm = try! Realm()
let PGYAPPID = "9bb10b86bf5f62f10ec4f83d1c9847e7"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LifeBandBleDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        #if UITEST
            
            uiTestStub()
            
        #endif
        
        #if RELEASE
            Log.enabled = false
           
        #endif
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        /**
         5适配
         */
        appFitWithDevice()
        
        realmConfig()
        
        pgyUpdateConfig()
        
        registerShareSdk()
        
        setRootViewController()
        crashConfig()
        
        return true

    }
    
    /**
     5,5c,5s适配
     */
    func appFitWithDevice() {
        
        if UIDevice.isPhone5() {
            
            timeButtonHeight = 40
            subTimeButtonHeight = 40
            chartTopHeigh = 20
            chartBottomHeigh = 20
            chartViewHight = 230
            listcellHight = 44
            
        }
        
    }
    
    /**
     首页设置
     
     - author: sim cai
     - date: 2016-06-01
     */
    func setRootViewController() {
        if CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId.isEmpty {
            return
        }
        
        
        let bindBandKey = "CavyAppMAC_" + CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
        BindBandCtrl.bandMacAddress = CavyDefine.bindBandInfos.bindBandInfo.userBindBand[bindBandKey] ?? NSData()
        
        window?.rootViewController = StoryboardScene.Home.instantiateRootView()
        
    }
    
    /**
     蒲公英升级
     
     - author: sim cai
     - date: 2016-06-01
     */
    func pgyUpdateConfig() {
    
        PgyUpdateManager.sharedPgyManager().startManagerWithAppId(PGYAPPID)
        PgyUpdateManager.sharedPgyManager().updateLocalBuildNumber()
        PgyUpdateManager.sharedPgyManager().checkUpdateWithDelegete(self, selector: #selector(AppDelegate.updateMethod))
        
    }
    
    /**
     自动异常上报
     
     - author: sim cai
     - date: 2016-06-01
     */
    func crashConfig() {
        
       PgyManager.sharedPgyManager().startManagerWithAppId(PGYAPPID)
        
    }
    
    /**
     分享SDK
     
     - author: sim cai
     - date: 2016-06-01
     */
    func registerShareSdk() {
        
        ShareSDK.registerApp(CavyDefine.shareSDKAppKey)
        
        // 新浪微博
        ShareSDK.connectSinaWeiboWithAppKey(CavyDefine.sinaShareAppKey, appSecret: CavyDefine.sinaShareAppSecret, redirectUri: CavyDefine.sinaShareAppRedirectUri, weiboSDKCls: WeiboSDK.classForCoder())
        
        // QQ
        ShareSDK.connectQQWithAppId(CavyDefine.qqShareAppKey, qqApiCls: QQApiInterface.classForCoder())
        
        // Wechat
        ShareSDK.connectWeChatTimelineWithAppId(CavyDefine.wechatShareAppKey, appSecret: CavyDefine.wechatShareAppSecret, wechatCls: WXApi.classForCoder())
        ShareSDK.connectWeChatSessionWithAppId(CavyDefine.wechatShareAppKey, appSecret: CavyDefine.wechatShareAppSecret, wechatCls: WXApi.classForCoder())
        
    }
    

    
    /**
     realm 数据合并配置
     
     - author: sim cai
     - date: 2016-06-01
     */
    func realmConfig() {
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: UInt64(ez.appBuild!)!, migrationBlock: { migration, oldSchemaVersion in
            
            if oldSchemaVersion > 6 {
                return
            }
            
            migration.enumerate(FriendInfoRealm.className()) { (oldObject, newObject) in
                
                let nikeName = oldObject!["nikeName"] as! String
                newObject!["fullName"] = nikeName.chineseToSpell() + nikeName
                
            }
            
        })
        
    }
    
    /**
     蒲公英更新检查
     
     - author: sim cai
     - date: 2016-06-01
     
     - parameter updateMethodWithDictionary: 
     */
    func updateMethod(updateMethodWithDictionary: [String: AnyObject]?) {
        
        guard let updateDictionary = updateMethodWithDictionary else {
            return
        }
        
        let localBuild = ez.appBuild?.toInt() ?? 0
        let newBuild = (updateDictionary["versionCode"] as? String ?? "").toInt() ?? 0
        
        guard localBuild < newBuild else {
            return
        }
        
        PgyUpdateManager.sharedPgyManager().checkUpdate()
        
    }

#if UITEST
    
    func uiTestStub() {
    
//        stub(isMethodPOST()) { _ in
//            let stubPath = OHPathForFile("GetFrendListResult.json", self.dynamicType)
//            return fixture(stubPath!, headers: ["Content-Type": "application/json"])
//        }
        
        if NSProcessInfo.processInfo().arguments.contains("AccountPageSwitchUITests") {
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = ""
            
        }
        
        if NSProcessInfo.processInfo().arguments.contains("ContactsAccountInfoUItests") {
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = "56d6ea3bd34635186c60492b"
        }

    
        if NSProcessInfo.processInfo().arguments.contains("STUB_HTTP_SIGN_IN") {
    
            // setup HTTP stubs for tests
            stub(isMethodPOST()) { _ in
            let stubPath = OHPathForFile("Sign_In_Ok.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type": "application/json"])
            }
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = ""
            
        }

        if NSProcessInfo.processInfo().arguments.contains("STUB_HTTP_SIGN_UP") {

            // setup HTTP stubs for tests
            stub(isMethodPOST()) { _ in
                let stubPath = OHPathForFile("Sign_Up_Ok.json", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type": "application/json"])
            }
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = ""
        }
    
        if NSProcessInfo.processInfo().arguments.contains("STUB_HTTP_COMMON_RESULT_OK") {
    
            // setup HTTP stubs for tests
            stub(isMethodPOST()) { _ in
                let stubPath = OHPathForFile("Sign_Up_Ok.json", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type": "application/json"])
            }
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = ""
        }
        
        if NSProcessInfo.processInfo().arguments.contains("AccountInfoSecurityUITest") {
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = "56d6ea3bd34635186c60492b"
            
        }
        
        if NSProcessInfo.processInfo().arguments.contains("AlarmClockUITest") {
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = "56d6ea3bd34635186c60492b"
            
        }
    
    }
    
#endif

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        // 只有 打开蓝牙并且连接手环 自动刷新的处理
        if LifeBandBle.shareInterface.centraManager?.state == .PoweredOn && LifeBandBle.shareInterface.getConnectState() == .Connected {
        
        NSNotificationCenter.defaultCenter().postNotificationName(RefreshStatus.AddAutoRefresh.rawValue, object: nil)
            
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - 如果使用SSO（可以简单理解成跳客户端授权），以下方法是必要的
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        return ShareSDK.handleOpenURL(url, wxDelegate: self)
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return ShareSDK.handleOpenURL(url, sourceApplication: sourceApplication, annotation: annotation, wxDelegate: self)
        
    }

}
