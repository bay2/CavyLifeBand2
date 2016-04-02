//
//  SignUpUITests.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/9.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest

class SignUpPhoneUITests: XCTestCase {
    
    
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            app.launchArguments = [ "STUB_HTTP_SIGN_UP" ]
            app.launch()
            
            let pageimage1Image = app.images["pageImage1"]
            pageimage1Image.swipeLeft()
            pageimage1Image.swipeLeft()
            pageimage1Image.swipeLeft()
            app.buttons["加入豚鼠"].tap()
        
            
            let guideButton = app.buttons["GuideRightBtn"]
            guideButton.tap()
            guideButton.tap()
            guideButton.tap()
            guideButton.tap()
            
            app.buttons["GuideGenderGirlGary"].tap()
            guideButton.tap()
            
            app.staticTexts["生日"].tap()
            guideButton.tap()
            app.staticTexts["身高"].tap()
            guideButton.tap()
            app.staticTexts["体重"].tap()
            guideButton.tap()
            app.staticTexts["目标"].tap()
            guideButton.tap()
            app.staticTexts["开启智能通知"].tap()
            guideButton.tap()
            app.staticTexts["开启位置共享"].tap()
            guideButton.tap()
            
            let staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            

        } else {
            // Fallback on earlier versions
        }

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmptyPhone() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        if #available(iOS 9.0, *) {
        
        
            let app = XCUIApplication()
            app.buttons["发送验证码"].tap()
            
            var alert = app.alerts
            var label = app.alerts.staticTexts["手机号码不能为空"]
            
            let alertCount = NSPredicate(format: "count == 1")
            let labelExist = NSPredicate(format: "exists == 1")
            
            expectationForPredicate(alertCount, evaluatedWithObject: alert, handler: nil)
            expectationForPredicate(labelExist, evaluatedWithObject: label, handler: nil)
            waitForExpectationsWithTimeout(5, handler: nil)
            
            app.buttons["注册"].tap()
            
            alert = app.alerts
            label = app.alerts.staticTexts["手机号码不能为空"]
            
            expectationForPredicate(alertCount, evaluatedWithObject: alert, handler: nil)
            expectationForPredicate(labelExist, evaluatedWithObject: label, handler: nil)
            app.buttons["OK"].tap()
            waitForExpectationsWithTimeout(5, handler: nil)
            
        }
        
    }
    
    func testEmptyPhoneSafetyCode() {
        
        if #available(iOS 9.0, *) {
        
            let app = XCUIApplication()
            
            app.textFields["手机"].typeText("18682398279")
            app.buttons["注册"].tap()
            
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
            
            app.textFields["手机"].typeText("18682398279\n")
            app.textFields["验证码"].typeText("1234")
            app.buttons["注册"].tap()
            
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
    
    func testNoReadProcotol() {
        
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            app.textFields["手机"].typeText("18682398279\n")
            app.textFields["验证码"].typeText("1234")
            app.buttons["return"].tap()
            app.secureTextFields["密码"].typeText("123456789")
            
            app.buttons["chosenbtn"].tap()
            app.buttons["注册"].tap()
            
            let alertCount = NSPredicate(format: "count == 1")
            let labelExist = NSPredicate(format: "exists == 1")
            
            let alert = app.alerts
            let label = app.alerts.staticTexts["请先阅读《豚鼠科技服务协议》"]
            
            expectationForPredicate(alertCount, evaluatedWithObject: alert, handler: nil)
            expectationForPredicate(labelExist, evaluatedWithObject: label, handler: nil)
            waitForExpectationsWithTimeout(5, handler: nil)
            app.buttons["OK"].tap()
            
            
            
            
        }
    }
    
    func testSignUp() {
        
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            app.textFields["手机"].typeText("18682398279")
            
            app.buttons["发送验证码"].tap()
            
            let sendBtn = app.buttons["发送验证码"]
            let sendBtnExist = NSPredicate(format: "exists == 0")
            
            expectationForPredicate(sendBtnExist, evaluatedWithObject: sendBtn, handler: nil)
            waitForExpectationsWithTimeout(5, handler: nil)
            
            app.textFields["验证码"].tap()
            app.textFields["验证码"].typeText("1234")
            app.buttons["return"].tap()
            app.secureTextFields["密码"].typeText("123456789")
            
            app.buttons["注册"].tap()
            
            let alert = app.alerts
            let alertCount = NSPredicate(format: "count == 0")
            
            expectationForPredicate(alertCount, evaluatedWithObject: alert, handler: nil)
            waitForExpectationsWithTimeout(5, handler: nil)
            
            
        }
        
    }
    
}
