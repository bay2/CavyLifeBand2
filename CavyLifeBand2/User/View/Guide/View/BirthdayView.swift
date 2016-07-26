//
//  BirthdayView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class BirthdayView: UIView, RulerViewDelegate {
    
    var titleLab = UILabel()
    var yyMMLabel = UILabel()
    var yymmRuler = RulerView()
    var dayLabel = UILabel()
    var dayRuler = RulerView()
    
    let beginYear = 1901
    var birthdayString: String {
        return "\(self.yymmRuler.nowYear + beginYear)-\(self.yymmRuler.nowMonth)-\(self.dayRuler.nowDay)"
    }
    
    convenience init(frame: CGRect, year: Int, month: Int, day: Int) {

      self.init(frame: frame)
        
        yymmRuler.rulerScroll.currentValue = "\(year).\(month)"
        yymmRuler.rulerDelegate?.changeRulerValue!(yymmRuler.rulerScroll)
        
        let nowCount = (year  - 1901) * birthYYMMLineCount + month
        yymmRuler.rulerScroll.setContentOffset(CGPointMake(CGFloat(nowCount * birthYYMMLineSpace), 0), animated: false)
        
        dayRuler.rulerScroll.currentValue = "\(day)"
        dayRuler.rulerDelegate?.changeDayRulerValue!(dayRuler.rulerScroll)
        dayRuler.rulerScroll.setContentOffset(CGPointMake(CGFloat((day - 1) * birthDayLineSpace) + horizontalInset / 2, 0), animated: false)

        
    }
    
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
        titleLab.font = UIFont.mediumSystemFontOfSize(18)
        titleLab.textColor = UIColor(named: .EColor)
        titleLab.textAlignment = .Center
        titleLab.snp_makeConstraints { make -> Void in
            make.size.equalTo(CGSizeMake(birthRulerWidth, 18))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 2)
        }
        
        yyMMLabel.font = UIFont.mediumSystemFontOfSize(42)
        yyMMLabel.textColor = UIColor(named: .EColor)
        yyMMLabel.textAlignment = NSTextAlignment.Center
        yyMMLabel.snp_makeConstraints { make -> Void in
            make.size.equalTo(CGSizeMake(birthRulerWidth, 40))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(middleViewHeight / 2 - birthRulerViewHeight - rulerBetweenSpace / 2)
        }
        
        yymmRuler.snp_makeConstraints { make -> Void in
            make.height.equalTo(birthRulerHeight)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(middleViewHeight / 2 - birthRulerHeight - rulerBetweenSpace / 2)
        }
        yymmRuler.rulerDelegate = self
        
        // 获取当前时间
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM"
        let dateString = dateFormatter.stringFromDate(NSDate())
        var dates = dateString.componentsSeparatedByString("/")
        let currentYear = dates[0].toInt()
        let currentMonth = dates[1].toInt()
        
        yymmRuler.initYearMonthRuler(currentYear!, monthValue: currentMonth!, style: .YearMonthRuler)
        yyMMLabel.text = yymmRuler.rulerScroll.currentValue
        
        dayLabel.font = UIFont.mediumSystemFontOfSize(42)
        dayLabel.textColor = UIColor(named: .EColor)
        dayLabel.textAlignment = NSTextAlignment.Center
        dayLabel.snp_makeConstraints { make -> Void in
            make.size.equalTo(CGSizeMake(birthRulerWidth, 40))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(middleViewHeight / 2 + rulerBetweenSpace)
        }
        
        dayRuler.snp_makeConstraints { make -> Void in
            make.height.equalTo(60)
            make.leading.equalTo(self).offset(10)
            make.trailing.equalTo(self).offset(-10)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(middleViewHeight / 2 + rulerBetweenSpace + birthRulerHeight)
        }
        dayRuler.rulerDelegate = self
        dayRuler.initDayRuler(31, style: .DayRuler)
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
        let days = NSDate().daysCount(yymmRuler.nowYear, month: yymmRuler.nowMonth)
        
        dayRuler.initDayRuler(days, style: .DayRuler)
        
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
