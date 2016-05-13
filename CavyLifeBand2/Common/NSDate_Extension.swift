//
//  NSDate_Extension.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation


extension NSDate {
    
    /**
     时间返回Label的Text
     */
    func dateChangeToLabelText(date: NSDate, timeBucket: TimeBucketStyle) -> String {
        
        var text: String = ""
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let  dateString = dateFormatter.stringFromDate(date)
        var dates = dateString.componentsSeparatedByString("/")
        let month = dates[0].toInt()
        let day = dates[1].toInt()

        switch timeBucket {
            
        case .Day:
            
            text = "\(month).\(day)"

        case .Month:
            
            text = "\(month)"
            
        case .Week:

            text = "\(month).\(day)-\(dayLastSunDayDate(date))"
        }
        
        return text
        
    }
    
    /**
     当前是这周的第几天
     */
    func indexInArray(date: NSDate) -> Int {
        
        let weekName = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        let string = dateFormatter.stringFromDate(date)

        return weekName.lastIndexOf(string)!
        
    }
    
    /**
      计算当前月份的天数
     */
    func daysCount(year: Int, month: Int) -> Int {
        
        var daysArray = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        
        if year % 400 == 0 || year % 100 != 0 && year % 4 == 0 {
            
            daysArray[2] += 1
            
        }
        
        return daysArray[month]

    }
    
    /**
     某一天所在周的 周日的 date 的NSDate
     */
    func dayLastSunDayDate(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyy/MM/dd"
        let  dateString = dateFormatter.stringFromDate(date)
        var dates = dateString.componentsSeparatedByString("/")
        let year = dates[0].toInt()
        let month = dates[1].toInt()
        let day = dates[2].toInt()
        
        ///  距离下一个周一的天数
        let index = 6 - indexInArray(date)
        /// 这个月有几天
        let days = daysCount(year!, month: month!)
        
        var newMonth = month!
        var newDay = day! + index
        
        if newDay > days { newDay = newDay - days }
        
        if newDay < 7 { newMonth = newMonth + 1 }
        
        if month > 12 { newMonth = 1 }

        if newMonth != month { return"\(newMonth).\(newDay)" }

        return "\(newDay)"
        
    }
    
    /**
     字符串转时间段
     */
    func timeStringChangeToNSDate(time: String, timeBucket: TimeBucketStyle) -> (NSDate, NSDate){
        
        
        Log.info(time)
        
        var date1 = ""
        var date2 = ""
        let dateFormatter = NSDateFormatter()

        switch timeBucket {
            
        case .Day:
            
            let timeDate:(year: Int, month: Int, day: Int) = changeMonthPointDayToInt(time)
            let year = timeDate.year
            let month = timeDate.month
            let day = timeDate.day
            
            let haveDays = daysCount(year, month: month)
            
            var newYear = year
            var newMonth = month
            var newDay = day + 1
            
            if newDay > haveDays {
                
                newDay = 1
                newMonth += 1//newMonth + 1
            }
            if newMonth > 12 {
                newMonth = 1
                newYear += 1
            }
          
            date1 = "\(year)-\(month)-\(day) 00:00:00"
            date2 = "\(newYear)-\(newMonth)-\(newDay) 00:00:00"
            
        case .Week:
            
            // 举例 4.11-15 4.28-5.3 12.29-1.4
            var dates = time.componentsSeparatedByString("-")
            let time1 = dates[1]
            let time2 = dates[2]
            
            // beginTime
            
            let timeDate1:(year: Int, month: Int, day: Int) = changeMonthPointDayToInt(time1)
            let year = timeDate1.year
            let month = timeDate1.month
            let day = timeDate1.day
            
            let haveDays = daysCount(year, month: month)
            
            // endTime
            var newYear = year
            var newMonth = month
            var newDay = day
            
            if time2.contains(".") {
    
                let timeDate2:(year: Int, month: Int, day: Int) = changeMonthPointDayToInt(time2)
                newYear = timeDate2.year
                newMonth = timeDate2.month
                
                newDay = timeDate1.day + 1
                
                if newDay > haveDays {
                    
                    newDay = 1
                    newMonth += 1//newMonth + 1
                }
                
                if newMonth > 12 {
                    newMonth = 1
                    newYear += 1
                }
                
            } else {
                
                newDay = time2.toInt()!
            }
            
            date1 = "\(year)-\(month)-\(day) 00:00:00"
            date2 = "\(newYear)-\(newMonth)-\(newDay) 00:00:00"
            
        case .Month:
            
            let month = time.toInt()!
            dateFormatter.dateFormat = "yyy"
            var year: Int = dateFormatter.stringFromDate(NSDate()).toInt()!
            
            var newMonth = month + 1
            let newYear = year
            
            // 例如 17.1.2 则 周一就是16年的
            if newMonth == 13 {
                
                newMonth = 1
                year -= 1
                
            }
            
            date1 = "\(year)-\(month)-1 00:00:00"
            date2 = "\(newYear)-\(newMonth)-1 00:00:00"
            
            
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let beginDate = dateFormatter.dateFromString(date1)!
        let endDate = dateFormatter.dateFromString(date2)!
        
        return (beginDate, endDate)
        
    }
    
    /**
     月.日 返回Int 类型的 年月日
     */
    func changeMonthPointDayToInt(timeString: String) -> (Int, Int, Int) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        let timeDate = dateFormatter.dateFromString(timeString)
        dateFormatter.dateFormat = "yyy"
        let year = dateFormatter.stringFromDate(timeDate!).toInt()
        var timeDates1 = timeString.componentsSeparatedByString(".")
        let month = timeDates1[0].toInt()
        let day = timeDates1[1].toInt()
        return (year!, month!, day!)
    }
    
    
    /**
     时间返回月份Label的Text
     */
    func dateChangeToMonthText(date: NSDate) -> String {
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        let month = dateFormatter.stringFromDate(date)
       
        return month
        
    }

    
    
}
