//
//  FirmwareUpdate.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/6/2.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import Alamofire

enum UpdateFirmwareError: ErrorType {
    case GetDataError
    case FileTooLong
}

enum UpdateFirmwareReslut<Error: ErrorType> {
    
    case Success
    case Failure(Error)
    
    func success(@noescape closure: Void -> Void) -> UpdateFirmwareReslut {
        
        switch self {
        case .Success:
            closure()
        default:
            break
        }
        
        return self
    }
    
    func failure(@noescape closure: Error -> Void) -> UpdateFirmwareReslut {
        
        switch self {
        case .Failure(let error):
            closure(error)
        default:
            break
        }
        
        return self
    }
    
    var isSuccess: Bool {
        
        switch self {
        case .Success:
            return true
        default:
            return false
        }
        
    }
    
}

// MARK: - 固件升级
extension LifeBandBle {
    
    /**
     firmware 更新
     
     - author: sim cai
     - date: 2016-06-03
     
     - parameter filePath: 文件路径
     
     - returns:
     */
    func updateFirmware(filePath: String, completionHander: (UpdateFirmwareReslut<UpdateFirmwareError>) -> Void) -> Bool {
        
        if LifeBandBle.isUpdataing {
            Log.error("update Firmware ...")
            return false
        }
        
        self.updateFWCompletionHander = completionHander
        
        return loadBinFile(filePath)
    }
    
    /**
     加载文件
     
     - author: sim cai
     - date: 2016-06-03
     
     - parameter filePath: 文件路径
     */
    func loadBinFile(filePath: String) -> Bool {
        
        var sendData: [UInt8] = []
        
        LifeBandBle.binData = NSData(contentsOfFile: filePath) ?? NSData()
        
        if LifeBandBle.binData.length == 0 {
            return false
        }
        
        guard let crc = LifeBandBle.binData.crc16() else {
            return false
        }
        
        sendData.append(crc[0])
        sendData.append(crc[1])
        sendData.append(0xFF)
        sendData.append(0xFF)
        sendData.append(0x00)
        sendData.append(0x00)
        sendData.append(UInt8((LifeBandBle.binData.length/4) & 0x00FF))
        sendData.append(UInt8(((LifeBandBle.binData.length/4) & 0xFF00) >> 8))
        sendData.append(0x45)
        sendData.append(0x45)
        sendData.append(0x45)
        sendData.append(0x45)
        sendData.append(0x00)
        sendData.append(0x00)
        sendData.append(0x01)
        sendData.append(0xff)
        
        sendMsgToBand("%OAD=1")
        oadSendToBand(NSData(bytes: sendData), mode: 0)
        
        Log.info("Update firmware begin \(NSDate().toString(format: "yyyy-MM-dd HH:mm:ss"))")
        
        LifeBandBle.isUpdataing = true
        
        return true
        
    }
    
    /**
     固件升级消息处理
     
     - author: sim cai
     - date: 2016-06-03
     
     - parameter data: 消息
     */
    func prepareFirmwareDataToBand(data: NSData) {
        
        guard data.length == 2 else {
            return
        }
        
        let sendedDataLength = Int(LifeBandBle.fileDataExIndex * 16)
        let noSendDataLength = data.length - sendedDataLength
        
        if noSendDataLength <= 0 {
            
            endOAD(.Success)
            return
        }
        
        let sendDataBeginIndex = Int(LifeBandBle.fileDataExIndex * 16)
        let sendDataEndIndex   = noSendDataLength >= 16 ? sendDataBeginIndex + 16 : sendDataBeginIndex + noSendDataLength
        
        guard var sendData = LifeBandBle.binData[sendDataBeginIndex...sendDataEndIndex] else {
            endOAD(.Failure(.GetDataError))
            Log.error("获取数据失败")
            return
        }
        
        if LifeBandBle.fileDataExIndex > 8191 {
            
            endOAD(.Failure(.FileTooLong))
            return
            
        }
        
        let replyIndex = data.uint16.bigEndian
        
        // 序号一致
        if replyIndex == LifeBandBle.fileDataExIndex {
            sendData = NSData(bytes: data.arrayOfBytes() + sendData.arrayOfBytes())
        } else if LifeBandBle.fileDataExIndex - 1 == replyIndex {
            sendData = LifeBandBle.resendData
        }
        
        oadSendToBand(sendData, mode: 1)
        
        LifeBandBle.resendData = sendData
        
    }
    
    /**
     升级结束
     
     - author: sim cai
     - date: 2016-06-03
     */
    func endOAD(reslut: UpdateFirmwareReslut<UpdateFirmwareError>) {
        
        LifeBandBle.isUpdataing     = false
        LifeBandBle.fileDataExIndex = 0
        
        if reslut.isSuccess {
            self.bleDisconnect()
        }
        
        self.updateFWCompletionHander?(reslut)
        
        Log.info("Update firmware end \(NSDate().toString(format: "yyyy-MM-dd HH:mm:ss"))")
        
    }
    
}

// MARK: - 从服务器下载Firmware
protocol FirmwareDownload {
    
    func downloadFirmware(url: String) -> Request
    
}

extension FirmwareDownload {
    
    /**
     下载文件
     
     - author: sim cai
     - date: 2016-06-03
     
     - parameter url: url
     
     - returns:
     */
    func downloadFirmware(url: String) -> Request {
        
        return Alamofire.download(.GET, url) { (temporaryURL, response) -> NSURL in
            
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename ?? "firmware"
            
            return directoryURL.URLByAppendingPathComponent(pathComponent)
            
        }
        
    }
    
}


