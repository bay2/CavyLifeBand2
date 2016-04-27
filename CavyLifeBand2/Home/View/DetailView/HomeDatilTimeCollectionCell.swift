//
//  HomeDatilTimeCollectionCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class HomeDatilTimeCollectionCell: UICollectionViewCell {
    
    
    var button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: .HomeDetailBackground)
        self.addSubview(button)
        button.snp_makeConstraints {(make) in
            make.size.equalTo(CGSizeMake(70, 30))
            make.center.equalTo(self)
        }
        deselectStatus()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func selectStatus() {
        
        button.backgroundColor = UIColor(named: .HomeViewMainColor)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)

    }
    
    func deselectStatus() {
        
        button.backgroundColor = UIColor(named: .HomeDetailBackground)
        button.setTitleColor(UIColor(named: .HomeDetailDeselectText), forState: .Normal)

    }
    
}
