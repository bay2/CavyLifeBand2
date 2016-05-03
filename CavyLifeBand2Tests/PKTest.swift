//
//  PKTest.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest
import OHHTTPStubs
import JSONJoy
@testable import CavyLifeBand2

class PKTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        stub(containsQueryParams(["cmd": "getPKRecordList"])) { _ in
            
            let stubPath = OHPathForFile("PK_RecordsList.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetPKRecords() {
        
        let loginId = "12"
        
        do {
        
            try PKWebApi.shareApi.getPKRecordList(loginId) {(result) in
                
                XCTAssertTrue(result.isSuccess)
                
                let resultMsg = try! PKRecordList(JSONDecoder(result.value!))
                
                XCTAssertTrue(resultMsg.commonMsg?.code == WebApiCode.Success.rawValue)
                
                XCTAssertTrue(resultMsg.waitList?.count == 2)
                
                XCTAssertTrue(resultMsg.waitList![0] is PKWaitRecord)
 
            }
            
        } catch let error {
            
            Log.warning("弹框提示失败\(error)")
            
        }
    }
    
}
