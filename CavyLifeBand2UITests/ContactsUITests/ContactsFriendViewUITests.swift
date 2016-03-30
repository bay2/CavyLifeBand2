//
//  ContactsFriendViewUITests.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest

class ContactsFriendViewUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        if #available(iOS 9.0, *) {
            
            XCUIApplication().launch()
            
            let app = XCUIApplication()
            
            // 出现左侧 然后点击好友进入联系人页面
            //            let showLeftTable = app.buttons[""]
            //            showLeftTable.tap()
            //            let leftTable = app.tables
            //            leftTable.buttons["好友"].tap()
            
            let contactsTable = app.tables
            contactsTable.staticTexts["添加好友"].tap()
            let elementBtns = app.otherElements.containingType(.NavigationBar, identifier:"联系人").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1)
            elementBtns.childrenMatchingType(.Button).elementBoundByIndex(0).tap()
            
            let backbtnButton = app.navigationBars["联系人"].buttons["backbtn"]
            backbtnButton.tap()
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /**
     搜索本地好友
     */
    func testSearchLocationFriends() {
        
        if #available(iOS 9.0, *) {
            
            
            let app = XCUIApplication()
            let navTitle = XCUIApplication().navigationBars["联系人"].staticTexts["联系人"]
            navTitle.tap()
            let backButton = app.navigationBars.buttons["backbtn"]
            
            // 搜索本地好友
            let searchBar = app.searchFields["搜索"]
            searchBar.tap()
            
            // 搜索好友 显示列表
            
            // 点击好友显示详情
            
            let cancelButton = searchBar.buttons["Cancel"]
            cancelButton.tap()
            backButton.tap()
            
            
        }
    }
    
    
    /**
     添加好友页面
     */
    func testAddFriends() {
        
        if #available(iOS 9.0, *) {
            
            
            let app = XCUIApplication()
            let navTitle = XCUIApplication().navigationBars["联系人"].staticTexts["联系人"]
            navTitle.tap()
            let backButton = app.navigationBars.buttons["backbtn"]
            
            let contactsTable = app.tables
            contactsTable.staticTexts["添加好友"].tap()
            
            let scrollViews = app.scrollViews
            let elementBtns = app.otherElements.containingType(.NavigationBar, identifier:"联系人").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1)
            elementBtns.childrenMatchingType(.Button).elementBoundByIndex(0).tap()
            elementBtns.childrenMatchingType(.Button).elementBoundByIndex(1).tap()
            elementBtns.childrenMatchingType(.Button).elementBoundByIndex(2).tap()
            
            navTitle.tap()
            let button1 = app.scrollViews.childrenMatchingType(.Table).elementBoundByIndex(0).childrenMatchingType(.Cell).elementBoundByIndex(0).buttons["添加"]
            button1.tap()
            navTitle.tap()
            let textField = app.textFields["  发送验证申请，等待对方通过"]
            textField.tap()
            app.buttons["发送"].tap()
            
            // 查看陌生人详情
            
            // 点击头像放大 && 看徽章
            
            // 点击到添加好友发送验证的页面
            
            
            elementBtns.childrenMatchingType(.Button).elementBoundByIndex(2).tap()
            navTitle.tap()
            
            elementBtns.childrenMatchingType(.Button).elementBoundByIndex(1).tap()
            
            let elementsQuery = scrollViews.otherElements
            let searchField = elementsQuery.searchFields["搜索"]
            searchField.tap()
            
            // 推荐联系人页
            // 搜索好友 显示列表
            
            // 点击好友显示详情 或者直接添加好友
            
            searchField.tap()
            let cancelButton = elementsQuery.buttons["Cancel"]
            cancelButton.tap()
            backButton.tap()
            
            
        }
    }
    
    
    /**
     新的朋友
     */
    func testNewFriendsList() {
        if #available(iOS 9.0, *) {
            
            let app = XCUIApplication()
            let tablesQuery = app.tables
            tablesQuery.staticTexts["新的朋友"].tap()
            
            let cell = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0)
            let button = cell.buttons["同意"]
            button.tap()
            
            let staticText = cell.staticTexts["吖保鸡丁"]
            staticText.tap()
            
            // 跳到查看陌生人详情
            
            // 点击头像放大 看徽章
            
            // 点击到添加好友发送验证的页面
            
            
            
            app.navigationBars["联系人"].buttons["backbtn"].tap()
            
        }
    }
    
    /**
     生活豚鼠页面
     */
    func textCavyTechView() {
        
        if #available(iOS 9.0, *){
            
            let app = XCUIApplication()
            let tablesQuery = app.tables
            tablesQuery.staticTexts["生活豚鼠"].tap()
            
            app.navigationBars["联系人"].buttons["backbtn"].tap()
            
        }
        
        
    }
    
    /**
     联系人好友的详情页面
     */
    func contactsFriendInfo() {
        
        if #available(iOS 9.0, *) {
            
            XCUIApplication().launch()
            let app = XCUIApplication()
            
            let leftTable = app.tables
            leftTable.staticTexts["好友"].tap()
            let contactsTale = app.tables
            contactsTale.staticTexts["东波排骨"].tap()
            
            // 进入好友详情
            
            // 查看头像
            
            // 修改备注
            
            // PK
            
            
        }
        
    }
    
}
