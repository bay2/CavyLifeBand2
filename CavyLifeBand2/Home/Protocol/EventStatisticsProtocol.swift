//
//  EventStatisticsProtocol.swift
//  CavyLifeBand2
//
//  Created by JL on 16/7/20.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation

class EventStatisticsApi: NetRequest {
    
    static var shareApi = EventStatisticsApi()
    
    func uploadEventInfo(type: ActivityEventType) {
        
        let parameters: [String: AnyObject] = [NetRequestKey.DeviceSerial.rawValue: CavyDefine.bindBandInfos.bindBandInfo.deviceSerial,
                                               NetRequestKey.DeviceModel.rawValue: UIDevice.deviceType().rawValue,
                                               NetRequestKey.AuthKey.rawValue: CavyDefine.gameServerAuthKey,
                                               NetRequestKey.BandMac.rawValue: CavyDefine.bindBandInfos.bindBandInfo.defaultBindBand,
                                               NetRequestKey.Longitude.rawValue: CavyDefine.userCoordinate.longitude,
                                               NetRequestKey.Latitude.rawValue: CavyDefine.userCoordinate.latitude,
                                               NetRequestKey.EventType.rawValue: type.rawValue]
        
        netPostRequest(WebApiMethod.Activities.description, para: parameters, modelObject: CommenMsgResponse.self, successHandler: { (data) in
            Log.info(data.commonMsg.msg)
        }) { (msg) in
            Log.error(msg.msg)
        }
    }
    
}

enum ActivityEventType: String {
    
    case AppOpen        = "GAME_OPEN"
    case AppQuit        = "GAME_QUIT"
    case BandConnect    = "GAME_CONNECT"
    case BandDisconnect = "GAME_DISCONNECT"
    case UserOnline     = "USER_ONLINE"
    case UserOffline    = "USER_OFFLINE"
    case Unkown         = "Unkown"    

}
