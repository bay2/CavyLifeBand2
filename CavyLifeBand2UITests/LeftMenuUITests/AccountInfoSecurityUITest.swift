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
            XCUIApplication().launch()
            
            let app = XCUIApplication()
            app.buttons["test"].tap()
            
            let tablesQuery = app.tables
            tablesQuery.staticTexts["信息公开"].tap()
            
            
            let backBtn = app.navigationBars["联系人"].buttons["backbtn"]
            backBtn.tap()
            
            
            
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
            
            
            app.buttons["test"].tap()
            
            let tablesQuery = app.tables
            tablesQuery.staticTexts["信息公开"].tap()
            
            let staticText = app.navigationBars["联系人"].staticTexts["联系人"]
            staticText.tap()
            let switch1 = tablesQuery.switches["身高"]
            switch1.tap()
            switch1.tap()
            switch1.tap()
            
            staticText.tap()
            let switch2 = tablesQuery.switches["体重"]
            switch2.tap()
            switch2.tap()
            
            staticText.tap()
            let switch3 = tablesQuery.switches["生日"]
            switch3.tap()
            switch3.tap()
            switch3.tap()
            
            let backBtn = app.navigationBars["联系人"].buttons["backbtn"]
            backBtn.tap()
            
            
            app.buttons["test"].tap()
            tablesQuery.staticTexts["信息公开"].tap()
            switch3.tap()
            
            backBtn.tap()
            
        } else {
            
        }
        
        
    }


}
