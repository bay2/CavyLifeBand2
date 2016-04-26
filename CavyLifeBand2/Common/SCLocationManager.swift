//
//  SCLocationManager.swift
//  GeocoderDemo
//
//  Created by xuemincai on 16/2/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import CoreLocation


class SCLocationManager: NSObject, CLLocationManagerDelegate {
    
    static var shareInterface: SCLocationManager = SCLocationManager()
    
    var locationManager: CLLocationManager!
    var coordinate: CLLocationCoordinate2D?
    var complete: (Void -> Void)?
    
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
    func startUpdateLocation(complete: (Void -> Void)? = nil) {
        
        if CLLocationManager.authorizationStatus() == .Denied || CLLocationManager.authorizationStatus() == .Restricted {
            
            return
        }
        
        locationManager.delegate = self
        locationManager.distanceFilter = 10.0
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.complete = complete
        
        
    }
    
    /**
     接收GPS信息
     
     - parameter manager:
     - parameter locations:
     */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let geocoder = CLGeocoder()
        
        coordinate = locations[0].coordinate
        
        let locationObj = CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
        
        geocoder.reverseGeocodeLocation(locationObj) {(placemark, error) -> Void in
            
            if error != nil {
                return
            }
            
            
        }
        
        locationManager.stopUpdatingLocation()
        complete?()
        
    }
    

}