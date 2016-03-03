//
//  GenderView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class GenderView: UIView {
    
    var MOrG = Bool()
    var titleLab = UILabel()
    var upGenderBtn = UIButton()
    var downGenderBtn = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        genderViewLayout()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     视图布局
     */
    private func genderViewLayout(){
        
        self.addSubview(titleLab)
        self.addSubview(upGenderBtn)
        self.addSubview(downGenderBtn)
    
        titleLab.text = L10n.GuideMine.string
        titleLab.font = UIFont.systemFontOfSize(18)
        titleLab.textColor = UIColor(named: .GuideColorCC)
        titleLab.textAlignment = .Center
        titleLab.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(spacingWidth25 * 23, 18))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(spacingWidth25 * 2)
        }
        
        
        upGenderBtn.backgroundColor = UIColor.lightGrayColor()
        upGenderBtn.frame.size = CGSizeMake(spacingWidth25 * 8, spacingWidth25 * 8)
        upGenderBtn.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(spacingWidth25 * 8, spacingWidth25 * 8))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(spacingWidth25 * 5)
        }
        
        downGenderBtn.backgroundColor = UIColor.lightGrayColor()
        downGenderBtn.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(spacingWidth25 * 8, spacingWidth25 * 8))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(spacingWidth25 * 15)
        }
        
        upGenderBtn.addTarget(self, action: "genderUpClick", forControlEvents: .TouchUpInside)
        downGenderBtn.addTarget(self, action: "genderDownClick", forControlEvents: .TouchUpInside)
    }
    /**
     上面按钮事件
     */
    func genderUpClick(){
        
        MOrG = true
        updateGender()

    }
    /**
     下面按钮的事件
     */
    func genderDownClick(){
        
        MOrG = false
        updateGender()
        
    }
    /**
     更新性别事件
     */
    func updateGender() {
        
        if MOrG{
            upGenderBtn.backgroundColor = UIColor.purpleColor()
            downGenderBtn.backgroundColor = UIColor.lightGrayColor()
        }else {
            downGenderBtn.backgroundColor = UIColor.purpleColor()
            upGenderBtn.backgroundColor = UIColor.lightGrayColor()
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
