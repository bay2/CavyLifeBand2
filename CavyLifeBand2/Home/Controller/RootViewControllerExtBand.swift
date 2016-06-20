//
//  RootViewControllerExtBand.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/31.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import CoreBluetooth

// MARK: - 手环相关函数定义
extension RootViewController: LifeBandBleDelegate {
    
    /**
     开始初始化，连接手环
     
     - author: sim cai
     - date: 2016-05-31
     */
    func bandInit() {
        
        LifeBandBle.shareInterface.lifeBandBleDelegate = self
        
        // 需要等待 LifeBandBle.shareInterface 初始化，这里延时1s连接
        NSTimer.runThisAfterDelay(seconds: 1) {
            self.bandConnect()
        }
        
    }
    
    /**
     手环连接处理
     
     - author: sim cai
     - date: 2016-05-31
     */
    func bandConnect() {
        
        if CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId.isEmpty {
            return
        }
        
        
        LifeBandBle.shareInterface.bleConnect(BindBandCtrl.bandMacAddress) {
            
            self.saveMacAddress()
            
            LifeBandCtrl.shareInterface.setDateToBand(NSDate())
            
            let lifeBandModel = LifeBandModelType.LLA.rawValue | LifeBandModelType.Step.rawValue | LifeBandModelType.Tilt.rawValue
            LifeBandCtrl.shareInterface.getLifeBandInfo {
                
                // 如果不等于生活手环模式，则重新设置生活手环模式
                if $0.model & lifeBandModel  != lifeBandModel {
                    LifeBandCtrl.shareInterface.seLifeBandModel()
                }
                
                BindBandCtrl.fwVersion = $0.fwVersion
                
            }
            
            LifeBandCtrl.shareInterface.installButtonEven()
            self.syncDataFormBand()
        }
    }
    
    
    /**
     向紧急联系人发消息
     成功后手环振动一次
     - author: sim cai
     - date: 2016-05-31
     */

    func callEmergency()  {
        
         
        
        do {
            
            try EmergencyWebApi.shareApi.sendEmergencyMsg ()
        
        }catch let error {
             Log.error("Cell EmergencyWebApi.shareApi.sendEmergencyMsg error (\(error))")
        }
    
    }
    
    
    
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