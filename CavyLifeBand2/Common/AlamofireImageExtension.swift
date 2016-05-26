//
//  AlamofireImageExtension.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/10.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func af_setCircleImageWithURL(URL: NSURL, placeholderImage: UIImage? = nil) {
        
        self.image = placeholderImage?.af_imageRoundedIntoCircle()
        
        self.af_setImageWithURL(URL) { response in
            
            if response.result.isFailure {
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.image = response.result.value?.af_imageRoundedIntoCircle()
                
            }
            
        }
    }
    
    func af_setCornerRadiusImageWithURL(URL: NSURL, placeholderImage: UIImage? = nil, radius: CGFloat, divideRadiusByImageScale: Bool = false) {
        
        self.image = placeholderImage?.af_imageWithRoundedCornerRadius(radius, divideRadiusByImageScale: divideRadiusByImageScale)
        
        self.af_setImageWithURL(URL) { response in
            
            if response.result.isFailure {
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.image = response.result.value?.af_imageWithRoundedCornerRadius(radius, divideRadiusByImageScale: divideRadiusByImageScale)
                
            }
            
        }
    }
    
}