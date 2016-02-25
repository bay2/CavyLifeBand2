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
    
    enum CLBButtonType {
        
        case Home
        case Login
    }
    
    var btnType: CLBButtonType = .Home {
        
        didSet {
            setButtonStyle()
        }
        
    }

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        self.setTitleColor(UIColor(named: .MainPageBtnText), forState: .Normal)
        self.setTitleColor(UIColor(named: .MainPageSelectedBtnText), forState: .Highlighted)
        self.setBackgroundColor(UIColor(named: .MainPageBtn), forState: .Normal)
        self.setBackgroundColor(UIColor(named: .MainPageSelectedBtn), forState: .Highlighted)
        
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.titleLabel?.font = UIFont.systemFontOfSize(18)
        
    }
    
    /**
     设置按钮风格
     */
    func setButtonStyle() {
        
        self.setTitleColor(UIColor(named: .MainPageBtnText), forState: .Normal)
        self.setBackgroundColor(UIColor(named: .MainPageBtn), forState: .Normal)
        self.setBackgroundColor(UIColor(named: .MainPageSelectedBtn), forState: .Highlighted)
        
        switch btnType {
        case .Home:
            self.setTitleColor(UIColor(named: .MainPageSelectedBtnText), forState: .Highlighted)
        case .Login:
            self.setTitleColor(UIColor(named: .SignInBackground), forState: .Highlighted)
            
        }
        
    }

    

}
