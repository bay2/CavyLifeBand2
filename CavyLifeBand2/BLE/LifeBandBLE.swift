//
//  LifeBandBLE.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import CoreBluetooth
import EZSwiftExtensions

let serviceUUID = "14839AC4-7D7E-415C-9A42-167340CF2339"
let sendCommandCharacteristicUUID = "8B00ACE7-EB0B-49B0-BBE9-9AEE0A26E1A3"
let revcCommandCharacteristicUUID = "0734594A-A8E7-4B1A-A6B1-CD5243059A57"

/**
 *  手环绑定控制结构
 */
struct BindBandCtrl {
    
    static var bandName = ""
    static var bindScene: BindScene = .SignUpBind
    
}

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
    
    private var peripheral: CBPeripheral?
    
    private var peripheralName: String = ""
    
    private var sendCharacteristic: CBCharacteristic?
    
    private var revcCharacteristic: CBCharacteristic?
    
    private var connectComplete: (Void -> Void)?
    
    private var bindingComplete: (String -> Void)?
    
    // 蓝牙消息发送队列
    private var writeToPeripheralQueue: [String] = []
    
    // 蓝牙消息处理回调
    private var peripheralResponsd: [UInt8: (NSData -> Void)] = [:]
    

// MARK: - 初始化
    
    override init() {
        
        super.init()
        
        Log.error("LifeBandBle")
        centraManager = CBCentralManager(delegate: self, queue: nil)
        initSendToBandQueue()
        
    }
    
// MARK: - 蓝牙消息发送处理
    
    /**
     初始化发送手环消息队列
     */
    private func initSendToBandQueue() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            while(true) {
                
                NSThread.sleepForTimeInterval(1)
                
                guard let characteristic = self.sendCharacteristic else {
                    continue
                }
                
                guard self.peripheral?.state == .Connected else {
                    continue
                }
                
                guard let firstData =  self.writeToPeripheralQueue.get(0) else {
                    continue
                }
                
                guard let data = firstData.dataUsingEncoding(NSUTF8StringEncoding) else {
                    continue
                }
                
                self.peripheral?.writeValue(data, forCharacteristic: characteristic, type: .WithoutResponse)
                
                self.writeToPeripheralQueue.removeAtIndex(0)
                
            }
            
        }
        
    }
    
    
    /**
     通过蓝牙给手环发送消息
     
     - parameter msg: 消息内容
     */
    func sendMsgToBand(msg: String) -> Self {
        
        Log.info("sendMsgToBand msg = \(msg)")
        writeToPeripheralQueue.append(msg)
        return self
        
    }
    
    /**
     安装接受处理
     
     - parameter cmd:     命令字 (cmd不能为0)
     - parameter msgProc: 处理回调
     */
    func installCmd(cmd: UInt8, msgProc: (NSData -> Void)) -> Self {
        
        if cmd == 0 {
            return self
        }
        
        peripheralResponsd[cmd] = msgProc
        
        return self
        
    }
    

// MARK: - 扫描蓝牙设备
    
    /**
     扫描附近蓝牙设备
     */
    func startScaning() {
        
        Log.error("startScaning")
        centraManager?.scanForPeripheralsWithServices(nil, options: nil)
        
    }
    
    /**
     停止扫描
     */
    func stopScaning() {
        centraManager?.stopScan()
    }

// MARK: - 手环连接绑定
    
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
        
        guard let peripheral = self.peripheral else {
            return
        }
        
        peripheralName = ""
        
        self.centraManager?.cancelPeripheralConnection(peripheral)
        
    }
    
    /**
     手环绑定
     
     - parameter bindingComplete: 回调
     */
    func bleBinding(bindingComplete: (String -> Void)? = nil) {
        
        self.bindingComplete = bindingComplete
        
        self.startScaning()
        
    }
    
    /**
     手环连接
     
     - parameter central:    控制中心
     - parameter peripheral: 设备
     */
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
        
        _ = characteristics.map { chara -> CBCharacteristic in
            
            if chara.UUID.isEqual(CBUUID(string: sendCommandCharacteristicUUID)) {
                self.connectComplete?()
                sendCharacteristic = chara
            }
            
            if chara.UUID.isEqual(CBUUID(string: revcCommandCharacteristicUUID)) {
                revcCharacteristic = chara
            }
            
            peripheral.setNotifyValue(true, forCharacteristic: chara)
            
            return chara
        }
        
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        guard let data = characteristic.value else {
            return
        }
        
        let dataArray = data.arrayOfBytes()
        
        guard dataArray[0] == 36 else {
            return
        }

        guard let responsd = peripheralResponsd[dataArray[1]] else {
            return
        }
        
        responsd(data)
        
    }
    
}