//
//  ChartJSON.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy


struct ChartView: JSONJoy {
    
    /// 日 周 月
    var timeBucket: String?
    
    init(_ decoder: JSONDecoder) throws {
    
        do { timeBucket = try decoder[""].getString() } catch { timeBucket = "" }
        
    }
    
}









struct ChartStepTableList: JSONJoy {
    
    var todatStep: Int?
    var kilometer: Int?
    var percent: Int?
    var useTime: Int?
    
    init(_ decoder: JSONDecoder) throws {
        
        do { todatStep = try decoder[""].getInt() } catch { todatStep = 0 }
        do { kilometer = try decoder[""].getInt() } catch { kilometer = 0 }
        do { percent = try decoder[""].getInt() } catch { percent = 0 }
        do { useTime = try decoder[""].getInt() } catch { useTime = 0 }
    }
}



struct ChartSlepTableList: JSONJoy {
    
    var indexNumber: Int?
    var deepHour: Int?
    var deepMIn: Int?
    var lightHour: Int?
    var lightMIn: Int?
    var avarage: Int?
    
    init(_ decoder: JSONDecoder) throws {
        
        do { indexNumber = try decoder[""].getInt() } catch { indexNumber = 0 }
        do { deepHour = try decoder[""].getInt() } catch { deepHour = 0 }
        do { deepMIn = try decoder[""].getInt() } catch { deepMIn = 0 }
        do { lightHour = try decoder[""].getInt() } catch { lightHour = 0 }
        do { lightMIn = try decoder[""].getInt() } catch { lightMIn = 0 }
        do { avarage = try decoder[""].getInt() } catch { avarage = 0 }
    }
}



















