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
            
            let app = XCUIApplication()
            app.launchArguments = ["AccountPageSwitchUITests"]
            app.launch()
            let pageimage1Image = app.images["pageImage1"]
            pageimage1Image.swipeLeft()
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
    
    /**
     登录
     */
    func testLoginCavy() {
        
        if #available(iOS 9.0, *) {
            
            
            
            let app = XCUIApplication()
            app.buttons["登录"].tap()
            let backbtnButton = app.buttons["backbtn"]
            
            XCTAssert(backbtnButton.exists)
            XCTAssert(app.staticTexts["准备开始"].exists)
            XCTAssert(app.buttons["注册"].exists)
            XCTAssert(app.textFields["手机/邮箱"].exists)
            XCTAssert(app.secureTextFields["密码"].exists)
            XCTAssert(app.buttons["忘记了密码？"].exists)
            XCTAssert(app.buttons["登录"].exists)
            
            app.textFields["手机/邮箱"].tap()
            app.secureTextFields["密码"].tap()
            app.buttons["登录"].tap()
            app.alerts.collectionViews.buttons["OK"].tap()
            app.buttons["忘记了密码？"].tap()
            
            
            // 忘记密码 -- 手机号找回
            XCTAssert(backbtnButton.exists)
            XCTAssert(app.staticTexts["忘记密码了?"].exists)
            XCTAssert(app.buttons["邮箱"].exists)
            XCTAssert(app.textFields["手机"].exists)
            XCTAssert(app.textFields["验证码"].exists)
            XCTAssert(app.buttons["发送验证码"].exists)
            XCTAssert(app.secureTextFields["新密码"].exists)
            XCTAssert(app.buttons["且慢，我想起来了！"].exists)
            XCTAssert(app.buttons["完成"].exists)
            
            app.textFields["手机"].tap()
            app.textFields["验证码"].tap()
            app.buttons["发送验证码"].tap()
            app.alerts.collectionViews.buttons["OK"].tap()
            app.secureTextFields["新密码"].tap()
            app.buttons["完成"].tap()
            app.alerts.collectionViews.buttons["OK"].tap()
            
            app.buttons["且慢，我想起来了！"].tap()
            app.buttons["忘记了密码？"].tap()
            app.buttons["邮箱"].tap()
            
            // 忘记密码 --- 邮箱找回
            XCTAssert(backbtnButton.exists)
            XCTAssert(app.staticTexts["忘记密码了?"].exists)
            XCTAssert(app.buttons["手机"].exists)
            XCTAssert(app.textFields["邮箱"].exists)
            XCTAssert(app.textFields["验证码"].exists)
            XCTAssert(app.secureTextFields["新密码"].exists)
            XCTAssert(app.buttons["且慢，我想起来了！"].exists)
            XCTAssert(app.buttons["完成"].exists)
            
            app.textFields["邮箱"].tap()
            app.textFields["验证码"].tap()
            app.secureTextFields["新密码"].exists
            
            app.buttons["完成"].tap()
            app.alerts.collectionViews.buttons["OK"].tap()
            app.buttons["且慢，我想起来了！"].tap()
            
            // 点击注册
            app.buttons["注册"].tap()
            
            // 引导页
            loginOrder()
            
            backbtnButton.tap()
            
            
        } else {
            
            // Fallback on earlier versions
            
        }
    }
    
    /**
     加入豚鼠
     */
    func testJoinCavy() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        if #available(iOS 9.0, *) {
            
            
            let app = XCUIApplication()
            
            let buttonJoin = app.buttons["加入豚鼠"]
            buttonJoin.tap()
            
            loginOrder()
            
        } else {
            
            // Fallback on earlier versions
            
        }
        
        
    }
    
    
    /**
     注册流程(引导页 + 注册)
     */
    func loginOrder() {
        
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            let guideButton = app.buttons["GuideRightBtn"]
            
            // 打开蓝牙
            XCTAssert(app.staticTexts["连接手环"].exists)
            let infoTitle = app.staticTexts["GuideViewInfoTitleLabel"]
            //            XCTAssert(infoTitle.label == "")
            XCTAssert(app.staticTexts["打开蓝牙"].exists)
            XCTAssert(app.staticTexts["手机蓝牙打开后才能成功连接手环"].exists)
            XCTAssert(app.images["GuideBluetooth"].exists)
            guideButton.tap()
            
            // 连接手环
            XCTAssert(app.staticTexts["连接手环"].exists)
            //            XCTAssert(infoTitle.label == "")
            XCTAssert(app.staticTexts["绑定手环"].exists)
            XCTAssert(app.staticTexts["请按下手环按钮，绑定手环"].exists)
            XCTAssert(app.images["GuideOpenBand"].exists)
            XCTAssert(app.staticTexts["没有灯充电试试看"].exists)
            guideButton.tap()
            
            // 正在连接。。。
            XCTAssert(app.staticTexts["连接手环"].exists)
            //            XCTAssert(infoTitle.label == "")
            XCTAssert(app.staticTexts["正在连接..."].exists)
            guideButton.tap()
            
            // 绑定成功
            XCTAssert(app.staticTexts["连接手环"].exists)
            //            XCTAssert(infoTitle.label == "")
            XCTAssert(app.staticTexts["绑定成功"].exists)
            XCTAssert(app.images["GuidePairSeccuss"].exists)
            XCTAssert(app.staticTexts["开始健康之旅吧"].exists)
            guideButton.tap()
            
            
            // 性别
            XCTAssert(app.staticTexts["我的信息"].exists)
            XCTAssert(infoTitle.label == "可以更好地帮助健康统计哦")
            XCTAssert(app.staticTexts["我是"].exists)
            app.buttons["GuideGenderGirlGary"].tap()
            app.buttons["GuideGenderBoyGary"].tap()
            guideButton.tap()
            
            
            // 生日
            XCTAssert(app.staticTexts["我的信息"].exists)
            XCTAssert(infoTitle.label == "可以更好地帮助健康统计哦")
            XCTAssert(app.staticTexts["生日"].exists)
  
            
            let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.StaticText)
            
            var staticText = element["1990.1"]
            XCTAssert(staticText.exists)
            staticText = element["15"]
            XCTAssert(staticText.exists)
            guideButton.tap()
            
            // 身高
            XCTAssert(app.staticTexts["我的信息"].exists)
            XCTAssert(infoTitle.label == "可以更好地帮助健康统计哦")
            XCTAssert(app.staticTexts["身高"].exists)
            XCTAssert(app.staticTexts["160"].exists)
            XCTAssert(app.staticTexts["CM"].exists)
            guideButton.tap()
            
            // 体重
            XCTAssert(app.staticTexts["我的信息"].exists)
            XCTAssert(infoTitle.label == "可以更好地帮助健康统计哦")
            XCTAssert(app.staticTexts["体重"].exists)
            XCTAssert(app.images["GuideWeightBg"].exists)
            XCTAssert(app.images["GuideWeightNiddle"].exists)
            XCTAssert(app.staticTexts["60.0"].exists)
            XCTAssert(app.staticTexts["kg"].exists)
            guideButton.tap()
            
            // 目标
            XCTAssert(app.staticTexts["我的信息"].exists)
            XCTAssert(infoTitle.label == "可以更好地帮助健康统计哦")
            XCTAssert(app.staticTexts["目标"].exists)
            
            // 计步
            XCTAssert(app.staticTexts["运动步数"].exists)
            XCTAssert(app.staticTexts["8000"].exists)
            XCTAssert(app.staticTexts["步"].exists)
            
            
            let elementSet = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
            var staticTextSet = elementSet.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.StaticText).matchingIdentifier("平均").elementBoundByIndex(0)
            
            staticTextSet = elementSet.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.StaticText).matchingIdentifier("推荐").elementBoundByIndex(0)

            XCTAssert(staticTextSet.exists)
            XCTAssert(staticTextSet.exists)
            
            
            // 睡眠
            XCTAssert(app.staticTexts["睡眠"].exists)
            XCTAssert(app.staticTexts["8"].exists)
            XCTAssert(app.staticTexts["h"].exists)
            XCTAssert(app.staticTexts["30"].exists)
            XCTAssert(app.staticTexts["min"].exists)
            
            staticTextSet = elementSet.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.StaticText).matchingIdentifier("推荐").elementBoundByIndex(1)
            XCTAssert(staticTextSet.exists)
            
            staticTextSet = elementSet.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.StaticText).matchingIdentifier("平均").elementBoundByIndex(1)
            XCTAssert(staticTextSet.exists)
            guideButton.tap()
            
            // 开启智能通知
            XCTAssert(app.buttons["backbtn"].exists)
            XCTAssert(app.staticTexts["设置"].exists)
            XCTAssert(app.buttons["跳过"].exists)
            //            XCTAssert(infoTitle.label == "")
            XCTAssert(app.images["GuideNotice"].exists)
            XCTAssert(app.staticTexts["开启智能通知"].exists)
            XCTAssert(app.staticTexts["随时关注我的健康生活"].exists)
            app.buttons["跳过"].tap()
            let backbtnButton = app.buttons["backbtn"]
            backbtnButton.tap()
            guideButton.tap()
            
            // 开启位置共享
            XCTAssert(app.buttons["backbtn"].exists)
            XCTAssert(app.staticTexts["设置"].exists)
            XCTAssert(app.buttons["跳过"].exists)
            //            XCTAssert(infoTitle.label == "")
            XCTAssert(app.images["GuideLocation"].exists)
            XCTAssert(app.staticTexts["开启位置共享"].exists)
            XCTAssert(app.staticTexts["告诉豚鼠你的位置，更有安全服务！"].exists)
            app.buttons["跳过"].tap()
            backbtnButton.tap()
            guideButton.tap()
            
            // 注册 -- 手机注册
            XCTAssert(app.buttons["backbtn"].exists)
            XCTAssert(app.staticTexts["加入豚鼠"].exists)
            XCTAssert(app.buttons["邮箱"].exists)
            XCTAssert(app.textFields["手机"].exists)
            XCTAssert(app.textFields["验证码"].exists)
            XCTAssert(app.buttons["发送验证码"].exists)
            XCTAssert(app.secureTextFields["密码"].exists)
            XCTAssert(app.staticTexts["我们已经阅读并接受"].exists)
            XCTAssert(app.buttons["《豚鼠科技服务协议》"].exists)
            app.buttons["发送验证码"].tap()
            app.alerts.collectionViews.buttons["OK"].tap()
            app.buttons["chosenbtn"].tap()
            app.buttons["unchosenbtn"].tap()
            
            app.buttons["注册"].tap()
            app.alerts.collectionViews.buttons["OK"].tap()
            app.buttons["邮箱"].tap()
            
            // 注册 -- 邮箱注册
            XCTAssert(app.buttons["backbtn"].exists)
            XCTAssert(app.staticTexts["加入豚鼠"].exists)
            XCTAssert(app.buttons["手机"].exists)
            XCTAssert(app.textFields["邮箱"].exists)
            XCTAssert(app.textFields["验证码"].exists)
            XCTAssert(app.secureTextFields["密码"].exists)
            XCTAssert(app.staticTexts["我们已经阅读并接受"].exists)
            XCTAssert(app.buttons["《豚鼠科技服务协议》"].exists)
            app.buttons["chosenbtn"].tap()
            app.buttons["unchosenbtn"].tap()
            
            app.buttons["注册"].tap()
            app.alerts.collectionViews.buttons["OK"].tap()
            
            app.buttons["手机"].tap()
            
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
            
        } else {
            
        }
    }
    
}
    
