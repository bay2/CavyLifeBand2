//
//  HomeRingView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Log
import EZSwiftExtensions

enum RingStyle {
    
    case StepRing
    case SleepRing
    
}

class HomeRingView: UIView {
    
    /// 图片
    @IBOutlet weak var imgView: UIImageView?
    
    /// 当前值
    @IBOutlet weak var currentLabel: UILabel?
    
    /// 完成百分比
    @IBOutlet weak var percentLabel: UILabel?
    
    var ringStyle: RingStyle = .SleepRing
    

    override func awakeFromNib() {
        
    }
    
    
    
    
    /**
     计步进度环
     
     - parameter targetNumber:
     - parameter currentNumber: 
     */
    func  stepRingWith(targetNumber: Int, currentNumber: Int) {
        
        
   
        
    }
    

    
    /**
     返回当前值的文本
     
     - returns:
     */
    func currectLabel() -> String {
        
        
        switch ringStyle {
            
        case .SleepRing:
            
            self.frame = CGRectMake(0, 0, ez.screenWidth * 0.35, ez.screenWidth * 0.35)
            
        case .StepRing:
            
            self.frame = CGRectMake(0, 0, ez.screenWidth * 0.55, ez.screenWidth * 0.55)
            
            
        }
        
        return " "
        
        
    }
    
    
    
    /**
     返回百分比的文本
     
     - returns:
     */
    func percentLabelText(targetNum: Int, currectNum: Int) -> String{
        
        var percent = currectNum / targetNum
        
        if percent > 2 {
            
            percent = 100
            
        } else {
            
            percent *= 100
        }
        
        switch ringStyle {
            
        case .SleepRing:
            
           let percentLabeltext = "\(percent)"
            
            return percentLabeltext
            
        case .StepRing:
            
            self.frame = CGRectMake(0, 0, ez.screenWidth * 0.55, ez.screenWidth * 0.55)
            
            let percentLabeltext = "\(percent)"
            
            return percentLabeltext

            
        }
                
    }
    
    
    /**
     返回百分比
     */
    func percentNumber(targetNum: Int, currectNum: Int) -> Int {
        
        let percent = currectNum / targetNum
        
        if percent > 2 {
            
            return 100
            
        } else {
            
            return percent * 100
        }
        
    }
    
    

}
