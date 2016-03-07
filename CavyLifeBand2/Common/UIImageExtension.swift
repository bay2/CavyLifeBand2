//
// Created by xuemincai on 16/2/27.
// Copyright (c) 2016 xuemincai. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    /**
     通过色值创建纯色的图片
     
     - parameter color: 颜色
     - parameter size:  大小
     
     - returns: 图片
     */
    static func  imageWithColor(color: UIColor, size: CGSize) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        color.set()
        UIRectFill(CGRectMake(0, 0, size.width, size.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return  newImg
    }

}