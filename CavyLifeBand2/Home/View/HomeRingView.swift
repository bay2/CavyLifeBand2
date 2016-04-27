//
//  HomeRingView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Log
import EZSwiftExtensions

enum RingStyle {
    
    case StepRing
    case SleepRing
    
}

class HomeRingView: UIView {
    
    /// 图片
    @IBOutlet weak var imgView: UIImageView?
    
    /// 当前值
    @IBOutlet weak var currentLabel: UILabel?
    
    /// 完成百分比
    @IBOutlet weak var percentLabel: UILabel?
    
    var ringStyle: RingStyle = .SleepRing
    
    
    /**
     计步模块
     */
    func  stepRingWith(ringStyle: RingStyle, targetNumber: Int, currentNumber: Int) {
        
        self.ringStyle = ringStyle
        
        addLabelText(targetNumber, currentNumber: currentNumber)
        
        allViewLayout()
        
        ringView(targetNumber, currentNumber: currentNumber, diameter: ez.screenWidth * 0.55, ringWidth: 16, ringColor: UIColor(named: .HomeStepRingColor))
        
    }
    
    /**
     睡眠模块
     */
    func  sleepRingWith(ringStyle: RingStyle, targetHour: Int, targetMinute: Int, currentHour: Int, currentMinute: Int) {
        self.ringStyle = ringStyle
        
        let targetNumber = targetHour * 60 + targetMinute
        let currentNumber = currentHour * 60 + currentMinute
        
        addLabelText(targetNumber, currentNumber: currentNumber)
        
        allViewLayout()
        
        ringView(targetNumber, currentNumber: currentNumber, diameter: ez.screenWidth * 0.4, ringWidth: 14, ringColor: UIColor(named: .HomeSleepRingColor))
        
    }
    
    
    /**
     环形
     
     - parameter ringStyle:     环Style
     - parameter targetNumber:  目标值
     - parameter currentNumber: 当前值
     - parameter diameter:      直径
     - parameter ringWidth:     环宽
     - parameter ringColor:     进度条颜色
     */
    func ringView(targetNumber: Int, currentNumber: Int, diameter: CGFloat, ringWidth: CGFloat, ringColor: UIColor) {
        
        let percent = percentNumber(targetNumber, currectNum: currentNumber)
        
        // 贝塞尔曲线
        let center = CGPoint(x: diameter / 2, y: diameter / 2)
        let redius = diameter / 2 - ringWidth / 2
        let startA = CGFloat(M_PI)
        let endA = CGFloat(M_PI - M_PI * 2 * Double(percent))
        
        // 背景bg
        let bgLayer = CAShapeLayer(layer: layer)
        bgLayer.frame = self.bounds
        bgLayer.fillColor = UIColor.clearColor().CGColor
        bgLayer.strokeColor = UIColor(named: .HomeRingViewBackground).CGColor
        bgLayer.lineWidth = ringWidth
        let bgPath = UIBezierPath(arcCenter: center, radius: redius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        bgLayer.path = bgPath.CGPath
        self.layer.addSublayer(bgLayer)
        
        // 虚线环
        if ringStyle == .StepRing {
            
            let lineLayer = CAShapeLayer(layer: layer)
            lineLayer.lineWidth = 1
            lineLayer.fillColor = UIColor.clearColor().CGColor
            lineLayer.strokeColor = UIColor(named: .HomeViewMainColor).CGColor
            lineLayer.lineDashPattern = [3, 4]
            let linePath = UIBezierPath(arcCenter: center, radius: redius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
            lineLayer.path = linePath.CGPath
            self.layer.addSublayer(lineLayer)
        }
        
        // 平头
        let lineBeginLayer = CAShapeLayer(layer: layer)
        lineBeginLayer.frame = self.bounds
        lineBeginLayer.fillColor = UIColor.clearColor().CGColor
        lineBeginLayer.strokeColor = ringColor.CGColor
        lineBeginLayer.lineWidth = ringWidth
        
        if percent > 0 {
            
            let lineBeginPath = UIBezierPath(arcCenter: center, radius: redius, startAngle: startA, endAngle: CGFloat(M_PI - M_PI * 2 * 0.03), clockwise: false)
            lineBeginLayer.path = lineBeginPath.CGPath
            self.layer.addSublayer(lineBeginLayer)
            
        } else if percent >= 100 {
            
            let lineBeginPath = UIBezierPath(arcCenter: center, radius: redius, startAngle: startA, endAngle: CGFloat(M_PI - M_PI * 2), clockwise: false)
            lineBeginLayer.path = lineBeginPath.CGPath
            self.layer.addSublayer(lineBeginLayer)
        }
        
        //环形
        let ringLayer = CAShapeLayer(layer: layer)
        ringLayer.frame = self.bounds
        ringLayer.fillColor = UIColor.clearColor().CGColor
        ringLayer.strokeColor = ringColor.CGColor
        ringLayer.lineWidth = ringWidth
        ringLayer.lineCap = kCALineCapRound
        let path = UIBezierPath(arcCenter: center, radius: redius, startAngle: CGFloat(M_PI - M_PI * 2 * 0.03), endAngle: endA, clockwise: false)
        ringLayer.path = path.CGPath
        self.layer.addSublayer(ringLayer)
        
        

    }
    
    /**
     适配
     */
    func allViewLayout() {
        
        switch ringStyle {
            
        case .SleepRing:
            
            imgView?.image = UIImage(asset: .HomeSleepRing)
            imgView?.snp_makeConstraints(closure: { (make) in

                make.size.equalTo(30)
                make.bottom.equalTo(currentLabel!).offset(-20)
            })
            percentLabel?.snp_makeConstraints(closure: { make in
                make.bottom.equalTo(currentLabel!).offset(20)
            })
            
        case .StepRing:

            imgView?.image = UIImage(asset: .HomeStepRing)
            imgView?.snp_makeConstraints(closure: { (make) in
                make.size.equalTo(46)
                make.bottom.equalTo(currentLabel!).offset(-40)
            })
            percentLabel?.snp_makeConstraints(closure: { make in
                make.bottom.equalTo(currentLabel!).offset(20)
            })
        }
        
    }
    
    /**
     返回当前文本
     */
    func addLabelText(targetNumber: Int, currentNumber: Int) {
        
         let percent = Int(percentNumber(targetNumber, currectNum: currentNumber) * 100)
        
        switch ringStyle {
            
            
        case .SleepRing:
            
            let hour = String(currentNumber / 60)
            let hourUnit = "\(L10n.HomeSleepRingUnitHour.string)"
            let minutes = String(currentNumber - (currentNumber / 60) * 60)
            let minUnit = "\(L10n.HomeSleepRingUnitMinute.string)"
            
            let attrs: NSMutableAttributedString = NSMutableAttributedString().attributeString(hour, numSize: 16, unit: hourUnit, unitSize: 12)
            attrs.appendAttributedString(NSMutableAttributedString().attributeString(minutes, numSize: 16, unit: minUnit, unitSize: 12))
            currentLabel!.attributedText = attrs
            
            percentLabel!.text = "\(L10n.HomeSleepRingPercerntText.string)\(percent)%"

            
        case .StepRing:
            
            let step = String(currentNumber)
            let stepUnit = "\(L10n.GuideStep.string)"
            
            currentLabel!.attributedText =  NSMutableAttributedString().attributeString(step, numSize: 32, unit: stepUnit, unitSize: 18)
            
            percentLabel?.text = "\(L10n.HomeStepRingPercerntText)\(percent)%"
            
            
        }
        
    }
    
       /**
     返回百分比
     */
    func percentNumber(targetNum: Int, currectNum: Int) -> CGFloat {
        
        let percent = CGFloat(currectNum) / CGFloat(targetNum)
        
        if percent > 1 {
            
            return 1
            
        }
        
        return percent
        
        
    }
    
}
