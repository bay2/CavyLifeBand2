//
//  SignInTest.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/15.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest
import OHHTTPStubs
import JSONJoy
@testable import CavyLifeBand2
let timeout: NSTimeInterval = 30.0

class SignUpTest: XCTestCase {
    
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
     注册ok
     */
    func testSignUpPhoneOk() {
        
        let parameters = [("17722112322", "123456", "1234"), ("23432@qq.com", "654321123", "1234")]
        
        for para in parameters {
            
            let expectation = expectationWithDescription("testSignUpPhoneOk succeed")
            
            UserNetRequestData.shareApi.requestSignUp(para.0, safetyCode: para.2, passwd: para.1) { result in
                
                XCTAssertTrue(result.isSuccess)
                
                let reValue = try! UserSignUpMsg(JSONDecoder(result.value!))
                
                XCTAssertTrue(reValue.commonMsg?.code == WebApiCode.Success.rawValue)
                XCTAssertTrue(reValue.commonMsg?.msg == "success")
                XCTAssertTrue(reValue.userId == "56d6ea3bd34635186c60492b")
                
                expectation.fulfill()
                
            }
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
 
    
    /**
     注册手机号错误
     */
    func testSignUpUserNameErr() {
        
        let parameters = [("177221d2322", "123456", "1234"), ("2343", "654321123", "1234"), ("2343@", "654321123", "1234"), ("1772212322", "654321123", "1234"), ("", "654321123", "1234")]
        
        for para in parameters {
            
            let expectation = expectationWithDescription("testSignUpUserNameErr succeed")
            
            UserNetRequestData.shareApi.requestSignUp(para.0, safetyCode: para.2, passwd: para.1) { result in
                
                XCTAssertTrue(result.isFailure)
                XCTAssertTrue(result.error == UserRequestErrorType.UserNameErr)
                
                expectation.fulfill()
                
            }
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
    }
    
    
    /**
     注册手机号错误
     */
    func testSignUpPasswdErr() {
        
        let parameters = [("17722122322", "12456", "1234"), ("17722122322", "", "1234"), ("2343@qq.com", "12312312312312312", "1234")]
        
        for para in parameters {
            
            let expectation = expectationWithDescription("testSignUpPasswdErr succeed")
            
            UserNetRequestData.shareApi.requestSignUp(para.0, safetyCode: para.2, passwd: para.1) { result in
                
                XCTAssertTrue(result.isFailure)
                XCTAssertTrue(result.error == UserRequestErrorType.PassWdErr)
                
                expectation.fulfill()
                
            }
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
