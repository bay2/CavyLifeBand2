//
//  AcceptPKTest.swift
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

class AcceptPKTest: XCTestCase, PKRecordsRealmModelOperateDelegate, PKWebRequestProtocol {
    
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
    
    func testAcceptPK() {
        
        let pkWait: PKWaitRealmModel = PKWaitRealmModel()
        pkWait.pkId = "101"
        pkWait.loginUserId = self.loginUserId
        pkWait.userId = "101"
        pkWait.nickname = "IronMan"
        pkWait.launchedTime = "2016-05-03 12:00:00"
        pkWait.pkDuration = "3"
        pkWait.type = PKWaitType.OtherWaitMe.rawValue
        
        let expectation = expectationWithDescription("testDeletePK succeed")
        
        self.deletePKRecordsRealm(PKWaitRealmModel.self)
        self.deletePKRecordsRealm(PKDueRealmModel.self)
        
        XCTAssertTrue(self.queryPKWaitRecordsRealm().count == 0)
        XCTAssertTrue(self.queryPKDueRecordsRealm().count == 0)
        
        let waitList:[PKWaitRealmModel] = [pkWait]
        
        self.savePKRecordsRealm(waitList)
        
        XCTAssertTrue(self.queryPKWaitRecordsRealm().count == 1)
        
        //将待回应记录的type改为已接受
        updatePKWaitRealm(pkWait, updateType: PKRecordsRealmUpdateType.AcceptWait)
        
        XCTAssertTrue(pkWait.type == PKWaitType.AcceptWait.rawValue)
        
        //根据待回应记录生成新的进行中记录
        let dueRealm = PKDueRealmModel()
        
        dueRealm.pkId        = pkWait.pkId
        dueRealm.loginUserId = pkWait.loginUserId
        dueRealm.userId      = pkWait.userId
        dueRealm.avatarUrl   = pkWait.userId
        dueRealm.nickname    = pkWait.nickname
        dueRealm.pkDuration  = pkWait.pkDuration
        dueRealm.beginTime   = "2016-05-03 13:00:00"
        dueRealm.syncState   = PKRecordsRealmSyncState.NotSync.rawValue
        
        //把新的进行中记录加入数据库
        addPKDueRealm(dueRealm)
        
        XCTAssertTrue(self.queryPKDueRecordsRealm().count == 1)
        
        //调接口接受PK,调接口成功后把那条刚加入数据库的进行中记录的同步状态改为已同步
        acceptPKInvitation([dueRealm], loginUserId: self.loginUserId, callBack: {
            self.syncPKRecordsRealm(PKDueRealmModel.self, pkId: dueRealm.pkId)
            
            XCTAssertTrue(dueRealm.syncState == PKRecordsRealmSyncState.Synced.rawValue)
            expectation.fulfill()
        }, failure: {(errorMsg) in
            
            XCTFail("弹框提示" + errorMsg)
            expectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
        
    }
    
}
