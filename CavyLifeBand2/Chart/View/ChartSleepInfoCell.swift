//
//  ChartSleepInfoCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class ChartSleepInfoCell: UITableViewCell {

    
    @IBOutlet weak var roundSleepView: UIView!
    
    @IBOutlet weak var sleepDegree: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    
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
    
    
}
