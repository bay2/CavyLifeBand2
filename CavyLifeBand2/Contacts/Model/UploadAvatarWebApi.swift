//
//  UploadAvatarWebApi.swift
//  CavyLifeBand2
//
//  Created by JL on 16/7/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import UIKit
import JSONJoy
import EZSwiftExtensions

class UploadAvatarWebApi: NetRequest {
    
    static var shareApi = UploadAvatarWebApi()
    
    func uploadAvatar(savePath: String, successHandler: (UploadAvatarJSON -> Void)? = nil, failHandler: (CommenResponse -> Void)? = nil) {
        
        // 从沙盒取出图片
        
        guard let savedImage = UIImage.init(contentsOfFile: savePath) else {
            
            let commonMsg = try! CommenResponse(JSONDecoder(["msg": RequestApiCode.ImageParseFail.description, "code": RequestApiCode.ImageParseFail.rawValue, "time": NSDate().timeIntervalSince1970]))
            
            failHandler?(commonMsg)
            
            return
        }
        
        let imageData = UIImageJPEGRepresentation(savedImage, 1.0)
        
        guard let imageBase64: String = imageData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength) else {
            
            let commonMsg = try! CommenResponse(JSONDecoder(["msg": RequestApiCode.ImageParseFail.description, "code": RequestApiCode.ImageParseFail.rawValue, "time": NSDate().timeIntervalSince1970]))
            
            failHandler?(commonMsg)
            
            return
        }
        
        let para = [NetRequestKey.Base64Data.rawValue: imageBase64]
        
        netPostRequest(WebApiMethod.UploadAvatar.description, para: para, modelObject: UploadAvatarJSON.self, successHandler: {
            successHandler?($0)
        }) { (msg) in
            failHandler?(msg)
        }
    
    }

}
