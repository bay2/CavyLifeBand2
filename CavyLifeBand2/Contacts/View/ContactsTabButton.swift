//
//  ContactsTabButton.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ContactsTabButton: UIButton {

    // 按钮类型
    enum ContactsTabButtonType {

        case AddressBook, Recommed, Nearby

    }

    //按钮被选中图片
    let searchBtnImgSelected = [UIImage(asset: .ContactsAddrssBookSelected), UIImage(asset: .ContactsRecommendSelected), UIImage(asset: .ContactsNearbySelected)]

    //按钮默认图片
    let searchBtnImgDefault = [UIImage(asset: .ContactsAddrssBookNormal), UIImage(asset: .ContactsRecommendNormal), UIImage(asset: .ContactsNearbyNormal)]
    
    let searchBtnTitle: Array<String> = [L10n.ContactsSearchPhoneNum.string, L10n.ContactsSearchRecommendNum.string, L10n.ContactsSearchNearbyNum.string]

    //当前按钮类型
    var searchBtnType: ContactsTabButtonType = .AddressBook

    //按钮图片
    private var imgView: UIImageView!

    //按钮标签
    private var nameLabel: UILabel!

    //按钮被选中标签
    private var flagView: UIView!
    
    convenience init(frame: CGRect = CGRectMake(0, 0, 0, 0), searchType: ContactsTabButtonType, name: String = "") {
        
        self.init(frame: frame)
        
        self.searchBtnType = searchType
        
        imgView = UIImageView(image: searchBtnImgDefault[searchBtnType.hashValue])
        self.addSubview(imgView)
        imgView.snp_makeConstraints { make -> Void in
            
            make.top.equalTo(self).offset(18)
            make.size.equalTo(CGSizeMake(40, 40))
            make.centerX.equalTo(self)
            
        }
        
        nameLabel = UILabel()
        self.addSubview(nameLabel)
        nameLabel.textAlignment = .Center
        nameLabel.textColor = UIColor(named: .BColor)
        nameLabel.font = UIFont.mediumSystemFontOfSize(14)
        nameLabel.text = searchBtnTitle[searchBtnType.hashValue]
        nameLabel.snp_makeConstraints { make -> Void in
            
            make.top.equalTo(imgView.snp_bottom).offset(8)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSizeMake(ez.screenWidth / 3, 14))
            
        }
        
        flagView = UIView()
        self.addSubview(flagView)
        flagView.backgroundColor = UIColor(named: .ContactsSearchFlagViewBg)
        flagView.hidden = true
        flagView.snp_makeConstraints { make -> Void in
            
            make.size.equalTo(CGSizeMake(ez.screenWidth / 3, 4))
            make.bottom.equalTo(self)
            make.centerX.equalTo(self)
            
        }
        
    }
    
    /**
    选中的状态
    */
    func selectButtonStatus() {
        
        imgView.image = searchBtnImgSelected[searchBtnType.hashValue]
        nameLabel.textColor = UIColor(named: .AColor)
        flagView.hidden = false
        
    }
    
    /**
     选中的状态
     */
    func deselectButtonStatus() {
        
        imgView.image = searchBtnImgDefault[searchBtnType.hashValue]
        nameLabel.textColor = UIColor(named: .BColor)
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
