//
//  ChartsSubTimeBucketCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/6/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit
import EZSwiftExtensions

class ChartsSubTimeBucketCell: UICollectionViewCell {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(70, 30))
            make.center.equalTo(self)
        }
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(14)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectStatus() {
        
         label.font = UIFont(name: "Helvetica-Bold", size: 14)
    }
    
    func unSlectStatus() {
        
        label.font = UIFont.systemFontOfSize(14)
    }
    
}
