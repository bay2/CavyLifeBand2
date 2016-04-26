//
//  SignInTextField.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class AccountTextField: UITextField {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        self.font = UIFont.systemFontOfSize(14)

        self.clearButtonMode = .WhileEditing
        self.setValue(UIColor(named: .SignInPlaceholderText), forKeyPath: "_placeholderLabel.textColor")
        self.textColor = UIColor(named: .TextFieldTextColor)
        
    }


}
