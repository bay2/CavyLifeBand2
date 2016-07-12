//
//  ShareCollectionCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ShareCollectionCell: UICollectionViewCell {

    var imgView = UIImageView()
    
    func config(dataSource: ShareViewDataSource) {
        imgView.image = dataSource.shareImage
    }

    override init(frame: CGRect) {
       super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        imgView.backgroundColor = UIColor.whiteColor()
        self.addSubview(imgView)
        imgView.snp_makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        imgView.roundSquareImage()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
