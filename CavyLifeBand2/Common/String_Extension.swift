//
//  String_Extension.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/13.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation

extension String {
    
    public var  isPhoneNum: Bool {
        
        if NSNumberFormatter().numberFromString(self) != nil {
            
            if self.length == 11 {
                return true
            }
            
        }
        
        return false
    }
    
    /**
     返回第一个字母
     
     - parameter name: 名字
     
     - returns: 第一个字母
     */
    func firstCharactor(name: String) -> String {
        
        let str = CFStringCreateMutableCopy(nil, 0, name)
        
        var returnStr = String()
        
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) {
            
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
                
                // 转换类型
                let string = String(str)
                string.capitalizedString
                let character = string[string.startIndex]
                
                returnStr = String(character)
            }
            
        }
        
        return returnStr.uppercaseString
    }
    
    /**
     数字转格式化字符 千位分隔格式
     
     - parameter num: 需转换数字
     
     - returns: 转换后的字符串
     */
    static func  numberDecimalFormatter(num: Int) -> String {
    
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        let string = numberFormatter.stringFromNumber(NSNumber(integer: num))
        
        return string!
    }
    
    
    
}
