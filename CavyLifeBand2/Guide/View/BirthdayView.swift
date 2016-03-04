//
//  BirthdayView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class BirthdayView: UIView {

    
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
            make.size.equalTo(CGSizeMake(spacingWidth25 * 23, 18))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(spacingWidth25 * 2)
        }
        
        yyMMLabel.font = UIFont.systemFontOfSize(45)
        yyMMLabel.textColor = UIColor(named: .GuideColorCC)
        yyMMLabel.textAlignment = NSTextAlignment.Center
        yyMMLabel.text = String(yymmRuler.currentValue)
        yyMMLabel.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(spacingWidth25 * 23, 45))
            make.centerX.equalTo(self)
            make.top.equalTo(titleLab).offset(spacingWidth25 * 2 + 18)
        }
        
        yymmRuler.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(spacingWidth25 * 23, 60))
            make.centerX.equalTo(self)
            make.top.equalTo(yyMMLabel).offset(spacingWidth25 + 45)
        }
        
        dayLabel.font = UIFont.systemFontOfSize(45)
        dayLabel.textColor = UIColor(named: .GuideColorCC)
        dayLabel.textAlignment = NSTextAlignment.Center
        dayLabel.text = String(format: "%.0f", dayRuler.currentValue)
        dayLabel.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(spacingWidth25 * 23, 45))
            make.centerX.equalTo(self)
            make.top.equalTo(yymmRuler).offset(spacingWidth25 * 2 + 60)
        }
        
        dayRuler.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(spacingWidth25 * 23, 60))
            make.centerX.equalTo(self)
            make.top.equalTo(dayLabel).offset(spacingWidth25 + 45)
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
