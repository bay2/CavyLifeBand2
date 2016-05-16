//
//  LifeBandBLE.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import CoreBluetooth

let serviceUUID = "14839AC4-7D7E-415C-9A42-167340CF2339"
let sendCommandCharacteristicUUID = "8B00ACE7-EB0B-49B0-BBE9-9AEE0A26E1A3"
let revcCommandCharacteristicUUID = "0734594A-A8E7-4B1A-A6B1-CD5243059A57"

protocol LifeBandBleDelegate {
    
    func bleMangerState(bleState: CBCentralManagerState)
    
}


class LifeBandBle: NSObject, CBCentralManagerDelegate {
    
    static var shareInterface = LifeBandBle()
    
    var lifeBandBleDelegate: LifeBandBleDelegate?
    
    var centraManager: CBCentralManager?
    
    var peripheral: CBPeripheral!
    
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
        
        
        guard let advertData = advertisementData["kCBAdvDataManufacturerData"] as? NSData else {
            return
        }
        
        let data = advertData.arrayOfBytes()
        
        guard data.last == 1 else {
            return
        }
        
        Log.error("advertisementData: \(advertData.toHexString())")
        self.peripheral = peripheral
        self.peripheral.delegate = self
        central.connectPeripheral(peripheral, options: nil)
        
        
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        Log.error("Connect to \(peripheral.name)")
        peripheral.discoverServices(nil)
        Log.error("CBPeripheralState is \(peripheral.state)")
        central.stopScan()
        
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
        Log.error("Fail connect to: \(peripheral.name)")
        
    }
    
}

extension LifeBandBle: CBPeripheralDelegate {
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        guard let services = peripheral.services else {
            return
        }
        
        _ = services.map { service -> CBService in
            
            if service.UUID.isEqual(CBUUID(string: serviceUUID)) {
                peripheral.discoverServices(nil)
//                peripheral.discoverCharacteristics(nil, forService: service)
            }
            
            return service
        }
        
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        guard service.UUID.isEqual(CBUUID(string: serviceUUID)) else {
            return
        }
        
        _ = service.characteristics.map {
            $0.map {
                return $0
            }
        }
        
    }
    
}