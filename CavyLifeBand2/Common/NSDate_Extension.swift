//
//  NSDate_Extension.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import EZSwiftExtensions
import Datez

extension NSDate {
    
    /**
     A年到B年间隔的年数
     */
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
    
    /**
     时间返回Label的Text
     * 日：4.3
     * 周：4.3-8
     * 月：4
     */
    func dateChangeToLabelText(timeBucket: TimeBucketStyle) -> String {
        
        switch timeBucket {
            
        case .Day:
            
            return self.toString(format: "M.d")

        case .Month:
            
            return self.toString(format: "M")
            
        case .Week:
            
            let index = self.indexInArray()
            var monday = self
            let sunDay = (self.gregorian + (7 - index).day).date
            
            if index != 1 {
                
                monday = (self.gregorian - (index - 1).day).date
                
            }
            
            if monday.toString(format: "M") == sunDay.toString(format: "M") {
                
                return "\(monday.toString(format: "M.d"))-\(sunDay.toString(format: "d"))"
                
            } else {
                
                return "\(monday.toString(format: "M.d"))-\(sunDay.toString(format: "M.d"))"
            }

        }
        
    }
    
    /**
     当前是这周的第几天
     * 1 - 7
     * 1 周一
     */

    func indexInArray() -> Int {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Weekday, fromDate: self)
        
        let days = components.weekday - 1
        
        if days == 0 {
            return 7
        }
        
        return days
        
    }
    
    /**
      返回当前月份的天数
     */
    func daysCount(year: Int, month: Int) -> Int {
        
        var daysArray = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        
        if year % 400 == 0 || year % 100 != 0 && year % 4 == 0 {
            
            daysArray[2] += 1
            
        }
        
        return daysArray[month]

    }
    
    /**
     时间转时间段
     */
    func timeStringChangeToNSDate(timeBucket: TimeBucketStyle) -> (NSDate, NSDate){
        
        // beginTime
        let year = self.toString(format: "yyyy").toInt()!
        let month = self.toString(format: "M").toInt()!
        let day = self.toString(format: "d").toInt()!
        
        var beginDateString = ""
        var endDateString = ""
        
        switch timeBucket {
            
        case .Day:
          
            beginDateString = "\(year)-\(month)-\(day) 00:00:00"
            endDateString = "\(year)-\(month)-\(day) 23:59:59"
            
        case .Week:
            
            // 举例 4.11-15 4.28-5.3 12.29-1.4

            let index = self.indexInArray()
            var monday = self
            let sunDay = (self.gregorian + (6 - index).day).date
            
            if index != 0 {
                
                monday = (self.gregorian - index.day).date
                
            }
            
            beginDateString = "\(monday.toString(format: "yyyy.M.d")) 00:00:00"
            endDateString = "\(sunDay.toString(format: "yyyy.M.d")) 23:59:59"
            
        case .Month:
            
            let monthOwenrDays = daysCount(year, month: month)

            beginDateString = "\(year)-\(month)-1 00:00:00"
            endDateString = "\(year)-\(month)-\(monthOwenrDays) 23:59:59"
            
        }
        
        let beginDate = NSDate(fromString: beginDateString, format: "yyyy-M-d HH:mm:ss")!
        let endDate = NSDate(fromString: endDateString, format: "yyyy-M-d HH:mm:ss")!
        
        return (beginDate, endDate)
        
    }
    
    /**
     
     从 beginTime 到 今天 所有的日期 按照 formatter 组成的 String 数组
     - parameter self:          到那个日期结束
     - parameter beginDate:     从那个日期开始
     - parameter formatter:     字符串格式
     
     - returns: 日期数组
     */
    func untilTodayArrayWithFormatter(formatter: String) -> [String]? {
        
        if self.toString(format: "yyyy-MM-dd") == NSDate().toString(format: "yyyy-MM-dd") {
            return [NSDate().toString(format: "yyyy.M.d")]
        }
        
        var returnArray: [String] = []
        
        let daysCount = (NSDate().gregorian.beginningOfDay.date - self).totalDays + 1
        
        if self.toString(format: "yyyy-MM-dd") == NSDate().toString(format: "yyyy-MM-dd") || daysCount < 1 {
            
            return [NSDate().toString(format: "yyyy.M.d")]
        }
        
        for i in 0 ... daysCount {
            
            let date = (self.gregorian + i.day).date
            
            returnArray.append(date.toString(format: formatter))
            
        }
        
        Log.info("\(returnArray) - \(returnArray.count)")
        return returnArray
    }
    
    
    /**
     格式化输出当天 day 时间
     
     - parameter newDate: <#newDate description#>
     
     - returns: <#return value description#>
     */
    
    func formartDate(newDate: NSDate) -> NSDate {
        
        let formart = NSDateFormatter()
        formart.dateFormat = "YYYY-MM-dd"
        
        let dateStr = formart.stringFromDate(newDate)
        
        let date = formart.dateFromString(dateStr)
        
        return date!
        
    }
}
