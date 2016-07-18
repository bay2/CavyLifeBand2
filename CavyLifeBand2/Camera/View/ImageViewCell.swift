//
//  ImageViewCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary
import EZSwiftExtensions

class ImageViewCell: UICollectionViewCell {

    var imgView = UIImageView()
    
    func configImage(asset: PHAsset) {
        
        self.backgroundColor = UIColor.blackColor()

        self.addSubview(imgView)
        imgView.backgroundColor = UIColor.blackColor()
        imgView.snp_makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: ez.screenWidth, height: ez.screenHeight - headerHeight - bottomHeight))
        }
        imgView.contentMode = .ScaleAspectFit
        

        // PHImageRequestOptions 设置照片质量
        let imgRequestOptions = PHImageRequestOptions()
        imgRequestOptions.deliveryMode = .HighQualityFormat
        
        
        // 获取照片
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(ez.screenWidth, ez.screenHeight), contentMode: .AspectFill, options: imgRequestOptions) { (result, info) -> Void in
            
            self.imgView.image = result ?? UIImage()
            
        }

    }
        
}
