//
//  EmergencyContactPersonCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class EmergencyContactPersonCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.textColor = UIColor(named: .EColor)
        titleLabel.font = UIFont.mediumSystemFontOfSize(16.0)
        
        addBtn.setTitleColor(UIColor(named: .GColor), forState: .Normal)
        addBtn.titleLabel?.font = UIFont.mediumSystemFontOfSize(16.0)
        addBtn.addTarget(nil, action: #selector(SafetySettingViewController.addEmergencyContact(_:)), forControlEvents: .TouchUpInside)
    }
    


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
