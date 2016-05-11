//
//  DeletePKTest.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest
import OHHTTPStubs
import JSONJoy
import RealmSwift
@testable import CavyLifeBand2

class DeletePKTest: XCTestCase, PKRecordsRealmModelOperateDelegate, PKWebRequestProtocol {
    
    var loginUserId: String = "12"
    
    var realm: Realm = try! Realm()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        stub(isMethodPOST()) { _ in
            
            let stubPath = OHPathForFile("PK_OK.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDeletePK() {
        
        
        let finishRealm: PKFinishRealmModel = PKFinishRealmModel()
        
        finishRealm.pkId = "102"
        finishRealm.loginUserId = self.loginUserId
        finishRealm.userId = "111"
        finishRealm.nickname = "IronMan"
        finishRealm.completeTime = "2016-05-02 12:00:00"
        finishRealm.pkDuration = "3"
        
        let expectation = expectationWithDescription("testDeletePK succeed")
        
        
        self.deletePKRecordsRealm(PKFinishRealmModel.self)
        
        XCTAssertTrue(self.queryPKFinishRecordsRealm().count == 0)
        
        let finishList: [PKFinishRealmModel] = [finishRealm]
        
        self.savePKRecordsRealm(finishList)
        
        XCTAssertTrue(self.queryPKFinishRecordsRealm().count == 1)
        
        updatePKFinishRealm(finishRealm)
        
        XCTAssertTrue(finishRealm.syncState == PKRecordsRealmSyncState.NotSync.rawValue)
        XCTAssertTrue(finishRealm.isDelete == true)
        
        //调接口把删除操作同步到服务器
        deletePKFinish([finishRealm], loginUserId: self.loginUserId, callBack: {
            
            self.syncPKRecordsRealm(PKFinishRealmModel.self, pkId: finishRealm.pkId)
            
            XCTAssertTrue(finishRealm.syncState == PKRecordsRealmSyncState.Synced.rawValue)
            
            expectation.fulfill()
            
        }, failure: {(erreoMsg) in
            XCTFail("网络请求错误" + erreoMsg)
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }
    
}
