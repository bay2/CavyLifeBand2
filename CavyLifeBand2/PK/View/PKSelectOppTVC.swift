//
//  PKSelectOppTVC.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/5.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

extension ContactsFriendCellModelView {
    
    init(friendInfoRealm: FriendInfoRealm) {
        
        name = friendInfoRealm.nikeName
        hiddenCare = !friendInfoRealm.isFollow
        headImagUrl = friendInfoRealm.headImage
        friendId = friendInfoRealm.friendId
        
    }
    
}

protocol PKSelectOppInfoDataSource {
    
    func itemsData(didSelectRowAtIndexPath indexPath: NSIndexPath) -> (userId: String, nikeName: String, avatarUrl: String)
    
}

extension PKSelectOppInfoDataSource {
    
    
}

protocol PKSelectOppTVCDelegate {
    
    func selectPKOpp(userId: String, nikeName: String, avatarUrl: String)
    
}

extension ContactsTableListModelView: PKSelectOppInfoDataSource {
    
    func itemsData(didSelectRowAtIndexPath indexPath: NSIndexPath) -> (userId: String, nikeName: String, avatarUrl: String) {
        
        let itemInfo = items[indexPath.row]
        
        return (itemInfo.friendId, itemInfo.name, itemInfo.headImagUrl)
        
    }
    
}

typealias PKSelectOppDataSource = protocol<ContactsTableViewSectionDataSource, PKSelectOppInfoDataSource>


class PKSelectOppTVC: UITableViewController, FriendInfoListDelegate, BaseViewControllerPresenter {
    
    var dataSource: [PKSelectOppDataSource] = []
    
    var realm: Realm = try! Realm()
    
    var userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    var delegate: PKSelectOppTVCDelegate?
    
    var navTitle: String {
        return L10n.PKInvitationVCSelectFriend.string
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateNavUI()
        
        loadFriendData()
        
        tableView.registerNib(UINib(nibName: "ContactsFriendListCell", bundle: nil), forCellReuseIdentifier: "ContactsFriendListCell")
        
        tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        tableView.separatorStyle = .SingleLine
        tableView.separatorColor = UIColor(named: .LColor)
        tableView.tableFooterView = UIView()
        
    }
    
    /**
     加载数据
     */
    func loadFriendData() {
        
        dataSource = "ABCDEFGHIJKNMLOPQRXTVUWSYZ".characters.map { letter -> PKSelectOppDataSource? in
            
            guard let queryResult = queryFriendListByLetter(String(letter)) else {
                return nil
            }
            
            if queryResult.count < 1 {
                return nil
            }
            
            let cellViewMaodels = queryResult.map { friendInfo -> ContactsFriendCellModelView in
                return ContactsFriendCellModelView(friendInfoRealm: friendInfo)
            }
            
            return ContactsTableListModelView(items: cellViewMaodels, sectionTitle: String(letter))
            
            }.flatMap { $0 }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rowCount
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return dataSource[indexPath.section].createCell(tableView, index: indexPath)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSource[section].createSectionView()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dataSource[indexPath.section].cellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let selectOppInfo = dataSource[indexPath.section].itemsData(didSelectRowAtIndexPath: indexPath)
        
        
        delegate?.selectPKOpp(selectOppInfo.userId, nikeName: selectOppInfo.nikeName, avatarUrl: selectOppInfo.avatarUrl)
        
        self.popVC()
        
    }

}
