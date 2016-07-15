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

extension String {
    
    func detailAttributeString(unit: String) -> NSMutableAttributedString{
        
        let numStr = "\(self)"
        let unitStr = " \(unit)"
        
        // 字体大小
        let detailNumSize: CGFloat = 24
        let detailUnitSize: CGFloat = 12
        
        let currentString = NSMutableAttributedString(string: numStr + unitStr)
        currentString.addAttribute(NSFontAttributeName, value: UIFont.mediumSystemFontOfSize(detailNumSize), range: NSMakeRange(0, numStr.length))
        currentString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(detailUnitSize), range: NSMakeRange(currentString.length - unitStr.length, unitStr.length))

        // 如果需要垂直居中 就是需要加入下面的 NSBaselineOffsetAttributeName 基数偏移

//        let attrs2: [String: AnyObject] = [NSFontAttributeName: UIFont.systemFontOfSize(detailUnitSize)， NSBaselineOffsetAttributeName: 4]
//        
//        currentString.addAttributes(attrs2, range: NSMakeRange(currentString.length - unitStr.length, unitStr.length))
   
        return currentString
    }
    
}

extension Int {
    
    /**
     计步睡眠详情的时间富文本字体
     
     - parameter num:  时间（分钟）
     
     - returns:
     */
    func detailTimeAttributeString() -> NSMutableAttributedString {
        
        let hourStr = String(self / 60)
        let minStr = String(self % 60)
        let hourUnit = String("h ")
        let minUnit = String("min")
        
        let hourAttr = hourStr.detailAttributeString(hourUnit)
        let minAttr = minStr.detailAttributeString(minUnit)
        
        let resultAttr: NSMutableAttributedString = hourAttr
        resultAttr.appendAttributedString(minAttr)
        
        return resultAttr
        
    }
    
}

