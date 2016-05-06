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

protocol PKSelectOppTVCDelegate {
    
    func selectPKOpp(userId: String, nikeName: String, avatarUrl: String)
    
}


class PKSelectOppTVC: UITableViewController, FriendInfoListDelegate, BaseViewControllerPresenter {
    
    var dataSource: [ContactsTableViewSectionDataSource] = []
    
    var realm: Realm = try! Realm()
    
    var userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    var delegate: PKSelectOppTVCDelegate?
    
    var navTitle: String {
        return L10n.PKInvitationVCSelectFriend.string
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadFriendData()
        
        self.tableView.registerNib(UINib(nibName: "ContactsFriendListCell", bundle: nil), forCellReuseIdentifier: "ContactsFriendListCell")
        
    }
    
    /**
     加载数据
     */
    func loadFriendData() {
        
        dataSource = "ABCDEFGHIJKNMLOPQRXTVUWSYZ".characters.map { letter -> ContactsTableViewSectionDataSource? in
            
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
        
        guard let listModelView = dataSource[indexPath.section] as? ContactsTableListModelView else {
            return
        }
        
        let userId = listModelView.items[indexPath.row].friendId
        let nikeName = listModelView.items[indexPath.row].name
        let avatarUrl = listModelView.items[indexPath.row].headImagUrl
        
        
        delegate?.selectPKOpp(userId, nikeName: nikeName, avatarUrl: avatarUrl)
    }

}
