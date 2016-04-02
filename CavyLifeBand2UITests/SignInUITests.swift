//
//  AccountUITests.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest
@testable import CavyLifeBand2

class SignInUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            app.launchArguments = [ "STUB_HTTP_SIGN_IN" ]
            app.launch()
            app.images["pageImage1"].swipeLeft()
            app.images["pageImage1"].swipeLeft()
            app.images["pageImage1"].swipeLeft()
            let btn = app.buttons["登入"]
            btn.tap()
            
            
            
        } else {
            // Fallback on earlier versions
        }
        


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        
        super.tearDown()
    }
    
    
    func testSignIn() {
        
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            
            let loginButton = app.buttons["登录"]
            loginButton.tap()
            
            let alertsQuery = app.alerts
            app.alerts.staticTexts["用户名不能为空"].tap()
            
            let okButton = alertsQuery.collectionViews.buttons["OK"]
            okButton.tap()
            
            let textField = app.textFields["手机/邮箱"]
            textField.typeText("17726738599")
            
            loginButton.tap()
            
            app.alerts.staticTexts["密码不能为空"].tap()
            okButton.tap()
            
            
            let secureTextField = app.secureTextFields["密码"]
            secureTextField.tap()
            secureTextField.typeText("123456")
            
            loginButton.tap()
            
            let window = app.windows.elementAtIndex(0)
            
            window.pressForDuration(3)

        }
        
    }
    
    func testSignInKeyboardNext() {
        
//        stub(isMethodPOST()) { _ in
//            let stubPath = OHPathForFile("Sign_Up_Ok.json", self.dynamicType)
//            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
//        }
        
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            
            let textField = app.textFields["手机/邮箱"]
            textField.tap()
            textField.typeText("17726738599")
            app.typeText("\n")
            
            let secureTextField = app.secureTextFields["密码"]
            secureTextField.typeText("123456")
            app.typeText("\n")
            
        }
        
    }
    
}
