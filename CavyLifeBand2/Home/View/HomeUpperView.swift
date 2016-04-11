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
    @IBOutlet weak var sleepRing: HomeRingView!
    
    ///  计步环
    @IBOutlet weak var stepRing: HomeRingView!
    
    /// 天气
    @IBOutlet weak var weatherView: UIView!
    


    /**
     适配
     */
    func allViewLayout() {
        
        self.frame = CGRectMake(0, 0, ez.screenWidth, 96 + ez.screenWidth * 0.55)
        
//        sleepRing = NSBundle.mainBundle().loadNibNamed("HomeRingView", owner: nil, options: nil).first as? HomeRingView
//        stepRing = NSBundle.mainBundle().loadNibNamed("HomeRingView", owner: nil, options: nil).first as? HomeRingView
//   
        
        let test = NSBundle.mainBundle().loadNibNamed("HomeRingView", owner: nil, options: nil).first as? HomeRingView
        test?.frame = CGRect(x: 0, y: 0, w: 100, h: 100)
        self.addSubview(test!)
        
        weatherView.backgroundColor = UIColor.whiteColor()
        sleepRing.backgroundColor = UIColor.yellowColor()
        stepRing.backgroundColor = UIColor.blueColor()
        
        Log.info("\(sleepRing)")
        
        
        // 计步
        
//        stepRing.stepRingWith(80000, currentNumber: 50000)
        
        
    }
    
    
    
}
