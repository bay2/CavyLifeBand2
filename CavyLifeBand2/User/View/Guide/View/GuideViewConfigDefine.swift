//
//  GuideViewConfigDefine.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/26.
//  Copyright © 2016年 xuemincai. All rights reserved.
//


import UIKit
import EZSwiftExtensions

/// 左右宽度
let horizontalInset: CGFloat = 20
/// 导航栏高度
let navHeight: CGFloat = 64
/// 引导页 导航栏和中间视图的垂直间隔
let upInset: CGFloat = 40
/// 中间视图距离底部的垂直高度
let bottomInset: CGFloat = 110
/// 中间视图的frame
let middleViewWidth = ez.screenWidth - horizontalInset * 2
let middleViewHeight = ez.screenHeight - navHeight - upInset - bottomInset

/// 生日页面
/// 年月模块高度
let birthRulerViewHeight: CGFloat = 110
/// 尺子宽高
let birthRulerWidth = ez.screenWidth - horizontalInset * 2
let birthRulerHeight: CGFloat = birthRulerViewHeight * 0.5
/// 大刻度线长度
let birthRulerLongLine: CGFloat = birthRulerViewHeight * 0.3
/// 小刻度线长度
let birthRulerShortLine: CGFloat = birthRulerViewHeight * 0.15
/// 上下格尺的间隙
let rulerBetweenSpace: CGFloat = 30
// 年月的刻度间隙 和 单位进制数
let birthYYMMLineSpace = 10
let birthYYMMLineCount = 12
/// 日期的刻度间隙 和 单位进制数
let birthDayLineSpace = 20
let birthDayLineCount = 5

/// 身高页面 
/// 尺子垂直长度
let heightRulerHeight = ez.screenHeight - navHeight - upInset - bottomInset - horizontalInset * 2
let heightRulerWidth: CGFloat = 80
/// 大刻度线长度
let heightRulerLongLine: CGFloat = 40
/// 小刻度线长度
let heightRulerShortLine: CGFloat = 20
/// 刻度间隙 和 单位进制数
let heightLineSpace = 12
let heightLineCount = 10




