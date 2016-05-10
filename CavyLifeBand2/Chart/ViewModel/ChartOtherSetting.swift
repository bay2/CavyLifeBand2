//
//  ChartLengthNote.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit
import EZSwiftExtensions


enum ChartViewStyle {
    case SleepChart
    case StepChart
}

enum TimeBucketStyle: String {
    case Day = "Day"
    case Week = "Week"
    case Month = "Month"
}

/// 时间段 宽度
let timeButtonWidth = ez.screenWidth / 3
/// 时间段 高度
let timeButtonHeight: CGFloat = 44
/// 左右inset
let insetSpace: CGFloat = 20
/// 详情 - chart 高度
let chartViewHight: CGFloat = 212
/// 详情 -list - cell 高度
let listcellHight: CGFloat = 42
/// 详情-list 高度
//let listViewHight: CGFloat = listcellHight * 4 + 20
/// 详情页面 宽
let infoViewWidth: CGFloat = ez.screenWidth - insetSpace * 2
/// 详情页面 高
//let infoViewHeight: CGFloat = chartViewHight + listViewHight

let dayTime = ["00:00", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
let dayData: [Double] = [0.1, 0, 0, 0, 0, 0.3, 0, 1, 1, 2, 1.2, 1, 1.5, 1, 2.4, 0, 0, 0.3, 0, 1.3, 2.5, 0, 0, 0]
let sleepDegree: [Double] = [180, 273]
let sleepName = ["深睡", "浅睡"]
let weekTime = ["Mon", "Stu", "Wed", "Thu", "Fir", "Str", "Sun"]
let deepSleep: [Double] = [3.5, 2.3, 1.3, 2, 2.5, 2.6, 1.9]
let lightSleep: [Double] = [3.5, 2.3, 1.3, 2, 2.5, 2.6, 1.9]



