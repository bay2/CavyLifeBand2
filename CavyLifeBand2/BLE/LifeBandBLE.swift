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
        centraManager?.scanForPeripheralsWithServices(nil, options: nil)
        
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String: AnyObject], RSSI: NSNumber) {
        
        Log.error("device: \(peripheral)")
        Log.error("advertisementData: \(advertisementData)")
        
    }
    
}