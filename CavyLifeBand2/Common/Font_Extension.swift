//
//  Font_Extension.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/7.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    /**
     字体是斜体
     
     - parameter size: 字体大小
     
     - returns: 
     */
    static func italicFontWithSize(size: CGFloat) -> UIFont {
        
        var italicFont = UIFont()
        // 设置斜体
        let matrix = CGAffineTransformMake(1, 0, CGFloat(tanf(15 * Float(M_PI) / 180)), 1, 0, 0)
        let italicDescriptor = UIFontDescriptor(name: UIFont.systemFontOfSize(16).fontName, matrix: matrix)
        
        italicFont = UIFont(descriptor: italicDescriptor, size: size)
        
        return italicFont
        
    }
    
    
    static func mediumSystemFontOfSize(size: CGFloat) -> UIFont {
        
        return UIFont.Font(.HelveticaNeue, type: .Medium, size: size)
        
    }
    
    
}

