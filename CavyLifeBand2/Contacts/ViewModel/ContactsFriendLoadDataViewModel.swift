//
//  ContactsFriendLoadDataViewModel.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/12.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import EZSwiftExtensions

class ContactsRecommendFriendData: ContactsAddFriendDataSync {
    
    typealias ItemType = ContactsAddFriendCellViewModel
    
    var items: [ItemType] = []
    var viewController: UIViewController
    var tableView: UITableView
    
    init(viewController: UIViewController, tableView: UITableView) {
        
        self.viewController = viewController
        self.tableView = tableView
        
    }
    
    func loadData() {
        
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

class ContactsAddressBookFriendData: AddressBookDataSource, ContactsAddFriendDataSync {
    
    typealias ItemType = ContactsAddressBookViewModel
    
    var items: [ItemType] = []
    var phoneNumInfos: [String: String] = [:]
    var viewController: UIViewController
    var tableView: UITableView
    
    init(viewController: UIViewController, tableView: UITableView) {
        
        self.viewController = viewController
        self.tableView = tableView
        
    }
    
    func loadData() {
        
        var phoneNumList = [String]()
        
        // 获取通信电话信息
        getAddresBookPhoneInfo { (firstName, lastName, phoneNum) in
            
            self.phoneNumInfos += [phoneNum: "\(firstName)\(lastName)"]
            phoneNumList.append(phoneNum)
            
        }
        
        // 2s 后进行网络请求
        NSTimer.runThisAfterDelay(seconds: 2, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
            
            do {
                
                try ContactsWebApi.shareApi.searchFriendByAddressBook(phoneNumList) {
                    
                    // 请求失败直接返回
                    guard $0.isSuccess else {
                        CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: $0.error)
                        return
                    }
                    
                    // 解析网络数据
                    let result = try! ContactsSearchFriendMsg(JSONDecoder($0.value!))
                    
                    guard result.commonMsg?.code == WebApiCode.Success.rawValue else {
                        CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, webApiErrorCode: result.commonMsg?.code ?? "")
                        return
                    }
                    
                    guard let friendInfos = result.friendInfos else {
                        return
                    }
                    
                    //筛选好友信息
                    for firendInfo in friendInfos {
                        
                        let firendId = firendInfo.userId ?? ""
                        let nickName = firendInfo.nickName ?? ""
                        let name = self.phoneNumInfos[firendInfo.phoneNum ?? ""] ?? ""
                        let headImageUrl = firendInfo.avatarUrl ?? ""
                        
                        self.items.append(ContactsAddressBookViewModel(viewController: self.viewController, firendId: firendId, name: nickName, introudce: name, headImageUrl: headImageUrl))
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
            } catch let error {
                
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self.viewController, userErrorCode: error as? UserRequestErrorType)
                
            }
            
        }
        
    }
    
}