//
//  LifeBandBLE.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import CoreBluetooth

class LifeBandBle: NSObject, CBCentralManagerDelegate {
    
    static var shareInterface = LifeBandBle()
    
    var centraManager: CBCentralManager?
    
    override init() {
        
        super.init()
        
        centraManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
    }
    
    func startScaning() {
        
        let serviuce = [CBUUID(string: "14839AC4-7D7E-415C-9A42-167340CF2339")]
        centraManager?.scanForPeripheralsWithServices(serviuce, options: nil)
        
    }
    
}