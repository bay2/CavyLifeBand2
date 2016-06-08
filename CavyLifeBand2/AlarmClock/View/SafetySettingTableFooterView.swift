//
//  SafetySettingTableFooterView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class SafetySettingTableFooterView: UIView {
    
    var titleLabel: UILabel = UILabel()
    
    var descriptionLabel: UILabel = UILabel()
    
    var cornerView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
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
        
        titleLabel.font      = UIFont.mediumSystemFontOfSize(16.0)
        titleLabel.textColor = UIColor(named: .AColor)
        titleLabel.text      = L10n.SettingSafetyTableFooterTitle.string
        
        descriptionLabel.font          = UIFont.systemFontOfSize(12.0)
        descriptionLabel.textColor     = UIColor(named: .AColor)
        descriptionLabel.text          = L10n.SettingSafetyTableFooterInfo.string

        descriptionLabel.numberOfLines = 0
        
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(self).offset(20.0)
            make.trailing.equalTo(self).offset(-20.0)
            make.top.equalTo(cornerView.snp_bottom).offset(28.0)
        }
        
        descriptionLabel.snp_makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(10.0)
        }
        
        self.updateConstraintsIfNeeded()
        self.layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
