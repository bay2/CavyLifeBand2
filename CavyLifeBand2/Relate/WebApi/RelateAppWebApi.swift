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

class RelateAppWebApi: NetRequestAdapter {

    static var shareApi = RelateAppWebApi()
    
    /**
     获取APP推荐信息
     
     - parameter callBack: 回调
     - parameter pagenum:  当前页
     - parameter pagesize: 每页条数，默认10
     
     - throws: 
     */
    func getRelateAppList(pagenum: Int = 1, pagesize: Int = 10, callBack: CompletionHandlernType? = nil) throws {
        
        let parameters: [String: AnyObject] = [UserNetRequsetKey.AC.rawValue: UserNetRequestMethod.CavyLife.rawValue,
                                               UserNetRequsetKey.PageNum.rawValue: pagenum,
                                               UserNetRequsetKey.PageSize.rawValue: pagesize]
        
        netGetRequestAdapter(CavyDefine.relateAppWebApiAddr, para: parameters, completionHandler: callBack)
    }

    
}
