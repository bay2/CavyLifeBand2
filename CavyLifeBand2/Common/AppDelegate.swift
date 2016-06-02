//
//  AppDelegate.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/5.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import KSCrash
import Log
import EZSwiftExtensions
import RealmSwift
#if UITEST
import OHHTTPStubs
#endif

var realm: Realm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LifeBandBleDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        #if UITEST
            
            uiTestStub()
            
        #endif
        
        if ez.isRelease {
            Log.enabled = false
        }
        
        realmConfig()
        
        crashConfig()
        
        pgyUpdateConfig()
        
        registerShareSdk()
        
        setRootViewController()
        
        return true

    }
    
    func setRootViewController() {
        
        if CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId.isEmpty {
            return
        }
        
        let bindBandKey = "CavyAppMAC_" + CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
        BindBandCtrl.bandMacAddress = CavyDefine.bindBandInfos.bindBandInfo.userBindBand[bindBandKey] ?? NSData()
        
        window?.rootViewController = StoryboardScene.Home.instantiateRootView()
        
    }
    
    func pgyUpdateConfig() {
    
        PgyUpdateManager.sharedPgyManager().startManagerWithAppId("d349dbd8cf3ecc6504e070143916baf3")
        PgyUpdateManager.sharedPgyManager().updateLocalBuildNumber()
        PgyUpdateManager.sharedPgyManager().checkUpdateWithDelegete(self, selector: #selector(AppDelegate.updateMethod))
        
    }
    
    func registerShareSdk() {
        
        ShareSDK.registerApp("12dda1a902dc9")
        
        // 新浪微博
        ShareSDK.connectSinaWeiboWithAppKey("3896444646", appSecret: "aeea3f7222fb54b4f65e2be9edd7df47", redirectUri: "http://sns.whalecloud.com/sina2/callback", weiboSDKCls: WeiboSDK.classForCoder())
        
        // QQ
        ShareSDK.connectQQWithAppId("1105413066", qqApiCls: QQApiInterface.classForCoder())
        
        // Wechat
        ShareSDK.connectWeChatTimelineWithAppId("", appSecret: "", wechatCls: WXApi.classForCoder())
        ShareSDK.connectWeChatSessionWithAppId("", appSecret: "", wechatCls: WXApi.classForCoder())
        
    }
    
    func crashConfig() {
        
        let installation = KSCrashInstallationStandard.sharedInstance()
        
        installation.url = NSURL(string: CavyDefine.bugHDKey)
        
        installation.install()
        installation.sendAllReportsWithCompletion(nil)
        
    }
    
    func realmConfig() {
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: UInt64(ez.appBuild!)!, migrationBlock: { migration, oldSchemaVersion in
            
            if oldSchemaVersion > 6 {
                return
            }
            
            migration.enumerate(FriendInfoRealm.className()) {(oldObject, newObject) in
                
                let nikeName = oldObject!["nikeName"] as! String
                newObject!["fullName"] = nikeName.chineseToSpell() + nikeName
                
            }
            
        })
        
    }
    
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
