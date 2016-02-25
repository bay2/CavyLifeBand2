//
//  SignInTextField.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class SignInTextField: UITextField {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        self.font = UIFont.systemFontOfSize(16)

        self.clearButtonMode = .UnlessEditing
        self.setValue(UIColor(named: .SignInBackground), forKeyPath: "_placeholderLabel.textColor")
        
    }


}
