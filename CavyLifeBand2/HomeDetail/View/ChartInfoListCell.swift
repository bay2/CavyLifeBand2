//
//  ChartInfoListCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class ChartInfoListCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!

    @IBOutlet weak var rightLabel: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()

        leftLabel.textColor = UIColor(named: .HomeViewUserName)
        rightLabel.textColor = UIColor(named: .HomeViewUserName)

        
        
        
        
    }
    
}
