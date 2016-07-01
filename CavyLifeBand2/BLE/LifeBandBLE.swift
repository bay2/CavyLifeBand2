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

let oadServiceUUID     = "F000FFC0-0451-4000-B000-000000000000"
let oadImgIdentifyUUID = "F000FFC1-0451-4000-B000-000000000000"
let oadImgBlockUUID    = "F000FFC2-0451-4000-B000-000000000000"

/**
 *  手环绑定控制结构
 */
struct BindBandCtrl {
    
    static var bandMacAddress: NSData = NSData()
    static var bindScene: BindScene   = .SignUpBind
    static var fwVersion: Int         = 0
    
}

protocol LifeBandBleDelegate {
    
    func bleMangerState(bleState: CBCentralManagerState)
    func saveMacAddress()
    
}

extension LifeBandBleDelegate {
    
    func bleMangerState(bleState: CBCentralManagerState) {}
    
    /**
     保存mac地址
     
     - author: sim cai
     - date: 2016-06-02
     */
    func saveMacAddress() {
        
        let bindBandKey = "CavyAppMAC_" + CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
        
        CavyDefine.bindBandInfos.bindBandInfo.userBindBand[bindBandKey] = BindBandCtrl.bandMacAddress
        
        if BindBandCtrl.bandMacAddress.length == 6 {
            CavyDefine.bindBandInfos.bindBandInfo.defaultBindBand = LifeBandBle.shareInterface.getPeripheralName() + "," +
                String(format: "%02X:%02X:%02X:%02X:%02X:%02X",
                       BindBandCtrl.bandMacAddress[0],
                       BindBandCtrl.bandMacAddress[1],
                       BindBandCtrl.bandMacAddress[2],
                       BindBandCtrl.bandMacAddress[3],
                       BindBandCtrl.bandMacAddress[4],
                       BindBandCtrl.bandMacAddress[5])
        }
        
        Log.info("defaultBindBand = \(CavyDefine.bindBandInfos.bindBandInfo.defaultBindBand)")
        //        defaultBindBand = Cavy2-D525,25:D5:4B:F8:E6:A0
    }
    

    
}

enum BandBleNotificationName: String {
    
    /// 手环连接通知
    case BandConnectNotification
    
    /// 手环断开通知
    case BandDesconnectNotification
    
}


class LifeBandBle: NSObject {
    
    static var shareInterface = LifeBandBle()
    
    var lifeBandBleDelegate: LifeBandBleDelegate?
    
    var centraManager: CBCentralManager?
    
    var peripheral: CBPeripheral?
    
    private var peripheralMacAddress: NSData = NSData()
    
    private var sendCharacteristic: CBCharacteristic?
    
    private var revcCharacteristic: CBCharacteristic?
    
    private var connectComplete: (Void -> Void)?
    
    private var bindingComplete: ((String, NSData) -> Void)?
    
    // 蓝牙消息发送队列
    private var writeToPeripheralQueue: [(CBCharacteristic, NSData)] = []
    
    // 蓝牙消息处理回调
    private var peripheralResponsd: [UInt8: (NSData -> Void)] = [:]
    
    private static var isRebend = false
    
    // MARK: - 固件升级属性定义
    
    /// 是否处于更新状态
    static var isUpdataing = false
    
    /// 文件数据
    static var binData: NSData!
    
    /// 重发数据
    static var resendData: NSData = NSData()
    
    /// 期望接收的文件数据索引
    static var fileDataExIndex: Int = 0
    
    static var remainsLenght: Int = 0
    
    var oadIdenifyCharacteristic: CBCharacteristic?
    
    var oadBlockCharacteristic: CBCharacteristic?
    
    var updateFWCompletionHander: ((UpdateFirmwareReslut<Double, UpdateFirmwareError>) -> Void)?
    

// MARK: - 初始化
    
    override init() {
        
        super.init()
        
        centraManager = CBCentralManager(delegate: self, queue: nil)
        initSendToBandQueue()
        
    }
    
// MARK: - 蓝牙消息发送处理
    
    /**
     初始化发送手环消息队列
     */
    private func initSendToBandQueue() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            while true {
                
                NSThread.sleepForTimeInterval(1)
                
                guard self.peripheral?.state == .Connected else {
                    continue
                }
                
                guard let firstData =  self.writeToPeripheralQueue.get(0) else {
                    continue
                }
                
                
                self.peripheral?.writeValue(firstData.1, forCharacteristic: firstData.0, type: .WithoutResponse)
                
                self.writeToPeripheralQueue.removeAtIndex(0)
                
            }
            
        }
        
    }
    
    
    /**
     通过蓝牙给手环发送消息
     
     - parameter msg: 消息内容
     */
    func sendMsgToBand(msg: String) -> Self {
        
        guard let data = msg.dataUsingEncoding(NSUTF8StringEncoding) else {
            Log.error("sendMsgToBand error")
            return self
        }
        
        guard let characteristic = self.sendCharacteristic else {
            Log.error("sendMsgToBand error")
            return self
        }
        
        Log.info("sendMsgToBand msg = \(msg)")
        
        writeToPeripheralQueue.append((characteristic, data))
        
        return self
        
    }
    
    /**
     升级发送接口
     
     - author: sim cai
     - date: 2016-06-02
     
     - parameter data: 数据
     - parameter mode: 模式
     */
    func oadSendToBand(data: NSData, mode: Int) {
        
        guard let oadIdenifyCharacteristic = self.oadIdenifyCharacteristic, oadBlockCharacteristic = self.oadBlockCharacteristic else {
            Log.error("oadSendToBand error")
            return
        }
        
        if mode == 0 {
            self.peripheral?.writeValue(data, forCharacteristic: oadIdenifyCharacteristic, type: .WithoutResponse)
//            writeToPeripheralQueue.append((oadIdenifyCharacteristic, data))
        } else {
//            writeToPeripheralQueue.append((oadBlockCharacteristic, data))
            self.peripheral?.writeValue(data, forCharacteristic: oadBlockCharacteristic, type: .WithoutResponse)
        }
        
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
    
    /**
     获取连接状态
     
     - author: sim cai
     - date: 2016-05-30
     
     - returns: 连接状态
     */
    func getConnectState() -> CBPeripheralState {
        return peripheral?.state ?? .Disconnected
    }
    
    /**
     获取设备名称
     
     - author: sim cai
     - date: 2016-05-30
     
     - returns: 设备名称
     */
    func getPeripheralName() -> String {
        return peripheral?.name ?? ""
    }
    

// MARK: - 扫描蓝牙设备
    
    /**
     扫描附近蓝牙设备
     */
    func startScaning() {
        
        Log.info("startScaning")
        centraManager?.scanForPeripheralsWithServices(nil, options: nil)
        
    }
    
    /**
     停止扫描
     */
    func stopScaning() {
        Log.info("stopScaning")
        centraManager?.stopScan()
    }

// MARK: - 手环连接绑定
    
    /**
     手环连接
     
     - parameter peripheralName:  手环名
     - parameter connectComplete: 回调
     */
    func bleConnect(peripheralMacAddress: NSData, connectComplete: (Void -> Void)? = nil) {
        
        if getConnectState() == .Connected {
            
            Log.info("bleConnect end")
            
            connectComplete?()
            return
        }
        
        self.connectComplete = connectComplete
        
        self.peripheralMacAddress = peripheralMacAddress
        
        self.startScaning()
        Log.info("bleConnect")
        
    }
    
    /**
     断开连接
     */
    func bleDisconnect() {
        
        guard let peripheral = self.peripheral else {
            return
        }
        
        Log.info("bleDisconnect")
        peripheralMacAddress = NSData()
        
        self.centraManager?.cancelPeripheralConnection(peripheral)
        
    }
    
    /**
     手环绑定
     
     - parameter bindingComplete: 回调
     */
    func bleBinding(bindingComplete: ((String, NSData) -> Void)? = nil) {
        
        Log.info("bleBinding")
        LifeBandBle.isRebend  = true
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
        
        if central.state == .PoweredOn {
            
            bleConnect(self.peripheralMacAddress)
            
            /**
             *  蓝牙状态改变 要自动刷新
             *
             *  等待1秒 连接手环的时间 手环连接商会请求刷新
             *  所以如果手环未连接 次吃在轻轻刷新 如果连接 就不要刷新
             *
             */
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue ()) {
                
                if LifeBandBle.shareInterface.getConnectState() != .Connected {
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(RefreshStatus.AddAutoRefresh.rawValue, object: nil)
                    
                }
                
            }
            
        } else {
            
            NSNotificationCenter.defaultCenter().postNotificationName(BandBleNotificationName.BandDesconnectNotification.rawValue, object: nil)
        }
        
        lifeBandBleDelegate?.bleMangerState(central.state)
        
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        peripheral.discoverServices(nil)
        stopScaning()
        central.stopScan()
        NSNotificationCenter.defaultCenter().postNotificationName(BandBleNotificationName.BandConnectNotification.rawValue, object: nil)
        
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        NSNotificationCenter.defaultCenter().postNotificationName(BandBleNotificationName.BandDesconnectNotification.rawValue, object: nil)
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        Log.error("Fail connect to: \(peripheral.name)")
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String: AnyObject], RSSI: NSNumber) {
        
        if self.peripheral?.state == .Connected {
            Log.error("peripheral is connected")
            central.stopScan()
            return
        }

        guard let advertData = advertisementData["kCBAdvDataManufacturerData"] as? NSData else {
            return
        }
        
        
        let data = advertData.arrayOfBytes()
        
        let macAddress = advertData[0...5]
        
        //连接设备
        if macAddress == peripheralMacAddress && LifeBandBle.isRebend == false {
            connect(central, peripheral: peripheral)
            return
        }
        
        // 1 为点击绑定标识
        guard data.last == 1 else {
            return
        }
        
        Log.info("advertisementData: \(advertData.toHexString())")
        
        LifeBandBle.isRebend = false
        
        bindingComplete?(peripheral.name ?? "", macAddress ?? NSData(bytes: [0, 0, 0, 0, 0, 0]))
        
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
        
        _ = services.map { service -> CBService in
            
            if service.UUID.isEqual(CBUUID(string: oadServiceUUID)) {
                peripheral.discoverCharacteristics(nil, forService: service)
            }
            
            return service
        }
        
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        Log.info("\(service)")
        
        searchOADCharacteristics(peripheral, service: service)
        
        guard service.UUID.isEqual(CBUUID(string: serviceUUID)) else {
            return
        }
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        _ = characteristics.map { chara -> CBCharacteristic in
            
            if chara.UUID.isEqual(CBUUID(string: sendCommandCharacteristicUUID)) {
                
                Log.info("bleConnect end")
                sendCharacteristic = chara
                self.connectComplete?()
                
            }
            
            if chara.UUID.isEqual(CBUUID(string: revcCommandCharacteristicUUID)) {
                revcCharacteristic = chara
                peripheral.setNotifyValue(true, forCharacteristic: chara)
            }
            
            
            return chara
        }
        
    }
    
    /**
     搜索OAD
     
     - author: sim cai
     - date: 2016-06-02
     
     - parameter peripheral:      设备
     - parameter characteristics: 特征
     */
    func searchOADCharacteristics(peripheral: CBPeripheral, service: CBService) {
        
        Log.info("\(service)")
        
        guard service.UUID.isEqual(CBUUID(string: oadServiceUUID)) else {
            return
        }
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        _ = characteristics.map { chara -> CBCharacteristic in
            
            if chara.UUID.isEqual(CBUUID(string: oadImgIdentifyUUID)) {
                
                oadIdenifyCharacteristic = chara
                peripheral.setNotifyValue(true, forCharacteristic: chara)
            }
            
            if chara.UUID.isEqual(CBUUID(string: oadImgBlockUUID)) {
                oadBlockCharacteristic = chara
                peripheral.setNotifyValue(true, forCharacteristic: chara)
            }
            
            
            
            return chara
        }
        
    }
    
    /**
     蓝牙消息接收
     
     - author: sim cai
     - date: 2016-06-03
     
     - parameter peripheral:
     - parameter characteristic:
     - parameter error:
     */
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        guard let data = characteristic.value else {
            return
        }
        
        prepareFirmwareDataToBand(data)
        
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
