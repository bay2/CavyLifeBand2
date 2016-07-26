//
//  ForgotPasswdEmailUITest.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/9.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest

class ForgotPasswdEmailUITest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            app.launchArguments = [ "STUB_HTTP_COMMON_RESULT_OK" ]
            app.launch()
            let pageimage1Image = app.images["pageImage1"]
            pageimage1Image.swipeLeft()
            pageimage1Image.swipeLeft()
            pageimage1Image.swipeLeft()
            app.buttons["登录"].tap()
            app.buttons["忘记了密码？"].tap()
            app.buttons["邮箱"].tap()
            
            
        }

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testEmptyEmail() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        if #available(iOS 9.0, *) {
            
            
            let app = XCUIApplication()
            
            app.buttons["完成"].tap()
            
            let alert = app.alerts
            let label = app.alerts.staticTexts["邮箱不能为空"]
            
            let alertCount = NSPredicate(format: "count == 1")
            let labelExist = NSPredicate(format: "exists == 1")
            
            expectationForPredicate(alertCount, evaluatedWithObject: alert, handler: nil)
            expectationForPredicate(labelExist, evaluatedWithObject: label, handler: nil)
            app.buttons["OK"].tap()
            waitForExpectationsWithTimeout(5, handler: nil)
            
        }
        
    }
    
    func testEmptySafetyCode() {
        
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            
            app.textFields["邮箱"].typeText("382sdf222@qq.com")
            app.buttons["完成"].tap()
            
            let alert = app.alerts
            let label = app.alerts.staticTexts["验证码不能为空"]
            
            let alertCount = NSPredicate(format: "count == 1")
            let labelExist = NSPredicate(format: "exists == 1")
            
            expectationForPredicate(alertCount, evaluatedWithObject: alert, handler: nil)
            expectationForPredicate(labelExist, evaluatedWithObject: label, handler: nil)
            app.buttons["OK"].tap()
            waitForExpectationsWithTimeout(5, handler: nil)
            
        }
        
    }
    
    func testEmptyPassword() {
        
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            
            app.textFields["邮箱"].typeText("382sdf222@qq.com\n")
            app.textFields["验证码"].typeText("1234")
            app.buttons["完成"].tap()
            
            let alert = app.alerts
            let label = app.alerts.staticTexts["密码不能为空"]
            
            let alertCount = NSPredicate(format: "count == 1")
            let labelExist = NSPredicate(format: "exists == 1")
            
            expectationForPredicate(alertCount, evaluatedWithObject: alert, handler: nil)
            expectationForPredicate(labelExist, evaluatedWithObject: label, handler: nil)
            waitForExpectationsWithTimeout(5, handler: nil)
            app.buttons["OK"].tap()
            
            
        }
        
    }
    
    
    func testForgotPasswd() {
        
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            app.textFields["邮箱"].typeText("382sdf222@qq.com\n")
            
            app.textFields["验证码"].typeText("1234")
            app.buttons["return"].tap()
            app.secureTextFields["新密码"].typeText("123456789")
            
            app.buttons["完成"].tap()
            
            let alert = app.alerts
            let alertCount = NSPredicate(format: "count == 0")
            
            expectationForPredicate(alertCount, evaluatedWithObject: alert, handler: nil)
            waitForExpectationsWithTimeout(5, handler: nil)
            
            
        }
        
    }
    
}
