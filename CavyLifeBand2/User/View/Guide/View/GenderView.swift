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
    var upGenderBtn = UIButton(type: .Custom)
    var downGenderBtn = UIButton(type: .Custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        MOrG = true // 默认True 是男的
        UserInfoModelView.shareInterface.userInfo!.sex = 0
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
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 23, 18))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 2)
        }
        
        upGenderBtn.setImage(UIImage(asset: .GuideGenderBoyChosen), forState: .Normal)
        upGenderBtn.frame.size = CGSizeMake(CavyDefine.spacingWidth25 * 8, CavyDefine.spacingWidth25 * 8)
        upGenderBtn.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 8, CavyDefine.spacingWidth25 * 8))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 5)
        }
        
        downGenderBtn.setImage(UIImage(asset: .GuideGenderGirlGary), forState: .Normal)
        downGenderBtn.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(CavyDefine.spacingWidth25 * 8, CavyDefine.spacingWidth25 * 8))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(CavyDefine.spacingWidth25 * 15)
        }
        
        upGenderBtn.addTarget(self, action: #selector(GenderView.genderUpClick), forControlEvents: .TouchUpInside)
        downGenderBtn.addTarget(self, action: #selector(GenderView.genderDownClick), forControlEvents: .TouchUpInside)
        
    }
    
    /**
     上面按钮事件
     */
    func genderUpClick() {
        
        MOrG = true
        UserInfoModelView.shareInterface.userInfo!.sex = 0
        updateGender()

    }
    
    /**
     下面按钮的事件
     */
    func genderDownClick() {
        
        MOrG = false
        UserInfoModelView.shareInterface.userInfo!.sex = 1
        updateGender()
        
    }
    
    /**
     更新性别事件
     */
    func updateGender() {
        
        if MOrG{
            
            upGenderBtn.setImage(UIImage(asset: .GuideGenderBoyChosen), forState: .Normal)
            downGenderBtn.setImage(UIImage(asset: .GuideGenderGirlGary), forState: .Normal)
            
        }else {
            
            upGenderBtn.setImage(UIImage(asset: .GuideGenderBoyGary), forState: .Normal)
            downGenderBtn.setImage(UIImage(asset: .GuideGenderGirlChosen), forState: .Normal)

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
