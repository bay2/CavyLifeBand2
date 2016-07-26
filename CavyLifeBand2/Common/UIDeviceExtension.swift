//
//  UIDeviceExtension.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/6/30.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation

enum DeviceMaxWidth: Float {
    case IPhone4     = 480.0
    case IPhone5     = 568.0
    case IPhone6     = 667.0
    case IPhone6Plus = 736.0
    case IPad        = 1024.0
    case IPadPro     = 1366.0
}

enum DeviceType: String {
    case IPhone
    case IPhone4
    case IPhone5
    case IPhone6
    case IPhone6Plus
    case IPad
    case IPadPro
    case Unknown
}

extension UIDevice {
    
    class func maxDeviceWidth() -> Float {
        let w = Float(UIScreen.mainScreen().bounds.width)
        let h = Float(UIScreen.mainScreen().bounds.height)
        return fmax(w, h)
    }
    
    class func deviceType() -> DeviceType {
        if isPhone4()     { return DeviceType.IPhone4     }
        if isPhone5()     { return DeviceType.IPhone5     }
        if isPhone6()     { return DeviceType.IPhone6     }
        if isPhone6Plus() { return DeviceType.IPhone6Plus }
        if isPadPro()     { return DeviceType.IPadPro     }
        if isPad()        { return DeviceType.IPad        }
        if isPhone()      { return DeviceType.IPhone      }
        return DeviceType.Unknown
    }
    
    class func isPhone() -> Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == .Phone
    }
    
    class func isPad() -> Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == .Pad
    }
    
    class func isPhone4() -> Bool {
        return isPhone() && maxDeviceWidth() == DeviceMaxWidth.IPhone4.rawValue
    }
    
    class func isPhone5() -> Bool {
        return isPhone() && maxDeviceWidth() == DeviceMaxWidth.IPhone5.rawValue
    }
    
    class func isPhone6() -> Bool {
        return isPhone() && maxDeviceWidth() == DeviceMaxWidth.IPhone6.rawValue
    }
    
    class func isPhone6Plus() -> Bool {
        return isPhone() && maxDeviceWidth() == DeviceMaxWidth.IPhone6Plus.rawValue
    }
    
    class func isPadPro() -> Bool {
        return isPad() && maxDeviceWidth() == DeviceMaxWidth.IPadPro.rawValue
    }
    
}

