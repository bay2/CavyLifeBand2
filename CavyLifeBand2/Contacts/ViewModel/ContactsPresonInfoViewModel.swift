//
//  ContactsPresonInfoViewModel.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/9.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

class PresonInfoListCellViewModel: ContactsPersonInfoListCellPresenter, AnyObject {
    
    typealias viewModeType = PresonInfoListCellViewModel
    var title: String
    var info: String
    var onClick: (Void -> Void)?
    
    init(title: String, info: String, onClick: (Void -> Void)? = nil) {
        
        self.title = title
        self.info = info
        self.onClick = onClick
        
    }
    
}

class PresonInfoCellViewModel: ContactsPersonInfoCellPresenter, AnyObject {
    
    typealias viewModeType = PresonInfoCellViewModel
    var title: String
    var subTitle: String
    var avatarUrl: String
    
    init(title: String, subTitle: String, avatarUrl: String) {
        
        self.title = title
        self.subTitle = subTitle
        self.avatarUrl = avatarUrl
        
    }
    
}