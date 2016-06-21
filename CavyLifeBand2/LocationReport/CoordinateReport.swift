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
protocol CoordinateReport: NetRequestAdapter {
    
    var userId: String { get }
    func coordinateReportServer()
    
}

extension CoordinateReport {
    
    /**
     每隔5分钟坐标上报服务器
     */
    func coordinateReportServer() {
        
        reportServer()
//        MARK:   先注释掉
//        NSTimer.runThisEvery(seconds: 5 * 60) { _ in
//            self.reportServer()
//        }
   
    }
    
    /**
     坐标上报服务器
     */
    private func reportServer() {
        
        SCLocationManager.shareInterface.startUpdateLocation { coordinate in
            
            let parameter = [UserNetRequsetKey.Cmd.rawValue: UserNetRequestMethod.ReportCoordinate.rawValue,
                UserNetRequsetKey.UserID.rawValue: self.userId,
                UserNetRequsetKey.Longitude.rawValue: "\(coordinate.longitude)",
                UserNetRequsetKey.Latitude.rawValue: "\(coordinate.latitude)"]
            
            self.netPostRequestAdapter(CavyDefine.webApiAddr, para: parameter)
            
            }
        
    }
    
}