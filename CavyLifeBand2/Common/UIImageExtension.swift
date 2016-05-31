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

    /**
     将图片存到沙盒的Cache文件
     
     - parameter imageName: 图片名称
     
     - returns: 文件路径（失败则为空）
     */
    func writeToChacheDocument(imageName: String) -> String {
        
        guard let imageData = UIImagePNGRepresentation(self) else {
            Log.error("image data get fail")
            return ""
        }
        
        let urls = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        
        var savePath = urls[0]
        
        let imageFullName = imageName.stringByAppendingString(".png")
        
        savePath = savePath + "/" + imageFullName
        
        guard imageData.writeToFile(savePath, atomically: false) == true else {
            Log.error("save image fail")
            return ""
        }
        
        return savePath
    }
    
}