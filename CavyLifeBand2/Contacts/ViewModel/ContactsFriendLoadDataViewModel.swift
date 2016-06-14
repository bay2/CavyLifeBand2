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
import Alamofire

extension ContactsAddFriendCellViewModel {
    
    init(viewController: UIViewController, friendInfo: ContactsSearchFriendInfo) {
        
        self.init(viewController: viewController, friendId: friendInfo.userId ?? "", name: friendInfo.nickName ?? "", headImageUrl: friendInfo.avatarUrl ?? "")
        
    }
    
}

extension ContactsRecommendCellViewModel {
    
     init(viewController: UIViewController, rowIndex: Int, friendInfo: ContactsSearchFriendInfo) {
        
        self.init(viewController: viewController, rowIndex: rowIndex, friendId: friendInfo.userId, name: friendInfo.nickName, headImageUrl: friendInfo.avatarUrl)
        
    }
    
}

extension ContactsNearbyCellViewModel {
    
    init(viewController: UIViewController, friendInfo: ContactsSearchFriendInfo) {
        
        self.init(viewController: viewController, friendId: friendInfo.userId ?? "", name: friendInfo.nickName ?? "", headImageUrl: friendInfo.avatarUrl ?? "", introudce: friendInfo.distance ?? "")
        
    }
    
}

extension ContactsNewFriendCellViewModel {
    
    init(viewController: UIViewController, friendInfo: ContactsFriendReqInfo) {
        
        self.init(viewController: viewController, friendId: friendInfo.userId ?? "", name: friendInfo.nickName ?? "", headImageUrl: friendInfo.avatarUrl ?? "", introudce: friendInfo.verifyMsg ?? "")
        
    }
    
}

/// 推荐好友数据源
class ContactsRecommendFriendData: ContactsAddFriendDataSync {
    
    typealias ItemType = ContactsRecommendCellViewModel
    
    var items: [ItemType] = []
    weak var viewController: UIViewController?
    weak var tableView: UITableView?
    
    init(viewController: UIViewController, tableView: UITableView) {
        
        self.viewController = viewController
        self.tableView = tableView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContactsRecommendFriendData.deleteItem), name: NotificationName.ContactsFirendReqDeleteItem.rawValue, object: nil)
        
    }
    
    @objc func deleteItem(userInfo: NSNotification) {
        
        guard let userInfoRow = userInfo.userInfo else {
            return
        }
        
        guard let rowIndex = userInfoRow["rowIndex"] as? Int else {
            return
        }
        
        items.removeAtIndex(rowIndex)
        
        var index = 0
        
        items = items.map { item -> ItemType in
            
            var newItem = item
            newItem.rowIndex = index
            index += 1
            return newItem
        }

    }
    
    /**
     加载推荐好友数据
     */
    func loadData() {
        
        do {
            
            try ContactsWebApi.shareApi.getRecommendFriend { (result) in
                
                guard result.isSuccess else {
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(userErrorCode: result.error)
                    return
                }
                
                let resultMsg = try! ContactsSearchFriendMsg(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(webApiErrorCode: resultMsg.commonMsg?.code ?? "")
                    return
                }
                
                for friendInfo in resultMsg.friendInfos! {
                    
                    let friendCellViewModel = ContactsRecommendCellViewModel(viewController: self.viewController!, rowIndex: self.items.count, friendInfo: friendInfo)
                    
                    self.items.append(friendCellViewModel)
                }
                
                self.tableView!.reloadData()
                
            }
            
        } catch let error {
            CavyLifeBandAlertView.sharedIntance.showViewTitle(userErrorCode: error as? UserRequestErrorType ?? UserRequestErrorType.UnknownError)
        }
        
    }
    
}

/// 通讯录好友数据源
class ContactsAddressBookFriendData: AddressBookDataSource, ContactsAddFriendDataSync {
    
    typealias ItemType = ContactsAddressBookViewModel
    
    var items: [ItemType] = []
    var phoneNumInfos: [String: String] = [:]
    weak var viewController: UIViewController?
    weak var tableView: UITableView?
    
    init(viewController: UIViewController, tableView: UITableView) {
        
        self.viewController = viewController
        self.tableView = tableView
    }
    
    /**
     请求通讯录好友数据
     */
    func loadData() {
        
        var phoneNumList = [String]()
        
        // 获取通信电话信息
        getAddresBookPhoneInfo { (firstName, lastName, phoneNum) in
            
            self.phoneNumInfos += [phoneNum: "\(firstName)\(lastName)"]
            phoneNumList.append(phoneNum)
            
        }
        
        // 1s 后进行网络请求
        NSTimer.runThisAfterDelay(seconds: 1, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
            
            do {
                
                try ContactsWebApi.shareApi.searchFriendByAddressBook(phoneNumList) {
                    
                    // 请求失败直接返回
                    guard $0.isSuccess else {
                        CavyLifeBandAlertView.sharedIntance.showViewTitle(userErrorCode: $0.error)
                        return
                    }
                    
                    // 解析网络数据
                    let result = try! ContactsSearchFriendMsg(JSONDecoder($0.value!))
                    
                    guard result.commonMsg?.code == WebApiCode.Success.rawValue else {
                        CavyLifeBandAlertView.sharedIntance.showViewTitle(webApiErrorCode: result.commonMsg?.code ?? "")
                        return
                    }
                    
                    guard let friendInfos = result.friendInfos else {
                        return
                    }
                    
                    //筛选好友信息
                    for firendInfo in friendInfos {
                        
                        let friendId = firendInfo.userId ?? ""
                        let nickName = firendInfo.nickName ?? ""
                        let name = self.phoneNumInfos[firendInfo.phoneNum] ?? ""
                        let headImageUrl = firendInfo.avatarUrl ?? ""
                        
                        self.items.append(ContactsAddressBookViewModel(viewController: self.viewController!, friendId: friendId, name: nickName, introudce: name, headImageUrl: headImageUrl))
                        
                    }
                    
                    self.tableView!.reloadData()
                    
                }
                
            } catch let error {
                
                CavyLifeBandAlertView.sharedIntance.showViewTitle(userErrorCode: error as? UserRequestErrorType)
                
            }
            
        }
        
    }
    
}



/// 搜索好友数据
class ContactsSearchFriendData: ContactsAddFriendDataSync {
    
    typealias ItemType = ContactsAddFriendCellViewModel
    var items: [ItemType] = []
    var searchText: String = ""
    weak var viewController: UIViewController?
    weak var tableView: UITableView?
    
    init(viewController: UIViewController, tableView: UITableView) {
        
        self.viewController = viewController
        self.tableView = tableView
        
    }
    
    /**
     加载搜索好友数据
     */
    func loadData() {
        
        if searchText.isEmpty {
            return
        }
        
        let searchDataParse: (Result<AnyObject, UserRequestErrorType> -> Void) = { reslut in
            
            guard reslut.isSuccess else {
                return
            }
            
            let reslutMsg = try! ContactsSearchFriendMsg(JSONDecoder(reslut.value!))
            
            guard reslutMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(webApiErrorCode: reslutMsg.commonMsg!.code)
                return
            }
            
            guard let friendInfos = reslutMsg.friendInfos else {
                return
            }
            
            for friendInfo in friendInfos {
                self.items.append(ContactsAddFriendCellViewModel(viewController: self.viewController!, friendInfo: friendInfo))
            }
            
            self.tableView!.reloadData()
            
        }
        
        do {
            try ContactsWebApi.shareApi.searchFriendByUserName(searchText, callBack: searchDataParse)
        } catch let error {
            CavyLifeBandAlertView.sharedIntance.showViewTitle(userErrorCode: error as? UserRequestErrorType ?? UserRequestErrorType.UnknownError)
        }
        
    }
    
}

/// 附近好友数据请求
class ContactsNearbyFriendData: ContactsAddFriendDataSync {
    
    typealias ItemType = ContactsNearbyCellViewModel
    var items: [ItemType] = []
    weak var viewController: UIViewController?
    weak var tableView: UITableView?
    
    init(viewController: UIViewController, tableView: UITableView) {
        
        self.viewController = viewController
        self.tableView = tableView
        
    }
    
    func loadData() {
        
        guard let coordinate = SCLocationManager.shareInterface.coordinate else {
            return
        }
        
        let searchDataParse: (Result<AnyObject, UserRequestErrorType> -> Void) = { reslut in
            
            guard reslut.isSuccess else {
                return
            }
            
            let reslutMsg = try! ContactsSearchFriendMsg(JSONDecoder(reslut.value!))
            
            guard reslutMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(webApiErrorCode: reslutMsg.commonMsg!.code)
                return
            }
            
            guard let friendInfos = reslutMsg.friendInfos else {
                return
            }
            
            for friendInfo in friendInfos {
                self.items.append(ContactsNearbyCellViewModel(viewController: self.viewController!, friendInfo: friendInfo))
            }

            self.tableView!.reloadData()
            
        }
        
        do {
            try ContactsWebApi.shareApi.getNearbyFriend("\(coordinate.longitude)", latitude: "\(coordinate.latitude)", callBack: searchDataParse)
        } catch let error {
            CavyLifeBandAlertView.sharedIntance.showViewTitle(userErrorCode: error as? UserRequestErrorType ?? UserRequestErrorType.UnknownError)
        }
        
    }
    
}

/// 新的好友数据源
class ContactsNewFriendData: ContactsAddFriendDataSync {
    
    typealias ItemType = ContactsNewFriendCellViewModel
    
    var items: [ItemType] = []
    
    weak var viewController: UIViewController?
    weak var tableView: UITableView?
    
    init(viewController: UIViewController, tableView: UITableView) {
        
        self.viewController = viewController
        self.tableView = tableView
        
    }
    
    func loadData() {
        
        let searchDataParse: (Result<AnyObject, UserRequestErrorType> -> Void) = { reslut in
            
            guard reslut.isSuccess else {
                return
            }
            
            let reslutMsg = try! ContactsFriendReqMsg(JSONDecoder(reslut.value!))
            
            guard reslutMsg.commendMsg?.code == WebApiCode.Success.rawValue else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(webApiErrorCode: reslutMsg.commendMsg?.code ?? "")
                return
            }
            
            for friendInfo in reslutMsg.userInfos {
                self.items.append(ContactsNewFriendCellViewModel(viewController: self.viewController!, friendInfo: friendInfo))
            }
            
            self.tableView!.reloadData()
            
        }
        
        ContactsWebApi.shareApi.getFriendReqList(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, callBack: searchDataParse)
            
    }
    
}
