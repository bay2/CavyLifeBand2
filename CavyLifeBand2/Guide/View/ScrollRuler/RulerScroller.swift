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
    
    // 视图风格
    var rulerStyle: RulerStyle = .yymmRuler
    
    enum RulerStyle {
        
        case yymmRuler
        case ddRuler
        case HeightRuler
    }

    /**
     更新视图风格
     */
    func updateRulerViewStyle() {
        
        /// 长竖线之间的距离
        
        // 设置scrollView的状态
        self.showsHorizontalScrollIndicator = false
        self.removeSubviews()
       
        // 添加左右空白视图 半个scrollView的长度
        let stanceView = UIView(frame: CGRectMake(contentSize.width - spacingWidth25 * 11.5, 0, spacingWidth25 * 11.5, 60))
        stanceView.backgroundColor = UIColor.redColor()
        
        /**
        *  通过不同的Style来选择不同的尺子
        */
        switch rulerStyle {
            
        case .yymmRuler:
            
            // 当前刻度值
            currentValue = "\(yearValue).\(monthValue)"
            // 两个Line中间的空隙 和 两个Longline的shortLine个数
            // 所有竖线个数
            let allCount: Int = yearValue * lineCount + monthValue - 1
            self.contentSize = CGSizeMake(spacingWidth25 * 23 + CGFloat(allCount * lineSpace), 60)
            self.contentOffset = CGPointMake(spacingWidth25 * 11.5 + CGFloat(allCount * lineSpace), 0)
            
            /// 循环添加刻度
            for var i = 0 ; i <= allCount; i++ {
                
                if (i) % lineCount == 0 {
                    /// 长线上面的Label
                    let lineLabel = UILabel()
                    lineLabel.frame = CGRectMake(spacingWidth25 * 11.5 + CGFloat(lineSpace * i) - 30 , 8, 60, 18)
                    lineLabel.textAlignment = .Center
                    lineLabel.textColor = UIColor(named: .GuideColor99)
                    lineLabel.text = String(i / 12) + ".1"
                    
                    /// 长线
                    let longLine = UIView()
                    longLine.backgroundColor = UIColor(named: .GuideLineColor)
                    longLine.frame = CGRectMake(spacingWidth25 * 11.5 + CGFloat(lineSpace * i) , 26, 1, 34)
                    self.addSubview(longLine)
                    self.addSubview(lineLabel)
                    
                }else{
                    /// 短线
                    let shortLine = UIView()
                    shortLine.backgroundColor = UIColor(named: .GuideLineColor)
                    shortLine.frame = CGRectMake(spacingWidth25 * 11.5 + CGFloat(lineSpace * i), 40, 1, 20)
                    self.addSubview(shortLine)
                }
            }

        case .ddRuler:
            
            currentValue = "15"
            self.contentSize = CGSizeMake(spacingWidth25 * 23 + CGFloat(lineSpace * (dayValue - 1)), 60)
            self.contentOffset = CGPointMake(CGFloat(lineSpace * 14), 0)

            /// 循环添加刻度
            for var i = 1 ; i <= dayValue; i++ {
                
                if i % lineCount == 0{
                    /// 长线上面的Label
                    let lineLabel = UILabel()
                    lineLabel.frame = CGRectMake(spacingWidth25 * 11.5 + CGFloat(lineSpace * (i - 1)) - 30 , 8, 60, 18)
                    lineLabel.textAlignment = .Center
                    lineLabel.textColor = UIColor(named: .GuideColor99)
                    lineLabel.text = String(i)
                    
                    /// 长线
                    let longLine = UIView()
                    longLine.backgroundColor = UIColor(named: .GuideLineColor)
                    longLine.frame = CGRectMake(spacingWidth25 * 11.5 + CGFloat(lineSpace * (i - 1)) , 26, 1, 34)
                    self.addSubview(longLine)
                    self.addSubview(lineLabel)
                    
                }else{
                    /// 短线
                    let shortLine = UIView()
                    shortLine.backgroundColor = UIColor(named: .GuideLineColor)
                    shortLine.frame = CGRectMake(spacingWidth25 * 11.5 + CGFloat(lineSpace * (i - 1)), 40, 1, 20)
                    self.addSubview(shortLine)
                }
            }

        case .HeightRuler:
            
            print(__FUNCTION__)

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
