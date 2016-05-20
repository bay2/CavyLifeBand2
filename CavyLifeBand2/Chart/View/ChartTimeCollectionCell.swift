//
//  ChartTimeCollectionCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class ChartTimeCollectionCell: UICollectionViewCell {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
        label.snp_makeConstraints {(make) in
            make.size.equalTo(CGSizeMake(70, 30))
            make.center.equalTo(self)
        }
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Center

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     选中状态
     */
    func selectStatus() {
        
        label.textColor = UIColor.whiteColor()

    }
    
    /**
     未选中状态
     */
    func deselectStatus() {
        
        label.textColor = UIColor(named: .ChartDeselectText)

    }
    
}
