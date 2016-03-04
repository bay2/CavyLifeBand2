//
//  RulerView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class RulerView: UIView {
    
    var rulerScroll = RulerScroller()
    var currentValue = CGFloat()    // 当前值
    var columeFlag = UIImageView()
    

    override func drawRect(rect: CGRect) {
        // Drawing code
        
        self.currentValue = rulerScroll.currentValue
        
        self.addSubview(rulerScroll)
        rulerScroll.snp_makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(self)
        }
        
        /**
        添加中间标志
        */
        self.addSubview(columeFlag)
        columeFlag.backgroundColor = UIColor.cyanColor()
        columeFlag.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(3, 60))
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
    }

}
