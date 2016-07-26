//
//  UploadBandData.swift
//  CavyLifeBand2
//
//  Created by JL on 16/6/30.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Alamofire
import JSONJoy
import RealmSwift

class UploadBandData: NetRequest {
    
    static var shareApi = UploadBandData()
    
    func uploadBandData(raw: [NSDictionary], successHandler: ((CommenMsgResponse) -> Void)? = nil, failHandler: (Void -> Void)? = nil) {
        
        let parameters: [String: AnyObject] = [NetRequestKey.Raw.rawValue: raw,
                                               NetRequestKey.TimeScale.rawValue: 10]
        
        netPostRequest(WebApiMethod.Dailies.description, para: parameters, modelObject: CommenMsgResponse.self, successHandler: { (data) in
            
            successHandler?(data)
            
        }) { (msg) in
            
            Log.error(msg)
            
            failHandler?()
            
        }

    }
    
}
