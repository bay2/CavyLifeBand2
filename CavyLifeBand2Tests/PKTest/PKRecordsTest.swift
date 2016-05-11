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
import RealmSwift
@testable import CavyLifeBand2

class PKRecordsTest: XCTestCase, PKRecordsRealmModelOperateDelegate {
   
    var loginUserId: String = "12"
    
    var realm: Realm = try! Realm()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        stub(isMethodPOST()) { _ in
            
            let stubPath = OHPathForFile("PK_RecordsList.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }
        
        Log.info("\(realm.configuration.fileURL)")
        
    
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
        
        do {
            
            let expectation = expectationWithDescription("testGetPKRecords succeed")
            
            try PKWebApi.shareApi.getPKRecordList(self.loginUserId) {(result) in
                
                
                XCTAssertTrue(result.isSuccess)
                
                let resultMsg = try! PKRecordList(JSONDecoder(result.value!))
                
                //验证打桩数据个数正确
                XCTAssertTrue(resultMsg.commonMsg.code == WebApiCode.Success.rawValue)
                
                XCTAssertTrue(resultMsg.waitList.count == 2)
                
                XCTAssertTrue(resultMsg.dueList.count == 1)
                
                XCTAssertTrue(resultMsg.finishList.count == 2)
                
                //转换数据
                let waitRecordsRealm: [PKWaitRealmModel]  = resultMsg.waitList.map {
                    return PKWaitRealmModel(loginUserId: self.loginUserId, model: $0)
                }
                
                let dueRecordsRealm: [PKDueRealmModel] = resultMsg.dueList.map {
                    return PKDueRealmModel(loginUserId: self.loginUserId, model: $0)
                }
                
                let finishRecordsRealm: [PKFinishRealmModel] = resultMsg.finishList.map {
                    return PKFinishRealmModel(loginUserId: self.loginUserId, model: $0)
                }
                
                //验证打桩数据转成数据库数据并且存储成功
            
                self.deletePKRecordsRealm(PKWaitRealmModel.self)
                self.deletePKRecordsRealm(PKDueRealmModel.self)
                self.deletePKRecordsRealm(PKFinishRealmModel.self)
                
                XCTAssertTrue(self.queryPKDueRecordsRealm().count == 0)
                XCTAssertTrue(self.queryPKWaitRecordsRealm().count == 0)
                XCTAssertTrue(self.queryPKFinishRecordsRealm().count == 0)
                
                self.savePKRecordsRealm(waitRecordsRealm)
                self.savePKRecordsRealm(dueRecordsRealm)
                self.savePKRecordsRealm(finishRecordsRealm)
                
                XCTAssertTrue(self.queryPKDueRecordsRealm().count == 1)
                XCTAssertTrue(self.queryPKWaitRecordsRealm().count == 2)
                XCTAssertTrue(self.queryPKFinishRecordsRealm().count == 2)
                
                expectation.fulfill()
                
            }
            
            waitForExpectationsWithTimeout(timeout, handler: nil)
            
        } catch let error {
            
            Log.warning("弹框提示失败\(error)")
            
        }
        
       

    }
    
}
