//
//  GoalView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Log
import EZSwiftExtensions

class GoalView: UIView {
    
    var stepCurrentValue: Int = 8000
    var hhCurrentValue: Int = 4
    var mmCurrentValue: Int = 58
    let sliderWidth = ez.screenWidth * 0.76
    // 标题 -- 目标
    @IBOutlet weak var titleLab: UILabel!
    
    // 上面模块标题 -- 运动步数
    @IBOutlet weak var stepModlue: UILabel!
    
    // 步数值 + 单位
    @IBOutlet weak var stepValue: UILabel!
    @IBOutlet weak var stepUnit: UILabel!
    
    // 步数平均标签
    @IBOutlet weak var stepPinAvg: UILabel!
    @IBOutlet weak var stepPineLine: UIView!
    
    // 步数推荐标签
    @IBOutlet weak var stepPinRecom: UILabel!
    @IBOutlet weak var stepPinRecomLIne: UIView!
    
    // 步数滑块
    @IBOutlet weak var stepSlider: UISlider!
    

    // 下面模块标题 -- 睡眠
    @IBOutlet weak var sleepModlue: UILabel!
    
    // 小时 数值 + 单位
    @IBOutlet weak var sleepHHValue: UILabel!
    @IBOutlet weak var sleepHHUnit: UILabel!
    
    // 分钟 数值 + 单位
    @IBOutlet weak var sleepMMValue: UILabel!
    @IBOutlet weak var sleepMMUnit: UILabel!
    
    // 平均标签
    @IBOutlet weak var sleepPinAvgLab: UILabel!
    @IBOutlet weak var sleepPineAvgLine: UIView!
    
    // 推荐标签
    @IBOutlet weak var sleepPinRecomLab: UILabel!
    @IBOutlet weak var sleepPinRecomLine: UIView!

    // 滑块
    @IBOutlet weak var sleepSlider: UISlider!
    
    
    var sleepTimeValue: Int {
        
        return self.hhCurrentValue * 60 + self.mmCurrentValue
                
    }

    // 布局
    func goalViewLayout() {
                
        self.backgroundColor = UIColor.whiteColor()

        // 页面名称
        titleLab.text = L10n.GuideGoal.string
        titleLab.font = UIFont.mediumSystemFontOfSize(18)
        titleLab.textColor = UIColor(named: .EColor)
        titleLab.snp_makeConstraints { make -> Void in
            make.top.equalTo(self).offset(ez.screenWidth * 0.08)
        }
        
        stepMoudleLayout()
        sleepModuleLayout()

    }
    
    // 添加计步运动目标模块
    func  stepMoudleLayout() {
        // 单位：步
        stepUnit.text = L10n.GuideStep.string
        stepUnit.textColor = UIColor(named: .EColor)
        stepUnit.font = UIFont.mediumSystemFontOfSize(14)
        stepUnit.snp_makeConstraints { make -> Void in
            make.right.equalTo(self).offset(0 - ez.screenWidth * 0.08)
        }
        
        // 目标步数
        stepValue.text = String(stepCurrentValue)
        stepValue.textColor = UIColor(named: .EColor)
        stepValue.font = UIFont.mediumSystemFontOfSize(30)
        stepValue.snp_makeConstraints { make -> Void in
            make.top.equalTo(titleLab).offset(ez.screenWidth * 0.14)
        }
        
        // 计步模块
        stepModlue.text = L10n.GuideGoalStep.string
        stepModlue.font = UIFont.mediumSystemFontOfSize(14)
        stepModlue.textColor = UIColor(named: .EColor)
        stepModlue.snp_makeConstraints { make -> Void in
            make.left.equalTo(self).offset(ez.screenWidth * 0.08)
        }
        
        // 滑块 stepSlider
        stepSlider.snp_makeConstraints { make -> Void in
            make.width.equalTo(sliderWidth)
            make.top.equalTo(stepValue).offset(ez.screenWidth * 0.12 + 36)
        }
        
        // 平均值线
        stepPinAvg.textColor = UIColor(named: .HColor)
        stepPinAvg.font = UIFont.mediumSystemFontOfSize(14)
        stepPineLine.backgroundColor = UIColor(named: .HColor)
        stepPineLine.snp_makeConstraints { make -> Void in
            make.bottom.equalTo(stepSlider).offset(0 - ez.screenWidth * 0.04)
            make.size.equalTo(CGSizeMake(1, ez.screenWidth * 0.04))
        }
        
        stepPinAvg.snp_makeConstraints { make -> Void in
            make.bottom.equalTo(stepSlider).offset(0 - ez.screenWidth * 0.06 - 14)
        }
        
        // 推荐值线
        stepPinRecom.textColor = UIColor(named: .HColor)
        stepPinRecom.font = UIFont.mediumSystemFontOfSize(14)
        stepPinRecomLIne.backgroundColor = UIColor(named: .HColor)
        stepPinRecomLIne.snp_makeConstraints { make -> Void in
            make.bottom.equalTo(stepSlider).offset(0 - ez.screenWidth * 0.04)
            make.size.equalTo(CGSizeMake(1, ez.screenWidth * 0.04))
        }
        
        stepPinRecom.snp_makeConstraints { make -> Void in
            make.bottom.equalTo(stepSlider).offset(0 - ez.screenWidth * 0.06 - 14)
        }
        

    }
    
    // 添加睡眠目标模块
    func sleepModuleLayout(){
        
        // 单位：分钟
        sleepMMUnit.text = L10n.GuideMinute.string
        sleepMMUnit.font = UIFont.mediumSystemFontOfSize(14)
        sleepMMUnit.textColor = UIColor(named: .EColor)
        sleepMMUnit.snp_makeConstraints { make -> Void in
            make.right.equalTo(self).offset(0 - ez.screenWidth * 0.08)
        }
        sleepMMValue.text = String(mmCurrentValue)
        sleepMMValue.textColor = UIColor(named: .EColor)
        sleepMMValue.font = UIFont.mediumSystemFontOfSize(30)
        sleepMMValue.snp_makeConstraints { make -> Void in
            make.top.equalTo(stepSlider).offset(ez.screenWidth * 0.22)
        }

        // 单位：小时
        sleepHHUnit.text = L10n.GuideHour.string
        sleepHHUnit.textColor = UIColor(named: .EColor)
        sleepHHUnit.font = UIFont.mediumSystemFontOfSize(14)
        sleepHHValue.text = String(hhCurrentValue)
        sleepHHValue.font = UIFont.mediumSystemFontOfSize(30)
        sleepHHValue.textColor = UIColor(named: .EColor)
        
        // 睡眠模块
        sleepModlue.text = L10n.GuideGoalSleep.string
        sleepModlue.font = UIFont.mediumSystemFontOfSize(14)
        sleepModlue.textColor = UIColor(named: .EColor)
        sleepModlue.snp_makeConstraints { make -> Void in
            make.left.equalTo(self).offset(ez.screenWidth * 0.08)
        }
        
        // 睡眠滑块
        sleepSlider.snp_makeConstraints { make -> Void in
            make.width.equalTo(sliderWidth)
            make.top.equalTo(sleepHHValue).offset(ez.screenWidth * 0.12 + 36)
        }

        // 平均值线
        sleepPinAvgLab.textColor = UIColor(named: .HColor)
        sleepPinAvgLab.font = UIFont.mediumSystemFontOfSize(14)
        sleepPineAvgLine.backgroundColor = UIColor(named: .HColor)
        sleepPineAvgLine.snp_makeConstraints { make -> Void in
            make.bottom.equalTo(sleepSlider).offset(0 - ez.screenWidth * 0.04)
            make.size.equalTo(CGSizeMake(1, ez.screenWidth * 0.04))
        }
        
        sleepPinAvgLab.snp_makeConstraints { make -> Void in
            make.bottom.equalTo(sleepSlider).offset(0 - ez.screenWidth * 0.06 - 14)
        }
        
        // 推荐值线
        sleepPinRecomLine.backgroundColor = UIColor(named: .HColor)
        sleepPinRecomLine.snp_makeConstraints { make -> Void in
            make.bottom.equalTo(sleepSlider).offset(0 - ez.screenWidth * 0.04)
            make.size.equalTo(CGSizeMake(1, ez.screenWidth * 0.04))
        }
        sleepPinRecomLab.textColor = UIColor(named: .HColor)
        sleepPinRecomLab.font = UIFont.mediumSystemFontOfSize(14)
        sleepPinRecomLab.snp_makeConstraints { make -> Void in
            make.bottom.equalTo(sleepSlider).offset(0 - ez.screenWidth * 0.06 - 14)
        }

    }
    
    /**
     步数的slider  （所有数值除以100 ，100为最小跨度）
     
     - parameter averageValue:   平均值
     - parameter recommandValue: 推荐值
     - parameter minValue:       最小值
     - parameter maxValue:       最大值
     */
    func sliderStepAttribute(averageValue: Int, recommandValue: Int, minValue: Int, maxValue: Int) {
        
        stepValue.text = String(recommandValue)
        
        let minSlider = Float(minValue / 100)
        let maxSlider = Float(maxValue / 100)
        let avgSlider = Float(averageValue / 100)
        let recomSlider = Float(recommandValue / 100)
        
        self.stepSlider.minimumValue = minSlider
        self.stepSlider.maximumValue = maxSlider
        self.stepSlider.value = recomSlider
        
        ///  平均 和 推荐标签移动的长度
        let avgMove = CGFloat(avgSlider - minSlider) / CGFloat(maxSlider - minSlider) * sliderWidth
        let recomMove = CGFloat(recomSlider - minSlider) / CGFloat(maxSlider - minSlider) * sliderWidth
//        Log.info("步数： \(avgMove)--\(recomMove)")

        self.stepPineLine.snp_makeConstraints { make -> Void in
            make.left.equalTo(self.stepSlider).offset(avgMove)
        }
        self.stepPinRecomLIne.snp_makeConstraints { make -> Void in
            make.left.equalTo(self.stepSlider).offset(recomMove)
        }
        
        // slider Action
        self.stepSlider.addTarget(self, action: #selector(GoalView.stepSliderAction), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    /**
     睡眠的slider 
     分钟以10为最小跨度 所以就像 5小时20分钟 Count 转换为 5 * 6 + 2 = 32
     
     - parameter avgH:   平均值小时
     - parameter avgM:   平均值分钟
     - parameter recomH: 推荐值小时
     - parameter recomM: 推荐值分钟
     - parameter minH:   最小值小时
     - parameter minM:   最小值分钟
     - parameter maxH:   最大值小时
     - parameter maxM:   最大值分钟
     */
    func sliderSleepAttribute(avgH: Int, avgM: Int, recomH: Int, recomM: Int, minH: Int, minM: Int, maxH: Int, maxM: Int) {
        
        sleepHHValue.text = String(recomH)
        sleepMMValue.text = String(recomM)
        
        let avgCount = hourChangeToMinutes(avgH, minutes: avgM)
        let recCount = hourChangeToMinutes(recomH, minutes: recomM)
        let minCount = hourChangeToMinutes(minH, minutes: minM)
        let maxCount = hourChangeToMinutes(maxH, minutes: maxM)

        self.sleepSlider.minimumValue = Float(minCount)
        self.sleepSlider.maximumValue = Float(maxCount)
        self.sleepSlider.value = Float(recCount)
        
        ///  平均 和 推荐标签移动的长度
        let avgMove = CGFloat(avgCount - minCount) / CGFloat(maxCount - minCount) * sliderWidth
        let recomMove = CGFloat(recCount - minCount) / CGFloat(maxCount - minCount) * sliderWidth
//        Log.info("睡眠： \(avgMove)--\(recomMove)")
        self.sleepPineAvgLine.snp_makeConstraints { make -> Void in
            make.left.equalTo(self.stepSlider).offset(avgMove)
        }
        self.sleepPinRecomLine.snp_makeConstraints { make -> Void in
            make.left.equalTo(self.stepSlider).offset(recomMove)
        }
        
        // slider Action
        self.sleepSlider.addTarget(self, action: #selector(GoalView.sleepSliderAction), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    /**
     将睡眠滑杆滑到指定值
     
     - parameter hour:   小时
     - parameter minute: 分钟
     */
    func sliderSleepToValue(hour: Int, minute: Int) {
        
        sleepHHValue.text = String(hour)
        sleepMMValue.text = String(minute)
        
        let recCount = hourChangeToMinutes(hour, minutes: minute)
        
        self.sleepSlider.value = Float(recCount)
        
    }
    
    /**
     将计步滑杆滑到指定值
     
     - parameter value: 值
     */
    func sliderStepToValue(value: Int) {
        
        stepValue.text = String(value)
        
        let recomSlider = Float(value / 100)
        
        self.stepSlider.value = recomSlider
        
    }
    

    // 小时转分钟 10一个刻度
    func hourChangeToMinutes(hour: Int, minutes: Int) -> Int{
        
        return hour * 6 + minutes / 10
    }
    
    // 分钟转小时 10 一个刻度
    func minutesChangeToHours(minutes: Int) -> (hour: Int, minutes: Int){
        
        let hh = minutes / 6
        let mm = (minutes - hh * 6) * 10
        
        return (hh, mm)
    }
    
    // 计步滑动事件
    func stepSliderAction() {
        
        
        let step = String(format: "%.0f", stepSlider.value)

        stepCurrentValue = Int(step)! * 100
        
        self.stepValue.text = "\(stepCurrentValue)"
        
    }
    
    // 睡眠滑动事件
    func sleepSliderAction(){
        
        let (hour, min) = minutesChangeToHours(Int(sleepSlider.value))
        
        hhCurrentValue = hour
        mmCurrentValue = min
        
        self.sleepHHValue.text = String(hour)
        self.sleepMMValue.text = String(min)
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        goalViewLayout()
        
    }
    */

}
