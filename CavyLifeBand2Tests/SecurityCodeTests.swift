//
//  CavyLifeBand2Tests.swift
//  CavyLifeBand2Tests
//
//  Created by xuemincai on 16/1/5.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Alamofire
@testable import CavyLifeBand2

class SecurityCodeTests: XCTestCase {
    let timeout: NSTimeInterval = 30.0
    let testUserNetRequest = UserNetRequestData()
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
        stub(isMethodPOST()) { _ in
            
            let stubPath = OHPathForFile("SecurityCode_Ok.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }
    
    /**
     手机验证码成功请求
     */
    func testPhoneNumSecurityCodeOk() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let expectation = expectationWithDescription("testPhoneNumSecurityCodeOk succeed")
        
        testUserNetRequest.netRequestApi(.SendSecurityCode, parameters: [UserNetRequestParaKeyPhoneNumKey : "17722618598"], completionHandler: { result in
            
            let resultMsg = ["code" : "1001", "msg" : "成功"]
            
            XCTAssert(result.isSuccess, "接口返回错误")
            
            let reValue:[String:String] = result.value as! [String:String]
            
            XCTAssert(reValue == resultMsg, "返回结果错误[reValue = \(reValue), resultMsg = \(resultMsg)]")
            
            expectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }
    
    /**
     邮箱验证码成功请求
     */
    func testEmailSecurityCodeOk() {
        
        let expectation = expectationWithDescription("testEmailSecurityCodeOk succeed")
        
        testUserNetRequest.netRequestApi(.SendSecurityCode, parameters: [UserNetRequestParaKeyEmailKey : "12311W@qq.com"], completionHandler: { result in
            
            let resultMsg = ["code" : "1001", "msg" : "成功"]
            
            XCTAssert(result.isSuccess, "接口返回错误")
            
            let reValue:[String:String] = result.value as! [String:String]
            
            XCTAssert(reValue == resultMsg, "返回结果错误[reValue = \(reValue), resultMsg = \(resultMsg)]")
            
            expectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }
    
    /**
     验证请求参数为nil
     */
    func testParaNilSecurityCode() {
        
        testUserNetRequest.netRequestApi(.SendSecurityCode, completionHandler : { result in
            
            XCTAssert(result.isFailure, "接口返回错误")
            
            XCTAssert(result.error == UserRequestErrorType.ParaNil, "返回结果错误")
            
        })
        
    }
    
    /**
     手机号码错误
     */
    func testPhoneNumErrSecurityCode() {
        
        let phoneNums = ["11111", "asdfadfs", "1111asdfsdf"]
        
        for phoneNum in phoneNums {
            
            testUserNetRequest.netRequestApi(.SendSecurityCode, parameters: [UserNetRequestParaKeyPhoneNumKey: phoneNum], completionHandler: { result in
                
                XCTAssert(result.isFailure, "接口返回错误(\(phoneNum))")
                
                XCTAssert(result.error == UserRequestErrorType.PhoneErr, "接口返回错误(\(phoneNum))")
                
            })
        }
        
    }
    
    /**
     邮箱错误
     */
    func testEmailErrSecurityCode() {
        
        let emails = ["fsadf.com", "sfsf@213", "sdfasdf", "sdfsaf@123."]
        
        for email in emails {
            
            testUserNetRequest.netRequestApi(.SendSecurityCode, parameters: [UserNetRequestParaKeyEmailKey: email], completionHandler: { result in
                
                XCTAssert(result.isFailure, "接口返回错误(\(email))")
                
                XCTAssert(result.error == UserRequestErrorType.EmailErr, "接口返回错误(\(email))")
                
            })
            
        }
        
        
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
