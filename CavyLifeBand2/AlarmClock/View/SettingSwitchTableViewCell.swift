//
//  SettingSwitchTableViewCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class SettingSwitchTableViewCell: UITableViewCell {
    
    enum CavyLifeBand2SwitchStyle {
        case RedDescription
        case GrayDescription
        case NoneDescription
    }

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var selectSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.descriptionLabel.hidden = true
        
        self.descriptionLabel.text = ""
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setWithStyle(contentStyle: CavyLifeBand2SwitchStyle) -> Void {
        
        switch contentStyle {
            
        case .RedDescription:
            descriptionLabel.hidden = false
            descriptionLabel.font = UIFont.systemFontOfSize(14.0)
            descriptionLabel.textColor = UIColor(named: .ContactsAddFriendButtonColor)
            
        case .GrayDescription:
            descriptionLabel.hidden = false
            descriptionLabel.font = UIFont.systemFontOfSize(13.0)
            descriptionLabel.textColor = UIColor(named: .ContactsIntrouduce)
            
        case .NoneDescription:
            descriptionLabel.hidden = true
       
        }
        
    }
    
}
