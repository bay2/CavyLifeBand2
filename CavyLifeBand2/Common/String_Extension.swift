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
    
}
