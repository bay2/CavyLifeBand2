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

extension ContactsRecommendFriendData: ContactsCellClickProtocol  {
    
    func onClickCell(viewController: UIViewController?, indexPath: NSIndexPath) {
        
        let requestVC = StoryboardScene.Contacts.instantiateContactsPersonInfoVC()
        requestVC.friendId = self.items[indexPath.row].friendId
        requestVC.friendNickName = self.items[indexPath.row].name
        viewController?.pushVC(requestVC)
        
    }
    
}

extension ContactsAddressBookFriendData: ContactsCellClickProtocol {

    func onClickCell(viewController: UIViewController?, indexPath: NSIndexPath) {
        
        let requestVC = StoryboardScene.Contacts.instantiateContactsPersonInfoVC()
        requestVC.friendId = self.items[indexPath.row].friendId
        requestVC.friendNickName = self.items[indexPath.row].name
        viewController?.pushVC(requestVC)
        
    }
    
}

extension ContactsSearchFriendData: ContactsCellClickProtocol {

    func onClickCell(viewController: UIViewController?, indexPath: NSIndexPath) {
        
        let requestVC = StoryboardScene.Contacts.instantiateContactsPersonInfoVC()
        requestVC.friendId = self.items[indexPath.row].friendId
        requestVC.friendNickName = self.items[indexPath.row].name
        viewController?.pushVC(requestVC)
        
    }
    
}

extension ContactsNearbyFriendData: ContactsCellClickProtocol {

    func onClickCell(viewController: UIViewController?, indexPath: NSIndexPath) {
        
        let requestVC = StoryboardScene.Contacts.instantiateContactsPersonInfoVC()
        requestVC.friendId = self.items[indexPath.row].friendId
        requestVC.friendNickName = self.items[indexPath.row].name
        viewController?.pushVC(requestVC)
        
    }
    
}


typealias ContactsTableViewProtocols = protocol<ContactsTableViewSectionDataSource, ContactsCellClickProtocol>

class ContactsAddFriendVC: UIViewController, UIScrollViewDelegate, BaseViewControllerPresenter {
    
    enum ContactsTabButtonTag: Int {
        
        case AddressBookTag = 1000
        case RecommendTag = 1001
        case NearbyTag = 1002
        
    }
    
    typealias CreateTableViewCell = ((ContactsAddFriendCell, NSIndexPath) -> ContactsAddFriendCell)
    
    var navTitle: String { return L10n.ContactsTitle.string }
    
    // 通讯录、推荐、附近 三个主按钮
    var searchBtnArray: [ContactsTabButton] = [ContactsTabButton(searchType: .AddressBook), ContactsTabButton(searchType: .Recommed), ContactsTabButton(searchType: .Nearby)]

    // 搜索控件
    let searchController = ContactsSearchController(searchResultsController: StoryboardScene.Contacts.instantiateSearchResultView())
    
    // 通讯录好友view
    var addressBookTableView: UITableView = UITableView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight - 164), style: .Plain)
    
    // 推荐好友View
    var recommendView: ContactRecommendFriendView = ContactRecommendFriendView(frame: CGRectMake(ez.screenWidth, 0, ez.screenWidth, ez.screenHeight - 164))
    
    // 附近好友View
    var nearbyTableView: UITableView = UITableView(frame: CGRectMake(ez.screenWidth * 2, 0, ez.screenWidth, ez.screenHeight - 164), style: .Plain)
    
    // 搜索结果tableview
    var searchTableView: UITableView = UITableView(frame: CGRectMake(0, 40, ez.screenWidth, ez.screenHeight), style: .Plain)
    
    // tableview 字典
    var tableDictionary: [UITableView: ContactsTableViewProtocols] = [:]
    
    var recommendFriendData: ContactsRecommendFriendData?
    
    var addressBookFriendData: ContactsAddressBookFriendData?
    
    // 三个空数据提示view
    var emptyViewRecommend: ContactListEmptyView?
    
    var emptyViewNearby: ContactListEmptyView?
    
    var emptyViewAddressBook: ContactListEmptyView?
    
    // 主按钮视图
    @IBOutlet weak var buttonView: UIView!

    // 主scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        buttonView.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        updateNavUI()
        
        self.buttonView.snp_makeConstraints { make -> Void in
            make.top.equalTo(self.view)
        }
        
        self.scrollView.snp_makeConstraints { make -> Void in
            make.top.equalTo(buttonView.snp_bottom)
        }
        
        addContactsTabButton()
        
        addScrollerView()
                
        addTableViewData(ContactsRecommendFriendData(viewController: self, tableView: recommendView.tableView), tableView: recommendView.tableView)
        addTableViewData(ContactsAddressBookFriendData(viewController: self, tableView: addressBookTableView), tableView: addressBookTableView)
        addTableViewData(ContactsSearchFriendData(viewController: self, tableView: searchTableView), tableView: searchTableView)
        addTableViewData(ContactsNearbyFriendData(viewController: self, tableView: nearbyTableView), tableView: nearbyTableView)
        
        loadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableDictionary.map { (key, value) -> (UITableView, ContactsTableViewSectionDataSource) in
            key.reloadData()
            
            return (key, value)
        }
        
    }
    
    /**
     加载数据
     */
    func loadData() {
        
        tableDictionary = tableDictionary.map { (key, value) -> (UITableView, ContactsTableViewProtocols) in
            
            let dataSource = value
            dataSource.loadData()
            
            return (key, dataSource)
        }
        
    }
    
    /**
     添加表格数据源
     
     - parameter dataSource: 数据源
     - parameter tableView:  tableview
     */
    func addTableViewData<T: ContactsTableViewProtocols where T: ContactsAddFriendDataSync>(dataSource: T, tableView: UITableView) {
        
        tableDictionary[tableView] = dataSource
        
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
        
        // 空数据View
        createEmptyView()
        
        // 通讯录好友 按照名字首字母分组和联系人页面一样
        createAddressBookView()

        // 推荐好友 有搜索 有刷新
        createRecommendFriendView()

        // 附近好友 有刷新
        createNearbyView()
        
        createSearchTableView()

    }
    
    /**
     配置全部三个空数据View
     */
    func createEmptyView() {
        
        emptyViewNearby = createSingleEmptyView()
        emptyViewNearby!.frame = nearbyTableView.frame
        emptyViewNearby?.displayInfo = L10n.ContactsEmptyViewNearbyInfo.string
        self.scrollView.addSubview(emptyViewNearby!)
        
        emptyViewRecommend = createSingleEmptyView()
        emptyViewRecommend!.frame = recommendView.tableView.frame
        self.scrollView.addSubview(emptyViewRecommend!)
        
        emptyViewAddressBook = createSingleEmptyView()
        emptyViewAddressBook!.frame = addressBookTableView.frame
        emptyViewAddressBook?.displayInfo = L10n.ContactsEmptyViewAddressBookInfo.string
        self.scrollView.addSubview(emptyViewAddressBook!)
        
    }
    
    /**
     创建单个空数据View实例
     
     - returns: ContactListEmptyView
     */
    func createSingleEmptyView() -> ContactListEmptyView {
        let view = NSBundle.mainBundle().loadNibNamed("ContactListEmptyView", owner: nil, options: nil).first as? ContactListEmptyView
        
        return view!
    }
    
    
    func createSearchTableView() {
        
        configureTableView(searchTableView)
        recommendView.addSubview(searchTableView)
        searchTableView.hidden = true
        
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
        
        configureTableView(self.addressBookTableView)
        self.scrollView.addSubview(self.addressBookTableView)

    }

    /**
     创建推荐好友搜索视图
     */
    func createRecommendFriendView() {

        configureTableView(recommendView.tableView)
        scrollView.addSubview(recommendView)
        
        recommendView.addSearchBar(searchController.contactsSearchBar!)
        searchController.searchResultsUpdater = self
        searchController.contactsSearchControllerDelegate = self

    }

    /**
     创建附近好友视图
     */
    func createNearbyView() {

        configureTableView(nearbyTableView)
        self.scrollView.addSubview(nearbyTableView)
    }

    /**
     配置tableview
     
     - parameter tableView:
     */
    func configureTableView(tableView: UITableView) {
        
        tableView.registerNib(UINib(nibName: "ContactsAddFriendCell", bundle: nil), forCellReuseIdentifier: "ContactsAddFriendCell")
        tableView.backgroundColor = UIColor.whiteColor()
        
        tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        tableView.separatorStyle = .SingleLine
        tableView.separatorColor = UIColor(named: .LColor)
        tableView.tableFooterView = UIView()
        
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
        
        _ = searchBtnArray.map {
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
    
}


// MARK: - tableview代理
extension ContactsAddFriendVC: UITableViewDataSource, UITableViewDelegate {
    
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
        
        guard let dataSourceViewModel = tableDictionary[tableView] else {
            tableView.hidden = true
            return 0
        }
        
        if dataSourceViewModel.rowCount == 0 {
            tableView.hidden = true
        } else {
            tableView.hidden = false
        }
        
        return dataSourceViewModel.rowCount
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
        
        guard let dataSourceViewModel = tableDictionary[tableView] else {
            fatalError()
        }
        
        return dataSourceViewModel.createCell(tableView, index: indexPath)

    }
    
    /**
     点击cell
     
     - parameter tableView:
     - parameter indexPath:
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        guard let dataSourceViewModel = tableDictionary[tableView] else {
            fatalError()
        }
        
        return dataSourceViewModel.onClickCell(self, indexPath: indexPath)
        
    }
    
}
