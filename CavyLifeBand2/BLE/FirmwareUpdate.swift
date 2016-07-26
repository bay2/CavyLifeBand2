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

enum UpdateFirmwareReslut<Value, Error: ErrorType> {
    
    case Success(Value)
    case Failure(Error)
    
    func success(@noescape closure: Value -> Void) -> UpdateFirmwareReslut {
        
        switch self {
        case .Success(let value):
            closure(value)
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
    func updateFirmware(filePath: String, completionHander: (UpdateFirmwareReslut<Double, UpdateFirmwareError>) -> Void) -> Bool {
        
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
                
        LifeBandBle.binData = NSData(contentsOfFile: filePath.stringByReplacingOccurrencesOfString("file://", withString: "")) ?? NSData()
        
        if LifeBandBle.binData.length == 0 {
            return false
        }
        
        guard let newData = LifeBandBle.binData[4...LifeBandBle.binData.length - 1] else {
            return false
        }
        
        guard let crc: UInt16 = newData.crc16() else {
            return false
        }
        
        LifeBandBle.remainsLenght = LifeBandBle.binData.length
        
        sendData.append(UInt8(crc & 0x00ff))
        sendData.append(UInt8((crc & 0xff00) >> 8))
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
        
        sendMsgToBand("%OAD=1\n")
        
        Log.info("Update firmware begin \(NSDate().toString(format: "yyyy-MM-dd HH:mm:ss"))")
        
        Log.info("\(sendData)")
        
        LifeBandBle.isUpdataing = true
        LifeBandBle.fileDataExIndex = 0
        
        NSTimer.runThisAfterDelay(seconds: 2) { 
            self.oadSendToBand(NSData(bytes: sendData), mode: 0)
        }
        
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
        
        
        if LifeBandBle.remainsLenght <= 0 {
            
            endOAD(.Success(1))
            return
        }
        
        let percentage = Double(LifeBandBle.binData.length - LifeBandBle.remainsLenght) / Double(LifeBandBle.binData.length)
        
        self.updateFWCompletionHander?(.Success(percentage))
        
        let sendDataBeginIndex = Int(LifeBandBle.binData.length - LifeBandBle.remainsLenght)
        let sendDataEndIndex   = LifeBandBle.remainsLenght >= 16 ? sendDataBeginIndex + 15 : LifeBandBle.remainsLenght - 1
        
        
        guard var sendData = LifeBandBle.binData[sendDataBeginIndex...sendDataEndIndex] else {
            endOAD(.Failure(.GetDataError))
            Log.error("获取数据失败")
            return
        }
        
        
        let replyIndex = data.uint16.littleEndian
        
        Log.info("remainsLenght = \(LifeBandBle.remainsLenght),  replyIndex = \(replyIndex), fileDataExIndex = \(LifeBandBle.fileDataExIndex), \(sendDataBeginIndex) - \(sendDataEndIndex)")
        
        
        
        // 序号一致
        if replyIndex == UInt16(LifeBandBle.fileDataExIndex) {
            sendData = NSData(bytes: data.arrayOfBytes() + sendData.arrayOfBytes(), length: 18)
            LifeBandBle.fileDataExIndex += 1
            LifeBandBle.remainsLenght -= (sendData.length - 2)
        } else if  UInt16(LifeBandBle.fileDataExIndex - 1) == replyIndex {
            sendData = LifeBandBle.resendData
        }
        
        oadSendToBand(sendData, mode: 1)
        
        LifeBandBle.resendData = sendData
        
        if LifeBandBle.fileDataExIndex > 8191 {
            
            endOAD(.Success(1))
            return
            
        }
        
        
    }
    
    /**
     升级结束
     
     - author: sim cai
     - date: 2016-06-03
     */
    func endOAD(reslut: UpdateFirmwareReslut<Double, UpdateFirmwareError>) {
        
        LifeBandBle.isUpdataing     = false
        
//        if reslut.isSuccess {
//            self.bleDisconnect()
//        }
        
        self.updateFWCompletionHander?(reslut)
        
        Log.info("Update firmware end \(NSDate().toString(format: "yyyy-MM-dd HH:mm:ss"))")
        
    }
    
}

// MARK: - 从服务器下载Firmware
protocol FirmwareDownload {
    
    func downloadFirmware(url: String, completeHandle: (String -> Void)) -> Request
    
}

extension FirmwareDownload {
    
    /**
     下载文件
     
     - author: sim cai
     - date: 2016-06-03
     
     - parameter url: url
     
     - returns:
     */
    func downloadFirmware(url: String, completeHandle: (String -> Void)) -> Request {
        
        var newFilePath: NSURL = NSURL()
        
        return Alamofire.download(.GET, url) { temporaryURL, response -> NSURL in
            
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
            let pathComponent = response.suggestedFilename ?? "firmware"
            
            newFilePath = directoryURL.URLByAppendingPathComponent(pathComponent)
            if fileManager.fileExistsAtPath(String(newFilePath).stringByReplacingOccurrencesOfString("file://", withString: "")) {
                try! fileManager.removeItemAtURL(newFilePath)
            }
            
            return newFilePath
            
        }.response(completionHandler: { _, _, _, error in
            
            if  error != nil {
                completeHandle(L10n.UpdateFirmwareDownloadError.string)
                return
            }
            
            completeHandle(String(newFilePath))
        })
        
    }
    
}



