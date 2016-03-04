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
            
            let button = app.buttons["登入"]
            button.tap()
            
            var staticText = app.staticTexts["准备开始"]
            staticText.tap()
            
            let backbtnButton = app.buttons["backbtn"]
            backbtnButton.tap()
            
            let button2 = app.buttons["加入豚鼠"]
            button2.tap()
            
            var staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            backbtnButton.tap()
            button.tap()
            app.buttons["注册"].tap()
            
            staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            
            let button3 = app.buttons["邮箱"]
            button3.tap()
            
            staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            
            let button4 = app.buttons["手机"]
            button4.tap()
            
            staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            button3.tap()
            
            staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            backbtnButton.tap()
            
            staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            backbtnButton.tap()
            
            staticText = app.staticTexts["准备开始"]
            staticText.tap()
            
            let button5 = app.buttons["忘记了密码？"]
            button5.tap()
            
            var staticText3 = app.staticTexts["忘记密码了?"]
            staticText3.tap()
            button3.tap()
            
            staticText3 = app.staticTexts["忘记密码了?"]
            staticText3.tap()
            backbtnButton.tap()
            
            staticText3 = app.staticTexts["忘记密码了?"]
            staticText3.tap()
            backbtnButton.tap()
            button5.tap()
            
            staticText3 = app.staticTexts["忘记密码了?"]
            staticText3.tap()
            
            let button6 = app.buttons["且慢，我想起来了！"]
            button6.tap()
            
            staticText = app.staticTexts["准备开始"]
            staticText.tap()
            
            button5.tap()
            button3.tap()
            
            staticText3 = app.staticTexts["忘记密码了?"]
            staticText3.tap()
            button6.tap()
            backbtnButton.tap()
            button2.tap()
            
            staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            button3.tap()
            
            staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            button4.tap()
            
            staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            button3.tap()
            
            staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            backbtnButton.tap()
            
            staticText2 = app.staticTexts["加入豚鼠"]
            staticText2.tap()
            backbtnButton.tap()
            
            
        }
        
    }
    
}
