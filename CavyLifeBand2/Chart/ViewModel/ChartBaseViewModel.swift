//
//  ChartViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit


protocol ChartViewProtocol {
    
    var title: String { get }
    var chartStyle: ChartViewStyle { get }
    
    
}

struct ChartViewModel: ChartViewProtocol {
    
    var title: String
    var chartStyle: ChartViewStyle
    
    init(title: String, chartStyle: ChartViewStyle) {
        
        self.title = title
        
        self.chartStyle = chartStyle
    }
    
}