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

class RulerView: UIView , UIScrollViewDelegate {
    
    var rulerDelegate: RulerViewDelegate?
    
    var rulerScroll = RulerScroller()
    var columeFlag = UIImageView()
    
    var nowYear = Int()
    var nowMonth = Int()
    var nowDay = Int()
    var nowHeight = CGFloat() // 当前身高 滑动跟随改变
    
    /**
     初始化生日年月标尺
     
     - parameter yearValue:  年份最大值
     - parameter monthValue: 月份最大值
     - parameter style:      标尺的风格
     */
    func initYearMonthRuler(yearValue:Int, monthValue: Int, lineSpace: Int, lineCount: Int, style : RulerScroller.RulerStyle){

        addRulerViewLayout()
        
        rulerScroll.backgroundColor = UIColor.whiteColor()
        rulerScroll.delegate = self
        rulerScroll.yearValue = yearValue
        rulerScroll.monthValue = monthValue
        rulerScroll.lineSpace = lineSpace
        rulerScroll.lineCount = lineCount
        rulerScroll.rulerStyle = style
        rulerScroll.updateRulerViewStyle()
    }
    
    /**
     初始化生日的日的标尺
     
     - parameter dayValue: 日的最大值
     - parameter style:    标尺风格
     */
    func initDayRuler(dayValue: Int, lineSpace: Int, lineCount: Int, style : RulerScroller.RulerStyle){
        
        addRulerViewLayout()
        
        rulerScroll.backgroundColor = UIColor.whiteColor()
        rulerScroll.delegate = self
        rulerScroll.dayValue = dayValue
        rulerScroll.lineSpace = lineSpace
        rulerScroll.lineCount = lineCount
        rulerScroll.rulerStyle = style
        rulerScroll.updateRulerViewStyle()
    }
    
     /**
     初始化身高标尺
     
     - parameter lineSpace: 间隔长度
     - parameter lineCount: 间隔数
     - parameter style:     格尺style
     */
    func initHeightRuler(lineSpace: Int, lineCount: Int, style : RulerScroller.RulerStyle){
        
        addHeightRulerViewLayout()
        
        rulerScroll.backgroundColor = UIColor.whiteColor()
        rulerScroll.delegate = self
        rulerScroll.lineSpace = lineSpace
        rulerScroll.lineCount = lineCount
        rulerScroll.rulerStyle = style
        rulerScroll.updateRulerViewStyle()
    }
        
    /**
     添加生日布局 + 中间标志
     */
    func addRulerViewLayout(){

        self.addSubview(rulerScroll)
        rulerScroll.snp_makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(self)
        }
        
        /**
        添加中间标志
        */
        self.addSubview(columeFlag)
        columeFlag.backgroundColor = UIColor.cyanColor()
        columeFlag.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(3, 60))
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }

    }
    
    /**
     添加身高布局 + 中间标志
     */
    func addHeightRulerViewLayout(){
        self.addSubview(rulerScroll)
        rulerScroll.snp_makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(self)
        }
        
        /**
        添加中间标志
        */
        self.addSubview(columeFlag)
        columeFlag.backgroundColor = UIColor.cyanColor()
        columeFlag.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(60, 3))
            make.centerY.equalTo(self)
            make.left.equalTo(self)
        }

    }
    
    //MARK: --- UIScrollViewDelegate 
    
    // 滑动触发
    func scrollViewDidScroll(scrollView: UIScrollView) {
        /// 转换成RulerScroll
        let sc =  scrollView as! RulerScroller
        
        if sc.rulerStyle == .yymmRuler {
            
            // 所有格子数
            let allCount = (sc.yearValue - 1901) * sc.lineCount + sc.monthValue - 1
            
            // 计算起始位置
            let beginSetX = CGFloat(allCount * sc.lineSpace)

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
            
        }else if sc.rulerStyle == .ddRuler{
            
            // 计算起始位置
            let beginSetX = CGFloat(sc.lineSpace * 14)
            
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
 
        }else if sc.rulerStyle == .hhRuler{
            // 计算起始位置
    
            let allCount = (240 - 30) * sc.lineCount
            
            let beginSetY = CGFloat(allCount * sc.lineSpace)
            
            // 移动的位置
            let endSetY = scrollView.contentOffset.y

            let moveCellInt = Int((endSetY - beginSetY) / CGFloat(sc.lineSpace))
            
            nowHeight = 240 + CGFloat(moveCellInt) * 0.1
            
            // 限制范围 防止两边数值溢出变化
            if nowHeight > 240 {
                return
            }
            
            if nowHeight < 30{
                return
            }
            
            sc.currentValue = "\(nowHeight)"
            rulerDelegate?.changeHeightRulerValue!(sc)
        }
    }
    
    // 减速停止时执行
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let sc =  scrollView as! RulerScroller
        
        if sc.rulerStyle == .yymmRuler {
            
            let nowCount = nowYear * sc.lineCount + nowMonth - 1
            
            UIView.animateWithDuration(0.2) { () -> Void in
                sc.contentOffset = CGPointMake(CGFloat(nowCount * sc.lineSpace), 0)
                
            }
            // 改变当前月份的天数
            rulerDelegate?.changeCountStatusForDayRuler!(sc)
            
            
        }else if sc.rulerStyle == .ddRuler{

            UIView.animateWithDuration(0.2) { () -> Void in
                
                sc.contentOffset = CGPointMake(CGFloat((self.nowDay - 1) * sc.lineSpace), 0)
                
            }
        }else if sc.rulerStyle == .hhRuler{
            
            UIView.animateWithDuration(0.2) { () -> Void in
                
                sc.contentOffset = CGPointMake(0, (self.nowHeight - 30) * CGFloat(sc.lineCount * sc.lineSpace))
            }
        }
    }
    
    // 完成拖拽
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let sc =  scrollView as! RulerScroller
        
        if sc.rulerStyle == .yymmRuler {
            
            let nowCount = nowYear * sc.lineCount + nowMonth - 1
            
            UIView.animateWithDuration(0.2) { () -> Void in
                sc.contentOffset = CGPointMake(CGFloat(nowCount * sc.lineSpace), 0)
                
            }
            
            // 改变当前月份的天数
            rulerDelegate?.changeCountStatusForDayRuler!(sc)
            
            
        }else if sc.rulerStyle == .ddRuler{
            
            UIView.animateWithDuration(0.2) { () -> Void in
                sc.contentOffset = CGPointMake(CGFloat((self.nowDay - 1) * sc.lineSpace), 0)
                
            }
            
        }else if sc.rulerStyle == .hhRuler{
            
            UIView.animateWithDuration(0.2) { () -> Void in
                
                sc.contentOffset = CGPointMake(0, (self.nowHeight - 30) * CGFloat(sc.lineCount * sc.lineSpace))

            }
        }
        
    }
}
