//
//  StepsDataReaml.swift
//  CavyLifeBand2
//
//  Created by Hanks on 16/6/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import RealmSwift
import Log
import Datez
import JSONJoy


class NChartStepDataRealm: Object {
    
    dynamic var userId             = ""
    dynamic var date: NSDate       = NSDate()
    dynamic var kilometer: CGFloat = 0
    dynamic var totalTime: Int     = 0
    dynamic var totalStep: Int     = 0
    dynamic var stepList: Array<[[String :Int]]>    = []
  
    
}

