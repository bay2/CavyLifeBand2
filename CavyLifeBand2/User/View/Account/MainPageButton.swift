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
    override func drawRect(rect: CGRect) {
        
        self.setTitleColor(UIColor(named: .MainPageBtnText), forState: .Normal)
        self.setBackgroundColor(UIColor(named: .MainPageBtn), forState: .Normal)
        self.setBackgroundColor(UIColor(named: .MainPageSelectedBtn), forState: .Highlighted)

        self.layer.masksToBounds = true
        self.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        self.titleLabel?.font = UIFont.systemFontOfSize(18)
        
    }

}
