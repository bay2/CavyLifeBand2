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
let timeout: NSTimeInterval = 30.0

class SignUpTest: XCTestCase {
    
    override func setUp() {
        
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        stub(isMethodPOST()) { _ in
            
            let stubPath = OHPathForFile("Sign_Up_Ok.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
    }

    /**
     手机注册ok
     */
    func testSignUpPhoneOk() {
        
        let paras = [[UserNetRequsetKey.PhoneNum.rawValue: "17722112322", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"]]
        
        for para in paras {
            
            let expectation = expectationWithDescription("testSignUpPhoneOk succeed")
            
            userNetReq.requestSignUp(para, completionHandler: { (result) -> Void in
                
                let resultMsg = ["code" : "1001", "msg" : "注册成功"]
                
                XCTAssert(result.isSuccess, "接口返回错误")
            
                let reValue: CommonResphones = result.value as! CommonResphones
                
                XCTAssert(reValue.code == resultMsg["code"], "返回结果错误[reValue.code = \(reValue.code), resulMsgObj!.code = \(resultMsg["code"])]")
                XCTAssert(reValue.msg == resultMsg["msg"], "返回结果错误[reValue.msg = \(reValue.msg), resulMsgObj!.msg = \(resultMsg["msg"])]")
                
                expectation.fulfill()
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
        }
        
        
    }
    
    /**
     邮件注册ok
     */
    func testSignUpEmailOk() {
        
        let paras = [[UserNetRequsetKey.Email.rawValue: "asdfwq@qq.com", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"]]
        
        for para in paras {
            
            let expectation = expectationWithDescription("testSignUpEmailOk succeed")
            
            userNetReq.requestSignUp(para, completionHandler: { (result) -> Void in
                
                let resultMsg = ["code" : "1001", "msg" : "注册成功"]
                
                XCTAssert(result.isSuccess, "接口返回错误")
            
                let reValue: CommonResphones = result.value as! CommonResphones
                
                XCTAssert(reValue.code == resultMsg["code"], "返回结果错误[reValue.code = \(reValue.code), resulMsgObj!.code = \(resultMsg["code"])]")
                XCTAssert(reValue.msg == resultMsg["msg"], "返回结果错误[reValue.msg = \(reValue.msg), resulMsgObj!.msg = \(resultMsg["msg"])]")
                
                expectation.fulfill()
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
 
    
    /**
     注册缺少参数
     */
    func testSignUpParaErr() {
        
        let paras = [[UserNetRequsetKey.PhoneNum.rawValue: "17722382211", UserNetRequsetKey.Passwd.rawValue: "123"],                         // 没有验证码
                    [UserNetRequsetKey.PhoneNum.rawValue: "17722382211", UserNetRequsetKey.SecurityCode.rawValue: "123456"],                 // 没有密码
                    [UserNetRequsetKey.Passwd.rawValue: "123", UserNetRequsetKey.SecurityCode.rawValue: "123456"]]                             // 没有手机号码和邮箱
        
        
        for para in paras {
            
            let expectation = expectationWithDescription("testSignUpParaErr succeed")
            
            userNetReq.requestSignUp(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.ParaErr, "返回结果错误[error = \(result.error)]")
                expectation.fulfill()
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
        }
        
        
    }
    
    /**
     注册手机号错误
     */
    func testSignUpPhoneErr() {
        
        let paras = [[UserNetRequsetKey.PhoneNum.rawValue: "1722112322", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
                    [UserNetRequsetKey.PhoneNum.rawValue: "17w22112o22", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
                    [UserNetRequsetKey.PhoneNum.rawValue: "adfasdfsfss", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"]
        ]
        
        for para in paras {
            
            let expectation = expectationWithDescription("testSignUpPhoneErr succeed")
            
            userNetReq.requestSignUp(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.PhoneErr, "返回结果错误[error = \(result.error)]")
                
                expectation.fulfill()
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
        }
    }
    
    /**
     注册邮箱错误
     */
    func testSignUpEmailErr() {
        
        let paras = [[UserNetRequsetKey.Email.rawValue: "1722112322", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
            [UserNetRequsetKey.Email.rawValue: "17w22112o22", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
            [UserNetRequsetKey.Email.rawValue: "adfasdfsfss", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
            [UserNetRequsetKey.Email.rawValue: "adfa@", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
            [UserNetRequsetKey.Email.rawValue: "adfasdfsfss@qq", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
            [UserNetRequsetKey.Email.rawValue: "adfasdfsfss@qq.", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
        ]
        
        for para in paras {
            
            let expectation = expectationWithDescription("testSignUpEmailErr succeed")
            
            userNetReq.requestSignUp(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.EmailErr, "返回结果错误[error = \(result.error)]")
                
                expectation.fulfill()
                
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
        }
    }
    
    /**
     注册密码错误
     */
    func testSignUpPwdErr() {
        
        let paras = [[UserNetRequsetKey.PhoneNum.rawValue: "17722112322", UserNetRequsetKey.Passwd.rawValue: "12345", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
            [UserNetRequsetKey.PhoneNum.rawValue: "17722112322", UserNetRequsetKey.Passwd.rawValue: "123456123498291112391", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
            [UserNetRequsetKey.Email.rawValue: "asdf@qq.com", UserNetRequsetKey.Passwd.rawValue: "12345", "authCode":"123456"],
            [UserNetRequsetKey.Email.rawValue: "asdf@qq.com", UserNetRequsetKey.Passwd.rawValue: "123456123498291112391", UserNetRequsetKey.SecurityCode.rawValue: "123456"]
        ]
        
        for para in paras {
            
            let expectation = expectationWithDescription("testSignUpParaErr succeed")
            
            userNetReq.requestSignUp(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.PassWdErr, "返回结果错误[error = \(result.error)]")
                
                expectation.fulfill()
                
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
    
    /**
     注册验证码错误
     */
    func testSecurityCodeErr() {
        
        let paras = [[UserNetRequsetKey.PhoneNum.rawValue: "17722112322", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "12456"],
            [UserNetRequsetKey.PhoneNum.rawValue: "17722112322", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "1234s6"],
            [UserNetRequsetKey.Email.rawValue: "asdf@qq.com", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "1234256"]
        ]
        
        for para in paras {
            
            let expectation = expectationWithDescription("testSecurityCodeErr Ok")
            
            userNetReq.requestSignUp(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.SecurityErr, "返回结果错误[error = \(result.error)]")
                
                expectation.fulfill()
            })
            
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
