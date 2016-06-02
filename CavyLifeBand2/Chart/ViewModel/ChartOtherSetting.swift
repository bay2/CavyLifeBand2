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

let weekTime = ["Mon", "Stu", "Wed", "Thu", "Fir", "Str", "Sun"]

//MARK: 解析数据 一小时6条数据 一天 24小时
let oneHourHav = 6
let OneDayHave = 24

