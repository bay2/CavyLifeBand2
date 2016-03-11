//
//  ProfileTest.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/7.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest
import Log
import JSONJoy
import OHHTTPStubs

@testable import CavyLifeBand2
class ProfileTest: XCTestCase {
    
    var userInfoModelView: UserInfoModelView?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

        OHHTTPStubs.removeAllStubs()
    }
    
    /**
     查询个人信息
     */
    func testUserProfile() {
        
        
        stub(isMethodPOST()) { _ in
            
            let stubPath = OHPathForFile("Profile_Ok.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }
        
        var expectation = expectationWithDescription("testQueryProfile succeed")
        
        UserInfoModelView.shareInterface.queryInfo(userId: "56d6ea3bd34635186c60492b") {
            
            XCTAssert($0)
            
            let expectationResult = [UserNetRequsetKey.NickName.rawValue: "aaa",
                UserNetRequsetKey.Birthday.rawValue: "1991-03-07",
                UserNetRequsetKey.Weight.rawValue: "52",
                UserNetRequsetKey.Sex.rawValue: "1",
                UserNetRequsetKey.Height.rawValue: "170",
                UserNetRequsetKey.Avater.rawValue: "",
                UserNetRequsetKey.Address.rawValue: "浙江-杭州"]
            
            
            XCTAssert(UserInfoModelView.shareInterface.userInfo!.nickname == expectationResult["nickname"], "期望值 = \(expectationResult["nickname"]) , 实际值 = \(UserInfoModelView.shareInterface.userInfo!.nickname)")
            XCTAssert("\(UserInfoModelView.shareInterface.userInfo!.sex)" == expectationResult["sex"], "期望值 = \(expectationResult["sex"]) , 实际值 = \(UserInfoModelView.shareInterface.userInfo!.sex)")
            XCTAssert(UserInfoModelView.shareInterface.userInfo!.height == expectationResult["height"], "期望值 = \(expectationResult["height"]) , 实际值 = \(UserInfoModelView.shareInterface.userInfo!.height)")
            XCTAssert(UserInfoModelView.shareInterface.userInfo!.weight == expectationResult["weight"], "期望值 = \(expectationResult["weight"]) , 实际值 = \(UserInfoModelView.shareInterface.userInfo!.weight)")
            XCTAssert(UserInfoModelView.shareInterface.userInfo!.birthday == expectationResult["birthday"], "期望值 = \(expectationResult["birthday"]) , 实际值 = \(UserInfoModelView.shareInterface.userInfo!.birthday)")
            XCTAssert(UserInfoModelView.shareInterface.userInfo!.avatarUrl == expectationResult["imgFile"], "期望值 = \(expectationResult["avatarUrl"]) , 实际值 = \(UserInfoModelView.shareInterface.userInfo!.avatarUrl)")
            XCTAssert(UserInfoModelView.shareInterface.userInfo!.address == expectationResult["address"], "期望值 = \(expectationResult["address"]) , 实际值 = \(UserInfoModelView.shareInterface.userInfo!.address)")
            
            expectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
        
        UserInfoModelView.shareInterface.userInfo?.nickname = "bbb"
        UserInfoModelView.shareInterface.userInfo?.sex = 1
        UserInfoModelView.shareInterface.userInfo?.height = "170"
        UserInfoModelView.shareInterface.userInfo?.weight = "52"
        UserInfoModelView.shareInterface.userInfo?.sleepTime = "7:51"
        UserInfoModelView.shareInterface.userInfo?.stepNum = 1000
        UserInfoModelView.shareInterface.userInfo?.avatarUrl = ""
        
        expectation = expectationWithDescription("testSetProfile succeed")
        
        UserInfoModelView.shareInterface.updateInfo(userId: "56d6ea3bd34635186c60492b") {
            
            expectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
