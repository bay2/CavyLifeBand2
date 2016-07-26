//
//  HomeListViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

/**
 *  计步cell
 */
struct HomeListStepViewModel: HomeListViewModelProtocol {
    
    var image: UIImage { return UIImage(asset: .HomeListStep) }
    var title: String { return L10n.HomeTimeLineCellStep.string }
    var friendName: String { return "" }
    var friendIconUrl: String { return "" }
    var resultNum: NSMutableAttributedString
    
    
    init(stepNumber: Int) {
        resultNum = NSMutableAttributedString().attributeString(String(stepNumber), numSize: 30, unit: L10n.GuideStep.string, unitSize: 12)
    }
    
    func onClickCell() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowStepView.rawValue, object: nil)
    }
    
}


/**
 *  睡眠Cell
 */
struct HomeListSleepViewModel: HomeListViewModelProtocol {
    
    var image: UIImage { return UIImage(asset: .HomeListSleep) }
    var title: String { return L10n.HomeTimeLineCellSleep.string }
    var friendName: String{ return "" }
    var friendIconUrl: String { return "" }

    var resultNum: NSMutableAttributedString
    
    init(sleepTime: Int) {

        let sleepHour = sleepTime / 60
        let sleepMin = sleepTime - sleepHour * 60
        resultNum = NSMutableAttributedString().attributeString(String(sleepHour), numSize: 30, unit: L10n.HomeSleepRingUnitHour.string, unitSize: 12)
        resultNum.appendAttributedString(NSMutableAttributedString().attributeString(String(sleepMin), numSize: 30, unit: L10n.HomeSleepRingUnitMinute.string, unitSize: 12))
    }
    
    func onClickCell() {

        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowSleepView.rawValue, object: nil)
        
    }
    
}

/**
 *  成就cell
 */
struct HomeListAchiveViewModel: HomeListViewModelProtocol {
    
    var image: UIImage { return UIImage(asset: .HomeListHonor) }
    var title: String { return L10n.HomeTimeLineCellAchive.string }
    var friendName: String{ return "" }
    var friendIconUrl: String { return "" }
    var resultNum: NSMutableAttributedString
    var medalIndex: Int
    
    // 0 ~ 5 共6个徽章 返回编号
    init(medalIndex: Int) {
        
        self.medalIndex = medalIndex
        
        let stepArray = [5000, 20000, 100000, 500000, 1000000, 5000000]
        resultNum = NSMutableAttributedString().attributeString(String(stepArray[medalIndex]), numSize: 28, unit: L10n.GuideStep.string, unitSize: 12)
    }
    
    func onClickCell() {

        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowAchieveView.rawValue, object: medalIndex)
    }
    
}

/**
 *  PKcell
 */
struct HomeListPKViewModel: HomeListViewModelProtocol {
    
    var image: UIImage { return UIImage(asset: .HomeListPK) }
    var title: String { return L10n.HomeTimeLineCellPK.string }
    var friendName: String
    var friendIconUrl: String { return "" }
    var resultNum: NSMutableAttributedString
    var pkId: String
    
    
    init(friendName: String, pkId: String, result: String) {
        self.friendName = friendName
        self.pkId = pkId
        resultNum = NSMutableAttributedString().attributeString(result, numSize: 24, unit: "", unitSize: 0)
    }
    
    func onClickCell() {

        let userInfo = ["pkId": self.pkId, "status": String(self.resultNum)]
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowPKView.rawValue, object: nil, userInfo: userInfo)
    }
    
}

/**
 *  健康 cell
 */
struct HomeListHealthViewModel: HomeListViewModelProtocol {
    
    var image: UIImage { return UIImage() }
    var title: String { return L10n.HomeTimeLineCellHealthiy.string }
    var friendName: String
    var friendId: String
    var friendIconUrl: String
    var resultNum: NSMutableAttributedString{ return NSMutableAttributedString(string: L10n.HomeTimeLineHealthyCare.string) }
    
    init(othersName: String, iconUrl: String, friendId: String){
        friendName = othersName
        friendIconUrl = iconUrl
        self.friendId = friendId

    }
    
    func onClickCell() {
        
        var userInfo = ["friendName": "", "friendId": ""]
        
        if friendName != "" && friendId != "" {
            
            userInfo = ["friendName": self.friendName, "friendId": self.friendId]

        }
        
        Log.info("\(userInfo)")
       
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowHealthyView.rawValue, object: nil, userInfo: userInfo)
        
    }
    
}
 