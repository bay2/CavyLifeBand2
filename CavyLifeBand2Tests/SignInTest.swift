//
//  SignInTest.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/2.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Alamofire
import JSONJoy
@testable import CavyLifeBand2

class SignInTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        stub(isMethodPOST()) { _ in
            let stubPath = OHPathForFile("Sign_In_Ok.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }

    /**
     登录成功
     */
    func testSignInOk() {
        
        let paras = [[UserNetRequsetKey.UserName.rawValue: "17722342211", UserNetRequsetKey.Passwd.rawValue: "123456"],
            [UserNetRequsetKey.UserName.rawValue: "werqqw@qq.com", UserNetRequsetKey.Passwd.rawValue: "123456"]]
        
        let expectResultMsg = ["code": "1001", "msg": "登录成功"]
        
        for para in paras {
            
            let expectation = expectationWithDescription("testSignInOk succeed")
            
            userNetReq.requestSignIn(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "返回值不正确")
                
                do {
                    
                    let reslutMsg = try CommenMsg(JSONDecoder(result.value!))
                    
                    XCTAssert(reslutMsg.code == expectResultMsg["code"], "Expect Value = [\(expectResultMsg["code"])]")
                    XCTAssert(reslutMsg.msg ==  expectResultMsg["msg"], "Expect Value = [\(expectResultMsg["msg"])]")
                    
                } catch {
                    
                    XCTAssert(false)
                    
                }
                
                expectation.fulfill()
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
        }
        
    }
    
    /**
     登录失败
     */
    func testSignInErr() {
        
        OHHTTPStubs.removeAllStubs()
        
        stub(isMethodPOST()) { _ in
            let stubPath = OHPathForFile("Sign_In_Error.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
        }
        
        let paras = [[UserNetRequsetKey.UserName.rawValue: "17722342211", UserNetRequsetKey.Passwd.rawValue: "123456"],
            [UserNetRequsetKey.UserName.rawValue: "werqqw@qq.com", UserNetRequsetKey.Passwd.rawValue: "123456"]]
        
        let expectResultMsg = ["code": "1000", "msg": "密码错误"]
        
        for para in paras {
            
            let expectation = expectationWithDescription("testSignInErr succeed")
            
            userNetReq.requestSignIn(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "返回值不正确")
                
                do {
                    
                    let reslutMsg = try CommenMsg(JSONDecoder(result.value!))
                    XCTAssert(reslutMsg.code == expectResultMsg["code"], "Expect Value = [\(expectResultMsg["code"])]")
                    XCTAssert(reslutMsg.msg ==  expectResultMsg["msg"], "Expect Value = [\(expectResultMsg["msg"])]")
                    
                } catch {
                    
                    XCTAssert(false)
                    
                }
                
                expectation.fulfill()
                
            })
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }
    
    /**
     用户名格式不正确
     */
    func testSignInUserNameErr() {
        
        let paras = [[UserNetRequsetKey.UserName.rawValue: "1772311", UserNetRequsetKey.Passwd.rawValue: "123456"],
            [UserNetRequsetKey.UserName.rawValue: "sdfsa123.com", UserNetRequsetKey.Passwd.rawValue: "123456"],
            [UserNetRequsetKey.UserName.rawValue: "1223345ew33", UserNetRequsetKey.Passwd.rawValue: "123456"]]
        
        for para in paras {
            
            let expectation = expectationWithDescription("testSignInUserNameErr succedd")
            
            userNetReq.requestSignIn(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "返回值不正确")
                
                XCTAssert(result.error == UserRequestErrorType.UserNameErr, "Result = [\(result.error)], Expect Value = [\(UserRequestErrorType.UserNameErr)]")
                
                expectation.fulfill()
            })
        }
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
    }
    
    func testSignInPasswdErr() {
        
        let paras = [[UserNetRequsetKey.UserName.rawValue: "17723321123", UserNetRequsetKey.Passwd.rawValue: "12311"],
            [UserNetRequsetKey.UserName.rawValue: "asdqwe@qq.com", UserNetRequsetKey.Passwd.rawValue: "12345"],
            [UserNetRequsetKey.UserName.rawValue: "18623242112", UserNetRequsetKey.Passwd.rawValue: "12345678901234567"],
            [UserNetRequsetKey.UserName.rawValue: "slkjldf@qq.com", UserNetRequsetKey.Passwd.rawValue: "12345678901234567"]]
        
        for para in paras  {
            
            let expectation = expectationWithDescription("testSignInPasswdErr succeed")
            
            userNetReq.requestSignIn(para, completionHandler: { (result) -> Void in
                
                
                XCTAssert(result.isFailure, "返回值不正确")
                
                XCTAssert(result.error == UserRequestErrorType.PassWdErr, "Result = [\(result.error)], Expect Value = [\(UserRequestErrorType.PassWdErr)]")
                
                expectation.fulfill()
                
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
