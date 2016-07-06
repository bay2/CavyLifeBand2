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
    
    func chineseToSpell() -> String {
        
        let str = CFStringCreateMutableCopy(nil, 0, self)
        
        var returnStr = ""
        
        if CFStringTransform(str, nil, kCFStringTransformToLatin, false) {
            
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
                
                let string = String(str)
                returnStr = string.capitalizedString
                
            }
        }
        
        returnStr = returnStr.trimmed()
        
        return returnStr
        
    }
    
    /**
     返回第一个字母
     
     - parameter name: 名字
     
     - returns: 第一个字母
     */
    func firstCharactor(name: String) -> String {
        
        var returnStr = ""
        
        let spellString = name.chineseToSpell()
        
        let beginChar = spellString[spellString.startIndex]
        
        returnStr = String(beginChar)
        
        return returnStr.uppercaseString
    }
    
    /**
     数字转格式化字符 千位分隔格式 ep:50000 -> 50,000
     
     - parameter num: 需转换数字
     
     - returns: 转换后的字符串
     */
    static func  numberDecimalFormatter(num: Int = 0) -> String {
    
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        let string = numberFormatter.stringFromNumber(NSNumber(integer: num))
        
        return string!
    }
 
       
}
