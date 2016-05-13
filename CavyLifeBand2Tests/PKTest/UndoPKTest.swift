//
//  UndoPKTest.swift
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

class UndoPKTest: XCTestCase, PKRecordsRealmModelOperateDelegate, PKWebRequestProtocol {
    
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
    
    func testUndoPKWithPKId() {
        
        let pkWaitA: PKWaitRealmModel = PKWaitRealmModel()
        pkWaitA.pkId = "101"
        pkWaitA.loginUserId = self.loginUserId
        pkWaitA.userId = "101"
        pkWaitA.nickname = "IronMan"
        pkWaitA.launchedTime = "2016-05-03 12:00:00"
        pkWaitA.pkDuration = "3"
        pkWaitA.type = PKWaitType.OtherWaitMe.rawValue
        
        self.deletePKRecordsRealm(PKWaitRealmModel.self)
        
        XCTAssertTrue(self.queryPKWaitRecordsRealm().count == 0)
        
        self.addPKWaitRealm(pkWaitA)
        
        XCTAssertTrue(self.queryPKWaitRecordsRealm().count == 1)
        
        updatePKWaitRealm(pkWaitA, updateType: PKRecordsRealmUpdateType.UndoWait)
        
        XCTAssertTrue(pkWaitA.type == PKWaitType.UndoWait.rawValue)
        XCTAssertTrue(pkWaitA.syncState == PKRecordsRealmSyncState.NotSync.rawValue)
        
        let expectation = expectationWithDescription("testGetPKRecords succeed")
        
        undoPK([pkWaitA], loginUserId: self.loginUserId, callBack: {
            self.syncPKRecordsRealm(PKWaitRealmModel.self, pkId: pkWaitA.pkId)
            
            XCTAssertTrue(pkWaitA.syncState == PKRecordsRealmSyncState.Synced.rawValue)
            
            expectation.fulfill()
            
        }, failure: {(errorMsg) in
                
            XCTFail("网络请求错误" + errorMsg)
            
            expectation.fulfill()
                
        })
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }
    
    func testUndoPKWithoutID() {
        
        let pkWaitB: PKWaitRealmModel = PKWaitRealmModel()
        pkWaitB.pkId = ""
        pkWaitB.loginUserId = self.loginUserId
        pkWaitB.userId = "101"
        pkWaitB.nickname = "IronMan"
        pkWaitB.launchedTime = "2016-05-03 12:00:00"
        pkWaitB.pkDuration = "3"
        pkWaitB.type = PKWaitType.OtherWaitMe.rawValue
        
        self.deletePKRecordsRealm(PKWaitRealmModel.self)
        
        XCTAssertTrue(self.queryPKWaitRecordsRealm().count == 0)
        
        self.addPKWaitRealm(pkWaitB)
        
        XCTAssertTrue(self.queryPKWaitRecordsRealm().count == 1)
        
        updatePKWaitRealm(pkWaitB, updateType: PKRecordsRealmUpdateType.UndoWait)
        
        XCTAssertTrue(self.queryPKWaitRecordsRealm().count == 0)
    }
    
}
