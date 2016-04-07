//
//  RulerScroller.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit


class RulerScroller: UIScrollView {

    var currentValue = String()// 当前值
    
    var yearValue = Int()
    var monthValue = Int()
    var dayValue = Int()

    var lineSpace = Int()
    var lineCount = Int()
    
    // 默认年份
    let defaultYear = 1990
    
    // 视图风格
    var rulerStyle: RulerStyle = .YearMonthRuler
    
    enum RulerStyle {
        
        case YearMonthRuler
        case DayRuler
        case HeightRuler
    }

    /**
     更新视图风格
     */
    func updateRulerViewStyle() {
        
        /// 长竖线之间的距离
        
        // 设置scrollView的状态
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.removeSubviews()
        
        /**
        *  通过不同的Style来选择不同的尺子
        */
        switch rulerStyle {
            
        case .YearMonthRuler:
            
            // 当前刻度值
            currentValue = "\(yearValue + 1901).\(monthValue)"
            let beginYear = 1901
            let beforSpace = 1901 * lineCount
            // 两个Line中间的空隙 和 两个Longline的shortLine个数
            // 所有竖线个数
            let allCount: Int = (yearValue - beginYear) * lineCount + monthValue - 1
            self.contentSize = CGSizeMake(CavyDefine.spacingWidth25 * 23 + CGFloat(allCount * lineSpace), 60)
            
            let defaultCount: Int = (defaultYear - beginYear) * lineCount
            self.contentOffset = CGPointMake(CGFloat(defaultCount * lineSpace), 0)
            
            /// 循环添加刻度
            for i in 0...allCount {
                
                if i % lineCount == 0 {
                    /// 长线上面的Label
                    let lineLabel = UILabel()
                    lineLabel.frame = CGRectMake(CavyDefine.spacingWidth25 * 11.5 + CGFloat(lineSpace * i) - 30, 8, 60, 18)
                    lineLabel.textAlignment = .Center
                    lineLabel.textColor = UIColor(named: .GuideColor99)
                    lineLabel.text = String((i + beforSpace) / 12) + ".1"
                    
                    /// 长线
                    let longLine = UIView()
                    longLine.backgroundColor = UIColor(named: .GuideLineColor)
                    longLine.frame = CGRectMake(CavyDefine.spacingWidth25 * 11.5 + CGFloat(lineSpace * i), 26, 1, 34)
                    self.addSubview(longLine)
                    self.addSubview(lineLabel)
                    
                }else{
                    /// 短线
                    let shortLine = UIView()
                    shortLine.backgroundColor = UIColor(named: .GuideLineColor)
                    shortLine.frame = CGRectMake(CavyDefine.spacingWidth25 * 11.5 + CGFloat(lineSpace * i), 40, 1, 20)
                    self.addSubview(shortLine)
                }
                
            }

        case .DayRuler:
            
            // 当前刻度值
            currentValue = "15"
            self.contentSize = CGSizeMake(CavyDefine.spacingWidth25 * 23 + CGFloat(lineSpace * (dayValue - 1)), 60)

            // 添加动画 防止每次年重置月份时候突兀
            UIView.animateWithDuration(0.2) { () -> Void in
                
                self.contentOffset = CGPointMake(CGFloat(self.lineSpace * 14), 0)
                
            }
            
            /// 循环添加刻度
            for i in 0...dayValue {
                
                if i % lineCount == 0 {
                    /// 长线上面的Label
                    let lineLabel = UILabel()
                    lineLabel.frame = CGRectMake(CavyDefine.spacingWidth25 * 11.5 + CGFloat(lineSpace * (i - 1)) - 30, 8, 60, 18)
                    lineLabel.textAlignment = .Center
                    lineLabel.textColor = UIColor(named: .GuideColor99)
                    lineLabel.text = String(i)
                    
                    /// 长线
                    let longLine = UIView()
                    longLine.backgroundColor = UIColor(named: .GuideLineColor)
                    longLine.frame = CGRectMake(CavyDefine.spacingWidth25 * 11.5 + CGFloat(lineSpace * (i - 1)), 26, 1, 34)
                    self.addSubview(longLine)
                    self.addSubview(lineLabel)
                    
                } else {
                    /// 短线
                    let shortLine = UIView()
                    shortLine.backgroundColor = UIColor(named: .GuideLineColor)
                    shortLine.frame = CGRectMake(CavyDefine.spacingWidth25 * 11.5 + CGFloat(lineSpace * (i - 1)), 40, 1, 20)
                    self.addSubview(shortLine)
                }
            }

        case .HeightRuler:
            
            // 当前刻度值
            currentValue = "160"
            let minHeight = 30
            let maxHeight = 240
            let allCount = (maxHeight - minHeight) * lineCount
            let beginCount = (160 - minHeight) * lineCount
            self.contentSize = CGSizeMake(60, CavyDefine.spacingWidth25 * 28 + CGFloat(allCount * lineSpace))
            self.contentOffset = CGPointMake(0, CGFloat(beginCount * lineSpace))

            /// 循环添加刻度
            
            for i in (minHeight * lineCount)...(maxHeight * lineCount) {
                
                if i % lineCount == 0{
                    
                    /// 长线
                    let longLine = UIView()
                    longLine.backgroundColor = UIColor(named: .GuideLineColor)
                    longLine.frame = CGRectMake(26, CavyDefine.spacingWidth25 * 14 + CGFloat(lineSpace * (i - minHeight * lineCount)), 34, 1)
                    
                    /// 长线上面的Label
                    let lineLabel = UILabel()
                    lineLabel.frame = CGRectMake(0, CavyDefine.spacingWidth25 * 14 + CGFloat(lineSpace * (i - minHeight * lineCount)) - 9, 60, 18)
                    lineLabel.textAlignment = .Left
                    lineLabel.textColor = UIColor(named: .GuideColor99)
                    lineLabel.text = String(i / lineCount)
                    
                    self.addSubview(longLine)
                    self.addSubview(lineLabel)
                    
                }else{
                    /// 短线
                    let shortLine = UIView()
                    shortLine.backgroundColor = UIColor(named: .GuideLineColor)
                    shortLine.frame = CGRectMake(40, CavyDefine.spacingWidth25 * 14 + CGFloat(lineSpace * (i - minHeight * lineCount)), 20, 1)
                    self.addSubview(shortLine)
                }
                
            }

        }
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
