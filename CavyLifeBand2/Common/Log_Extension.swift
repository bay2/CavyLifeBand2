//
//  Log_Extension.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/1/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import Log

extension Logger {
    
    func netRequestFormater(url: String, para: [String: AnyObject]? = nil) {
        
        guard enabled else {
            return
        }
        
        if para == nil {
            self.info("\(url)")
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
        
        self.info("\(requestUrl)")
        
    }
    
}
