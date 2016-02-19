//
//  Log_Extension.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import Log

public enum Level {
    case Trace, Debug, Info, Warning, Error
    
    var description: String {
        return String(self).uppercaseString
    }
}

extension Logger {
    
    func netRequestFormater(url: String, para: [String: AnyObject]? = nil, items: Any..., separator: String = " ", terminator: String = "\n", file: String = __FILE__, line: Int = __LINE__, column: Int = __COLUMN__, function: String = __FUNCTION__) {
        
        guard enabled else {
            return
        }
        
        if para == nil {
            self.info("\(url)", file: file, line: line, column: column, function: function)
            return
        }
        
        var requestUrl = url + "?"
        var isFirst = true
        
        for (key, value) in para! {
            
            if isFirst {
                isFirst = false
                requestUrl = requestUrl + "\(key)=\(value)"
            } else {
                requestUrl = requestUrl + "&\(key)=\(value)"
            }
            
            
        }
        
        self.info("\(requestUrl)", file: file, line: line, column: column, function: function)
        
    }

    
}

