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
        resultNum = NSMutableAttributedString().attributeString(String(stepNumber), numSize: 16, unit: L10n.GuideStep.string, unitSize: 14)
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
        resultNum = NSMutableAttributedString().attributeString(String(sleepHour), numSize: 16, unit: L10n.HomeSleepRingUnitHour.string, unitSize: 14)
        resultNum.appendAttributedString(NSMutableAttributedString().attributeString(String(sleepMin), numSize: 16, unit: L10n.HomeSleepRingUnitMinute.string, unitSize: 14))
    }
    
    func onClickCell() {

        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowSleepView.rawValue, object: nil)
    }
 
    
}

/**
 *  成就cell
 */
struct HomeListAchiveViewModel: HomeListViewModelProtocol {
    
    var image: UIImage
    var title: String { return L10n.HomeTimeLineCellAchive.string }
    var friendName: String{ return "" }
    var friendIconUrl: String { return "" }
    var resultNum: NSMutableAttributedString
    
    init(stepCount: Int) {
        
        switch stepCount {
            
        case 0 ..< 5000:
            
            self.image = UIImage()
            
        case 5000 ..< 20000:
            
            self.image = UIImage(asset: .Medal5000)
        case 20000 ..< 100000:
            
            self.image = UIImage(asset: .Medal20000)
        case 100000 ..< 500000:
            
            self.image = UIImage(asset: .Medal100000)
        case 500000 ..< 1000000:
            
            self.image = UIImage(asset: .Medal500000)
        case 1000000 ..< 5000000:
            
            self.image = UIImage(asset: .Medal1000000)
 
        default:
            self.image = UIImage(asset: .Medal5000000)
        }
        
        resultNum = NSMutableAttributedString(string: "\(stepCount)\(L10n.GuideStep.string)")
        
    }
    
    func onClickCell() {

        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowAchieveView.rawValue, object: nil)
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
        resultNum = NSMutableAttributedString(string: result)
    }
    
    func onClickCell() {

        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowPKView.rawValue, object: nil)
    }
    
}

/**
 *  健康 cell
 */
struct HomeListHealthViewModel: HomeListViewModelProtocol {
    
    var image: UIImage { return UIImage() }
    var title: String { return L10n.HomeTimeLineCellHealthiy.string }
    var friendName: String
    var friendIconUrl: String
    var resultNum: NSMutableAttributedString{ return NSMutableAttributedString(string: L10n.HomeTimeLineHealthyCare.string) }
    
    init(othersName: String, iconUrl: String){
        friendName = othersName
        friendIconUrl = iconUrl
        
    }
    
    func onClickCell() {

        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowHealthyView.rawValue, object: nil)
    }
    
}
 