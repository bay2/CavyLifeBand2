//
//  SecurityCodeTest.swift
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

class SecurityCodeTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
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
     请求发送短信验证码
     */
    func testSecurityCodeOk() {
        
        let samplePara = [[UserNetRequsetKey.PhoneNum.rawValue: "17767894566"],
            [UserNetRequsetKey.PhoneNum.rawValue: "17722334466"]]
        
        let expectationResult = ["code": "0000", "msg": "success"]
        
        for para in samplePara {
            
            let expectation = expectationWithDescription("testSecurityCodeOk succeed")
            
            UserNetRequestData.shareApi.requestPhoneSecurityCode(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "返回值不正确")
                
                do {
                    
                    let resultVar = try CommenMsg(JSONDecoder(result.value!))
                    
                    XCTAssert(resultVar.code == expectationResult["code"])
                    XCTAssert(resultVar.msg == expectationResult["msg"])
                    
                    
                } catch {
                    XCTAssert(false)
                }
                
                expectation.fulfill()
                
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
        }
        
        
    }
    
    func testSecurityCodePhoneError() {
        
        let samplePara = [[UserNetRequsetKey.PhoneNum.rawValue: "1776789456"],
        [UserNetRequsetKey.PhoneNum.rawValue: "sdfqwe"],
        [UserNetRequsetKey.PhoneNum.rawValue: "177678945666"]]
        
        
        for para in samplePara {
            
            let expectation = expectationWithDescription("testSecurityCodePhoneError succeed")
            
            UserNetRequestData.shareApi.requestPhoneSecurityCode(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "返回值不正确")
                
                XCTAssert(result.error == UserRequestErrorType.PhoneErr, "实际返回值 = \(result.error), 期望返回值 = \(UserRequestErrorType.PhoneErr)")
                
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
