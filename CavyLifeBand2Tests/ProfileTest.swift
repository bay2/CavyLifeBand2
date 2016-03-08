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
    func testQueryProfile() {
        
        
        stub(isMethodPOST()) { _ in
            
            let stubPath = OHPathForFile("Profile_Ok.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }
        
        let para = [UserNetRequsetKey.UserID.rawValue: "56d6ea3bd34635186c60492b"]
        
        let expectation = expectationWithDescription("testQueryProfile succeed")
        
        userNetReq.queryProfile(para) { (result) -> Void in
            
            XCTAssert(result.isSuccess)
            
            if result.isFailure {
                expectation.fulfill()
                return
            }
            
            do {
                
                let expectationResult = [UserNetRequsetKey.NickName.rawValue: "aaa",
                    UserNetRequsetKey.Birthday.rawValue: "1991-03-07",
                    UserNetRequsetKey.Weight.rawValue: "52",
                    UserNetRequsetKey.Sex.rawValue: "1",
                    UserNetRequsetKey.Height.rawValue: "170",
                    UserNetRequsetKey.Avater.rawValue: "",
                    UserNetRequsetKey.Address.rawValue: "浙江-杭州",
                    "code": "0000",
                    "msg": "success"]

                let actualResult = try UserProfileMsg(JSONDecoder(result.value!))

                XCTAssert(actualResult.commonMsg?.code == expectationResult["code"], "期望值 = \(expectationResult["code"]) , 实际值 = \(actualResult.commonMsg?.code)")
                XCTAssert(actualResult.commonMsg?.msg == expectationResult["msg"], "期望值 = \(expectationResult["msg"]) , 实际值 = \(actualResult.commonMsg?.msg)")
                XCTAssert(actualResult.nickName == expectationResult["nickname"], "期望值 = \(expectationResult["nickname"]) , 实际值 = \(actualResult.nickName)")
                XCTAssert(actualResult.sex == expectationResult["sex"], "期望值 = \(expectationResult["sex"]) , 实际值 = \(actualResult.sex)")
                XCTAssert(actualResult.height == expectationResult["height"], "期望值 = \(expectationResult["height"]) , 实际值 = \(actualResult.height)")
                XCTAssert(actualResult.weight == expectationResult["weight"], "期望值 = \(expectationResult["weight"]) , 实际值 = \(actualResult.weight)")
                XCTAssert(actualResult.birthday == expectationResult["birthday"], "期望值 = \(expectationResult["birthday"]) , 实际值 = \(actualResult.birthday)")
                XCTAssert(actualResult.avatarUrl == expectationResult["imgFile"], "期望值 = \(expectationResult["avatarUrl"]) , 实际值 = \(actualResult.avatarUrl)")
                XCTAssert(actualResult.address == expectationResult["address"], "期望值 = \(expectationResult["address"]) , 实际值 = \(actualResult.address)")

                Log.info("actualResult = \(actualResult)")
            } catch {

                XCTAssert(false)
                
            }


            expectation.fulfill()

        }

        waitForExpectationsWithTimeout(timeout, handler: nil)

    }
    
    /**
     查询个人信息，参数为nil
     */
    func testQueryProfileParaNil() {
        
        let expectation = expectationWithDescription("testQueryProfileParaNil succeed")
        
        userNetReq.queryProfile(nil) { (result) -> Void in
            
            XCTAssert(result.isFailure)
            
            XCTAssert(result.error == UserRequestErrorType.ParaNil, "期望值 = \(UserRequestErrorType.ParaNil), 实际值 = \(result.error)")
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }

    /**
     设置个人信息
     */
    func testSetProfile() {
        
        stub(isMethodPOST()) { _ in
            
            let stubPath = OHPathForFile("CommonResultOk.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }

        let paras = [[UserNetRequsetKey.UserID.rawValue: "56d6ea3bd34635186c60492b", UserNetRequsetKey.NickName.rawValue: "aaa"],
                    [UserNetRequsetKey.UserID.rawValue: "56d6ea3bd34635186c60492b", UserNetRequsetKey.Sex.rawValue: "0"],
                    [UserNetRequsetKey.UserID.rawValue: "56d6ea3bd34635186c60492b", UserNetRequsetKey.Height.rawValue: "170"],
                    [UserNetRequsetKey.UserID.rawValue: "56d6ea3bd34635186c60492b", UserNetRequsetKey.Weight.rawValue: "56"],
                    [UserNetRequsetKey.UserID.rawValue: "56d6ea3bd34635186c60492b", UserNetRequsetKey.Birthday.rawValue: "1990-01-03"],
                    [UserNetRequsetKey.UserID.rawValue: "56d6ea3bd34635186c60492b", UserNetRequsetKey.Address.rawValue: "浙江省-杭州市"]]

        for para in paras {

            let expectation = expectationWithDescription("testSetProfile succeed")

                userNetReq.setProfile(para) { (result) in

                    XCTAssert(result.isSuccess)

                    if result.isFailure {
                        expectation.fulfill()
                        return
                    }

                    let actualResult = result.value as! [String: String]
                    let expectationResult = ["code": "0000", "msg": "success"]

                    XCTAssert(expectationResult == actualResult, "期望值 = \(expectationResult), 实际值 = \(actualResult)")

                    expectation.fulfill()

            }

            waitForExpectationsWithTimeout(timeout, handler: nil)

        }

    }

    /**
     设置个人信息参数错误
     */
    func testSetProfileParaError() {

        let para = [UserNetRequsetKey.UserID.rawValue: "56d6ea3bd34635186c60492b"]

        let expectation = expectationWithDescription("testSetProfile succeed")

        userNetReq.setProfile(para) { (result) -> Void in

            XCTAssert(result.isFailure)

            if result.isSuccess {
                expectation.fulfill()
                return
            }

            XCTAssert(UserRequestErrorType.ParaErr == result.error, "期望值 = \(UserRequestErrorType.ParaErr), 实际值 = \(result.error)")

            expectation.fulfill()

        }

        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }
    
    
    /**
     设置个人信息参数为nil
     */
    func testSetProfileParaNil() {
        
        let expectation = expectationWithDescription("testSetProfile succeed")
        
        userNetReq.setProfile(nil) { (result) -> Void in
            
            XCTAssert(result.isFailure)
            
            if result.isSuccess {
                expectation.fulfill()
                return
            }
            
            XCTAssert(UserRequestErrorType.ParaNil == result.error, "期望值 = \(UserRequestErrorType.ParaNil), 实际值 = \(result.error)")
            
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
