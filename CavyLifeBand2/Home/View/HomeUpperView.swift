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
    

    /**
     适配
     */
    func allViewLayout() {
        
        self.frame = CGRectMake(0, 0, ez.screenWidth, 96 + ez.screenWidth * 0.55)
        
        // 睡眠
        let sleepView = NSBundle.mainBundle().loadNibNamed("HomeRingView", owner: nil, options: nil).first as? HomeRingView
        sleepRing.addSubview(sleepView!)
        sleepRing.layer.cornerRadius = sleepRing.frame.width / 2
        sleepView!.layer.cornerRadius = sleepView!.frame.width / 2
        sleepView!.snp_makeConstraints(closure: { (make) in
            make.left.right.top.bottom.equalTo(sleepRing)
        })
        sleepView!.sleepRingWith(.SleepRing, targetHour: 7, targetMinute: 0, currentHour: 5, currentMinute: 10)
        
        
        // 计步
        let stepView = NSBundle.mainBundle().loadNibNamed("HomeRingView", owner: nil, options: nil).first as? HomeRingView
        stepRing.addSubview(stepView!)
        stepRing.layer.cornerRadius = stepView!.frame.width / 2
        stepView!.layer.cornerRadius = stepView!.frame.width / 2
        stepView!.snp_makeConstraints(closure: { (make) in
            make.left.right.top.bottom.equalTo(stepRing)

        })
        stepView!.stepRingWith(.StepRing, targetNumber: 80000, currentNumber: 50000)
        
       // 天气
        weatherView.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self).offset(40)
        })
        let weather = NSBundle.mainBundle().loadNibNamed("HomeWeatherView", owner: nil, options: nil).first as? HomeWeatherView
        weatherView.addSubview(weather!)
        weather!.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(weatherView)
        }
        weather!.loadWeatherView()
        
    }
    
    
    
    
}
