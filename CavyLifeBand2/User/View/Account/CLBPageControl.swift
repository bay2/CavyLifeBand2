//
//  CLBPageControl.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class CLBPageControl: UIPageControl {


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        currentPageIndicatorTintColor = UIColor.whiteColor()
        pageIndicatorTintColor = UIColor(hexString: "#FFFFFF", alpha: 0.2)
    }


}
