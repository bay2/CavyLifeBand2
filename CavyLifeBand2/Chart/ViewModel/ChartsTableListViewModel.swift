//
//  ChartsTableListViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/6/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol ChartsTableDataSource {
    
    var labelLeftArray: [String] { get }
    
//    var listCount: Int
//
//    var timeString: String
//    
//    var tableViewHight: CGFloat
//    
//  
    
}

struct StepChartsModel: ChartsTableDataSource {
    
    var labelLeftArray: [String] = []
    
    init(timeBucket: TimeBucketStyle) {
        
        switch timeBucket {
            
        case .Week:
            
            labelLeftArray = [L10n.ChartStepWeekStep.string, L10n.ChartStepKilometer.string, L10n.ChartStepAverageStep.string, L10n.ChartStepTimeUsed.string]
        case .Month:
            
            labelLeftArray = [L10n.ChartStepMonthStep.string, L10n.ChartStepKilometer.string, L10n.ChartStepAverageStep.string, L10n.ChartStepTimeUsed.string]
            
        default:
            labelLeftArray = [L10n.ChartStepTodayStep.string, L10n.ChartStepKilometer.string, L10n.ChartTargetPercent.string, L10n.ChartStepTimeUsed.string]
            
            
        }
        

    }
    
}



struct SleepChartsModel {
    
    var labelLeftArray: [String] = []
    
    init(timeBucket: TimeBucketStyle) {
        
        switch timeBucket {
        case.Day:
            labelLeftArray = [L10n.ChartTargetPercent.string]
        case .Week, .Month:
            labelLeftArray = [L10n.ChartSleepAverage.string]
        }
        
        
    }

}

