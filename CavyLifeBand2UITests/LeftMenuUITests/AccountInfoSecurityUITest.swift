//
//  AccountInfoSecurityUITest.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest

class AccountInfoSecurityUITest: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            app.launchArguments = ["AccountInfoSecurityUITest"]
            app.launch()
            app.buttons["HomeLeftMenu"].tap()
            
            
        } else {
            // Fallback on earlier versions
        }


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInfoSecurity() {
        
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            
            let tablesQuery = app.tables
            let openInfoTxt = tablesQuery.staticTexts["信息公开"]
            openInfoTxt.tap()
            
            let staticText = app.navigationBars["信息公开"].staticTexts["信息公开"]
            let backBtn = app.navigationBars["信息公开"].buttons["backbtn"]
            XCTAssert(staticText.exists)
            
            let switchHeight = tablesQuery.switches["身高"]
            let switchWeight = tablesQuery.switches["体重"]
            let switchBirth = tablesQuery.switches["生日"]
            
            
            //关闭公开身高
            switchHeight.tap()
            backBtn.tap()
            
            openInfoTxt.tap()

            
            //关闭公开体重
            switchHeight.tap()
            switchWeight.tap()
            backBtn.tap()
            openInfoTxt.tap()

            
            //关闭公开生日
            switchWeight.tap()
            switchBirth.tap()
            backBtn.tap()
            openInfoTxt.tap()

            
            //全部关闭
            switchWeight.tap()
            switchHeight.tap()
            backBtn.tap()
            openInfoTxt.tap()

            
            //全部打开
            switchHeight.tap()
            switchWeight.tap()
            switchBirth.tap()
            backBtn.tap()
            openInfoTxt.tap()

            
        }
        
        
    }


}
