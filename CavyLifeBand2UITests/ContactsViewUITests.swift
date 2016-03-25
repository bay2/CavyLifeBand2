//
//  ContactsViewUITests.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest

class ContactsViewUITests: XCTestCase {
        
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
            
            let leftTable = app.tables
            leftTable.staticTexts["好友"].tap()

        } else {
            // Fallback on earlier versions
        }
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddFriends() {
        
        if #available(iOS 9.0, *) {
            
            
            let app = XCUIApplication()
            app.buttons["test"].tap()
            app.tables.staticTexts["好友"].tap()

            
          
            
            
            
            
            
            
            
            
            
            
            let app = XCUIApplication()
        
            let searchField = app.searchFields["搜索"]
            //            searchField.typeText("Jessica")
            searchField.tap()
            app.buttons["Search"].tap()
            
            let cancelButton = app.buttons["Cancel"]
            cancelButton.tap()
            
            
            let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(2).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1)
            let button = element.childrenMatchingType(.Button).elementBoundByIndex(0)
            button.tap()
            
            let button2 = element.childrenMatchingType(.Button).elementBoundByIndex(2)
            button2.tap()
            
            let button3 = element.childrenMatchingType(.Button).elementBoundByIndex(1)
            button3.tap()
            button.tap()
            button3.tap()
            button2.tap()

            
            
            
            
            
            
            /**
             *
             let app = XCUIApplication()
             
             let searchField = app.searchFields["搜索"]
             searchField.tap()
             
             let cancelButton = app.buttons["Cancel"]
             cancelButton.tap()
             searchField.tap()
             app2.keys["T"].tap()
             app.searchFields["搜索"]
             
             let searchButton = app2.buttons["Search"]
             searchButton.tap()
             app.searchFields["搜索"]
             
             let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(2).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1)
             element.childrenMatchingType(.Other).element.childrenMatchingType(.Image).element.tap()
             cancelButton.tap()
             tablesQuery.staticTexts["添加好友"].tap()
             
             let button = element.childrenMatchingType(.Button).elementBoundByIndex(0)
             button.tap()
             
             let button2 = element.childrenMatchingType(.Button).elementBoundByIndex(1)
             button2.tap()
             
             let button3 = element.childrenMatchingType(.Button).elementBoundByIndex(2)
             button3.tap()
             button.tap()
             button2.tap()
             button3.tap()
             button2.tap()
             
             let elementsQuery = app.scrollViews.otherElements
             let searchField2 = elementsQuery.searchFields["搜索"]
             searchField2.tap()
             elementsQuery.searchFields["搜索"]
             searchButton.tap()
             elementsQuery.searchFields["搜索"]
             
             let cancelButton2 = elementsQuery.buttons["Cancel"]
             cancelButton2.tap()
             elementsQuery.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).buttons["添加"].tap()
             app.textFields["  发送验证申请，等待对方通过"].tap()
             app.textFields["  发送验证申请，等待对方通过"]
             app.buttons["发送"].tap()
             searchField2.buttons["Clear text"].tap()
             cancelButton2.tap()
             
             let backbtnButton = app.navigationBars["联系人"].buttons["backbtn"]
             backbtnButton.tap()
             searchField.buttons["Clear text"].tap()
             cancelButton.tap()
             backbtnButton.tap()
             
             
             

             */
        }
    }
    
    
    
}
