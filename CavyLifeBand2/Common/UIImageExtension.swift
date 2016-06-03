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
   
    /**
     返回正常方向的图片
     
     - returns: Normal Image
     */
    func imageRotateNormal() -> UIImage {
        
        if self.imageOrientation == .Up {
            return self
        }
        
        var transform = CGAffineTransformIdentity

        // 计算新的图片的大小
        switch self.imageOrientation {
        case .Down, .DownMirrored:
            
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            
        case .Left, .LeftMirrored:
            
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            
        case .Right, .RightMirrored:
            
            transform = CGAffineTransformTranslate(transform, 0, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))

        default:
            break
        }
        
        // 是否左/右/向下旋转 是镜像翻转
        switch self.imageOrientation {

        case .UpMirrored, .DownMirrored:
            
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            
        case .LeftMirrored, .RightMirrored:
            
            transform = CGAffineTransformTranslate(transform, self.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)

        default:
            break
        }
        
        let ctx = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
                                        CGImageGetBitsPerComponent(self.CGImage), 0,
                                        CGImageGetColorSpace(self.CGImage),
                                        CGImageGetBitmapInfo(self.CGImage).rawValue)
        CGContextConcatCTM(ctx, transform)
        
        // 绘制底层的CGImage
        switch self.imageOrientation {
        case .Left, .LeftMirrored, .Right, .RightMirrored:

            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage)
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage)
            
        }
        
        // 创建新的UIimage 放置新的CGImage
        let cgimg = CGBitmapContextCreateImage(ctx)
        let newImg: UIImage = UIImage(CGImage: cgimg!)

        return newImg
        
        
    }
    
}