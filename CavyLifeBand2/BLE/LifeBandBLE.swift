//
//  LifeBandBLE.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import CoreBluetooth

protocol LifeBandBleDelegate {
    
    func bleMangerState(bleState: CBCentralManagerState)
    
}


class LifeBandBle: NSObject, CBCentralManagerDelegate {
    
    static var shareInterface = LifeBandBle()
    
    var lifeBandBleDelegate: LifeBandBleDelegate?
    
    var centraManager: CBCentralManager?
    
    override init() {
        
        super.init()
        
        Log.error("LifeBandBle")
        centraManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    /**
     蓝牙状态更新
     
     - parameter central:
     */
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        Log.error("centralManagerDidUpdateState")
        lifeBandBleDelegate?.bleMangerState(central.state)
        
    }
    
    func startScaning() {
        
        Log.error("startScaning")
        let serviuce = [CBUUID(string: "14839AC4-7D7E-415C-9A42-167340CF2339")]
        centraManager?.scanForPeripheralsWithServices(serviuce, options: nil)
        
    }
    
}