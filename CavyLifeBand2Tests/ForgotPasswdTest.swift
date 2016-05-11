//
//  ForgotPasswdTest.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Alamofire
import JSONJoy
@testable import CavyLifeBand2



class ForgotPasswdTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        stub(isMethodPOST()) { _ in
            
            let stubPath = OHPathForFile("ForgotPasswd_Ok.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    func testForgotPasswdOk() {
        
        let parameters = [("17722618599", "123456", "1234"), ("sdfwer@qq.com", "123456", "1234")]
        
        for para in parameters {
            
            let expectation = expectationWithDescription("testForgotPasswdOk succeed")
            
            UserNetRequestData.shareApi.forgotPasswd(para.0, passwd: para.1, safetyCode: para.2) { reslut in
                
                XCTAssertTrue(reslut.isSuccess)
                
                let resultVar = try! CommenMsg(JSONDecoder(reslut.value!))
                
                XCTAssertTrue(resultVar.code == WebApiCode.Success.rawValue)
                XCTAssertTrue(resultVar.msg == "success")
                
                expectation.fulfill()
            
            }
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
       
        
    }
    
    func testForgotPasswd_UserNameError() {
        
        let parameters = [("1772261899", "123456", "1234"), ("sdfweq.com", "123456", "1234"), ("", "123456", "1234")]
        
        for para in parameters {
            
            let expectation = expectationWithDescription("testForgotPasswd_UserNameError succeed")
            
            UserNetRequestData.shareApi.forgotPasswd(para.0, passwd: para.1, safetyCode: para.2) { reslut in
                
                XCTAssertTrue(reslut.isFailure)
                XCTAssertTrue(reslut.error! == UserRequestErrorType.UserNameErr)
                
                expectation.fulfill()
                
            }
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
    
    func testForgotPasswd_PassWdError() {
        
        let parameters = [("17722618599", "12345678901234567", "1234"), ("sdfwe@qq.com", "12356", "1234"), ("17722618599", "", "1234")]
        
        for para in parameters {
            
            let expectation = expectationWithDescription("testForgotPasswd_PassWdError succeed")
            
            UserNetRequestData.shareApi.forgotPasswd(para.0, passwd: para.1, safetyCode: para.2) { reslut in
                
                XCTAssertTrue(reslut.isFailure)
                XCTAssertTrue(reslut.error! == UserRequestErrorType.PassWdErr)
                
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
