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
        
        let paras = [[UserNetRequsetKey.UserName.rawValue: "17722342211", UserNetRequsetKey.Passwd.rawValue: "123456"]]
        
        let expectResultMsg = ["code": "1001", "msg": "登录成功"]
        
        for para in paras {
            
            let expectation = expectationWithDescription("testSignInOk succeed")
            
            userNetReq.requestSignIn(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "返回值不正确")
                
                let reslutMsg = result.value as! CommonResphones
                
                XCTAssert(reslutMsg.code == expectResultMsg["code"], "Expect Value = [\(expectResultMsg["code"])]")
                XCTAssert(reslutMsg.msg ==  expectResultMsg["msg"], "Expect Value = [\(expectResultMsg["msg"])]")
                
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
