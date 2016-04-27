//
//  SCLocationManager.swift
//  GeocoderDemo
//
//  Created by xuemincai on 16/2/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import CoreLocation


/*
 功能：
 1.获取经纬度坐标
 2.获取城市名称
 
 */

class SCLocationManager: NSObject, CLLocationManagerDelegate {
    
    static var shareInterface: SCLocationManager = SCLocationManager()
    
    var locationManager: CLLocationManager!
    var complete: (CLLocationCoordinate2D -> Void)?
    var cityComplete: (String -> Void)?
    
    override init(){
        
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
    }
    
    /**
     更新GSP位置
     */
    func startUpdateLocation(complete: (CLLocationCoordinate2D -> Void)? = nil, cityComplete: (String -> Void)? = nil) {
        
        if CLLocationManager.authorizationStatus() == .Denied || CLLocationManager.authorizationStatus() == .Restricted {
            
            return
        }
        
        locationManager.delegate = self
        locationManager.distanceFilter = 10.0
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.complete = complete
        self.cityComplete = cityComplete
        
    }
    
    /**
     接收GPS信息
     
     - parameter manager:
     - parameter locations:
     */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let geocoder = CLGeocoder()
        
        let locationObj = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(locationObj) {(placemark, error) -> Void in
            
            if error != nil {
                return
            }
            
            guard let placemarks = placemark else {
                return
            }
            
            _ = placemarks.map {[unowned self]  in
                self.cityComplete?($0.locality ?? "")
            }
            
        }
        
        locationManager.stopUpdatingLocation()
        complete?(locations[0].coordinate)
        
    }
    

}
