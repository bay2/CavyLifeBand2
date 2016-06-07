//
//  IntelligentClockTableHeaderView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class IntelligentClockTableHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let maskRect = CGRect(x: 0, y: 0, w: frame.size.width, h: frame.size.height)
        
        let maskPath = UIBezierPath(roundedRect: maskRect,
                                    byRoundingCorners: [.TopRight, .TopLeft],
                                    cornerRadii: CGSize(width: CavyDefine.commonCornerRadius,
                                                        height: CavyDefine.commonCornerRadius))
        
        
        
        let maskLayer   = CAShapeLayer()
        maskLayer.frame = maskRect
        maskLayer.path  = maskPath.CGPath
        
        self.layer.mask = maskLayer
        self.backgroundColor = UIColor.whiteColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
