//
//  HightView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class HightView: UIView, RulerViewDelegate {

    var titleLab = UILabel()
    var heightLabel = UILabel()
    var heightRuler = RulerView()
    var heightValue: Int {
        return self.heightRuler.nowHeight
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightViewLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func heightViewLayout(){
        
        let CMLabel = UILabel()
        self.addSubview(titleLab)
        self.addSubview(CMLabel)
        self.addSubview(heightLabel)
        self.addSubview(heightRuler)
        
        heightRuler.snp_makeConstraints { make -> Void in
            make.size.equalTo(CGSizeMake(80, heightRulerHeight))
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(middleViewWidth - heightRulerWidth - horizontalInset / 2)
        }
        heightRuler.rulerDelegate = self
        heightRuler.initHeightRuler(.HeightRuler)
        heightLabel.text = heightRuler.rulerScroll.currentValue
        
        titleLab.text = L10n.GuideHeight.string
        titleLab.font = UIFont.mediumSystemFontOfSize(18)
        titleLab.textColor = UIColor(named: .EColor)
        titleLab.textAlignment = .Center
        titleLab.snp_makeConstraints { make -> Void in
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 23, 18))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 2)
        }
        
        heightLabel.text = "160"
        heightLabel.font = UIFont.mediumSystemFontOfSize(50)
        heightLabel.textColor = UIColor(named: .EColor)
        heightLabel.textAlignment = NSTextAlignment.Center
        heightLabel.snp_makeConstraints { make -> Void in
            make.size.equalTo(CGSizeMake(heightRulerHeight, 48))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 11 + 18)
        }
        
        CMLabel.text = "CM"
        CMLabel.font = UIFont.mediumSystemFontOfSize(30)
        CMLabel.textColor = UIColor(named: .EColor)
        CMLabel.textAlignment = NSTextAlignment.Center
        CMLabel.snp_makeConstraints { make -> Void in
            make.size.equalTo(CGSizeMake(80, 30))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 12 + 66)
        }
        
    }
    
    // 时刻更新 身高 刻度尺的当前值
    func changeHeightRulerValue(scrollRuler: RulerScroller) {
        
        heightLabel.text = scrollRuler.currentValue
        
    }
    
    func setHeightValue(height: String) {
        heightRuler.rulerScroll.updateRulerViewStyle(height)
    }

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
