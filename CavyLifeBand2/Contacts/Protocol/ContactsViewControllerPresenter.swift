//
//  ContactsViewControllerPresenter.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/18.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation

protocol ContactsReqFriendViewControllerDataSource {
    
    var placeholderText: String { get }
    var textFieldTitle: String { get }
    
    var bottonTitle: String { get }
    
}

protocol ContactsReqFriendViewControllerDelegate {
    
    var verifyMsg: String { set get }
    func onClickButton()
    
}
