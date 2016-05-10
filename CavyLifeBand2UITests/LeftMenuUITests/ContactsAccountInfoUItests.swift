//
//  ContactsAccountInfoUItests.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest

class ContactsAccountInfoUItests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            
            app.launchArguments = [ "ContactsAccountInfoUItests"]
            app.launch()
            app.buttons["HomeLeftMenu"].tap()
            app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Image).element.tap()
        
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
     账户信息
     */
    func testAccountView() {
        
        if #available(iOS 9.0, *) {
            let app = XCUIApplication()
            // 点击头像 修改头像
            
            let headViewImageButton = app.scrollViews.otherElements.tables.buttons["ContactsAccountEditButton"]
            headViewImageButton.tap()
            
            // 点击cell 修改昵称
            
            let nickNameEditButton = XCUIApplication().scrollViews.otherElements.tables.buttons["ContactsAccountEditButton"]
            nickNameEditButton.tap()
            
            // 点击每行 修改自己的数值
            
            let elementsQuery = app.scrollViews.otherElements
            let tablesQuery = elementsQuery.tables
            tablesQuery.staticTexts["性别"].tap()
            tablesQuery.staticTexts["身高"].tap()
            tablesQuery.staticTexts["体重"].tap()
            tablesQuery.staticTexts["生日"].tap()
            tablesQuery.staticTexts["地址"].tap()
            
            // 查看成就
            elementsQuery.staticTexts["成就"].tap()
            
            // 点击退出登录
            
            elementsQuery.buttons["退出登录"].tap()
            
            //返回主页面
            app.navigationBars["联系人"].buttons["backbtn"].tap()
            
            
        } else {
            // Fallback on earlier versions
        }
        
        
        
        
    }
    
}
