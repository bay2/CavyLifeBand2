//
//  RelateAppWebApi.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/13.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Alamofire
import Log
import JSONJoy

class RelateAppWebApi: NetRequest {

    static var shareApi = RelateAppWebApi()
    
    /**
     获取体感应用信息
     
     - parameter callBack: 回调
     - parameter pagenum:  当前页
     - parameter pagesize: 每页条数，默认10
     
     - throws: 
     */
    func getRelateAppList(pagenum: Int = 1, pagesize: Int = 10, successHandler: ([GameJSON] -> Void)? = nil, failHandler: (CommenResponse -> Void)? = nil) {
        
//        let parameters: [String: AnyObject] = [UserNetRequsetKey.AC.rawValue: UserNetRequestMethod.CavyLife.rawValue,
//                                               UserNetRequsetKey.PageNum.rawValue: pagenum,
//                                               UserNetRequsetKey.PageSize.rawValue: pagesize]
        
//        netGetRequestAdapter(CavyDefine.relateAppWebApiAddr, para: parameters, completionHandler: callBack)
        
        
        netGetRequest(WebApiMethod.RecommendGames.description, modelObject: RelateAppResponse.self, successHandler: {
            
            successHandler?($0.gameList)
            
        }) { (msg) in
            
            failHandler?(msg)
            
        }
    }

    
}
