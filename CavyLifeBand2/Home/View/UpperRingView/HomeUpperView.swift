//
//  HomeUpperView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import RealmSwift
import Datez

enum NumberFollowUpper: String {
    
    case FollowUpperSleep
    case FollowUpperStep
    
}

class HomeUpperView: UIView, UserInfoRealmOperateDelegate, ChartsRealmProtocol {
    
    var realm: Realm = try! Realm()
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    /// 天气
    @IBOutlet weak var weatherView: UIView!
    
    /// 睡眠环
    @IBOutlet weak var sleepRing: UIView!
    
    ///  计步环
    @IBOutlet weak var stepRing: UIView!
    
    var sleepView: HomeRingView!
    
    var stepView: HomeRingView!
    
    var viewController = UIViewController()
    
    var stepNotificationToken: NotificationToken?
    
    var sleepNotificationToken: NotificationToken?
    
    /**
     上面环形和下面List的计步睡眠数据不一致 需要同步
     
     - FollowUpperSleep: 跟随Upper的睡眠变化
     - FollowUpperStep:  跟随Upper的计步变化
     */

    override func awakeFromNib() {
        
        allViewLayout()
        configStepAndSleepValue()
        
        configRealm()

        // 接受改变目标后回来改变视图的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateUpperViewRing), name: "updateUpperViewRing", object: nil)

    }
    
    func configRealm() {
        
        let stepRealmReslut = queryAllStepInfo()
        let sleepRealmReslut = queryAllSleepInfo()
        
        stepNotificationToken = stepRealmReslut.addNotificationBlock { change in
            
            switch change {
            case .Update(_, deletions: _, insertions: _, modifications: _):
                self.configStepValue()
                NSNotificationCenter.defaultCenter().postNotificationName(NumberFollowUpper.FollowUpperStep.rawValue, object: nil)

            default:
                break
            }
            
        }
        
        sleepNotificationToken = sleepRealmReslut.addNotificationBlock { change in
            switch change {
            case .Update(_, deletions: _, insertions: _, modifications: _):
                self.configSleepValue()
                NSNotificationCenter.defaultCenter().postNotificationName(NumberFollowUpper.FollowUpperSleep.rawValue, object: nil)

            default:
                break
            }
        }
        
    }

    /**
     适配
     */
    func allViewLayout() {
        
        // 天气
        weatherView.snp_makeConstraints(closure: { make in
            make.left.equalTo(self).offset(40)
        })
        
        
        guard let weather = NSBundle.mainBundle().loadNibNamed("HomeWeatherView", owner: nil, options: nil).first as? HomeWeatherView else {
            fatalError("loadNibNamed view(HomeWeatherView) error")
        }
        
        weatherView.addSubview(weather)
        weather.snp_makeConstraints { make in
            make.left.right.top.bottom.equalTo(weatherView)
        }
        weather.loadWeatherView()
        
        // 睡眠
        guard let loadSleepView = NSBundle.mainBundle().loadNibNamed("HomeRingView", owner: nil, options: nil).first as? HomeRingView else {
            fatalError("loadNibNamed view(HomeRingView) error")
        }
        
        self.sleepView = loadSleepView
        
        sleepRing.addSubview(self.sleepView)
        sleepRing.layer.cornerRadius = sleepRing.frame.width / 2
        self.sleepView.layer.cornerRadius = self.sleepView.frame.width / 2
        self.sleepView.snp_makeConstraints(closure: { make in
            make.left.right.top.bottom.equalTo(sleepRing)
        })
        self.sleepView.ringStyle = .SleepRing
        self.sleepView.ringDefaultSetting()
        self.sleepView.addTapGesture { [unowned self] _ in
            self.showSleepDetailView()
        }
        
        
        // 计步
        guard let loadStepView = NSBundle.mainBundle().loadNibNamed("HomeRingView", owner: nil, options: nil).first as? HomeRingView else {
            fatalError("")
        }
        
        self.stepView = loadStepView
        
        stepRing.addSubview(self.stepView)
        stepRing.layer.cornerRadius = self.stepView.frame.width / 2
        self.stepView.layer.cornerRadius = self.stepView.frame.width / 2
        self.stepView.snp_makeConstraints(closure: { make in
            make.left.right.top.bottom.equalTo(stepRing)

        })
        
        self.stepView.ringStyle = .StepRing
        self.stepView.ringDefaultSetting()
        self.stepView.addTapGesture { [unowned self] _ in
            self.showStepDetailView()
        }
        
    }
    
    func configStepAndSleepValue() {
        
        configSleepValue()
        configStepValue()
        
    }
    
    func configSleepValue() {
        
        // 计步睡眠目标值
        guard let userInfo: UserInfoModel = queryUserInfo(userId) else {
            return
        }
        
        var sleepString = "\(userInfo.sleepGoal/60):\(userInfo.sleepGoal%60)"
        
        if sleepString == "0:0" {
            // 如果没有目标值 则显示推荐值
            sleepString = "8:30"
            
        }
        
        let sleepTimeArray = sleepString.componentsSeparatedByString(":")
        let sleepTargetNumber = sleepTimeArray[0].toInt()! * 60 + sleepTimeArray[1].toInt()!
        
        // 计步睡眠 当前值
        let time = NSDate()
        let resultSeelp = self.querySleepInfoDay(time.gregorian.beginningOfDay.date, endTime: time)
        let sleepCurrentNumber = Int(resultSeelp.0 * 10)
        
        sleepView.ringWithStyle(sleepTargetNumber, currentNumber: sleepCurrentNumber)
        
    }
    
    func configStepValue() {
        
        // 计步睡眠目标值
        guard let userInfo: UserInfoModel = queryUserInfo(userId) else {
            return
        }
        var stepTargetNumber = userInfo.stepGoal
        
        // 如果没有目标值 则显示推荐值
        if stepTargetNumber == 0 {
            stepTargetNumber = 8000
            
        }
        
        let time = NSDate()
        let resultStep = self.queryStepNumber(time.gregorian.beginningOfDay.date, endTime: time, timeBucket: .Day)
        
         let stepCurrentNumber = resultStep.totalStep
        
        stepView.ringWithStyle(stepTargetNumber, currentNumber: stepCurrentNumber)
        
    }
    
    func showSleepDetailView(){
        
        let sleepVM = ChartViewModel(title: L10n.ContactsShowInfoSleep.string, chartStyle: .SleepChart)
        let chartVC = ChartsViewController()
        chartVC.configChartsView(sleepVM)
        
        self.viewController.pushVC(chartVC)
    }
    
    func showStepDetailView(){
        
        let stepVM = ChartViewModel(title: L10n.ContactsShowInfoStep.string, chartStyle: .StepChart)
        let chartVC = ChartsViewController()
        chartVC.configChartsView(stepVM)
        
        self.viewController.pushVC(chartVC)
    }
    
    /**
     更新视图
     修改目标值时候 更新视图
     */
    func updateUpperViewRing() {
        
        configStepAndSleepValue()
        
    }
    
}
