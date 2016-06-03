//
//  EmptyClockView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class EmptyClockView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = UIColor(named: .DColor)
        infoLabel.textColor = UIColor(named: .DColor)
        
        titleLabel.font = UIFont.mediumSystemFontOfSize(18.0)
        infoLabel.font = UIFont.mediumSystemFontOfSize(14.0)
        
        titleLabel.text = L10n.AlarmClockEmptyViewTitle.string
        infoLabel.text = L10n.AlarmClockEmptyViewInfo.string
    }

}
