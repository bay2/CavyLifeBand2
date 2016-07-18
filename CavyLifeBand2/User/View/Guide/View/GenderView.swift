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
    
    var genderBtnSize: CGSize {
        
        return CGSizeMake(130, 130)
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        MOrG = true // 默认True 是男的
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
        titleLab.font = UIFont.mediumSystemFontOfSize(18)
        titleLab.textColor = UIColor(named: .EColor)
        titleLab.textAlignment = .Center
        titleLab.snp_makeConstraints { make -> Void in
            make.top.equalTo(self)
            make.bottom.equalTo(upGenderBtn.snp_top)
            make.centerX.equalTo(self)
        }
        
        upGenderBtn.setImage(UIImage(asset: .GuideGenderBoyChosen), forState: .Normal)
        upGenderBtn.setImage(UIImage(asset: .GuideGenderBoyChosen), forState: .Highlighted)
        upGenderBtn.snp_makeConstraints { make -> Void in
            make.size.equalTo(genderBtnSize)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp_centerY).offset(-15)
        }
        
        downGenderBtn.setImage(UIImage(asset: .GuideGenderGirlGary), forState: .Normal)
        downGenderBtn.setImage(UIImage(asset: .GuideGenderGirlChosen), forState: .Highlighted)
        downGenderBtn.snp_makeConstraints { make -> Void in
            make.size.equalTo(genderBtnSize)
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp_centerY).offset(15)
        }
        
        upGenderBtn.addTarget(self, action: #selector(GenderView.genderUpClick), forControlEvents: .TouchUpInside)
        downGenderBtn.addTarget(self, action: #selector(GenderView.genderDownClick), forControlEvents: .TouchUpInside)
        
    }
    
    /**
     上面按钮事件
     */
    func genderUpClick() {
        
        MOrG = true
        updateGender()

    }
    
    /**
     下面按钮的事件
     */
    func genderDownClick() {
        
        MOrG = false
        updateGender()
        
    }
    
    /**
     更新性别事件
     */
    func updateGender() {
        
        if MOrG{
            
            upGenderBtn.setImage(UIImage(asset: .GuideGenderBoyChosen), forState: .Normal)
            downGenderBtn.setImage(UIImage(asset: .GuideGenderGirlGary), forState: .Normal)
            
        } else {
            
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
