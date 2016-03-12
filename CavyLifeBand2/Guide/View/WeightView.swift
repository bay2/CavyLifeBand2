//
//  WeightView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import MHRotaryKnob

class WeightView: UIView {
    
    var titleLab = UILabel()
    var weightBgImage = UIImageView()
    var valueLabel = UILabel()
    var KGLabel = UILabel()
    
    var rotaryView = MHRotaryKnob()
    var currentValue: CGFloat = 120
    let minValue: CGFloat = 10
    let maxValue: CGFloat = 450
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        weightViewLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func weightViewLayout(){
        
        self.addSubview(titleLab)
        self.addSubview(weightBgImage)
        self.addSubview(rotaryView)
        rotaryView.addSubview(valueLabel)
        rotaryView.addSubview(KGLabel)
        
        titleLab.text = L10n.GuideWeight.string
        titleLab.font = UIFont.systemFontOfSize(18)
        titleLab.textColor = UIColor(named: .GuideColorCC)
        titleLab.textAlignment = .Center
        titleLab.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(spacingWidth25 * 23, 18))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(spacingWidth25 * 2)
        }
        
        weightBgImage.userInteractionEnabled = true
        weightBgImage.image = UIImage(asset: .GuideWeightBg)
        weightBgImage.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(spacingWidth25 * 19, spacingWidth25 * 18))
            make.centerX.centerY.equalTo(self)
        }
        
        rotaryView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(boundsWidth * 0.72, boundsWidth * 0.72))
            make.center.equalTo(self)
        }
        
        rotaryView.scalingFactor = 1
        rotaryView.minimumValue = Float(minValue)
        rotaryView.maximumValue = Float(maxValue)
        rotaryView.interactionStyle = MHRotaryKnobInteractionStyleRotating
        rotaryView.defaultValue = Float(currentValue)
        rotaryView.value = Float(currentValue)
        rotaryView.backgroundImage = UIImage(asset: .GuideWeightBg)
        rotaryView.setKnobImage(UIImage(asset: .GuideWeightNiddle), forState: .Normal)
        rotaryView.knobImageCenter = CGPointMake(boundsWidth * 0.36, boundsWidth * 0.36)
        rotaryView.addTarget(self, action: "rotaryKnobDidChange", forControlEvents: UIControlEvents.ValueChanged)
        
        // 当前值
        valueLabel.text = "120"
        valueLabel.textAlignment = .Center
        valueLabel.textColor = UIColor(named: .GuideColorCC)
        valueLabel.font = UIFont.systemFontOfSize(45)
        valueLabel.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(boundsWidth * 0.72, 45))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(boundsWidth * 0.72)
        }
        
        // kg 标签
        KGLabel.text = "kg"
        KGLabel.textAlignment = .Center
        KGLabel.textColor = UIColor(named: .GuideColorCC)
        KGLabel.font = UIFont.systemFontOfSize(30)
        KGLabel.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(boundsWidth * 0.72, 40))
            make.centerX.equalTo(self)
            make.top.equalTo(valueLabel).offset(boundsWidth * 0.04 + 30)
        }
        
    
    }
    
    func rotaryKnobDidChange(){

        valueLabel.text = String(format: "%.1f", rotaryView.value)
        
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}