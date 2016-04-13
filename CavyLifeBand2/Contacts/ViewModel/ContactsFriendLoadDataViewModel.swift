//
//  ContactsFriendLoadDataViewModel.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy

struct ContactsRecommendFriendData {
    
    var items: [ContactsAddFriendCellViewModel] = []
    var viewController: UIViewController
    var tableView: UITableView
    
    init(viewController: UIViewController, tableView: UITableView) {
        
        self.viewController = viewController
        self.tableView = tableView
        
    }
    
    mutating func loadData() {
        
        do {
            
            try ContactsWebApi.shareApi.getRecommendFriend { (result) in
                
                guard result.isSuccess else {
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: result.error)
                    return
                }
                
                let resultMsg = try! ContactsSearchFriendMsg(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: resultMsg.commonMsg?.code ?? "")
                    return
                }
                
                for friendInfo in resultMsg.friendInfos! {
                    
                    let friendCellViewModel = ContactsAddFriendCellViewModel(viewController: self.viewController, firendId: friendInfo.userId!, name: friendInfo.nickName!, headImageUrl: friendInfo.avatarUrl!)
                    
                    self.items.append(friendCellViewModel)
                }
                
                self.tableView.reloadData()
                
            }
            
        } catch let error {
            CavyLifeBandAlertView.sharedIntance.showViewTitle(viewController, userErrorCode: error as? UserRequestErrorType)
        }
        
    }
    
}