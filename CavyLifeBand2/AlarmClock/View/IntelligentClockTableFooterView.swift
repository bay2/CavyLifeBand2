//
//  IntelligentClockTableFooterView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class IntelligentClockTableFooterView: UIView {
    
    var infoLabel: UILabel = UILabel()
    
    var cornerView: UIView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.addSubview(infoLabel)
        self.addSubview(cornerView)
        self.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        // 圆角Layer
        let maskRect = CGRect(x: 0, y: 0, w: frame.size.width, h: 10)
        let maskPath = UIBezierPath(roundedRect: maskRect,
                                    byRoundingCorners: [.BottomLeft, .BottomRight],
                                    cornerRadii: CGSize(width: CavyDefine.commonCornerRadius,
                                        height: CavyDefine.commonCornerRadius))
        
        let maskLayer   = CAShapeLayer()
        maskLayer.path  = maskPath.CGPath
        maskLayer.frame = maskRect
        
        // 圆角View设置
        cornerView.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(10)
        }
        
        cornerView.layer.mask      = maskLayer
        
        cornerView.backgroundColor = UIColor.whiteColor()
        
        // 信息Label设置
        infoLabel.font          = UIFont.mediumSystemFontOfSize(12.0)

        infoLabel.text          = L10n.AlarmClockIntelligentClockTableFooterInfo.string

        infoLabel.textColor     = UIColor(named: .AColor)

        infoLabel.textAlignment = .Center
        
        infoLabel.snp_makeConstraints { make in
            make.top.equalTo(cornerView.snp_bottom).offset(28)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
