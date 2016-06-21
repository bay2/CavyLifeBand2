//
//  BandElectricView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/26.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class BandElectricView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private let lable = UILabel()
    private let shapeMake = CAShapeLayer()
    private let backImage = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        drawElectricImage()
    }
    
    

    /**
     绘制电量视图
     */
    func drawElectricImage() {
        
        let diameter = self.bounds.width
        let radius = diameter / 2
        
        // 绘制背景图层
        let bgLayer = CAShapeLayer(layer: layer)
        bgLayer.frame = self.bounds
        bgLayer.fillColor = UIColor(hexString: "e5e5e5")?.CGColor
        let bgPath = UIBezierPath(arcCenter: CGPointMake(radius, radius), radius: CGFloat(radius), startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        bgLayer.path = bgPath.CGPath
        self.layer.addSublayer(bgLayer)
        
        // 绘制电量不足的背景图层
        let electricLayer = CAShapeLayer(layer: layer)
        electricLayer.frame = self.bounds
        electricLayer.fillColor = UIColor(hexString: "ff9138")?.CGColor
        let bgelectricPath = UIBezierPath(arcCenter: CGPointMake(radius, radius), radius: radius - 3, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        electricLayer.path = bgelectricPath.CGPath
        self.layer.addSublayer(electricLayer)
        
        // 绘制填充电量的背景图层
        let electricFillLayer = CAShapeLayer(layer: layer)
        electricFillLayer.frame = self.bounds
        electricFillLayer.fillColor = UIColor(hexString: "ffc392")?.CGColor
        electricFillLayer.path = bgelectricPath.CGPath
        self.layer.addSublayer(electricFillLayer)
        
        // 创建图层蒙版
        let path = UIBezierPath(rect: CGRectMake(0, 0, self.bounds.width, self.bounds.width - (self.bounds.width * 0)))
        shapeMake.path = path.CGPath
        electricFillLayer.mask = shapeMake
        
        lable.text = "0%"
        lable.font = UIFont.mediumSystemFontOfSize(18.0)
        lable.textColor = UIColor(named: .AColor)
        self.addSubview(lable)
        lable.snp_makeConstraints { make in
            make.center.equalTo(self)
        }
        
        backImage.image = UIImage(asset: .RightMenuDisconnect)
        backImage.frame = self.bounds
        self.addSubview(backImage)
        
    }
    
    /**
     配置电量视图
     
     - parameter percent: 百分比  1 ~ 0
     */
    func setElectric(percent: CGFloat?, isConnect: Bool) {
        
        if isConnect {
            
            backImage.hidden = true
            let path = UIBezierPath(rect: CGRectMake(0, 0, self.bounds.width, self.bounds.width - (self.bounds.width * percent!)))
            shapeMake.path = path.CGPath
            lable.text = "\(Int(percent! * 100))%"

        }else
        {
            backImage.hidden = false
        }
        
    }

}
