//
//  ChartInfoViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/10.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

/**
 *  计步柱状图
 */
struct BarChartViewModel: BarChartDataSource {
    
    
    
    
    
    
}

/**
 *  睡眠柱状图
 */
struct StackChartViewModel: BarChartDataSource {
 
    
    
    
}


/**
 *  柱状图代理
 */
protocol BarChartDataSource {
    
    var dataCount: Int { get }
    var legendColors: [UIColor] { get }
    var leftMaxValue: Int { get }
    var leftLabelCount: Int { get }
    var legendText: String { get }
    var leftUnit: String { get }
    var spaceBetweenLabel: Int { get }
    var stackLabel: [String] { get }
    
}

extension BarChartDataSource {
    
    var leftMaxValue: Int { return 1 }
    var leftLabelCount: Int { return 1 }
    var legendText: String { return "" }
    var legendColors: [UIColor] { return [UIColor.whiteColor()] }
    var leftUnit: String { return ""}
    var spaceBetweenLabel: Int { return 1 }
    var dataCount: Int { return 1 }
    var stackLabel: [String] { return [""] }
}

