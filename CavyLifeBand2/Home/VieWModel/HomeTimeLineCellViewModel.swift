//
//  HomeTimeLineCellViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

/**
 *  计步cell
 */
struct TimeLineStepViewModel: HomeTimeLineDataSource, HomeTimeLineDelegate {
    
    var image: UIImage { return UIImage(asset: .HomeListStep) }
    var title: String { return L10n.HomeTimeLineCellStep.string }
    var time: String { return "00:00" }
    var others: String{ return "" }
    var resultNum: NSMutableAttributedString { return NSMutableAttributedString() }
    
    func configSleepViewModel(stepNumber: Int) {
        
        resultNum.appendAttributedString(NSMutableAttributedString().attributeString(String(stepNumber), numSize: 16, unit: L10n.GuideStep.string, unitSize: 14))
    }
    
    
    // 跳到计步详情页
    func showDetailViewController() {
     Log.info("跳到计步详情")
    }
    
}

/**
 *  睡眠Cell
 */
struct TimeLineSleepViewModel: HomeTimeLineDataSource, HomeTimeLineDelegate {
    
    var image: UIImage { return UIImage(asset: .HomeListSleep) }
    var title: String { return L10n.HomeTimeLineCellSleep.string }
    var time: String { return "00:00" }
    var others: String{ return "" }
    var resultNum: NSMutableAttributedString { return NSMutableAttributedString() }
    
    func sleepViewModelNeed() {
        
    }
    
    // 跳到睡眠详情页
    func showDetailViewController() {
        
    }
    
}

/**
 *  成就cell
 */
struct TimeLineAchiveViewModel: HomeTimeLineDataSource, HomeTimeLineDelegate {
    
    var image: UIImage { return UIImage() }
    var title: String { return L10n.HomeTimeLineCellAchive.string }
    var time: String { return "00:00" }
    var others: String{ return "" }
    var resultNum: NSMutableAttributedString { return NSMutableAttributedString() }
    
    // 跳到成就详情页
    func showDetailViewController() {
        
    }
    
}

/**
 *  PKcell
 */
struct TimeLinePKViewModel: HomeTimeLineDataSource, HomeTimeLineDelegate {
    
    var image: UIImage { return UIImage(asset: .HomeListPK) }
    var title: String { return L10n.HomeTimeLineCellPK.string }
    var time: String { return "00:00" }
    var others: String{ return "东坡排骨" }
    var resultNum: NSMutableAttributedString { return NSMutableAttributedString() }
    
    // 跳到PK详情页
    func showDetailViewController() {
        
    }
    
}

/**
 *  健康 cell
 */
struct TimeLineHealthViewModel: HomeTimeLineDataSource, HomeTimeLineDelegate {
    
    var image: UIImage { return UIImage(asset: .HomeListHealth) }
    var title: String { return L10n.HomeTimeLineCellHealthiy.string }
    var time: String { return "00:00" }
    var others: String{ return "东坡排骨" }
    var resultNum: NSMutableAttributedString { return NSMutableAttributedString() }
    
    // 跳到健康详情页
    func showDetailViewController() {
        
    }
    
}
 