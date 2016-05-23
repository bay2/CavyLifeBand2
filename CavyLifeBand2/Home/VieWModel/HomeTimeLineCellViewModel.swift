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
    var friendName: String { return "" }
    var resultNum: NSMutableAttributedString
    

    init(stepNumber: Int) {
        resultNum = NSMutableAttributedString().attributeString(String(stepNumber), numSize: 16, unit: L10n.GuideStep.string, unitSize: 14)
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
    var friendName: String{ return "" }
    var resultNum: NSMutableAttributedString
    
    init(sleepHour: Int, sleepMin: Int) {
        resultNum = NSMutableAttributedString().attributeString(String(sleepHour), numSize: 16, unit: L10n.HomeSleepRingUnitHour.string, unitSize: 14)
        resultNum.appendAttributedString(NSMutableAttributedString().attributeString(String(sleepMin), numSize: 16, unit: L10n.HomeSleepRingUnitMinute.string, unitSize: 14))
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
    var friendName: String{ return "" }
    var resultNum: NSMutableAttributedString
    
    init(result: String) {
        resultNum = NSMutableAttributedString(string: "徽章")
    }
    
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
    var friendName: String
    var resultNum: NSMutableAttributedString
    
    
    init(othersName: String, result: String) {
        friendName = othersName
        resultNum = NSMutableAttributedString(string: result)
    }
    
    /**
     返回不同的富文本内容
     */
    func attrsString(str: String) -> NSMutableAttributedString {
        
        let attrs = NSMutableAttributedString(string: str)
        
        attrs.addAttribute(NSForegroundColorAttributeName, value: UIColor(named: .HomeTimeLinePKCellTextColor), range: NSMakeRange(0, str.length))
        
        // XX领先了10000步
        
        // XX落后了10000步
        
        // XX胜利了
        
        // XX失败了
    
        return attrs
        
    }
    
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
    var friendName: String
    var resultNum: NSMutableAttributedString{ return NSMutableAttributedString(string: L10n.HomeTimeLineHealthyCare.string) }
    
    init( othersName: String){
        friendName = othersName
    }
    
    
    // 跳到健康详情页
    func showDetailViewController() {
        
    }
    
}
 