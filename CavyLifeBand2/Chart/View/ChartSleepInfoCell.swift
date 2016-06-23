//
//  ChartSleepInfoCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit


enum SleepStatus {
    case LightSleep
    case DeepSleep
}

class ChartSleepInfoCell: UITableViewCell {
    
    let sleepDegreeColors: [UIColor] = [UIColor.whiteColor(), UIColor(named: .ChartSubTimeBucketViewBg)]
    let dataSleepArray: [String] = [L10n.ChartSleepDegreeDeep.string + L10n.ChartSleep.string, L10n.ChartSleepDegreeLight.string + L10n.ChartSleep.string, L10n.ChartTargetPercent.string]

    
    @IBOutlet weak var roundSleepView: UIView!
    
    @IBOutlet weak var sleepDegree: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    
    var sleepStatua: SleepStatus = .LightSleep
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        roundSleepView.layer.masksToBounds = true
        roundSleepView.layer.cornerRadius = roundSleepView.frame.size.height / 2
        

        sleepDegree.textColor = UIColor(named: .EColor)
        rightLabel.textColor = UIColor(named: .EColor)
        
        sleepDegree.font = UIFont.mediumSystemFontOfSize(16.0)
        rightLabel.font = UIFont.mediumSystemFontOfSize(16.0)
        
        self.selectionStyle = .None

    }

    func configSleepCell(sleepStatus: SleepStatus, text: String) {
        
        switch sleepStatus {
            
        case .LightSleep:
            
            roundSleepView.backgroundColor = UIColor.whiteColor()
            sleepDegree.text  = L10n.ChartSleepDegreeLight.string + L10n.ChartSleep.string
            
            roundSleepView.layer.borderWidth = 1
            roundSleepView.layer.borderColor = UIColor(named: .HomeViewMainColor).CGColor
            
            
        case .DeepSleep:
            
            roundSleepView.backgroundColor = UIColor(named: .ChartSubTimeBucketViewBg)
            sleepDegree.text  = L10n.ChartSleepDegreeDeep.string + L10n.ChartSleep.string

        }
        
    }
    
    
}
