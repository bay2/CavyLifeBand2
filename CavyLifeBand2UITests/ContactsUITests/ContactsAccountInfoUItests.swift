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
            
            XCUIApplication().launch()
            
            let app = XCUIApplication()
            app.buttons["leftBtn"].tap()
            
            let leftTable = app.tables
            leftTable.buttons["账号信息"].tap()
            
            
        } else {
            
            
            
        }
        

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAccountView() {
        
        // 点击头像 修改头像
        
        
        // 点击cell 修改昵称
        
        
        // 点击每行 修改自己的数值
        
        
        // 点击退出登录
        
        
        
        
    }
    
}
