//
//  UserProtocolVIew.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import SnapKit

class UserProtocolView: UIView {

    var desText: UILabel = UILabel()

    var protocolBtn: UIButton = UIButton()

    var checkboxBtn: CheckboxButton = CheckboxButton()

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {

        desText.text = L10n.SignUpProcotolViewTitle.string
        desText.textColor = UIColor(named: .AColor)
        desText.font = UIFont.systemFontOfSize(14)

        protocolBtn.setTitle(L10n.SignUpProcotolViewBtn.string, forState: .Normal)
        protocolBtn.setTitleColor(UIColor(named: .CColor), forState: .Normal)
        protocolBtn.titleLabel!.font = UIFont.systemFontOfSize(14)

        
        defineViewLayout()
      

    }

    /**
     视图布局
     */
    func defineViewLayout() {

        self.addSubview(desText)
        self.addSubview(protocolBtn)
        self.addSubview(checkboxBtn)
        
        checkboxBtn.frame.size = CGSizeMake(15, 15)

        checkboxBtn.snp_makeConstraints { make -> Void in
            make.left.equalTo(self)
            make.centerY.equalTo(self)
        }

        desText.snp_makeConstraints { make -> Void in
            make.left.equalTo(checkboxBtn.snp_right).offset(10)
            make.centerY.equalTo(self)
        }

        protocolBtn.snp_makeConstraints { make -> Void in

            make.left.equalTo(desText.snp_right)
            make.centerY.equalTo(self)

        }

    }

}
