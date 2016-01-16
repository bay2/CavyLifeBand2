//
//  ImageForScrollView.swift
//  CavyLifeBand2
//
//  Created by 李艳楠 on 16/1/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class ImageForScrollView: UIImageView {
    let kWidth :CGFloat = UIScreen.mainScreen().bounds.width
    let kHeight :CGFloat = UIScreen.mainScreen().bounds.height - 64 - 69
    
    func changeImageSize(receivedImage : UIImage ) -> UIImageView {
        
        let imageV = UIImageView()
        
        if (receivedImage.size.width < kWidth) && (receivedImage.size.height < kHeight){
            
            imageV.frame = CGRectMake(0, 0, receivedImage.size.width, receivedImage.size.height)

        }else if receivedImage.size.width > receivedImage.size.height {
            
            let scale = receivedImage.size.width / receivedImage.size.height
            
            let newHeight = kWidth / scale
            
            imageV.frame = CGRectMake(0, 0, kWidth, newHeight)
            
        }else{
    
            let scale = receivedImage.size.width / receivedImage.size.height
            
            let newWidth = kHeight / scale
            
            imageV.frame = CGRectMake(0, 0, newWidth, kHeight)

        }
     //    imageV.image = receivedImage
        return imageV

        
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
