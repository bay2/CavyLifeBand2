//
//  NSDate_Extension.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation

extension NSDate {
    
    func yearsInBetweenDate(date: NSDate) -> Int {
        
        let dateF = NSDateFormatter()
        dateF.dateFormat = "yyyy"
        
        let selfYearStr = dateF.stringFromDate(self)
        let otherYesrStr = dateF.stringFromDate(date)

        let selfYear = selfYearStr.toInt() ?? 0
        let otherYesr = otherYesrStr.toInt() ?? 0
        
        let diffYear = selfYear - otherYesr
        
        return diffYear
    }

}