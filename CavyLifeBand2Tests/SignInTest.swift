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
        
        let parameters = [("17722342211", "123456"), ("werqqw@qq.com", "123456")]
        
        for para in parameters {
            
            let expectatoin = expectationWithDescription("testSignInOk succes")
            
            userNetReq.requestSignIn(para.0, passwd: para.1) { result in
                
                XCTAssertTrue(result.isSuccess)
                
                let reslutMsg = try! UserSignUpMsg(JSONDecoder(result.value!))
                
                XCTAssertTrue(reslutMsg.commonMsg?.code == WebApiCode.Success.rawValue)
                XCTAssertTrue(reslutMsg.commonMsg?.msg == "success")
                XCTAssertTrue(reslutMsg.userId == "56d6ea3bd34635186c60492b")
                
                expectatoin.fulfill()
                
            }
            
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
        
        let parameters = [("17722342211", "123456"), ("werqqw@qq.com", "123456")]
        
        for para in parameters {
            
            let expectation = expectationWithDescription("testSignInErr succeed")
            
            userNetReq.requestSignIn(para.0, passwd: para.1) { result in
                
                XCTAssertTrue(result.isSuccess)
                
                let reslutMsg = try! UserSignUpMsg(JSONDecoder(result.value!))
                
                XCTAssertTrue(reslutMsg.commonMsg?.code == WebApiCode.UserPasswdError.rawValue)
                XCTAssertTrue(reslutMsg.commonMsg?.msg == "user or password error")
                XCTAssertTrue(reslutMsg.userId == "")
                
                expectation.fulfill()
            }
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
    
    func testSignInPasswdErr() {
        
        let parameters = [("17722334831", "23456"), ("asdqwe@qq.com", "12312312312312312")]
        
        for para in parameters  {
            
            let expectation = expectationWithDescription("testSignInPasswdErr succeed")
            
            userNetReq.requestSignIn(para.0, passwd: para.1) { result in
                
                XCTAssertTrue(result.isFailure)
                XCTAssertTrue(result.error == UserRequestErrorType.PassWdErr)
                
                expectation.fulfill()
                
            }
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
    
    func testSignInPasswdNil() {
        
        let parameters = [("17722334831", ""), ("asdqwe@qq.com", "")]
        
        for para in parameters  {
            
            let expectation = expectationWithDescription("testSignInPasswdNil succeed")
            
            userNetReq.requestSignIn(para.0, passwd: para.1) { result in
                
                XCTAssertTrue(result.isFailure)
                XCTAssertTrue(result.error == UserRequestErrorType.PassWdNil)
                
                expectation.fulfill()
                
            }
            
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
