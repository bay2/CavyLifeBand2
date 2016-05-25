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

class HomeUpperView: UIView, UserInfoRealmOperateDelegate, HomeListRealmProtocol {
    
    var realm: Realm = try! Realm()
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    /// 天气
    @IBOutlet weak var weatherView: UIView!
    
    /// 睡眠环
    @IBOutlet weak var sleepRing: UIView!
    
    ///  计步环
    @IBOutlet weak var stepRing: UIView!
    
    var viewController = UIViewController() 

    /**
     适配
     */
    func allViewLayout() {
        
        // 天气
        weatherView.snp_makeConstraints(closure: { make in
            make.left.equalTo(self).offset(40)
        })
        let weather = NSBundle.mainBundle().loadNibNamed("HomeWeatherView", owner: nil, options: nil).first as? HomeWeatherView
        weatherView.addSubview(weather!)
        weather!.snp_makeConstraints { make in
            make.left.right.top.bottom.equalTo(weatherView)
        }
        weather!.loadWeatherView()
        
        // 睡眠
        let sleepView = NSBundle.mainBundle().loadNibNamed("HomeRingView", owner: nil, options: nil).first as? HomeRingView
        sleepRing.addSubview(sleepView!)
        sleepRing.layer.cornerRadius = sleepRing.frame.width / 2
        sleepView!.layer.cornerRadius = sleepView!.frame.width / 2
        sleepView!.snp_makeConstraints(closure: { make in
            make.left.right.top.bottom.equalTo(sleepRing)
        })
        sleepView!.ringStyle = .SleepRing
        sleepView!.ringDefaultSetting()
        sleepView!.addTapGesture {(_) in
            self.showSleepDetailView()
        }
        
        // 计步
        let stepView = NSBundle.mainBundle().loadNibNamed("HomeRingView", owner: nil, options: nil).first as? HomeRingView
        stepRing.addSubview(stepView!)
        stepRing.layer.cornerRadius = stepView!.frame.width / 2
        stepView!.layer.cornerRadius = stepView!.frame.width / 2
        stepView!.snp_makeConstraints(closure: { make in
            make.left.right.top.bottom.equalTo(stepRing)

        })
        stepView!.ringStyle = .StepRing
        stepView!.ringDefaultSetting()
        stepView!.addTapGesture {(_) in
            self.showStepDetailView()
        }
        
        // 计步睡眠目标值
        guard let userInfo: UserInfoModel = queryUserInfo(userId) else {
            return
        }
        
        let sleepString = userInfo.sleepTime
        let sleepTimeArray = sleepString.componentsSeparatedByString(":")
        let sleepTargetNumber = sleepTimeArray[0].toInt()! * 60 + sleepTimeArray[1].toInt()!
        let stepTargetNumber = userInfo.stepNum
        
        // 计步失眠 当前值
        
        let time = NSDate().toString(format: "yyyy-MM-dd")
        let result = queryHomeList(time)!
//        let stepCurrentNumber = result.stepCount
//        let sleepCurrentNumber = result.sleepTime
        
        let stepCurrentNumber = Int(arc4random_uniform(UInt32(stepTargetNumber + 1)))
        let sleepCurrentNumber = Int(arc4random_uniform(UInt32(sleepTargetNumber + 1)))
        
        stepView!.ringWithStyle(stepTargetNumber, currentNumber: stepCurrentNumber)
        sleepView!.ringWithStyle(sleepTargetNumber, currentNumber: sleepCurrentNumber)

    }
    
    func showSleepDetailView(){
        
        let sleepVM = ChartViewModel(title: L10n.ContactsShowInfoSleep.string, chartStyle: .SleepChart)
        let chartVC = ChartBaseViewController()
        chartVC.configChartBaseView(sleepVM)
        
        self.viewController.pushVC(chartVC)
    }
    
    func showStepDetailView(){
        
        let stepVM = ChartViewModel(title: L10n.ContactsShowInfoStep.string, chartStyle: .StepChart)
        let chartVC = ChartBaseViewController()
        chartVC.configChartBaseView(stepVM)
        
        self.viewController.pushVC(chartVC)
    }
    
}
