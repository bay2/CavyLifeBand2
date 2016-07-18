//
//  Array_Extension.swift
//  CavyLifeBand2
//
//  Created by Hanks on 16/6/15.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation


/**
 * 移动号段正则表达式
 */

let Cm = "^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$"

/**
 * 联通号段正则表达式
 */

let Cu = "^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$"

/**
 * 电信号段正则表达式
 */

let Ct = "^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$"

extension Array {
    
    
    /**
     筛选手机号数组
     
     - parameter phoneArr: 传入的手机号数组
     
     - returns:
     */

   public func getPhoneNumArr() -> [String]  {
    
    var resultArr: [String] = []
 
    for phone in self
    {
        
        guard let resultPhone = valiMobile(phone as! String) else
            
        {
            continue
        }
        
        resultArr.append(resultPhone)
    }
    
    return resultArr
    
   }
    
    
    
    /**
     筛选手机号
     
     - parameter mobile: 手机号
     
     - returns: 如果是手机号则返回手机号
     */
    
  public  func valiMobile(mobile: String) -> String? {
    
    var  newMobile = mobile
        
    newMobile =  newMobile.stringByReplacingOccurrencesOfString("-", withString: "").stringByReplacingOccurrencesOfString("+86", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
  
        guard newMobile.length == 11 else {
            
            return nil
        }
        
        let isMatch1 =  NSPredicate(format: "SELF MATCHES %@", "\(Cm)").evaluateWithObject(newMobile)
        let isMatch2 =  NSPredicate(format: "SELF MATCHES %@", "\(Cu)").evaluateWithObject(newMobile)
        let isMatch3 =  NSPredicate(format: "SELF MATCHES %@", "\(Ct)").evaluateWithObject(newMobile)

    
        
        if isMatch1 || isMatch2 || isMatch3 {
            
            return newMobile
            
        }else
        {
            return nil
        }
        
    }
    
}


