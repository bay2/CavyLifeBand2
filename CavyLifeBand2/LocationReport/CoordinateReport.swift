//
//  CoordinateReport.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import EZSwiftExtensions

/**
 *  上报坐标
 */
protocol CoordinateReport: NetRequest {
    
    var userId: String { get }
    func coordinateReportServer()
    
}

extension CoordinateReport {
    
    /**
     每隔10分钟坐标上报服务器
     */
    func coordinateReportServer() {
        
        reportServer()
//        MARK:   先注释掉
//        NSTimer.runThisEvery(seconds: 10 * 60) { _ in
//            self.reportServer()
//        }
   
    }
    
    /**
     坐标上报服务器
     */
    private func reportServer() {
        
        SCLocationManager.shareInterface.startUpdateLocation { coordinate in
  
       let parameters: [String: AnyObject] = [NetRequestKey.Longitude.rawValue: "\(coordinate.longitude)",
                NetRequestKey.Latitude.rawValue: "\(coordinate.latitude)"]
            
            self.netPostRequest(WebApiMethod.Location.description, para: parameters, modelObject: CommenMsgResponse.self)

       }
        
    }
    
}