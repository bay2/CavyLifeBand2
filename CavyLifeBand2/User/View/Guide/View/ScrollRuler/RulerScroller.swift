//
//  RulerScroller.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

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
    func updateRulerViewStyle(value: String? = nil) {
        
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
            self.contentSize = CGSizeMake(birthRulerWidth + CGFloat(allCount * lineSpace), birthRulerHeight)
            
            let defaultCount: Int = (defaultYear - beginYear) * lineCount
            self.contentOffset = CGPointMake(CGFloat(defaultCount * lineSpace) + horizontalInset / 2, 0)
            
            /// 循环添加刻度
            for i in 0...allCount {
                
                if i % lineCount == 0 {
                    
                    /// 长线上面的Label
                    let lineLabel = UILabel()
                    lineLabel.font = UIFont.systemFontOfSize(14)
                    lineLabel.frame = CGRectMake(birthRulerWidth / 2 + CGFloat(lineSpace * i) - 30, 8, 60, 14)
                    lineLabel.textAlignment = .Center
                    lineLabel.textColor = UIColor(named: .GColor)
                    lineLabel.text = String((i + beforSpace) / lineCount) + ".1"
                    
                    /// 长线
                    let longLine = UIView()
                    longLine.backgroundColor = UIColor(named: .GuideLineColor)
                    longLine.frame = CGRectMake(birthRulerWidth / 2 + CGFloat(lineSpace * i), birthRulerHeight - birthRulerLongLine, 1, birthRulerLongLine)
                    self.addSubview(longLine)
                    self.addSubview(lineLabel)
                    
                }else{
                    
                    /// 短线
                    let shortLine = UIView()
                    shortLine.backgroundColor = UIColor(named: .GuideLineColor)
                    shortLine.frame = CGRectMake(birthRulerWidth / 2 + CGFloat(lineSpace * i), birthRulerHeight - birthRulerShortLine, 1, birthRulerShortLine)
                    self.addSubview(shortLine)
                }
                
            }

        case .DayRuler:
            
            // 当前刻度值
            currentValue = "15"
            self.contentSize = CGSizeMake(birthRulerWidth + CGFloat(lineSpace * (dayValue - 1)), 60)

            self.setContentOffset(CGPointMake(CGFloat(self.lineSpace * 14) + horizontalInset / 2, 0), animated: true)
            
            /// 循环添加刻度
            for i in 1...dayValue {
                
                if i % lineCount == 0 {
                    
                    
                    /// 长线上面的Label
                    let lineLabel = UILabel()
                    lineLabel.font = UIFont.systemFontOfSize(14)
                    lineLabel.frame = CGRectMake(birthRulerWidth / 2 + CGFloat(lineSpace * (i - 1)) - birthRulerHeight / 2, 8, 60, 14)
                    lineLabel.textAlignment = .Center
                    lineLabel.textColor = UIColor(named: .GColor)
                    lineLabel.text = String(i)
                    
                    /// 长线
                    let longLine = UIView()
                    longLine.backgroundColor = UIColor(named: .GuideLineColor)
                    longLine.frame = CGRectMake(birthRulerWidth / 2 + CGFloat(lineSpace * (i - 1)), birthRulerHeight - birthRulerLongLine, 1, birthRulerLongLine)
                    self.addSubview(longLine)
                    self.addSubview(lineLabel)
                    
                } else {
                    /// 短线
                    let shortLine = UIView()
                    shortLine.backgroundColor = UIColor(named: .GuideLineColor)
                    shortLine.frame = CGRectMake(birthRulerWidth / 2 + CGFloat(lineSpace * (i - 1)), birthRulerHeight - birthRulerShortLine, 1, birthRulerShortLine)
                    self.addSubview(shortLine)
                }
            }

        case .HeightRuler:
            
            // 当前刻度值
            currentValue = value ?? "160"
            let minHeight = 30
            let maxHeight = 240
            let allCount = maxHeight - minHeight
            let beginCount = (currentValue.toInt() ?? 160) - minHeight
            self.contentSize = CGSizeMake(60, heightRulerHeight + CGFloat(allCount * lineSpace))
            self.contentOffset = CGPointMake(0, CGFloat(beginCount * lineSpace))

            /// 循环添加刻度
            for i in minHeight...maxHeight {
              
                if i % lineCount == 0 {
                    
                    /// 长线
                    let longLine = UIView()
                    longLine.backgroundColor = UIColor(named: .GuideLineColor)
                    longLine.frame = CGRectMake(heightRulerWidth - heightRulerLongLine, heightRulerHeight / 2 + CGFloat(lineSpace * (i - minHeight)), heightRulerLongLine, 1)
                    
                    /// 长线上面的Label
                    let lineLabel = UILabel()
                    lineLabel.font = UIFont.systemFontOfSize(14)
                    lineLabel.frame = CGRectMake(heightRulerShortLine - 10, heightRulerHeight / 2 + CGFloat(lineSpace * (i - minHeight)) - 7, heightRulerWidth - heightRulerShortLine, 14)
                    lineLabel.textAlignment = .Left
                    lineLabel.textColor = UIColor(named: .GColor)
                    lineLabel.text = String(i)
                    
                    self.addSubview(longLine)
                    self.addSubview(lineLabel)
                    
                }else{
                    /// 短线
                    let shortLine = UIView()
                    shortLine.backgroundColor = UIColor(named: .GuideLineColor)
                    shortLine.frame = CGRectMake(heightRulerWidth - heightRulerShortLine, heightRulerHeight / 2 + CGFloat(lineSpace * (i - minHeight)), heightRulerShortLine, 1)
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
