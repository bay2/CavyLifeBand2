//
//  HomeRingView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Log



class HomeRingView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    enum RingStyle {
        
        case StepRing
        case SleepRing
        
    }
    
    
    
    /**
     计步
     
     - parameter ringStyle:     圆环类型
     - parameter targetNumber:  目标值
     - parameter currentNumber: 当前值
     */
    func  stepRingWith(ringStyle: RingStyle, targetNumber: Int, currentNumber: Int) {
        
        switch ringStyle {
            
        case .SleepRing:
            Log.info("SleepRing")
            
            
            
            
            
            
            
            
            
            
            
        case .StepRing:
            Log.info("SleepRing")
            
            
            
            
            
            
        }
        
    }
    
    
    
    
    

}
