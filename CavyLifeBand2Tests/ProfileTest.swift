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
        
        userInfoModelView = UserInfoModelView(userId: "56d6ea3bd34635186c60492b") {
            
            XCTAssert($0)
            
            let expectationResult = [UserNetRequsetKey.NickName.rawValue: "aaa",
                UserNetRequsetKey.Birthday.rawValue: "1991-03-07",
                UserNetRequsetKey.Weight.rawValue: "52",
                UserNetRequsetKey.Sex.rawValue: "1",
                UserNetRequsetKey.Height.rawValue: "170",
                UserNetRequsetKey.Avater.rawValue: "",
                UserNetRequsetKey.Address.rawValue: "浙江-杭州"]
            
            
            XCTAssert(self.userInfoModelView!.userInfo!.nickname == expectationResult["nickname"], "期望值 = \(expectationResult["nickname"]) , 实际值 = \(self.userInfoModelView!.userInfo!.nickname)")
            XCTAssert("\(self.userInfoModelView!.userInfo!.sex)" == expectationResult["sex"], "期望值 = \(expectationResult["sex"]) , 实际值 = \(self.userInfoModelView!.userInfo!.sex)")
            XCTAssert(self.userInfoModelView!.userInfo!.height == expectationResult["height"], "期望值 = \(expectationResult["height"]) , 实际值 = \(self.userInfoModelView!.userInfo!.height)")
            XCTAssert(self.userInfoModelView!.userInfo!.weight == expectationResult["weight"], "期望值 = \(expectationResult["weight"]) , 实际值 = \(self.userInfoModelView!.userInfo!.weight)")
            XCTAssert(self.userInfoModelView!.userInfo!.birthday == expectationResult["birthday"], "期望值 = \(expectationResult["birthday"]) , 实际值 = \(self.userInfoModelView!.userInfo!.birthday)")
            XCTAssert(self.userInfoModelView!.userInfo!.avatarUrl == expectationResult["imgFile"], "期望值 = \(expectationResult["avatarUrl"]) , 实际值 = \(self.userInfoModelView!.userInfo!.avatarUrl)")
            XCTAssert(self.userInfoModelView!.userInfo!.address == expectationResult["address"], "期望值 = \(expectationResult["address"]) , 实际值 = \(self.userInfoModelView!.userInfo!.address)")
            
            expectation.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
        userInfoModelView?.userInfo?.nickname = "bbb"
        userInfoModelView?.userInfo?.sex = 1
        userInfoModelView?.userInfo?.height = "170"
        userInfoModelView?.userInfo?.weight = "52"
        userInfoModelView?.userInfo?.sleepTime = "7:51"
        userInfoModelView?.userInfo?.stepNum = 1000
        userInfoModelView?.userInfo?.avatarUrl = ""
        
        expectation = expectationWithDescription("testSetProfile succeed")
        
        userInfoModelView?.updateInfo() {
            
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
