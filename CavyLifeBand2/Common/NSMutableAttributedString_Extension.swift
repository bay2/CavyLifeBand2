//
//  NSMutableAttributedString_Extension.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    /**
     富文本
     
     - parameter num:      数值
     - parameter numSize:  数值字体大小
     - parameter unit:     单位
     - parameter unitSize: 单位字体大小
     
     - returns: 数值 + 单位
     */
    func attributeString(num: String, numSize: CGFloat, unit: String, unitSize: CGFloat) -> NSMutableAttributedString {
    
        
        let currentString = NSMutableAttributedString(string: "\(num)\(unit)")
        
        currentString.addAttribute(NSFontAttributeName, value: UIFont.mediumSystemFontOfSize(numSize), range: NSMakeRange(0, num.length))
        currentString.addAttribute(NSFontAttributeName, value: UIFont.mediumSystemFontOfSize(unitSize), range: NSMakeRange(currentString.length - unit.length, unit.length))
        
        return currentString

    }
    
    
}