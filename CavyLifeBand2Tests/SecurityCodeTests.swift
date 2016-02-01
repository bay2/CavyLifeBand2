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
        
        
        
        userNetReq.requestSecurityCode([UserNetRequestParaKey.PhoneNumKey.rawValue: "17722618598"], completionHandler: { result in
            
            let resultMsg = ["code" : "1001", "msg" : "成功"]
            
            XCTAssert(result.isSuccess, "接口返回错误")
            
            let reValue:[String:String] = result.value as! [String:String]
            
            XCTAssert(reValue == resultMsg, "返回结果错误[reValue = \(reValue), resultMsg = \(resultMsg)]")
            
            expectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }
    
    
    /**
     手机号码错误
     */
    func testPhoneNumErrSecurityCode() {
        
        let phoneNums = ["11111", "asdfadfs", "1111asdfsdf"]
        
        for phoneNum in phoneNums {
            
            userNetReq.requestSecurityCode([UserNetRequestParaKey.PhoneNumKey.rawValue: phoneNum], completionHandler: { result in
                
                XCTAssert(result.isFailure, "接口返回错误(\(phoneNum))")
                
                XCTAssert(result.error == UserRequestErrorType.PhoneErr, "接口返回错误(\(phoneNum))")
                
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
