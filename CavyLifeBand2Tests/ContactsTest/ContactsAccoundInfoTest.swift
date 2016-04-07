//
//  ContactsAccoundInfoTest.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import XCTest
import OHHTTPStubs
import JSONJoy
@testable import CavyLifeBand2

class ContactsAccoundInfoTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        stub(isMethodPOST()) { _ in
            
            let stubPath = OHPathForFile("AccountInfo_Ok.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type" : "application/json"])
            
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        OHHTTPStubs.removeAllStubs()
        
        
    }
    
    func testAccountInfo() {
        
        _ = UserNetRequsetKey.Address.rawValue 
        
//        let paras = [[UserNetRequsetKey.PhoneNum.rawValue: "17722112322", UserNetRequsetKey.Passwd.rawValue: "123456", UserNetRequsetKey.SecurityCode.rawValue: "123456"]]
        

        
        
        
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
