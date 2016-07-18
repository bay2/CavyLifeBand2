//
//  RulerView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

@objc protocol RulerViewDelegate: NSObjectProtocol
{
    
    optional func changeRulerValue(scrollRuler: RulerScroller)
    optional func changeDayRulerValue(scrollRuler: RulerScroller)
    optional func changeCountStatusForDayRuler(scrollRuler: RulerScroller)
    optional func changeHeightRulerValue(scrollRuler: RulerScroller)
}

class RulerView: UIView, UIScrollViewDelegate {
    
    var rulerDelegate: RulerViewDelegate?
    
    var rulerScroll = RulerScroller()
    var columeFlag = UIImageView()
    
    var nowYear = Int()
    var nowMonth = Int()
    var nowDay = Int()
    var nowHeight: Int = 0  // 当前身高 滑动跟随改变
    
    /**
     初始化生日年月标尺
     
     - parameter yearValue:  年份最大值
     - parameter monthValue: 月份最大值
     - parameter style:      标尺的风格
     */
    func initYearMonthRuler(yearValue: Int, monthValue: Int, style: RulerScroller.RulerStyle) {

        addRulerViewLayout()
        
        rulerScroll.backgroundColor = UIColor.clearColor()
        rulerScroll.delegate = self
        rulerScroll.yearValue = yearValue
        rulerScroll.monthValue = monthValue
        rulerScroll.lineSpace = birthYYMMLineSpace
        rulerScroll.lineCount = birthYYMMLineCount
        rulerScroll.rulerStyle = style
        rulerScroll.updateRulerViewStyle()
    }
    
    /**
     初始化生日的日的标尺
     
     - parameter dayValue: 日的最大值
     - parameter style:    标尺风格
     */
    func initDayRuler(dayValue: Int, style: RulerScroller.RulerStyle) {
        
        addRulerViewLayout()
        
        rulerScroll.backgroundColor = UIColor.clearColor()
        rulerScroll.delegate = self
        rulerScroll.dayValue = dayValue
        rulerScroll.lineSpace = birthDayLineSpace
        rulerScroll.lineCount = birthDayLineCount
        rulerScroll.rulerStyle = style
        rulerScroll.updateRulerViewStyle()
    }
    
     /**
     初始化身高标尺
     
     - parameter lineSpace: 间隔长度
     - parameter lineCount: 间隔数
     - parameter style:     格尺style
     */
    func initHeightRuler(style: RulerScroller.RulerStyle) {
        
        addHeightRulerViewLayout()
        
        rulerScroll.backgroundColor = UIColor.clearColor()
        rulerScroll.delegate = self
        rulerScroll.lineSpace = heightLineSpace
        rulerScroll.lineCount = heightLineCount
        rulerScroll.rulerStyle = .HeightRuler
        rulerScroll.updateRulerViewStyle()
    }
        
    /**
     添加生日布局 + 中间标志
     */
    func addRulerViewLayout(){

        self.addSubview(rulerScroll)
        rulerScroll.snp_makeConstraints { make -> Void in
            make.top.bottom.left.right.equalTo(self)
        }
        
        /**
        添加中间标志
        */
        self.addSubview(columeFlag)
        columeFlag.image = UIImage(asset: .GuideFlagV)
        columeFlag.snp_makeConstraints { make -> Void in
            make.size.equalTo(CGSizeMake(3, birthRulerHeight))
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }

    }
    
    /**
     添加身高布局 + 中间标志
     */
    func addHeightRulerViewLayout(){
        self.addSubview(rulerScroll)
        rulerScroll.snp_makeConstraints { make -> Void in
            make.top.bottom.left.right.equalTo(self)
        }
        
        /**
        添加中间标志
        */
        self.addSubview(columeFlag)
        columeFlag.image = UIImage(asset: .GuideFlagH)
        columeFlag.snp_makeConstraints { make -> Void in
            make.size.equalTo(CGSizeMake(heightRulerWidth, 3))
            make.centerY.equalTo(self)
            make.left.equalTo(self)
        }

    }
    
    //MARK: --- UIScrollViewDelegate 
    
    // 滑动触发
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        /// 转换成RulerScroll
        let sc =  scrollView as! RulerScroller
        
        if sc.rulerStyle == .YearMonthRuler {
            
            // 所有格子数
            let allCount = (sc.yearValue - 1901) * sc.lineCount + sc.monthValue - 1
            
            // 计算起始位置
            let beginSetX = CGFloat(allCount * sc.lineSpace) + horizontalInset / 2

            // 移动的位置
            let endSetX = scrollView.contentOffset.x

            let moveCellInt = Int((endSetX - beginSetX) / CGFloat(sc.lineSpace))
            
            // 限制范围 防止两边数值溢出变化
            if moveCellInt > 0{
                return
            }
            if moveCellInt < (0 - allCount) {
                return
            }
            
            nowYear = (allCount + moveCellInt) / sc.lineCount
            nowMonth = (allCount + moveCellInt) - nowYear * sc.lineCount + 1

            sc.currentValue = "\(nowYear + 1901).\(nowMonth)"
            
            // 代理更新数据
            rulerDelegate?.changeRulerValue!(sc)
            
        }else if sc.rulerStyle == .DayRuler{
            
            // 计算起始位置
            let beginSetX = CGFloat(sc.lineSpace * 14) + horizontalInset / 2
            
            // 移动的位置
            let endSetX = scrollView.contentOffset.x
            let moveCellInt = Int((endSetX - beginSetX) / CGFloat(sc.lineSpace))
            
            nowDay = 15 + moveCellInt
            
            // 限制范围 防止两边数值溢出变化
            if nowDay > sc.dayValue {
                return
            }
            
            if nowDay < 1{
                return
            }
            
            sc.currentValue = "\(nowDay)"
            rulerDelegate?.changeDayRulerValue!(sc)
 
        }else if sc.rulerStyle == .HeightRuler{
            // 计算起始位置
    
            let allCount = 240 - 30
            
            let beginSetY = CGFloat(allCount * sc.lineSpace)
            
            // 移动的位置
            let endSetY = scrollView.contentOffset.y

            let moveCellInt = Int((endSetY - beginSetY) / CGFloat(sc.lineSpace))
            
            nowHeight = 240 + moveCellInt
            
            // 限制范围 防止两边数值溢出变化
            if nowHeight > 240 {
                return
            }
            
            if nowHeight < 30{
                return
            }
            
            sc.currentValue = "\(nowHeight)"
            rulerDelegate?.changeHeightRulerValue?(sc)
        }
    }
    
    // 减速停止时执行
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        scrollViewStopAction(scrollView)
        
    }
    
    // 完成拖拽
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        scrollViewStopAction(scrollView)
        
    }
    
    // 滑动结束事件
    func scrollViewStopAction(scrollView: UIScrollView) {
        
        guard let sc =  scrollView as? RulerScroller else {
            return
        }
        
        if sc.rulerStyle == .YearMonthRuler {
            
            let nowCount = nowYear * sc.lineCount + nowMonth - 1
            
            sc.setContentOffset(CGPointMake(CGFloat(nowCount * sc.lineSpace), 0), animated: true)
            
            // 改变当前月份的天数
            rulerDelegate?.changeCountStatusForDayRuler!(sc)
            
            
        } else if sc.rulerStyle == .DayRuler{
            
            sc.setContentOffset(CGPointMake(CGFloat((self.nowDay - 1) * sc.lineSpace) + horizontalInset / 2, 0), animated: true)
         
        } else if sc.rulerStyle == .HeightRuler{
            
            sc.setContentOffset(CGPointMake(0, CGFloat(self.nowHeight - 30) * CGFloat(sc.lineSpace)), animated: true)
     
        }

        
    }
    
    
}
