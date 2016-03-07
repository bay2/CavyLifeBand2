//
//  RulerView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/4.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol RulerViewDelegate: NSObjectProtocol
{
    func changeRulerValue(scrollRuler: RulerScroller)
    func changeDayRulerValue(scrollRuler: RulerScroller)
    func changeCountStatusForDayRuler(scrollRuler: RulerScroller)
}

class RulerView: UIView , UIScrollViewDelegate {
    
    weak var rulerDelegate = RulerViewDelegate?()
    
    var rulerScroll = RulerScroller()
    var columeFlag = UIImageView()
    
    var nowYear = Int()
    var nowMonth = Int()
    var nowDay = Int()
    
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
     视图布局 + 添加中间标志
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

    // 滑动触发
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let sc =  scrollView as! RulerScroller
        
        if sc.rulerStyle == .yymmRuler {
            
            // 所有格子数
            let allCount = sc.yearValue * sc.lineCount + sc.monthValue - 1
            // 计算起始位置
            let beginSetX = CGFloat((sc.yearValue * sc.lineCount + sc.monthValue - 1) * sc.lineSpace)
            // 移动的位置
            let endSetX = scrollView.contentOffset.x
            let moveCellInt = Int((endSetX - beginSetX) / CGFloat(sc.lineSpace))
//            print("moveCell *************** \(moveCellInt)")
            
            nowYear = (allCount + moveCellInt) / sc.lineCount
            nowMonth = (allCount + moveCellInt) - nowYear * sc.lineCount + 1
            
            sc.currentValue = "\(nowYear).\(nowMonth)"
            
            // 代理更新数据
            rulerDelegate?.changeRulerValue(sc)
            
        }else if sc.rulerStyle == .ddRuler{
            
            // 计算起始位置
            let beginSetX = CGFloat(sc.lineSpace * 14)
            
            // 移动的位置
            let endSetX = scrollView.contentOffset.x
            let moveCellInt = Int((endSetX - beginSetX) / CGFloat(sc.lineSpace))
            
            nowDay = 15 + moveCellInt
            sc.currentValue = "\(nowDay)"
            rulerDelegate?.changeDayRulerValue(sc)

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
            rulerDelegate?.changeCountStatusForDayRuler(sc)
            
            
        }else if sc.rulerStyle == .ddRuler{

            UIView.animateWithDuration(0.2) { () -> Void in
                
                sc.contentOffset = CGPointMake(CGFloat((self.nowDay - 1) * sc.lineSpace), 0)
                
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
            rulerDelegate?.changeCountStatusForDayRuler(sc)
            
            
        }else if sc.rulerStyle == .ddRuler{
            
            UIView.animateWithDuration(0.2) { () -> Void in
                sc.contentOffset = CGPointMake(CGFloat((self.nowDay - 1) * sc.lineSpace), 0)
                
            }
            
        }
        
    }
    
    

}
