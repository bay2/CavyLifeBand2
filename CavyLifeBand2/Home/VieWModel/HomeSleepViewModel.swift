//
//  HomeSleepViewModel.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//


import UIKit
import EZSwiftExtensions


struct HomeSleepViewModel: RingViewDataSource, RingViewDelegate{
    
    var image: UIImage { return UIImage(asset: .GuideOpenBand) }
//    var currentLabText: String { return "  " }
//    var percentLabText: String { return "  " }
    
    var currentNumber: Int { return 0 }
    var targetNumber: Int { return 0 }
    var ringColor: UIColor{ return UIColor(named: .HomeSleepRingColor) }
    var diameter: CGFloat { return ez.screenWidth * 0.4 }
    var ringWidth: CGFloat { return 14 }
    
    
    func setRingView(view: UIView) {
        
        let percent = HomeRingView().percentNumber(targetNumber, currectNum: currentNumber)
        
        // 贝塞尔曲线
        let center = CGPoint(x: diameter / 2, y: diameter / 2)
        let redius = diameter / 2 - ringWidth / 2
        let startA = CGFloat(M_PI)
        let endA = CGFloat(M_PI - M_PI * 2 * Double(percent))
        
        // 背景bg
        let bgLayer = CAShapeLayer()
        bgLayer.frame = view.bounds
        bgLayer.fillColor = UIColor.clearColor().CGColor
        bgLayer.strokeColor = UIColor(named: .HomeRingViewBackground).CGColor
        bgLayer.lineWidth = ringWidth
        let bgPath = UIBezierPath(arcCenter: center, radius: redius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        bgLayer.path = bgPath.CGPath
        view.layer.addSublayer(bgLayer)
        
        // 初始平头 和 100% 满环
        
        let lineBeginLayer = CAShapeLayer()
        lineBeginLayer.frame = view.bounds
        lineBeginLayer.fillColor = UIColor.clearColor().CGColor
        lineBeginLayer.strokeColor = ringColor.CGColor
        lineBeginLayer.lineWidth = ringWidth
        
        if percent > 0 {
            let lineBeginPath = UIBezierPath(arcCenter: center, radius: redius, startAngle: startA, endAngle: CGFloat(M_PI - M_PI * 2 * 0.03), clockwise: false)
            lineBeginLayer.path = lineBeginPath.CGPath
            view.layer.addSublayer(lineBeginLayer)
            
        } else if percent >= 100 {
            let lineBeginPath = UIBezierPath(arcCenter: center, radius: redius, startAngle: startA, endAngle: CGFloat(M_PI - M_PI * 2), clockwise: false)
            lineBeginLayer.path = lineBeginPath.CGPath
            view.layer.addSublayer(lineBeginLayer)
        }
        
        
        //环形
        let ringLayer = CAShapeLayer()
        ringLayer.frame = view.bounds
        ringLayer.fillColor = UIColor.clearColor().CGColor
        ringLayer.strokeColor = ringColor.CGColor
        ringLayer.lineWidth = ringWidth
        ringLayer.lineCap = kCALineCapRound
        let path = UIBezierPath(arcCenter: center, radius: redius, startAngle: CGFloat(M_PI - M_PI * 2 * 0.03), endAngle: endA, clockwise: false)
        ringLayer.path = path.CGPath
        view.layer.addSublayer(ringLayer)
        
        
        
        
    }
    
    
    func setCurrentLabelText() -> NSMutableAttributedString {
        
        let hour = String(currentNumber / 60)
        let hourUnit = "\(L10n.HomeSleepRingUnitHour.string)"
        let minutes = String(currentNumber - (currentNumber / 60) * 60)
        let minUnit = "\(L10n.HomeSleepRingUnitMinute.string)"
        
        let string = hour + hourUnit + minutes + minUnit
        let currentString = NSMutableAttributedString(string: string)
        currentString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: NSMakeRange(0, hour.length))
        currentString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: NSMakeRange(hour.length, hourUnit.length))
        currentString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16), range: NSMakeRange(hour.length + hourUnit.length, minutes.length))
        currentString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: NSMakeRange(hour.length + hourUnit.length + minutes.length, minUnit.length))
        
        return currentString

    }
    
    func setPercentLabelText() -> String {

        
        let percent = Int(HomeRingView().percentNumber(targetNumber, currectNum: currentNumber) * 100)
        
        return "\(L10n.HomeSleepRingPercerntText.string)\(percent)%"
    }
    
    
    
    
    
    
    
}

