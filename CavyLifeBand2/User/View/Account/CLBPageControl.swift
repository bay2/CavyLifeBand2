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
//    override func drawRect(rect: CGRect) {
//        
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        currentPageIndicatorTintColor = UIColor.whiteColor()
        pageIndicatorTintColor = UIColor(named: .PageIndicatorTintColor)
    }


}
