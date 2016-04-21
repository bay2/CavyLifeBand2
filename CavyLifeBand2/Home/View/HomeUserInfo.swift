//
//  HomeUserInfo.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class HomeUserInfo: UIView, MenuPushViewDelegate{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var nextView: UIViewController { return StoryboardScene.AccountInfo.instantiateContactsAccountInfoVC() }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configuration(delegate: HomeUserDelegate) {

        delegate.iconImage.roundSquareImage()
        delegate.userName.textColor = UIColor(named: .HomeViewUserName)
        delegate.account.textColor = UIColor(named: .HomeViewAccount)

        let font = UIFont.systemFontOfSize(18)
        font.fontWithSize(0.23)
        delegate.userName.font = font
        delegate.account.font = UIFont.systemFontOfSize(14)

    }


}

protocol HomeUserDelegate {

    var iconImage: UIImageView { get }
    var userName: UILabel { get }
    var account: UILabel { get }

}
