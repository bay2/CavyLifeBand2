//
//  AboutSectionEmptyView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

enum SectionHeaderCornerType {
    case Bottom
    case Top
}

class AboutSectionEmptyView: UIView {

    convenience override init(frame: CGRect) {
        
        self.init(frame: frame, cornerType: .Top)
        
    }
    
    init(frame: CGRect, cornerType: SectionHeaderCornerType) {
    
        super.init(frame: frame)
        
        
        let maskRect = CGRect(x: 0, y: 0, w: frame.size.width, h: frame.size.height)
        
        var cornerStyle: UIRectCorner
        
        switch cornerType {
        case .Top:
            cornerStyle = [.TopRight, .TopLeft]
        case .Bottom:
            cornerStyle = [.BottomRight, .BottomLeft]
        }
        
        let maskPath = UIBezierPath(roundedRect: maskRect,
                                    byRoundingCorners: cornerStyle,
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
