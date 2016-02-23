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
        
        let phoneNumPara = [UserNetRequsetKey.PhoneNum.rawValue: "18611236633",
            UserNetRequsetKey.Passwd.rawValue: "123456",
            UserNetRequsetKey.SecurityCode.rawValue: "123456"]
        
        let emailPara = [UserNetRequsetKey.Email.rawValue: "sdfasdw@qq.com",
            UserNetRequsetKey.Passwd.rawValue: "123456",
            UserNetRequsetKey.SecurityCode.rawValue: "nsd2"]
        
        let expectationResult = ["code": "1001", "msg": "成功"]
        
        let expectation1 = expectationWithDescription("testForgotPasswdOk succeed")
        
        userNetReq.forgotPasswd(phoneNumPara) { (result) -> Void in
            
            XCTAssert(result.isSuccess, "返回值不正确")
            
            do {
                
                let resultVar = try CommenMsg(JSONDecoder(result.value!))
                XCTAssert(resultVar.code == expectationResult["code"], "返回结果错误[code] = \(resultVar.code), 期望值[code] = \(expectationResult["code"])")
                XCTAssert(resultVar.msg == expectationResult["msg"], "返回结果错误[msg] = \(resultVar.msg), 期望值[msg] = \(expectationResult["msg"])")
                
            } catch {
                XCTAssert(false)
            }
            
            expectation1.fulfill()
            
        }
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
        let expectation2 = expectationWithDescription("testForgotPasswdOk succeed")
        
        userNetReq.forgotPasswd(emailPara) { (result) -> Void in
            
             XCTAssert(result.isSuccess, "返回值不正确")
            
            do {
                
                let resultVar = try CommenMsg(JSONDecoder(result.value!))
                XCTAssert(resultVar.code == expectationResult["code"], "返回结果错误[code] = \(resultVar.code), 期望值[code] = \(expectationResult["code"])")
                XCTAssert(resultVar.msg == expectationResult["msg"], "返回结果错误[msg] = \(resultVar.msg), 期望值[msg] = \(expectationResult["msg"])")
                
            } catch {
                XCTAssert(false)
            }
            
            expectation2.fulfill()
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }
    
    /**
     手机邮箱都未空
     */
    func testForgotPasswdPhoneEmailIsNil() {
        
        let samplePara = [[UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
        [UserNetRequsetKey.Passwd.rawValue: "126879", UserNetRequsetKey.SecurityCode.rawValue: "122316"],
        [UserNetRequsetKey.Passwd.rawValue: "126879", UserNetRequsetKey.SecurityCode.rawValue: "sdfe"]]
        
        
        for para in samplePara {
            
            let expectation = expectationWithDescription("testForgotPasswdPhoneEmailIsNil succeed")
            
            userNetReq.forgotPasswd(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "返回结果不正确")
                
                XCTAssert(result.error == UserRequestErrorType.ParaErr, "返回错误码 = \(result.error) , 期望错误码 = \(UserRequestErrorType.ParaErr)")
                
                expectation.fulfill()
                
            })
            
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
    
    /**
     手机号码错误
     */
    func testForgotPasswdPhoneNumError() {
        
        let samplePara = [[UserNetRequsetKey.PhoneNum.rawValue: "1772239281", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
        [UserNetRequsetKey.PhoneNum.rawValue: "177223928112", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
        [UserNetRequsetKey.PhoneNum.rawValue: "17722392w81", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
        [UserNetRequsetKey.PhoneNum.rawValue: "qweqqwewq@qq.com", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"]]
        
        for para in samplePara {
            
            let expectation = expectationWithDescription("testForgotPasswdPhoneNumError succeed")
            
            userNetReq.forgotPasswd(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "返回结果不正确")
                
                XCTAssert(result.error == UserRequestErrorType.PhoneErr, "返回错误码 = \(result.error), 期望错误码 = \(UserRequestErrorType.PhoneErr)")
                
                expectation.fulfill()
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
    
    /**
     邮箱错误
     */
    func testForgotPasswdEmailError() {
        
        let samplePara = [[UserNetRequsetKey.Email.rawValue: "17722983292", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "ndse"],
        [UserNetRequsetKey.Email.rawValue: "sdfwec.com", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "ndse"],
        [UserNetRequsetKey.Email.rawValue: "asdfww@qq", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "ndse"]]
        
        for para in samplePara {
            
            let expectation = expectationWithDescription("testForgotPasswdEmailError succeed")
            
            userNetReq.forgotPasswd(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "返回结果不正确")
                
                XCTAssert(result.error == UserRequestErrorType.EmailErr, "返回错误码 = \(result.error), 期望错误码 = \(UserRequestErrorType.EmailErr)")
                
                expectation.fulfill()
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
    }
    
    /**
     密码错误
     */
    func testForgotPasswdPasswdError() {
        
        let samplePara = [[UserNetRequsetKey.PhoneNum.rawValue: "17712336211", UserNetRequsetKey.Passwd.rawValue: "12345", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
        [UserNetRequsetKey.PhoneNum.rawValue: "17712336211", UserNetRequsetKey.Passwd.rawValue: "12345678901112131", UserNetRequsetKey.SecurityCode.rawValue: "123456"],
        [UserNetRequsetKey.Email.rawValue: "sdfse@qq.com", UserNetRequsetKey.Passwd.rawValue: "12345", UserNetRequsetKey.SecurityCode.rawValue:"suwf"],
        [UserNetRequsetKey.Email.rawValue: "sdfse@qq.com", UserNetRequsetKey.Passwd.rawValue: "12345678901112131", UserNetRequsetKey.SecurityCode.rawValue:"3jse"]]
        
        for para in samplePara {
            
            let expectation = expectationWithDescription("testForgotPasswdPasswdError succeed")
            
            userNetReq.forgotPasswd(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "返回结果不正确")
                
                XCTAssert(result.error == UserRequestErrorType.PassWdErr, "返回错误码 = \(result.error), 期望错误码 = \(UserRequestErrorType.PassWdErr)")
                
                expectation.fulfill()
                
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
   
    /**
     验证码错误
     */
    func testForgotPasswdSecutityCodeError() {
        
        let samplePara = [[UserNetRequsetKey.PhoneNum.rawValue: "17712336211", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "12345"],
            [UserNetRequsetKey.PhoneNum.rawValue: "17712336211", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "s"],
            [UserNetRequsetKey.PhoneNum.rawValue: "17712336211", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "1234567"],
            [UserNetRequsetKey.Email.rawValue: "sdfse@qq.com", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue:"56"],
            [UserNetRequsetKey.Email.rawValue: "sdfse@qq.com", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue:"123456"],
            [UserNetRequsetKey.Email.rawValue: "sdfse@qq.com", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue:"12345d"],
            [UserNetRequsetKey.Email.rawValue: "sdfse@qq.com", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue:"34567"]]
        
        for para in samplePara {
            
            let expectation = expectationWithDescription("testForgotPasswdSecutityCodeError succeed")
            
            userNetReq.forgotPasswd(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "返回结果不正确")
                
                XCTAssert(result.error == UserRequestErrorType.SecurityCodeErr, "返回错误码 = \(result.error), 期望错误码 = \(UserRequestErrorType.SecurityCodeErr)")
                
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
