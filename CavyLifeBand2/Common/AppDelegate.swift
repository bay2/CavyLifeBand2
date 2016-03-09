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
#if UITEST
import OHHTTPStubs
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Override point for customization after application launch.

        let installation = KSCrashInstallationStandard.sharedInstance()

        installation.url = NSURL(string: bugHDKey)

        installation.install()
        installation.sendAllReportsWithCompletion(nil)

        let defaults = NSUserDefaults.standardUserDefaults()

        let userName = defaults["userName"]
        let passwd = defaults["passwd"]
        if userName != nil && passwd != nil {
            
            let signInViewModel = SignInViewModel(viewController: UIViewController(), userName: userName as! String, passwd: passwd as! String)
            signInViewModel.userSignIn()
            
        }
        
//        #if TARGET_NAME = CavyLifeBand2UITests
        
        #if UITEST
        
        if NSProcessInfo.processInfo().arguments.contains("STUB_HTTP_ENDPOINTS") {
            // setup HTTP stubs for tests
            stub(isMethodPOST()) { _ in
                let stubPath = OHPathForFile("Sign_In_Ok.json", self.dynamicType)
                return fixture(stubPath!, headers: ["Content-Type": "application/json"])
            }
        }
        
        #endif
            
//        #endif
        

//        let navigation = UINavigationController(rootViewController: StoryboardScene.Main.PageViewScene.viewController())

//        UINavigationBar.appearance().translucent = false

//        self.window?.rootViewController = navigation

        return true

    }


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


}
