//
//  HomeSleepViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//


import UIKit
import EZSwiftExtensions


struct HomeSleepViewModel: RingViewDataSource, RingViewDelegate{
    
    var image: UIImage { return UIImage(asset: .GuideOpenBand) }
    var currentLabText: String { return "  " }
    var percentLabText: String { return "  " }
    
    var currectNumber: Int { return 0 }
    var targetNumber: Int { return 0 }
    
    
    func setCurrentLabelText() {
        
    }
    
    func setPercentLabelText() {
        
    }
    
    
    
    
    
    
    
}

