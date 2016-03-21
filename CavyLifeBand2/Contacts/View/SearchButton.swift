//
//  SearchButton.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class SearchButton: UIView {

    var imgView = UIImageView()
    var nameLabel = UILabel()
    var flagView = UIView()
    var button = UIButton()
    
    func searchTableViewInit(frame: CGRect, image: UIImage, name: String){
        
        self.frame = frame
        self.imgView.image = image
        self.nameLabel.text = name
        
        self.size = CGSizeMake(ez.screenWidth / 3, 100)
        
        self.addSubview(imgView)
        self.addSubview(nameLabel)
        self.addSubview(flagView)
        self.addSubview(button)
        
        imgView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(15)
            make.size.equalTo(CGSizeMake(40, 40))
            make.centerX.equalTo(self)
        }
        imgView.userInteractionEnabled = true
        nameLabel.textAlignment = .Center
        nameLabel.textColor = UIColor(named: .ContactsFindFriendLight)
        nameLabel.font = UIFont.systemFontOfSize(14)
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(imgView).offset(48)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSizeMake(ez.screenWidth / 3, 14))
        }
        flagView.backgroundColor = UIColor(named: .ContactsSearchFlagViewBg)
        flagView.hidden = true
        flagView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(ez.screenWidth / 3, 4))
            make.bottom.equalTo(self)
            make.centerX.equalTo(self)
        }
        button.backgroundColor = UIColor.clearColor()
        button.snp_makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(self)
        }
       
    }
    
    // 选中的状态
    func selectButtonStatus(image: UIImage){
        
        imgView.image = image
        nameLabel.textColor = UIColor(named: .ContactsFindFriendDark)
        flagView.hidden = false
        
    }
    
    // 没有选中的状态
    func cancelSelectButtonStatus(image: UIImage) {
        
        imgView.image = image
        nameLabel.textColor = UIColor(named: .ContactsFindFriendLight)
        flagView.hidden = true
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
