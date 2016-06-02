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
    var middleImgView: UIImageView = UIImageView()
    var bottomLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String = "", titleInfo: String = "", bottomInfo: String = "", midImage: UIImageView, frame: CGRect = CGRectMake(0, 0, ez.screenWidth - horizontalInset * 2, ez.screenHeight - navHeight - upInset - bottomInset)) {
        
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
        self.addSubview(middleImgView)
        self.addSubview(bottomLab)
        
        titleLab.font = UIFont.mediumSystemFontOfSize(18)
        titleLab.textColor = UIColor(named: .EColor)
        titleLab.textAlignment = .Center
        titleLab.snp_makeConstraints { make -> Void in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.titleInfo.snp_top).offset(-10)
        }
        
        titleInfo.font = UIFont.systemFontOfSize(14)
        titleInfo.textColor = UIColor(named: .FColor)
        titleInfo.textAlignment = .Center
        titleInfo.snp_makeConstraints { make -> Void in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.middleImgView.snp_top)
        }

        middleImgView.backgroundColor = UIColor.whiteColor()
        middleImgView.snp_makeConstraints { make -> Void in
            make.height.equalTo(middleImgView.snp_width)
            make.left.equalTo(self.snp_left).offset(20)
            make.right.equalTo(self.snp_right).offset(-20)
            make.center.equalTo(self)
        }
        
        bottomLab.font = UIFont.mediumSystemFontOfSize(14)
        bottomLab.textColor = UIColor(named: .GColor)
        bottomLab.textAlignment = .Center
        bottomLab.snp_makeConstraints { make -> Void in
            make.top.equalTo(middleImgView.snp_bottom)
            make.bottom.equalTo(self).offset(-40)
            make.centerX.equalTo(self)
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
