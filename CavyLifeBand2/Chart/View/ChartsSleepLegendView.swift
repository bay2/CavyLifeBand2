//
//  ChartsSleepLegendView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import SnapKit
import EZSwiftExtensions

class ChartsSleepLegendView: UIView {

    @IBOutlet weak var deepLabel: UILabel!
    
    @IBOutlet weak var deepRoundView: UIView!
    
    @IBOutlet weak var lightLabel: UILabel!
    
    @IBOutlet weak var lightRoundView: UIView!
    
    override func awakeFromNib() {
        
        deepRoundView.setCornerRadius(radius: 5)
        lightRoundView.setCornerRadius(radius: 5)
        
        lightRoundView.backgroundColor = UIColor.whiteColor()
        deepRoundView.backgroundColor = UIColor(named: .ChartSubTimeBucketViewBg)
        
        deepLabel.text = L10n.ChartSleepDeep.string
        lightLabel.text = L10n.ChartSleepLight.string
      
    }
    
}
