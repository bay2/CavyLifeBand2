//
//  CheckboxButton.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class CheckboxButton: UIButton {

    var isCheck = true {

        didSet {

            if isCheck {
                self.setImage(UIImage(asset: .Chosenbtn), forState: .Normal)
            } else {
                self.setImage(UIImage(asset: .Unchosenbtn), forState: .Normal)
            }

        }

    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {

        self.setImage(UIImage(asset: .Chosenbtn), forState: .Normal)
        self.addTarget(self, action: #selector(CheckboxButton.onClickBtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)

    }

    func onClickBtn(sender: AnyObject) {

        isCheck = !isCheck

    }
  

}
