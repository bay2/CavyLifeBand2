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

struct UserInfoTest: QueryUserInfoRequestsDelegate {
    
    var queryUserId: String {
        return "56d6ea3bd34635186c60492b"
    }
    
}

@testable import CavyLifeBand2
class ProfileTest: XCTestCase {
    
    var userInfoModelView = UserInfoTest()
    
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
        
        let expectation = expectationWithDescription("testQueryProfile succeed")
        
        
        userInfoModelView.queryUserInfoByNet("56d6ea3bd34635186c60492b") {
           
            XCTAssert($0 != nil)
            
            let expectationResult: [String: AnyObject] = [UserNetRequsetKey.Avater.rawValue: "res/images/default_head_boy.png",
                UserNetRequsetKey.NickName.rawValue: "aaa",
                UserNetRequsetKey.Birthday.rawValue: "1991-03-07",
                UserNetRequsetKey.Weight.rawValue: "52",
                UserNetRequsetKey.Sex.rawValue: "1",
                UserNetRequsetKey.Height.rawValue: "170",
                UserNetRequsetKey.Address.rawValue: "浙江-杭州",
                UserNetRequsetKey.IsLocalShare.rawValue: true,
                UserNetRequsetKey.IsNotification.rawValue: true,
                UserNetRequsetKey.IsOpenBirthday.rawValue: true,
                UserNetRequsetKey.IsOpenHeight.rawValue: true,
                UserNetRequsetKey.IsOpenWeight.rawValue: true,
                UserNetRequsetKey.SleepTime.rawValue: "4:58",
                UserNetRequsetKey.StepNum.rawValue: 8000]
            
            XCTAssert($0?.nickName == expectationResult["nickname"] as? String, "期望值 = \(expectationResult["nickname"]) , 实际值 = \($0?.nickName)")
            XCTAssert($0?.sex == expectationResult["sex"] as? String, "期望值 = \(expectationResult["sex"]) , 实际值 = \($0?.sex)")
            XCTAssert($0?.height == expectationResult["height"] as? String, "期望值 = \(expectationResult["height"]) , 实际值 = \($0?.height)")
            XCTAssert($0?.weight == expectationResult["weight"] as? String, "期望值 = \(expectationResult["weight"]) , 实际值 = \($0?.weight)")
            XCTAssert($0?.birthday == expectationResult["birthday"] as? String, "期望值 = \(expectationResult["birthday"]) , 实际值 = \($0?.birthday)")
            XCTAssert($0?.avatarUrl == expectationResult["imgFile"] as? String, "期望值 = \(expectationResult["avatarUrl"]) , 实际值 = \($0?.avatarUrl)")
            XCTAssert($0?.address == expectationResult["address"] as? String, "期望值 = \(expectationResult["address"]) , 实际值 = \($0?.address)")
            XCTAssert($0?.isLocalShare == expectationResult[UserNetRequsetKey.IsLocalShare.rawValue] as? Bool, "期望值 = \(expectationResult[UserNetRequsetKey.IsLocalShare.rawValue]) , 实际值 = \($0?.isLocalShare)")
            XCTAssert($0?.isNotification == expectationResult[UserNetRequsetKey.IsNotification.rawValue] as? Bool, "期望值 = \(expectationResult[UserNetRequsetKey.IsNotification.rawValue]) , 实际值 = \($0?.isNotification)")
            XCTAssert($0?.isOpenBirthday == expectationResult[UserNetRequsetKey.IsOpenBirthday.rawValue] as? Bool, "期望值 = \(expectationResult[UserNetRequsetKey.IsOpenBirthday.rawValue]) , 实际值 = \($0?.isOpenBirthday)")
            XCTAssert($0?.isOpenHeight == expectationResult[UserNetRequsetKey.IsOpenHeight.rawValue] as? Bool, "期望值 = \(expectationResult[UserNetRequsetKey.IsOpenHeight.rawValue]) , 实际值 = \($0?.isOpenHeight)")
            XCTAssert($0?.isOpenWeight == expectationResult[UserNetRequsetKey.IsOpenWeight.rawValue] as? Bool, "期望值 = \(expectationResult[UserNetRequsetKey.IsOpenWeight.rawValue]) , 实际值 = \($0?.isOpenWeight)")
            XCTAssert($0?.sleepTime == expectationResult[UserNetRequsetKey.SleepTime.rawValue] as? String, "期望值 = \(expectationResult[UserNetRequsetKey.SleepTime.rawValue]) , 实际值 = \($0?.sleepTime)")
            XCTAssert($0?.stepNum == expectationResult[UserNetRequsetKey.StepNum.rawValue] as? Int, "期望值 = \(expectationResult[UserNetRequsetKey.StepNum.rawValue]) , 实际值 = \($0?.stepNum)")
            
            expectation.fulfill()
            
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
        
//        
//        UserInfoModelView.shareInterface.userInfo?.nickname = "bbb"
//        UserInfoModelView.shareInterface.userInfo?.sex = 1
//        UserInfoModelView.shareInterface.userInfo?.height = "170"
//        UserInfoModelView.shareInterface.userInfo?.weight = "52"
//        UserInfoModelView.shareInterface.userInfo?.sleepTime = "7:51"
//        UserInfoModelView.shareInterface.userInfo?.stepNum = 1000
//        UserInfoModelView.shareInterface.userInfo?.avatarUrl = ""
//        
//        expectation = expectationWithDescription("testSetProfile succeed")
//        
//        UserInfoModelView.shareInterface.updateInfo(userId: "56d6ea3bd34635186c60492b") {
//            
//            expectation.fulfill()
//            
//        }
//        
//        waitForExpectationsWithTimeout(timeout, handler: nil)
//        

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
