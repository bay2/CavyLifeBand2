//
//  ContactsPresonInfoViewModel.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/9.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RandomKit
import JSONJoy
import RealmSwift

class PresonInfoListCellViewModel: ContactsPersonInfoListCellPresenter, AnyObject {
    
    var title: String
    var info: String
    var onClick: (Void -> Void)?
    
    init(title: String, info: String, onClick: (Void -> Void)? = nil) {
        
        self.title = title
        self.info = info
        self.onClick = onClick
        
    }
    
}

class PresonInfoCellViewModel: NSObject, ContactsPersonInfoCellPresenter, ContactsPersonInfoCellDelegate  {
    
    var title: String
    var subTitle: String
    var avatarUrl: String
    var realm: Realm = try! Realm()
    var relation: PersonRelation {
        return .OwnRelation
    }
    
    init(title: String, subTitle: String, avatarUrl: String) {
        
        self.title = title
        self.subTitle = subTitle
        self.avatarUrl = avatarUrl
        
    }
    
    func onClickHeadView() {
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        
        let actionPhoto = UIAlertAction(title: L10n.AccountInofPhoto.string, style: .Default) { [unowned self]  _ in
            
            self.openImagePicker(.PhotoLibrary)
        }
        
        let actionCamera = UIAlertAction(title: L10n.AccountInofCamera.string, style: .Default) { _ in
            self.openImagePicker(.Camera)
        }
        
        let actionCancel = UIAlertAction(title: L10n.CameraBack.string, style: .Cancel) { _ in
            
        }
        
        actionSheet.addAction(actionPhoto)
        actionSheet.addAction(actionCamera)
        actionSheet.addAction(actionCancel)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentVC(actionSheet)
        
        
//        actionSheet.addAction(UIAlertAction)
        
    }
    
    func openImagePicker(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentVC(imagePicker)
        
    }
    
}

extension PresonInfoCellViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserInfoRealmOperateDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else {
            return
        }
        
        if !mediaType.contains("public.image") {
            return
        }
        
        guard var newImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            return
        }
        
        newImage = newImage.af_imageScaledToSize(CGSize(width: 128, height: 128))
        
        guard let imageData = UIImagePNGRepresentation(newImage) else {
            return
        }
        
        let urls = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        
        var savePath = urls[0]
        
        var imageName = String.random(30, "a"..."z")
        imageName = imageName.stringByAppendingString(".png")
        
        savePath = savePath + "/" + imageName
        
        imageData.writeToFile(savePath, atomically: false)
        
        
        let activityView = UIActivityIndicatorView()
        activityView.centerX = picker.view.centerX
        activityView.centerY = picker.view.centerY
        
        picker.view.addSubview(activityView)
        
        activityView.startAnimating()
        
        let loginUserId = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
        
        UserNetRequestData.shareApi.uploadPicture(loginUserId, filePath: "file://" + savePath) {
            
            guard $0.isSuccess else {
                picker.dismissVC(completion: nil)
                return
            }
            
            let reslutMsg = try! UplodPictureMsg(JSONDecoder($0.value ?? ""))
            
            guard reslutMsg.commonMsg.code == WebApiCode.Success.rawValue else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(webApiErrorCode: reslutMsg.commonMsg.code)
                picker.dismissVC(completion: nil)
                return
            }
            
            self.updateUserInfo(loginUserId) { userInfo -> UserInfoModel in
                
                userInfo.avatarUrl = reslutMsg.iconUrl
                return userInfo
                
            }
            
            picker.dismissVC(completion: nil)
            
            
        }
        
    }
    
}
