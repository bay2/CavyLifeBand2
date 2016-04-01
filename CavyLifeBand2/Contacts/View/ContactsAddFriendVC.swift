//
//  SearchViewController.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import Log
import Alamofire
import JSONJoy

class ContactsAddFriendVC: ContactsBaseViewController, UIScrollViewDelegate, UISearchResultsUpdating, ContactsSearchControllerDelegate {
    
    enum ContactsTabButtonTag: Int {
        
        case AddressBookTag = 1000
        case RecommendTag = 1001
        case NearbyTag = 1002
        
    }
    
    // 通讯录、推荐、附近 三个主按钮
    var searchBtnArray: [ContactsTabButton] = [ContactsTabButton(searchType: .AddressBook), ContactsTabButton(searchType: .Recommed), ContactsTabButton(searchType: .Nearby)]

    // 搜索控件
    let searchController = ContactsSearchController(searchResultsController: StoryboardScene.Contacts.instantiateSearchResultView())
    
    // 通讯录好友view
    var addressBookTableView: UITableView?
    
    // 推荐好友View
    var recommendView: ContactRecommendFriendView?
    
    // 附近好友View
    var nearbyTableView: UITableView?
    
    // 搜索结果列表
    var searchList: [ContactsSearchFriendInfo]?
    
    // 主按钮视图
    @IBOutlet weak var buttonView: UIView!

    // 主scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        buttonView.backgroundColor = UIColor(named: .HomeViewMainColor)
//        self.navBar?.translucent = false
        
        self.buttonView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
        }
        
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(buttonView.snp_bottom)
        }
        
        addContactsTabButton()
        
        addScrollerView()
        
    }
    

    
    /**
     添加 Searchutton
     */
    func addContactsTabButton() {

        searchBtnArray[1].selectButtonStatus()

        for i in 0  ..< 3  {
            
            let searchBtn = searchBtnArray[i]

            searchBtn.frame = CGRectMake(ez.screenWidth / 3 * CGFloat(i), 0, ez.screenWidth / 3, 100)
            searchBtn.tag = ContactsTabButtonTag.AddressBookTag.rawValue + i

            searchBtn.addTarget(self, action: #selector(ContactsAddFriendVC.searchBtnAction(_:)), forControlEvents: .TouchUpInside)
            self.buttonView.addSubview(searchBtn)

        }
        
    }
    
    /**
     添加滚动视图上的 TableView
     */
    func addScrollerView() {
        
        createScrollView()
        
        // 通讯录好友 按照名字首字母分组和联系人页面一样
        createAddressBookView()

        // 推荐好友 有搜索 有刷新
        createRecommendFriendView()

        // 附近好友 有刷新
        createNearbyView()

    }

    /**
     创建Scroll视图
     */
    func createScrollView() {

        self.scrollView.contentSize = CGSizeMake(ez.screenWidth * 3, 0)
        self.scrollView.contentOffset = CGPointMake(ez.screenWidth, 0)
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor(named: .HomeViewMainColor)

    }

    /**
     创建通讯录添加好友视图
     */
    func createAddressBookView() {

        self.addressBookTableView = UITableView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight), style: .Plain)
        configureTableView(self.addressBookTableView!)
        self.scrollView.addSubview(self.addressBookTableView!)

    }

    /**
     创建推荐好友搜索视图
     */
    func createRecommendFriendView() {

        recommendView = ContactRecommendFriendView(frame: CGRectMake(ez.screenWidth, 0, ez.screenWidth, ez.screenHeight))
        configureTableView(recommendView!.tableView)
        scrollView.addSubview(recommendView!)
        
        recommendView!.addSearchBar(searchController.contactsSearchBar!)
        searchController.searchResultsUpdater = self
        searchController.contactsSearchControllerDelegate = self

    }

    /**
     创建附近好友视图
     */
    func createNearbyView() {

        nearbyTableView = UITableView(frame: CGRectMake(ez.screenWidth * 2, 0, ez.screenWidth, ez.screenHeight), style: .Plain)
        configureTableView(nearbyTableView!)
        self.scrollView.addSubview(nearbyTableView!)
    }

    /**
     配置tableview
     
     - parameter tableView:
     */
    func configureTableView(tableView: UITableView) {
        
        tableView.registerNib(UINib(nibName: "ContactsAddFriendCell", bundle: nil), forCellReuseIdentifier: "ContactsAddFriendCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.whiteColor()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    /**
     选中按钮更该按钮状态
     
     - parameter sender:
     */
    func searchBtnAction(sender: UIButton) {
        
        changeSeachBtnStatus(sender.tag - ContactsTabButtonTag.AddressBookTag.rawValue)
        
    }
    
    /**
     切换按钮状态
     
     - parameter index:
     */
    func changeSeachBtnStatus(index: Int) {
        
        let _ = searchBtnArray.map {
            $0.deselectButtonStatus()
        }

        searchBtnArray[index].selectButtonStatus()
        self.scrollView.setContentOffset(CGPointMake(ez.screenWidth * CGFloat(index), 0), animated: true)

    }
    
    /**
     完成拖拉
     
     - parameter scrollView:
     */
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if self.scrollView != scrollView {
            return
        }
        
        let moveX = self.scrollView.contentOffset.x
        
        let currentIndex = Int(moveX / ez.screenWidth)
        
        if moveX > 2 * ez.screenWidth || moveX < 0 {
            return
        }
        
        changeSeachBtnStatus(currentIndex)
        
    }
    
    /**
     隐藏按钮视图
     
     - parameter hidden: 是否隐藏
     */
    func setButtonViewHidden(hidden: Bool) {
        
        self.navigationController?.setNavigationBarHidden(hidden, animated: true)
        
        if hidden {
            
            self.scrollView.snp_remakeConstraints { (make) -> Void in
                make.top.equalTo(buttonView.snp_bottom).offset(20)
            }
            
            self.buttonView.snp_remakeConstraints { (make) -> Void in
                make.top.equalTo(self.view).offset(-100)
            }
            
            
        } else {
            
            self.scrollView.snp_remakeConstraints { (make) -> Void in
                make.top.equalTo(buttonView.snp_bottom)
            }
            
            self.buttonView.snp_remakeConstraints { (make) -> Void in
                make.top.equalTo(self.view)
            }
            
        }
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        
        UIView.animateWithDuration(0.3) {
            
            self.view.layoutIfNeeded()
            
        }
    
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if self.searchController.isSearching {
            
            setButtonViewHidden(true)
            self.scrollView.scrollEnabled = false
            
        } else {
            
            setButtonViewHidden(false)
            self.scrollView.scrollEnabled = true
            self.searchController.contactsSearchBar?.text = ""
            searchList?.removeAll()
           
        }
        
        recommendView?.tableView.reloadData()
        
    }
    
    func didTapOnSearchButton() {
        
        let searchDataParse: (Result<AnyObject, UserRequestErrorType> -> Void) = { reslut in
            
            guard reslut.isSuccess else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, userErrorCode: reslut.error!)
                return
            }
            
            let reslutMsg = try! ContactsSearchFriendMsg(JSONDecoder(reslut.value!))
            
            guard reslutMsg.commonMsg?.code == WebApiCode.Success.rawValue else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(self, webApiErrorCode: reslutMsg.commonMsg!.code!)
                return
            }
            
            self.searchList = reslutMsg.friendInfos
            
            self.recommendView?.tableView.reloadData()
            
        }
        
        try! ContactsWebApi.shareApi.searchFriendByUserName(self.searchController.contactsSearchBar!.text!, callBack: searchDataParse)
        
    }
    
}

// MARK: - tableview代理
extension ContactsAddFriendVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    /**
    section 个数
    
    - parameter tableView:
    
    - returns:
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    
    /**
     cell 个数
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let list = searchList {
            return list.count
        }
        
        return 0
    }
    
    /**
     cell 高度
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return 66 }
    
    /**
     创建 cell
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsAddFriendCell", forIndexPath: indexPath) as! ContactsAddFriendCell

        let pushRquestView: (String -> Void) = { _ in

            self.navigationController?.navigationBarHidden = false
            self.pushVC(StoryboardScene.Contacts.instantiateContactsReqFriendVC())
        }
        
        if let listRet = searchList {
            
            if listRet.count > 0 {
                let addFriendViewModel = ContactsAddFriendCellViewModel(name: listRet[indexPath.row].nickName!, headImageUrl: listRet[indexPath.row].avatarUrl!, changeRequest: pushRquestView)
                cell.configure(addFriendViewModel, delegate: addFriendViewModel)
                return cell
            }
            
        }
        
        if tableView == addressBookTableView {
            let addressBookCellViewModel = ContactsAddressBookViewModel(changeRequest: pushRquestView)
            cell.configure(addressBookCellViewModel, delegate: addressBookCellViewModel)
        } else {
            let addFriendViewModel = ContactsAddFriendCellViewModel(changeRequest: pushRquestView)
            cell.configure(addFriendViewModel, delegate: addFriendViewModel)
        }
        
        return cell
    }
    
    /**
     点击cell
     
     - parameter tableView:
     - parameter indexPath:
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
}
