//
//  UploadPicture.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/23.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Alamofire
import JSONJoy
@testable import CavyLifeBand2

class UploadPicture: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        stub(isMethodPOST()) { _ in
            
            let stubPath = OHPathForFile("UploadPicture_Ok.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
        
    }
    
    /**
     上传头像
     */
    func testUploadPictureOk() {
        
        let image = UIImage(named: "flash_automatic")
        
        let casePara: [[String: AnyObject]] = [[UserNetRequsetKey.UserID.rawValue: "1", UserNetRequsetKey.Avater.rawValue: image!],
            [UserNetRequsetKey.UserID.rawValue: "2", UserNetRequsetKey.Avater.rawValue: image!]]
        
        let expectationResult = ["code": "1001", "msg": "成功"]
        
        for para in casePara {
            
            let expectation = expectationWithDescription("testUploadPictureOk succeed")
            
            userNetReq.uploadPicture(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isSuccess, "返回值不正确")
                
                do {
                    
                    let realResult = try CommenMsg(JSONDecoder(result.value!))
                    
                    XCTAssert(expectationResult["code"] == realResult.code, "实际值 = \(realResult.code), 期望值 = \(expectationResult["code"])")
                    XCTAssert(expectationResult["msg"] == realResult.msg, "实际值 = \(realResult.msg), 期望值 = \(expectationResult["msg"])")
                    
                    
                } catch {
                    
                    XCTAssert(false)
                }
                
                
                expectation.fulfill()
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
    
    /**
     用户ID为空
     */
    func testUploadPictureUserIDNil() {
        
        let image = UIImage(named: "flash_automatic")
        
        let casePara: [[String: AnyObject]] = [[UserNetRequsetKey.UserID.rawValue: "1", UserNetRequsetKey.Avater.rawValue: image!]]
        
        for para in casePara {
            
            let expectation = expectationWithDescription("testUploadPictureOk succeed")
            
            userNetReq.uploadPicture(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "返回值不正确")
                
                XCTAssert(result.error == UserRequestErrorType.ParaErr, "实际值 = \(result.error), 期望值 = \(UserRequestErrorType.ParaErr)")
                
                expectation.fulfill()
            })
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        }
        
    }
    
    func testUploadPictureAvaterNil() {
        
        let casePara: [[String: AnyObject]] = [[UserNetRequsetKey.UserID.rawValue: "1"], [UserNetRequsetKey.UserID.rawValue: "2"]]
        
        
        for para in casePara {
            
            let expectation = expectationWithDescription("testUploadPictureOk succeed")
            
            userNetReq.uploadPicture(para, completionHandler: { (result) -> Void in
                
                XCTAssert(result.isFailure, "返回值不正确")
                
                XCTAssert(result.error == UserRequestErrorType.ParaErr, "实际值 = \(result.error), 期望值 = \(UserRequestErrorType.ParaErr)")
                    
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
