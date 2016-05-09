//
//  ContactsPresonInfoViewModel.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/9.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

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

class PresonInfoCellViewModel: ContactsPersonInfoCellPresenter, ContactsPersonInfoCellDelegate, AnyObject {
    
    var title: String
    var subTitle: String
    var avatarUrl: String
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
        
        let actionPhoto = UIAlertAction(title: L10n.AccountInofPhoto.string, style: .Default) {  _ in
        }
        
        let actionCamera = UIAlertAction(title: L10n.AccountInofCamera.string, style: .Default) { _ in
        }
        
        let actionCancel = UIAlertAction(title: L10n.CameraBack.string, style: .Cancel) { _ in
            
        }
        
        actionSheet.addAction(actionPhoto)
        actionSheet.addAction(actionCamera)
        actionSheet.addAction(actionCancel)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentVC(actionSheet)
        
        
//        actionSheet.addAction(UIAlertAction)
        
    }
    
}