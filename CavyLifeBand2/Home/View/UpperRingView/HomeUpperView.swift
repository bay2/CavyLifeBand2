//
//  HomeUpperView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class HomeUpperView: UIView {
    
    /// 睡眠环
    @IBOutlet weak var sleepRing: UIView!
    
    ///  计步环
    @IBOutlet weak var stepRing: UIView!
    
    /// 天气
    @IBOutlet weak var weatherView: UIView!
    
    var viewController = UIViewController()
    
    /**
     适配
     */
    func allViewLayout() {
        
        // 睡眠
        let sleepView = NSBundle.mainBundle().loadNibNamed("HomeRingView", owner: nil, options: nil).first as? HomeRingView
        sleepRing.addSubview(sleepView!)
        sleepRing.layer.cornerRadius = sleepRing.frame.width / 2
        sleepView!.layer.cornerRadius = sleepView!.frame.width / 2
        sleepView!.snp_makeConstraints(closure: { make in
            make.left.right.top.bottom.equalTo(sleepRing)
        })
        sleepView!.sleepRingWith(.SleepRing, targetHour: 7, targetMinute: 0, currentHour: 5, currentMinute: 10)
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
        stepView!.stepRingWith(.StepRing, targetNumber: 80000, currentNumber: 50000)
        stepView!.addTapGesture {(_) in
            self.showStepDetailView()
        }
        
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
