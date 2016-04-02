//
//  WeightView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import MHRotaryKnob
import EZSwiftExtensions

class WeightView: UIView {
    
    var titleLab = UILabel()
    var valueLabel = UILabel()
    var KGLabel = UILabel()
    
    var rotaryView: MHRotaryKnob?
    let minValue: CGFloat = 0
    let maxValue: CGFloat = 180
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        weightViewLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func weightViewLayout(){
        
        rotaryView = MHRotaryKnob(frame: CGRectMake(0, 0, ez.screenWidth * 0.72, ez.screenWidth * 0.72))
        
        self.addSubview(titleLab)
        self.addSubview(rotaryView!)
        rotaryView!.addSubview(valueLabel)
        rotaryView!.addSubview(KGLabel)
        
        titleLab.text = L10n.GuideWeight.string
        titleLab.font = UIFont.systemFontOfSize(18)
        titleLab.textColor = UIColor(named: .GuideColorCC)
        titleLab.textAlignment = .Center
        titleLab.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 23, 18))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 2)
        }
        
        rotaryView!.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.size.equalTo(CGSizeMake(ez.screenWidth * 0.72, ez.screenWidth * 0.72))
        }
        
        rotaryView!.scalingFactor = 1
        rotaryView!.minimumValue = Float(minValue)
        rotaryView!.maximumValue = Float(maxValue)
        rotaryView!.interactionStyle = MHRotaryKnobInteractionStyleRotating
        rotaryView!.defaultValue = 60
        rotaryView!.value = 60
        rotaryView!.backgroundImage = UIImage(asset: .GuideWeightBg)
        rotaryView!.setKnobImage(UIImage(asset: .GuideWeightNiddle), forState: .Normal)
        rotaryView!.knobImageCenter = CGPointMake(ez.screenWidth * 0.36, ez.screenWidth * 0.36)
        rotaryView!.addTarget(self, action: #selector(WeightView.rotaryKnobDidChange), forControlEvents: UIControlEvents.ValueChanged)
        
        // 当前值
        valueLabel.text = "60.0"
        valueLabel.textAlignment = .Center
        valueLabel.textColor = UIColor(named: .GuideColorCC)
        valueLabel.font = UIFont.systemFontOfSize(45)
        valueLabel.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(ez.screenWidth * 0.72, 45))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(ez.screenWidth * 0.72)
        }
        
        // kg 标签
        KGLabel.text = "kg"
        KGLabel.textAlignment = .Center
        KGLabel.textColor = UIColor(named: .GuideColorCC)
        KGLabel.font = UIFont.systemFontOfSize(30)
        KGLabel.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(ez.screenWidth * 0.72, 40))
            make.centerX.equalTo(self)
            make.top.equalTo(valueLabel).offset(ez.screenWidth * 0.04 + 30)
        }
        
    }
    
    func rotaryKnobDidChange(){

        valueLabel.text = String(format: "%.1f", rotaryView!.value)

    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
