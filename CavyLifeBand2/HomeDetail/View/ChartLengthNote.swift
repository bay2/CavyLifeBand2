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

/// 时间段 宽度
let timeButtonWidth = ez.screenWidth / 3
/// 时间段 高度
let timeButtonHeight: CGFloat = 44
/// 左右inset
let insetSpace: CGFloat = 20
/// 详情 - chart 高度
let chartViewHight: CGFloat = 212
/// 详情 -list - cell 高度
let listcellHight: CGFloat = 44
/// 详情-list 高度
let listViewHight: CGFloat = 44 * 4 + 20
/// 详情页面 宽
let infoViewWidth: CGFloat = ez.screenWidth - insetSpace * 2
/// 详情页面 高
let infoViewHeight: CGFloat = chartViewHight + listViewHight
