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
let subTimeButtonWidth = ez.screenWidth / 5
/// 左右inset
let insetSpace: CGFloat = 20

// ----------计步睡眠图标页面的高度--------------

/* 详情 - chart
 * 其他高度  |-50-|-44-|-280-|-50 * 4(或3)-|
 * 5s的     |-40-|-40-|-230-|-44 * 4(或3)-|
 */
/// 时间段 高度
var timeButtonHeight: CGFloat = 50
var subTimeButtonHeight: CGFloat = 44
//var timeButtonHeight: CGFloat = 40
//var subTimeButtonHeight: CGFloat = 40

/* 详情 - chart
 * 其他高度  |-40-|-210-|-30-| = 280
 * 5s的     |-20-|-190-|-20-| = 230
 */
//var chartTopHeigh: CGFloat = 20
//var chartMiddleHeigh: CGFloat = 190
//var chartBottomHeigh: CGFloat = 20
//var chartViewHight: CGFloat = chartTopHeigh + chartMiddleHeigh + chartBottomHeigh
var chartTopHeigh: CGFloat = 40
var chartMiddleHeigh: CGFloat = 210
var chartBottomHeigh: CGFloat = 30
var chartViewHight: CGFloat = chartTopHeigh + chartMiddleHeigh + chartBottomHeigh

/// 详情 -list - cell 高度
var listcellHight: CGFloat = 50
//var listcellHight: CGFloat = 44

// ----------计步睡眠图标页面的高度--------------

//let weekTime = ["Mon", "Stu", "Wed", "Thu", "Fir", "Str", "Sun"]
let weekArray: [String] = [L10n.AlarmDayMonday.string,
                           L10n.AlarmDayTuesday.string,
                           L10n.AlarmDayWednesday.string,
                           L10n.AlarmDayThursday.string,
                           L10n.AlarmDayFriday.string,
                           L10n.AlarmDaySaturday.string,
                           L10n.AlarmDaySunday.string]
//MARK: 解析数据 一小时6条数据 一天 24小时
let oneHourHav = 6
let OneDayHave = 24

