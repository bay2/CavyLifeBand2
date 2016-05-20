//
//  AlarmClockUITest.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/30.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest

@available(iOS 9.0, *)
class AlarmClockUITest: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
            app.launchArguments = ["AlarmClockUITest"]
//            app.launch()
        

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    /**
     测试添加新的闹钟
     */
    func testAddNewClock() {
    
        app.launch()
    
        app.navigationBars["CavyLifeBand2.HomeView"].childrenMatchingType(.Button).elementBoundByIndex(2).tap()
        
        app.tables.staticTexts["智能闹钟"].tap()
        
        app.navigationBars["智能闹钟"].buttons["AlarmClockAdd"].tap()
        
        let collectionViewsQuery = app.scrollViews.otherElements.collectionViews
        
        collectionViewsQuery.buttons["一"].tap()
        collectionViewsQuery.buttons["二"].tap()
        collectionViewsQuery.buttons["三"].tap()
        
        let datePickersQuery = app.scrollViews.otherElements.datePickers
        
        datePickersQuery.pickerWheels["00 minutes"].tap()
        
        app.navigationBars["智能闹钟"].buttons["AlarmClockNavSave"].tap()
        
    }
    
    /**
     测试删除一个闹钟
     */
    func testDeleteClcok() {
        
        app.launch()
        
        app.navigationBars["CavyLifeBand2.HomeView"].childrenMatchingType(.Button).elementBoundByIndex(2).tap()
        
        app.tables.staticTexts["智能闹钟"].tap()
        
        app.tables["AlarmClockTable"]
        
   
        if app.tables["AlarmClockTable"].cells.count == 0 {
            app.navigationBars["智能闹钟"].childrenMatchingType(.Button).elementBoundByIndex(2).tap()
            
            let collectionViewsQuery = app.scrollViews.otherElements.collectionViews
            
            collectionViewsQuery.buttons["一"].tap()
            collectionViewsQuery.buttons["二"].tap()
            
            app.scrollViews.otherElements.datePickers.pickerWheels["00 minutes"].tap()
            
            app.navigationBars["智能闹钟"].buttons["AlarmClockNavSave"].tap()
        }
        
        app.tables["AlarmClockTable"].cells.elementBoundByIndex(0).tap()
        
        
        app.scrollViews.otherElements.buttons["删除"].tap()
        
    }
    
    /**
     测试编辑一个闹钟
     */
    func testEditClock() {
        
        app.launch()
        
        app.navigationBars["CavyLifeBand2.HomeView"].childrenMatchingType(.Button).elementBoundByIndex(2).tap()
        
        app.tables.staticTexts["智能闹钟"].tap()
        
        if app.tables["AlarmClockTable"].cells.count == 0 {
            app.navigationBars["智能闹钟"].childrenMatchingType(.Button).elementBoundByIndex(2).tap()
            
            let collectionViewsQuery = app.scrollViews.otherElements.collectionViews
            
            collectionViewsQuery.buttons["一"].tap()
            collectionViewsQuery.buttons["二"].tap()
            
            app.scrollViews.otherElements.datePickers.pickerWheels["00 minutes"].tap()
            
            app.navigationBars["智能闹钟"].buttons["AlarmClockNavSave"].tap()
        }
        
        app.tables["AlarmClockTable"].cells.elementBoundByIndex(0).tap()
        
        let collectionViewsQuery = app.scrollViews.otherElements.collectionViews
        
        collectionViewsQuery.buttons["一"].tap()
        collectionViewsQuery.buttons["二"].tap()
        collectionViewsQuery.buttons["三"].tap()
        
        app.navigationBars["智能闹钟"].buttons["AlarmClockNavSave"].tap()
            
    
    }
    
}
