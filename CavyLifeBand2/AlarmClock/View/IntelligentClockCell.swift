//
//  IntelligentClockCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class IntelligentClockCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var setSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .None
        
        self.backgroundColor = UIColor.whiteColor()
        
        timeLabel.textColor = UIColor(named: .SettingTableCellTitleColor)
        
        dayLabel.textColor = UIColor(named: .SettingTableCellInfoGrayColor)
        
        timeLabel.text = "08:30"
        
        dayLabel.text = "一，二，三"
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
