//
//  HomeStepViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//


import UIKit
import EZSwiftExtensions


struct HomeStepViewModel: RingViewDataSource {
    
    var image: UIImage { return UIImage(asset: .GuideOpenBand) }
//    var currentLabText: String { return "  " }
//    var percentLabText: String { return "  " }
    
    var currentNumber: Int { return 0 }
    var targetNumber: Int { return 0 }
    var ringColor: UIColor{ return UIColor(named: .HomeStepRingColor) }
    var diameter: CGFloat { return ez.screenWidth * 0.55 }
    var ringWidth: CGFloat { return 16 }
    
}
