//
//  FirmwareUpdateWebApi.swift
//  CavyLifeBand2
//
//  Created by JL on 16/6/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Alamofire
import JSONJoy

class FirmwareUpdateWebApi: NetRequestAdapter {
    
    static var shareApi = FirmwareUpdateWebApi()
    
    /**
     获取固件版本
     
     - parameter version:  当前版本（可选参数）
     - parameter callBack:
     
     - throws:
     */
    func getVersion(version: String = "", callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.GetVersion.rawValue,
                                               UserNetRequsetKey.Version.rawValue: version]
        
        netPostRequestAdapter(CavyDefine.webApiAddr, para: parameters, completionHandler: callBack)
        
    }
    
}

