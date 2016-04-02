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
        
        titleLab.text = L10n.GuideHeight.string
        titleLab.font = UIFont.systemFontOfSize(18)
        titleLab.textColor = UIColor(named: .GuideColorCC)
        titleLab.textAlignment = .Center
        titleLab.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 23, 18))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 2)
        }
        
        heightLabel.text = "160"
        heightLabel.font = UIFont.systemFontOfSize(48)
        heightLabel.textColor = UIColor(named: .GuideColorCC)
        heightLabel.textAlignment = NSTextAlignment.Center
        heightLabel.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 23, 48))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 11 + 18)
        }
        
        CMLabel.text = "CM"
        CMLabel.font = UIFont.systemFontOfSize(30)
        CMLabel.textColor = UIColor(named: .GuideColorCC)
        CMLabel.textAlignment = NSTextAlignment.Center
        CMLabel.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(80, 30))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 12 + 66)
        }
        
        heightRuler.backgroundColor = UIColor.blackColor()

        heightRuler.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(80, CavyDefine.spacingWidth25 * 28))
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(CavyDefine.spacingWidth25 * 17)
        }
        heightRuler.rulerDelegate = self
        heightRuler.initHeightRuler(13, lineCount: 10, style: .HeightRuler)
        heightLabel.text = heightRuler.rulerScroll.currentValue
    }
    
    // 时刻更新 身高 刻度尺的当前值
    func changeHeightRulerValue(scrollRuler: RulerScroller) {
        
        heightLabel.text = scrollRuler.currentValue
        
    }
    

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
