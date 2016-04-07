//
//  ContactsFriendListVC.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import JSONJoy
import Alamofire
import AlamofireImage
import RealmSwift
import Log


class ContactsFriendListVC: ContactsBaseViewController, UISearchResultsUpdating, FriendInfoListDelegate, FollowFriendDelegate, DeleteFriendDelegate {

    let defulatDataSource: [ContactsFriendListDataSource] = [ContactsAddFriendViewModel(), ContactsNewFriendCellModelView(), ContactsCavyModelView()]

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var contactsTable: UITableView!
    
    var notificationToken: NotificationToken?

    @IBOutlet weak var searchCtrlView: UITableView!
    // 搜索控件
    var searchCtrl  = ContactsSearchController(searchResultsController: StoryboardScene.Contacts.instantiateSearchResultView())
    
    // 搜索页面视图
    
    var dataSource: [ContactsFriendListDataSource] = [ContactsFriendListDataSource]()
    var dataGroup: ContactsSortAndGroup?
    
    var realm: Realm = try! Realm()
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        configureSearchController()
        
        loadFirendListData()
        
        notificationToken = realm.addNotificationBlock { _, _ in
            
            self.loadFirendListData()
            
        }
        
    }
    
    /**
     通过网络加载数据
     */
    func loadFriendListDataByNet() {
        
        ContactsWebApi.shareApi.getFriendList(userId) { (result) in
            
            guard result.isSuccess else {
                
                Log.error("Get friend list error")
                return
            }
            
            do {
                
                let netResult = try ContactsFriendListMsg(JSONDecoder(result.value!))
                self.parserFriendListData(netResult)
                
            } catch let error {
                
                Log.error("\(#function) result error (\(error))")
                
            }
            
        }
    }
    
    /**
     解析好友列表数据
     */
    func parserFriendListData(result: ContactsFriendListMsg) {
        
        guard result.commonMsg?.code == WebApiCode.Success.rawValue else {
            Log.error("Query friend list error \(result.commonMsg?.code)")
            return
        }
        
        let friendList = FriendInfoListRealm()
        
        friendList.userId = userId
        
        for friendInfo in result.friendInfos! {
            
            let friendInfoRealm = FriendInfoRealm()
            
            friendInfoRealm.headImage = friendInfo.avatarUrl!
            friendInfoRealm.friendId = friendInfo.userId!
            friendInfoRealm.nikeName = friendInfo.nickName!
            friendInfoRealm.isFollow = friendInfo.isFoolow!
            
            friendList.friendListInfo.append(friendInfoRealm)
            
        }
        
        saveFriendList(friendList)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        loadFriendListDataByNet()
        
    }
    
    /**
     加载好友列表数据
     */
    func loadFirendListData() {
        
        queryFriendList()
        
        updateDataSource()
        
        self.contactsTable.reloadData()
        
    }
    
    /**
     更新数据
     */
    func updateDataSource() {
        
        dataSource.removeAll()
        
        guard let friendList = queryFriendList() else {
            dataGroup = ContactsSortAndGroup(contactsList: dataSource)
            dataGroup?.insertAsFrist(defulatDataSource)
            return
        }
        
        for friendInfo in friendList.friendListInfo {
            
            let contactsFriendInfo = ContactsFriendCellModelView(friendId: friendInfo.friendId, name: friendInfo.nikeName, headImagUrl: friendInfo.headImage, hiddenCare: !friendInfo.isFollow)
            dataSource.append(contactsFriendInfo)
            
        }
        
        dataGroup = ContactsSortAndGroup(contactsList: dataSource)
        dataGroup?.insertAsFrist(defulatDataSource)
        
    }
    
    
    /**
     跳转到添加好友
     */
    func pushAddFriendView() {

        self.pushVC(StoryboardScene.Contacts.instantiateContactsAddFriendVC())

    }

    /**
     配置搜索Controller
     */
    func configureSearchController() {

        searchView.addSubview(searchCtrl.contactsSearchBar!)
        
        searchCtrl.searchResultsUpdater = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func requestAction() {
        
        let requestVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
        self.pushVC(requestVC)

    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {

        if searchCtrl.isSearching {

            searchCtrlView.hidden = false
            contactsTable.hidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)

        } else {

            searchCtrlView.hidden = true
            contactsTable.hidden = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)

        }

    }
    
    /**
     关注好友
     
     - parameter index:  索引
     - parameter follow: 关注类型
     */
    func followFriend(index: NSIndexPath, follow: Bool) {
        
        let friendList = dataGroup!.contactsGroupList![index.section].1
        let friendId = friendList[index.row].friendId
        
        ContactsWebApi.shareApi.followFriend(userId, friendId: friendId, follow: follow) { result in
            
            guard result.isSuccess else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: result.error!)
                return
            }
            
            let resultMsg = try! CommenMsg(JSONDecoder(result.value!))
            
            guard resultMsg.code == WebApiCode.Success.rawValue else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, webApiErrorCode: resultMsg.code!)
                return
            }
            
            self.setFollowFriend(friendId, isFollow: follow)
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContactsFriendListVC {
    
    /**
     cell 编辑结束
     
     - parameter tableView:
     - parameter indexPath:
     */
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? ContactsFriendListCell
        cell?.showEditing(false)
        
    }
    
    /**
     左滑按钮
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.section == 0 {
            return nil
        }
        
        let concernAction = createFollowAction(indexPath)
        let pkRowAction = createPkAction()
        let deleteRowAction = createDelAction(indexPath)
       
        return [deleteRowAction, concernAction, pkRowAction]
    }
    
    /**
     添加删除按钮
     
     - parameter indexPath: 索引
     
     - returns:
     */
    func createDelAction(indexPath: NSIndexPath) -> UITableViewRowAction {
        
        var names = self.dataGroup!.contactsGroupList![indexPath.section].1
        let friendId = names[indexPath.row].friendId
        
        let deleteFriendNetDataParse: (Result<AnyObject, UserRequestErrorType>) -> Void = { reslut in
            
            guard reslut.isSuccess else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: reslut.error!)
                return
            }
        
            let reslutMsg = try! CommenMsg(JSONDecoder(reslut.value!))
        
            guard reslutMsg.code == WebApiCode.Success.rawValue else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, webApiErrorCode: reslutMsg.code!)
                return
            }
            
            self.deleteFriend(friendId)
        
        }
        
        let deleteActionProc: (UITableViewRowAction, NSIndexPath) -> Void = { _, _ in
            
            ContactsWebApi.shareApi.delFriend(self.userId, friendId: friendId, callBack: deleteFriendNetDataParse)
            
        }
        
        
        let deleteRowAction = UITableViewRowAction(style: .Default, title: L10n.ContactsListCellDelete.string, handler: deleteActionProc)
        
        
        deleteRowAction.backgroundColor = UIColor(named: .ContactsDeleteBtnColor)
        
        return deleteRowAction
        
    }
    
    
    /**
     创建PK按钮
     */
    func createPkAction() -> UITableViewRowAction {
        
        let pkRowAction = UITableViewRowAction(style: .Default, title: " PK ") {_, _ in
            
            self.contactsTable.editing = false
            
        }
        
        pkRowAction.backgroundColor = UIColor(named: .ContactsPKBtnColor)

        return pkRowAction

    }
    
    /**
     创建关注按钮
     */
    func createFollowAction(indexPath: NSIndexPath) -> UITableViewRowAction {
        
        let cell = contactsTable.cellForRowAtIndexPath(indexPath) as? ContactsFriendListCell
        
        var names = self.dataGroup!.contactsGroupList![indexPath.section].1
        
        let concernActionTitle = cell!.hiddenCare ? L10n.ContactsListCellCare.string : L10n.ContactsListCellUndoCare.string
        let concernActionColor = cell!.hiddenCare ? UIColor(named: .ContactsCareBtnColor) : UIColor(named: .ContactsUndoCareBtnColor)
        
        let concernAction = UITableViewRowAction(style: .Default, title: concernActionTitle) {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            self.contactsTable.editing = false
            
            cell?.hiddenCare = !cell!.hiddenCare
            names[indexPath.row].hiddenCare = cell!.hiddenCare
            
            self.followFriend(indexPath, follow: !cell!.hiddenCare)
            
        }

        concernAction.backgroundColor = concernActionColor
        
        return concernAction
        
    }
    
    /**
     cell 编辑类型
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if indexPath.section == 0 {
            return .None
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? ContactsFriendListCell
        
        cell?.showEditing(true)
        
        return .Delete
        
    }
    
    /**
     row 数
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let names = self.dataGroup!.contactsGroupList![section].1
        
        return names.count
        
    }
    
    /**
     cell 高度
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 66
    }
    
    /**
     section 高度
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        
        return 28
    }
    
    /**
     创建cell
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerNib(UINib(nibName: "ContactsFriendListCell", bundle: nil), forCellReuseIdentifier: "ContactsFriendListCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsFriendListCell", forIndexPath: indexPath) as! ContactsFriendListCell
        
        var names = self.dataGroup!.contactsGroupList
        
        cell.configure(names![indexPath.section].1[indexPath.row])
        
        return cell
    }
    
    /**
     创建section
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }
        
        let letterView = NSBundle.mainBundle().loadNibNamed("ContactsLetterView", owner: nil, options: nil).first as? ContactsLetterView
        letterView?.title.text = dataGroup?.contactsGroupList![section].0
        
        return letterView
        
    }
    
    /**
     点击事件cell
     
     - parameter tableView:
     - parameter indexPath:
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let names = dataGroup?.contactsGroupList![indexPath.section].1
        names![indexPath.row].onClickCell(self)
        
    }
    
    /**
     sections 个数
     
     - parameter tableView:
     
     - returns:
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return dataGroup!.contactsGroupList!.count
        
    }
    
}
