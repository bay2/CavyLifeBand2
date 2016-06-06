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
    
    /// 完成百分比Label
    @IBOutlet weak var percentLabel: UILabel?
    
    var ringStyle: RingStyle = .SleepRing
    
    var diameter: CGFloat = 0
    var ringWidth: CGFloat = 0
    var ringColor: UIColor = UIColor.clearColor()
    
    
    /**
     默认设置 布局 和 环形配置
     */
    func ringDefaultSetting(){

        allViewLayout()
        
        ringDefultView()
        
    }
    
    /**
     设置环形数据
     
     - parameter targetNumber:  目标值
     - parameter currentNumber: 现在数值
     */
    func  ringWithStyle(targetNumber: Int, currentNumber: Int) {
        
        addLabelText(targetNumber, currentNumber: currentNumber)
        
        ringView(targetNumber, currentNumber: currentNumber)
    }
    
    /**
     默认全部视图布局
     */
    func allViewLayout() {
        
        switch ringStyle {
            
        case .SleepRing:
            
            imgView?.image = UIImage(asset: .HomeSleepRing)
            imgView?.snp_makeConstraints(closure: { make in
                
                make.size.equalTo(30)
                make.bottom.equalTo(currentLabel!).offset(-20)
            })
            percentLabel?.snp_makeConstraints(closure: { make in
                make.bottom.equalTo(currentLabel!).offset(20)
            })
            
        case .StepRing:
            
            imgView?.image = UIImage(asset: .HomeStepRing)
            imgView?.snp_makeConstraints(closure: { make in
                make.size.equalTo(46)
                make.bottom.equalTo(currentLabel!).offset(-40)
            })
            percentLabel?.snp_makeConstraints(closure: { make in
                make.bottom.equalTo(currentLabel!).offset(20)
            })
        }
        
    }
   
    /**
     默认环形背景设置
     */
    func ringDefultView() {
        
        // 百分比Label
        percentLabel?.textColor = UIColor(named: .AColor)
        percentLabel?.font = UIFont.mediumSystemFontOfSize(12.0)
        
        // 当前示数Label
        currentLabel?.textColor = UIColor(named: .AColor)
     
        switch ringStyle {
            
        case .StepRing:
            
            diameter = ez.screenWidth * 0.55
            ringWidth = 16
            ringColor = UIColor(named: .HomeStepRingColor)
            
            currentLabel!.attributedText =  NSMutableAttributedString().attributeString("0", numSize: 30, unit: L10n.GuideStep.string, unitSize: 16)
            
            percentLabel?.text = "\(L10n.HomeStepRingPercerntText.string)\(0)%"
            
        case .SleepRing:
            
            diameter = ez.screenWidth * 0.4
            ringWidth = 14
            ringColor = UIColor(named: .HomeSleepRingColor)

            let attrs: NSMutableAttributedString = NSMutableAttributedString().attributeString("0", numSize: 16, unit: L10n.HomeSleepRingUnitHour.string, unitSize: 12)
            attrs.appendAttributedString(NSMutableAttributedString().attributeString("0", numSize: 16, unit: L10n.HomeSleepRingUnitMinute.string, unitSize: 12))
            currentLabel!.attributedText = attrs
            
            percentLabel!.text = "\(L10n.HomeSleepRingPercerntText.string)\(0)%"
            
        }
        
        // 贝塞尔曲线
        let center = CGPoint(x: diameter / 2, y: diameter / 2)
        let redius = diameter / 2 - ringWidth / 2
        
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

    }
    
    /**
     环形 数据进度条添加
     
     - parameter targetNumber:  目标值
     - parameter currentNumber: 当前值
     */
    func ringView(targetNumber: Int, currentNumber: Int) {
        
        let percent = percentNumber(targetNumber, currectNum: currentNumber)
        
        // 贝塞尔曲线
        let center = CGPoint(x: diameter / 2, y: diameter / 2)
        let redius = diameter / 2 - ringWidth / 2
        let startA = CGFloat(M_PI)
        let middleA = startA - startA * 0.04
        var endA = CGFloat(M_PI - M_PI * 2 * Double(percent))
        if endA > middleA {
            endA = middleA - 0.01
        }
        
        // 平头
        let lineBeginLayer = CAShapeLayer(layer: layer)
        lineBeginLayer.frame = self.bounds
        lineBeginLayer.fillColor = UIColor.clearColor().CGColor
        lineBeginLayer.strokeColor = ringColor.CGColor
        lineBeginLayer.lineWidth = ringWidth
        
        if percent == 0 {
            
            return
        }else if percent > 0 {
            
            let lineBeginPath = UIBezierPath(arcCenter: center, radius: redius, startAngle: startA, endAngle: middleA, clockwise: false)

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
        let path = UIBezierPath(arcCenter: center, radius: redius, startAngle: middleA, endAngle: endA, clockwise: false)
        ringLayer.path = path.CGPath
        self.layer.addSublayer(ringLayer)

    }
    
    /**
     返回当前数值文本
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
            
            currentLabel!.attributedText =  NSMutableAttributedString().attributeString(step, numSize: 30, unit: stepUnit, unitSize: 16)
            
            percentLabel?.text = "\(L10n.HomeStepRingPercerntText)\(percent)%"
            
        }
        
    }
    
    /**
     返回百分比
     */
    func percentNumber(targetNum: Int, currectNum: Int) -> CGFloat {
        
        if targetNum == 0 {
            return 0 
        }
        let percent = CGFloat(currectNum) / CGFloat(targetNum)
        
        if percent > 0 && percent < 0.01 {
            
            return 0.01
    
        }
        
        if percent > 1 {
            
            return 1
            
        }
        
        return percent
        
    }
    
}
