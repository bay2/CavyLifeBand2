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

class ContactsSearchVC: ContactsBaseViewController, UIScrollViewDelegate, UISearchResultsUpdating {
    
    enum SearchButtonTag: Int {
        
        case AddressBookTag = 1000
        case RecommendTag = 1001
        case NearbyTag = 1002
        
    }
    
    // 通讯录、推荐、附近 三个主按钮
    var searchBtnArray: [SearchButton] = [SearchButton(searchType: .AddressBook), SearchButton(searchType: .Recommed), SearchButton(searchType: .Nearby)]

    // 搜索控件
    let searchController = ContactsSearchController(searchResultsController: StoryboardScene.Contacts.instantiateSearchResultView())
    
    // 通讯录好友view
    var addressBookTableView: UITableView?
    
    // 推荐好友View
    var recommendView: RecommendSearchView?
    
    // 附近好友View
    var nearbyTableView: UITableView?
    
    // 主按钮视图
    @IBOutlet weak var buttonView: UIView!

    // 主scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = UIColor(named: .HomeViewMainColor)
        buttonView.backgroundColor = UIColor(named: .HomeViewMainColor)
        self.navBar?.translucent = false
        
        self.buttonView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
        }
        
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(buttonView.snp_bottom)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        addSearchButton()
        
        addScrollerView()

    }
    
    /**
     添加 Searchutton
     */
    func addSearchButton() {

        searchBtnArray[1].selectButtonStatus()

        for var i = 0 ; i < 3 ; i++ {
            
            let searchBtn = searchBtnArray[i]

            searchBtn.frame = CGRectMake(ez.screenWidth / 3 * CGFloat(i), 0, ez.screenWidth / 3, 100)
            searchBtn.tag = SearchButtonTag.AddressBookTag.rawValue + i

            searchBtn.addTarget(self, action: "searchBtnAction:", forControlEvents: .TouchUpInside)
            self.buttonView.addSubview(searchBtn)

        }
        
    }
    
    /**
     添加滚动视图上的 SearchTableView
     */
    func addScrollerView() {
        
        createScrollView()
        
        // 通讯录好友 按照名字首字母分组和联系人页面一样
        createAddressBookView()

        // 推荐好友 有搜索 有刷新
        createRecommendSearchView()

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
        self.scrollView.alwaysBounceHorizontal = false
        self.scrollView.showsHorizontalScrollIndicator = false

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
    func createRecommendSearchView() {

        recommendView = RecommendSearchView(frame: CGRectMake(ez.screenWidth, 0, ez.screenWidth, ez.screenHeight))
        configureTableView(recommendView!.tableView)
        scrollView.addSubview(recommendView!)
        
        recommendView!.addSearchBar(searchController.contactsSearchBar!)
        searchController.searchResultsUpdater = self

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
        
        tableView.registerNib(UINib(nibName: "ContactsSearchTVCell", bundle: nil), forCellReuseIdentifier: "ContactsSearchTVCell")
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
        
        changeSeachBtnStatus(sender.tag - SearchButtonTag.AddressBookTag.rawValue)
        
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
        
        let moveX = scrollView.contentOffset.x
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
        
        if hidden {
            
            self.scrollView.snp_remakeConstraints(closure: { (make) -> Void in
                make.top.equalTo(self.view).offset(20)
            })
            
            self.buttonView.snp_remakeConstraints(closure: { (make) -> Void in
                make.top.equalTo(self.view).offset(-100)
            })
            
            
        } else {
            
            self.scrollView.snp_remakeConstraints(closure: { (make) -> Void in
                make.top.equalTo(self.view).offset(100)
            })
            
            self.buttonView.snp_remakeConstraints(closure: { (make) -> Void in
                make.top.equalTo(self.view)
            })
            
        }
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        
        UIView.animateWithDuration(0.1) {
            
            self.view.layoutIfNeeded()
            
        }
    
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if self.searchController.isSearching {
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            setButtonViewHidden(true)
            
        } else {
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            setButtonViewHidden(false)
            
        }
        
    }
    
}

extension ContactsSearchVC: UITableViewDataSource, UITableViewDelegate {
    
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 5 }
    
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsSearchTVCell", forIndexPath: indexPath) as! ContactsSearchTVCell
        
        let viewMode = SearchCellViewModel { _ in
            self.pushVC(StoryboardScene.Contacts.instantiateRquestView())
        }
        
        cell.configure(viewMode, delegate: viewMode)
        
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
