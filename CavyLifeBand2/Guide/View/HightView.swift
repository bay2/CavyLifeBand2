//
//  HightView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class HightView: UIView {

    var titleLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        heightViewLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func heightViewLayout(){
        
        self.addSubview(titleLab)
        
        
        titleLab.text = L10n.GuideHeight.string
        titleLab.font = UIFont.systemFontOfSize(18)
        titleLab.textColor = UIColor(named: .GuideColorCC)
        titleLab.textAlignment = .Center
        titleLab.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(spacingWidth25 * 23, 18))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(spacingWidth25 * 2)
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
