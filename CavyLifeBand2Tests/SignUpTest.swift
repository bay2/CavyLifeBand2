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
        
        let paras = [[UserNetRequestParaKey.PhoneNumKey.rawValue: "17722112322", UserNetRequestParaKey.PasswdKey.rawValue: "123456", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],
                     [UserNetRequestParaKey.EmailKey.rawValue: "asdf@qq.com", UserNetRequestParaKey.EmailKey.rawValue: "123456", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"]]
        
        let expectation = expectationWithDescription("testPhoneNumSecurityCodeOk succeed")
        
        for para in paras {
            
            userNetReq.requestSecurityCode(para, completionHandler: { (result) -> Void in
                
                let resultMsg = ["code" : "1001", "msg" : "注册成功"]
                
                let resulMsgObj = CommonResphones(JSON: resultMsg)
                
                XCTAssert(result.isSuccess, "接口返回错误")
            
                let reValue: CommonResphones = result.value as! CommonResphones
                
                XCTAssert(reValue.code == resulMsgObj!.code, "返回结果错误[reValue.code = \(reValue.code), resulMsgObj!.code = \(resulMsgObj!.code)]")
                XCTAssert(reValue.msg == resulMsgObj!.msg, "返回结果错误[reValue.msg = \(reValue.msg), resulMsgObj!.msg = \(resulMsgObj!.msg)]")
                
                expectation.fulfill()
            })
            
        }
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }
    
    func testSignUpParaErr() {
        
        let paras = [[UserNetRequestParaKey.PhoneNumKey.rawValue: "17722382211", UserNetRequestParaKey.PasswdKey.rawValue: "123"],                         // 没有验证码
                    [UserNetRequestParaKey.PhoneNumKey.rawValue: "17722382211", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],                 // 没有密码
                    [UserNetRequestParaKey.PasswdKey.rawValue: "123", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"]]                             // 没有手机号码和邮箱
        
        
        for para in paras {
            
            
            userNetReq.requestSecurityCode(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.NetErr, "返回结果错误[error = \(result.error)]")
                
            })
        }
        
        
    }
    
    func testSignUpPhoneErr() {
        
        let paras = [[UserNetRequestParaKey.PhoneNumKey.rawValue: "1722112322", UserNetRequestParaKey.PasswdKey.rawValue: "123456", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],
                    [UserNetRequestParaKey.PhoneNumKey.rawValue: "17w22112o22", UserNetRequestParaKey.PasswdKey.rawValue: "123456", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],
                    [UserNetRequestParaKey.PhoneNumKey.rawValue: "adfasdfsfss", UserNetRequestParaKey.PasswdKey.rawValue: "123456", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"]
        ]
        
        for para in paras {
            
            userNetReq.requestSecurityCode(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.PhoneErr, "返回结果错误[error = \(result.error)]")
                
            })
        }
    }
    
    func testSignUpEmailErr() {
        
        let paras = [[UserNetRequestParaKey.EmailKey.rawValue: "1722112322", UserNetRequestParaKey.PasswdKey.rawValue: "123456", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],
            [UserNetRequestParaKey.EmailKey.rawValue: "17w22112o22", UserNetRequestParaKey.PasswdKey.rawValue: "123456", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],
            [UserNetRequestParaKey.EmailKey.rawValue: "adfasdfsfss", UserNetRequestParaKey.PasswdKey.rawValue: "123456", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],
            [UserNetRequestParaKey.EmailKey.rawValue: "adfa@", UserNetRequestParaKey.PasswdKey.rawValue: "123456", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],
            [UserNetRequestParaKey.EmailKey.rawValue: "adfasdfsfss@qq", UserNetRequestParaKey.PasswdKey.rawValue: "123456", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],
            [UserNetRequestParaKey.EmailKey.rawValue: "adfasdfsfss@qq.", UserNetRequestParaKey.PasswdKey.rawValue: "123456", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],
        ]
        
        for para in paras {
            
            userNetReq.requestSecurityCode(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.PhoneErr, "返回结果错误[error = \(result.error)]")
                
            })
        }
    }
    
    func testSignUpPwdErr() {
        
        let paras = [[UserNetRequestParaKey.PhoneNumKey.rawValue: "17722112322", UserNetRequestParaKey.PasswdKey.rawValue: "12345", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],
            [UserNetRequestParaKey.PhoneNumKey.rawValue: "17722112322", UserNetRequestParaKey.PasswdKey.rawValue: "123456123498291112391", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"],
            [UserNetRequestParaKey.EmailKey.rawValue: "asdf@qq.com", UserNetRequestParaKey.PasswdKey.rawValue: "12345", "authCode":"123456"],
            [UserNetRequestParaKey.EmailKey.rawValue: "asdf@qq.com", UserNetRequestParaKey.PasswdKey.rawValue: "123456123498291112391", UserNetRequestParaKey.SecurityCodeKey.rawValue: "123456"]
        ]
        
        for para in paras {
            
            userNetReq.requestSecurityCode(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "接口返回错误")
                XCTAssert(result.error == UserRequestErrorType.PassWdErr, "返回结果错误[error = \(result.error)]")
                
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
