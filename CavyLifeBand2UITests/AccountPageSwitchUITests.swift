//
//  AccountPageSwitchUITests.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest

class AccountPageSwitchUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        if #available(iOS 9.0, *) {
            
            XCUIApplication().launch()
            let app = XCUIApplication()
            let pageimage1Image = app.images["pageImage1"]
            pageimage1Image.swipeLeft()
            pageimage1Image.swipeLeft()
            pageimage1Image.swipeLeft()
            
        } else {
            // Fallback on earlier versions
        }

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPageSwitch() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        if #available(iOS 9.0, *) {
            
            
            let app = XCUIApplication()
            
            let backbtnButton = app.buttons["backbtn"]
            let buttonJoin = app.buttons["加入豚鼠"]
            buttonJoin.tap()
            
            let guideButton = app.buttons["GuideRightBtn"]
            guideButton.tap()
            guideButton.tap()
            guideButton.tap()
            guideButton.tap()
            
            app.buttons["GuideGenderGirlGary"].tap()
            app.buttons["GuideGenderBoyGary"].tap()
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
            
            let signUpBtn = app.buttons["注册"]
            signUpBtn.tap()
            app.alerts.collectionViews.buttons["OK"].tap()
            
            backbtnButton.tap()
            backbtnButton.tap()
            
            let jumpButton = app.buttons["跳过"]
            app.staticTexts["开启智能通知"].tap()
            jumpButton.tap()
            app.staticTexts["开启位置共享"].tap()
            jumpButton.tap()
            
            staticText2.tap()
            
            let buttonEmil = app.buttons["邮箱"]
            buttonEmil.tap()
            
            staticText2.tap()
            let buttonPhone = app.buttons["手机"]
            buttonPhone.tap()

            staticText2.tap()
            backbtnButton.tap()
            guideButton.tap()
            
            staticText2.tap()
            buttonEmil.tap()
            
            staticText2.tap()
            backbtnButton.tap()
            
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            
            let button = app.buttons["登入"]
            button.tap()
            
            var staticText = app.staticTexts["准备开始"]
            staticText.tap()
            
            let buttonForget = app.buttons["忘记了密码？"]
            buttonForget.tap()
            
            var staticText3 = app.staticTexts["忘记密码了?"]
            staticText3.tap()
            buttonEmil.tap()
            
            staticText3 = app.staticTexts["忘记密码了?"]
            staticText3.tap()
            buttonPhone.tap()
            
            staticText3.tap()
            backbtnButton.tap()
            buttonForget.tap()
            
            staticText3 = app.staticTexts["忘记密码了?"]
            staticText3.tap()
            
            let buttonRemmber = app.buttons["且慢，我想起来了！"]
            buttonRemmber.tap()
            
            staticText = app.staticTexts["准备开始"]
            staticText.tap()
            
            buttonForget.tap()
            buttonEmil.tap()
            
            staticText3.tap()
            buttonRemmber.tap()
            backbtnButton.tap()
            
            button.tap()
            staticText.tap()
            signUpBtn.tap()
            
            guideButton.tap()
            guideButton.tap()
            guideButton.tap()
            guideButton.tap()
            
            app.buttons["GuideGenderGirlGary"].tap()
            guideButton.tap()
            
            guideButton.tap()
            guideButton.tap()
            guideButton.tap()
            guideButton.tap()
            guideButton.tap()
            guideButton.tap()
            
            staticText2.tap()
            
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            backbtnButton.tap()
            
            buttonJoin.tap()
            backbtnButton.tap()
            
 
        }
        
    }
    
    
    
}
