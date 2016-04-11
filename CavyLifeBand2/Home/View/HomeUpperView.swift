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
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        allViewLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
     适配
     */
    func allViewLayout() {
        
        self.frame = CGRectMake(0, 0, ez.screenWidth, 96 + ez.screenWidth * 0.55)
        
        
        
        
        
        
        
        
    }
    
    
    
}
