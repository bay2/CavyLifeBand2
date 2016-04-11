//
//  PictureView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Gifu
import EZSwiftExtensions

class PictureView: UIView {

    var titleLab = UILabel()
    var titleInfo = UILabel()
    var middleImgView: AnimatableImageView?
    var bottomLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(title: String = "", titleInfo: String = "", bottomInfo: String = "", midImage: AnimatableImageView, frame: CGRect = CGRectMake(0, 0, ez.screenWidth * 0.92, ez.screenWidth * 1.12)) {
        
        self.init(frame: frame)
        
        self.titleLab.text = title
        self.titleInfo.text = titleInfo
        self.bottomLab.text = bottomInfo
        
        self.middleImgView = midImage
        
        pictureViewLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pictureViewLayout(){
        
        self.addSubview(titleLab)
        self.addSubview(titleInfo)
        self.addSubview(middleImgView!)
        self.addSubview(bottomLab)
        
        titleLab.font = UIFont.systemFontOfSize(18)
        titleLab.textColor = UIColor(named: .GuideColorCC)
        titleLab.textAlignment = .Center
        titleLab.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(ez.screenWidth * 0.6, 18))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(ez.screenWidth * 0.1 - 9)
        }
        titleInfo.font = UIFont.systemFontOfSize(12)
        titleInfo.textColor = UIColor(named: .GuideColor99)
        titleInfo.textAlignment = .Center
        titleInfo.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(ez.screenWidth * 0.6, 12))
            make.centerX.equalTo(self)
            make.top.equalTo(titleLab).offset(ez.screenWidth * 0.04 + 12)
        }

        middleImgView!.backgroundColor = UIColor.whiteColor()
        middleImgView!.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(ez.screenWidth * 0.72, ez.screenWidth * 0.72))
            make.center.equalTo(self)
        }
        
        bottomLab.font = UIFont.systemFontOfSize(12)
        bottomLab.textColor = UIColor(named: .GuideColor66)
        bottomLab.textAlignment = .Center
        bottomLab.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(ez.screenWidth * 0.6, 12))
            make.centerX.equalTo(self)
            make.top.equalTo(middleImgView!).offset(ez.screenWidth * 0.76)
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
