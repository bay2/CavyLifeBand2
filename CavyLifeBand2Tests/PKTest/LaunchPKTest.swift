//
//  LaunchPKTest.swift
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

class LaunchPKTest: XCTestCase, PKRecordsRealmModelOperateDelegate, PKWebRequestProtocol {
    
    var loginUserId: String = "12"
    
    var realm: Realm = try! Realm()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        stub(isMethodPOST()) { _ in
            
            let stubPath = OHPathForFile("Launch_PK_Single.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }
        
        self.deletePKRecordsRealm(PKWaitRealmModel.self)
        self.deletePKRecordsRealm(PKDueRealmModel.self)
        self.deletePKRecordsRealm(PKFinishRealmModel.self)
        
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
    
    func testLaunchPK() {
        
        let expectation = expectationWithDescription("testLaunchPK succeed")
        
        let pkWaitRealmModel: PKWaitRealmModel = PKWaitRealmModel()
        pkWaitRealmModel.loginUserId = self.loginUserId
        pkWaitRealmModel.syncState = PKRecordsRealmSyncState.NotSync.rawValue
        pkWaitRealmModel.userId = "103"
        pkWaitRealmModel.nickname = "Bat"
        pkWaitRealmModel.avatarUrl = ""
        pkWaitRealmModel.type = PKWaitType.MeWaitOther.rawValue
        pkWaitRealmModel.isAllowWatch = PKAllowWatchState.OtherNoWatch.rawValue
        pkWaitRealmModel.pkDuration = "3"
        
        launchPK([pkWaitRealmModel], loginUserId: self.loginUserId, callBack: {
            
            self.deletePKRecordsRealm(PKWaitRealmModel.self)
            
            XCTAssertTrue(self.queryPKWaitRecordsRealm().count == 0)
            
            let pkId = $0[0]
            
            pkWaitRealmModel.launchedTime = "2016-05-03 12:00:00"
            pkWaitRealmModel.pkId         = pkId
            pkWaitRealmModel.syncState    = PKRecordsRealmSyncState.Synced.rawValue
            
            self.addPKWaitRealm(pkWaitRealmModel)
            
            XCTAssertTrue(self.queryPKWaitRecordsRealm().count == 1)
            
            expectation.fulfill()
            
        }, failure: {(errorMsg) in
            
            XCTFail("网络请求失败")
            
            expectation.fulfill()
        
        })
        
        waitForExpectationsWithTimeout(timeout, handler: nil)
    
    }
    
}
