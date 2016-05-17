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

extension LifeBandBleDelegate {
    
    func bleMangerState(bleState: CBCentralManagerState) {}
    
}


class LifeBandBle: NSObject {
    
    static var shareInterface = LifeBandBle()
    
    var lifeBandBleDelegate: LifeBandBleDelegate?
    
    var centraManager: CBCentralManager?
    
    private var peripheral: CBPeripheral!
    
    private var peripheralName: String = ""
    
    private var sendCharacteristic: CBCharacteristic!
    
    private var revcCharacteristic: CBCharacteristic!
    
    private var connectComplete: (Void -> Void)?
    
    private var bindingComplete: (String -> Void)?
    
    override init() {
        
        super.init()
        
        Log.error("LifeBandBle")
        centraManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    func startScaning() {
        
        Log.error("startScaning")
        centraManager?.scanForPeripheralsWithServices(nil, options: nil)
        
    }
    
    func stopScaning() {
        centraManager?.stopScan()
    }
    
    /**
     手环连接
     
     - parameter peripheralName:  手环名
     - parameter connectComplete: 回调
     */
    func bleConnect(peripheralName: String, connectComplete: (Void -> Void)? = nil) {
        
        self.connectComplete = connectComplete
        
        self.peripheralName = peripheralName
        
        self.startScaning()
        
    }
    
    /**
     断开连接
     */
    func bleDisconnect() {
        
        self.centraManager?.cancelPeripheralConnection(self.peripheral)
        
    }
    
    /**
     手环绑定
     
     - parameter bindingComplete: 回调
     */
    func bleBinding(bindingComplete: (String -> Void)? = nil) {
        
        self.bindingComplete = bindingComplete
        
        self.startScaning()
        
    }
    
    private func connect(central: CBCentralManager, peripheral: CBPeripheral) {
        
        self.peripheral = peripheral
        peripheral.delegate = self
        central.connectPeripheral(peripheral, options: nil)
        
    }
    
}

extension LifeBandBle: CBCentralManagerDelegate {
    
    /**
     蓝牙状态更新
     
     - parameter central:
     */
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        lifeBandBleDelegate?.bleMangerState(central.state)
        
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        self.connectComplete?()
        
        peripheral.discoverServices(nil)
        
        central.stopScan()
        
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
        Log.error("Fail connect to: \(peripheral.name)")
        
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String: AnyObject], RSSI: NSNumber) {
        
        //连接设备
        if peripheral.name == peripheralName {
            
            connect(central, peripheral: peripheral)
            return
            
        }
        
        guard let advertData = advertisementData["kCBAdvDataManufacturerData"] as? NSData else {
            return
        }
        
        let data = advertData.arrayOfBytes()
        
        // 1 为点击绑定标识
        guard data.last == 1 else {
            return
        }
        
        Log.error("advertisementData: \(advertData.toHexString())")
        
        bindingComplete?(peripheral.name ?? "")
        
    }
    
}

extension LifeBandBle: CBPeripheralDelegate {
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        
        guard let services = peripheral.services else {
            return
        }
        
        _ = services.map { service -> CBService in
            
            if service.UUID.isEqual(CBUUID(string: serviceUUID)) {
                peripheral.discoverCharacteristics(nil, forService: service)
            }
            
            return service
        }
        
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        guard service.UUID.isEqual(CBUUID(string: serviceUUID)) else {
            return
        }
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        _ = characteristics.map { (chara) -> CBCharacteristic in
            
            if chara.UUID.isEqual(CBUUID(string: sendCommandCharacteristicUUID)) {
                sendCharacteristic = chara
            }
            
            if chara.UUID.isEqual(CBUUID(string: revcCommandCharacteristicUUID)) {
                revcCharacteristic = chara
            }
            
            peripheral.setNotifyValue(true, forCharacteristic: chara)
            
            return chara
        }
        
    }
    
}