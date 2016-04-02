//
//  BirthdayView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class BirthdayView: UIView, RulerViewDelegate {
    
    var titleLab = UILabel()
    var yyMMLabel = UILabel()
    var yymmRuler = RulerView()
    var dayLabel = UILabel()
    var dayRuler = RulerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        birthdayViewLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func birthdayViewLayout(){
        
        self.addSubview(yyMMLabel)
        self.addSubview(yymmRuler)
        self.addSubview(dayLabel)
        self.addSubview(dayRuler)
        self.addSubview(titleLab)
        
        titleLab.text = L10n.GuideBirthday.string
        titleLab.font = UIFont.systemFontOfSize(18)
        titleLab.textColor = UIColor(named: .GuideColorCC)
        titleLab.textAlignment = .Center
        titleLab.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 23, 18))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 2)
        }
        yyMMLabel.font = UIFont.systemFontOfSize(45)
        yyMMLabel.textColor = UIColor(named: .GuideColorCC)
        yyMMLabel.textAlignment = NSTextAlignment.Center
        yyMMLabel.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 23, 45))
            make.centerX.equalTo(self)
            make.top.equalTo(titleLab).offset(CavyDefine.spacingWidth25 * 2 + 18)
        }
        yymmRuler.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 23, 60))
            make.centerX.equalTo(self)
            make.top.equalTo(yyMMLabel).offset(CavyDefine.spacingWidth25 + 45)
        }
        yymmRuler.rulerDelegate = self
        
        // 获取当前时间
        let dateFormatter = NSDateFormatter() // = NSDate()
        dateFormatter.dateFormat = "yyyy/MM"
        let dateString = dateFormatter.stringFromDate(NSDate())
        var dates = dateString.componentsSeparatedByString("/")
        let currentYear = dates[0].toInt()
        let currentMonth = dates[1].toInt()
        
        yymmRuler.initYearMonthRuler(currentYear!, monthValue: currentMonth!, lineSpace: 13, lineCount: 12, style: .YearMonthRuler)
        yyMMLabel.text = yymmRuler.rulerScroll.currentValue
        
        dayLabel.font = UIFont.systemFontOfSize(45)
        dayLabel.textColor = UIColor(named: .GuideColorCC)
        dayLabel.textAlignment = NSTextAlignment.Center
        dayLabel.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 23, 45))
            make.centerX.equalTo(self)
            make.top.equalTo(yymmRuler).offset(CavyDefine.spacingWidth25 * 2 + 60)
        }
        
        dayRuler.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 23, 60))
            make.centerX.equalTo(self)
            make.top.equalTo(dayLabel).offset(CavyDefine.spacingWidth25 + 45)
        }
        dayRuler.rulerDelegate = self
        dayRuler.initDayRuler(31, lineSpace: 26, lineCount: 5, style: .DayRuler)
        dayLabel.text = dayRuler.rulerScroll.currentValue
        
    }
    
    // 时刻更新 年月 刻度尺的当前值
    func changeRulerValue(scrollRuler: RulerScroller) {

        yyMMLabel.text = scrollRuler.currentValue

    }
    
    // 时刻更新 日期 刻度尺的当前值
    func changeDayRulerValue(scrollRuler: RulerScroller) {
        dayLabel.text = scrollRuler.currentValue
    }
    
    // 更改刻度尺状态
    func changeCountStatusForDayRuler(scrollRuler: RulerScroller) {
        // 通过年月日来判断 下面刻度尺的日期天数
        let days = daysCount(yymmRuler.nowYear, month: yymmRuler.nowMonth)
        
        dayRuler.initDayRuler(days, lineSpace: 26, lineCount: 5, style: .DayRuler)
        
    }
    
    // 计算当前月份的天数
    func daysCount(year: Int, month: Int) -> Int {
        
        var daysArray = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        
        if year % 400 == 0 || year % 100 != 0 && year % 4 == 0 {
            
            daysArray[2] += 1
            
        }
        
        return daysArray[month]
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
