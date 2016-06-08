//
//  MainPageButton.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class MainPageButton: UIButton {
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        
//    }
    
    override func awakeFromNib() {
        
        self.setTitleColor(UIColor(named: .PColor), forState: .Normal)
        self.setBackgroundColor(UIColor(named: .OColor), forState: .Normal)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        self.titleLabel?.font = UIFont.mediumSystemFontOfSize(18)
        
    }
    
    override func setBackgroundColor(color: UIColor, forState: UIControlState) {
        
        super.setBackgroundColor(color, forState: forState)
        self.backgroundColor = UIColor(named: .MainPageBtn)
    }

}
