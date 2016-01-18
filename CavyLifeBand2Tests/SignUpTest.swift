//
//  SignInTest.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/15.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Alamofire
@testable import CavyLifeBand2

class SignInTest: XCTestCase {
    
    let timeout: NSTimeInterval = 30.0
    let testUserNetRequest = UserNetRequestData()

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
    }

    func testSignUpOk() {
        
        let paras = [["phoneNum":"17722112322", "pwd":"123456", "authCode":"123456"],
                     ["email":"asdf@qq.com", "pwd":"123456", "authCode":"123456"]]
        
        let expectation = expectationWithDescription("testPhoneNumSecurityCodeOk succeed")
        
        for para in paras {
            
            testUserNetRequest.netRequestApi(.SignUp, parameters: para, completionHandler: { (result) -> Void in
                
                let resultMsg = ["code" : "1001", "msg" : "注册成功"]
                
                XCTAssert(result.isSuccess, "接口返回错误")
                
                let reValue:[String:String] = result.value as! [String:String]
                
                XCTAssert(reValue == resultMsg, "返回结果错误[reValue = \(reValue), resultMsg = \(resultMsg)]")
                
                expectation.fulfill()
                
            })
        }
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }
    
    func testSignUpParaErr() {
        
        let paras = [["phoneNum":"17722382211", "pwd":"123"],                         // 没有验证码
                    ["phoneNum":"17722382211", "autoCode":"123456"],                 // 没有密码
                    ["pwd":"123", "autoCode":"123456"]]                             // 没有手机号码和邮箱
        
        
        for para in paras {
            
            testUserNetRequest.netRequestApi(.SignUp, parameters: para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.NetErr, "返回结果错误[error = \(result.error)]")
                
            })
        }
        
        
    }
    
    func testSignUpPhoneErr() {
        
        let paras = [["phoneNum":"1722112322", "pwd":"123456", "authCode":"123456"],
                    ["phoneNum":"17w22112o22", "pwd":"123456", "authCode":"123456"],
                    ["phoneNum":"adfasdfsfss", "pwd":"123456", "authCode":"123456"]
        ]
        
        for para in paras {
            
            testUserNetRequest.netRequestApi(.SignUp, parameters: para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.PhoneErr, "返回结果错误[error = \(result.error)]")
                
            })
        }
    }
    
    func testSignUpEmailErr() {
        
        for para in paras {
            
            testUserNetRequest.netRequestApi(.SignUp, parameters: para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.PhoneErr, "返回结果错误[error = \(result.error)]")
                
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
