//
// Created by xuemincai on 16/2/27.
// Copyright (c) 2016 xuemincai. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    static func  imageWithColor(color: UIColor, size: CGSize) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        color.set()
        UIRectFill(CGRectMake(0, 0, size.width,size.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return  newImg
    }

}