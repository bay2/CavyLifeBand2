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

class SearchViewController: ContactsBaseViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var searchBtnArray = Array<SearchButton>()
    let searchBtnName: Array<String> = [L10n.ContactsSearchPhoneNum.string, L10n.ContactsSearchRecommendNum.string, L10n.ContactsSearchNearbyNum.string]
    let searchBtnImage: Array<UIImage> = [UIImage(asset: .GuideNotice), UIImage(asset: .GuideNotice), UIImage(asset: .GuideNotice)]
    let serchBtnDefaultImg: Array<UIImage> = [UIImage(asset: .GuideNotice), UIImage(asset: .GuideNotice), UIImage(asset: .GuideNotice)]
    let searchController = ContactsSearchController(searchResultsController: StoryboardScene.Contacts.instantiateSearchResultView())
    @IBOutlet weak var buttonView: UIView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        buttonView.backgroundColor = UIColor(named: .HomeViewMainColor)
        self.navBar?.translucent = false
    }
    
    override func viewWillAppear(animated: Bool) {
        
        addSearchButton()
        
        addScrollerView()

    }
    
    /**
     添加 Searchutton
     */
    func addSearchButton() {
        
        for var i = 0 ; i < 3 ; i++ {
            
            let searchBtn = SearchButton()
            searchBtn.searchTableViewInit(CGRectMake(ez.screenWidth / 3 * CGFloat(i), 20, ez.screenWidth / 3, 100), image: searchBtnImage[i], name: searchBtnName[i])
            if i == 1 {
                searchBtn.selectButtonStatus(searchBtnImage[i])
            }
            searchBtn.button.tag = 1000 + i
            searchBtn.button.addTarget(self, action: "searchBtnAction:", forControlEvents: .TouchUpInside)
            searchBtnArray.append(searchBtn)
            self.view.addSubview(searchBtn)
        }
        
    }
    
    /**
     添加滚动视图上的 SearchTableView
     */
    func addScrollerView(){
        
        self.scrollView.frame = CGRectMake(0, 0, ez.screenWidth, ez.screenHeight - 120)
        self.scrollView.contentSize = CGSizeMake(ez.screenWidth * 3, scrollView.frame.height)
        self.scrollView.contentOffset = CGPointMake(ez.screenWidth, 0)
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.showsHorizontalScrollIndicator = false
        
        // 通讯录好友 按照名字首字母分组和联系人页面一样
        let tableView = UITableView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight), style: UITableViewStyle.Grouped)
        tableView.tag = 2000
        scrollViewAddTableView(tableView)
        self.scrollView.addSubview(tableView)
        
        // 推荐好友 有搜索 有刷新
        let recommandView = RecommendSearchView(frame: CGRectMake(ez.screenWidth, 0, ez.screenWidth, ez.screenHeight))
        recommandView.tableView.tag = 2001
        scrollViewAddTableView(recommandView.tableView)
        scrollView.addSubview(recommandView)
        recommandView.addSearchBar(searchController.contactsSearchBar!)
        
        // 附近好友 有刷新
        let nearbyView = SearchTableView(frame: CGRectMake(ez.screenWidth * 2, 0, ez.screenWidth, ez.screenHeight), style: UITableViewStyle.Plain)
        tableView.tag = 2003
        scrollViewAddTableView(nearbyView)
        self.scrollView.addSubview(nearbyView)
    }


    func scrollViewAddTableView(tableView: UITableView) {
        
        tableView.registerNib(UINib(nibName: "ContactsSearchTVCell", bundle: nil), forCellReuseIdentifier: "ContactsSearchTVCell")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.backgroundColor = UIColor.clearColor()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    // 选中按钮更该按钮状态
    func searchBtnAction(sender: UIButton) {
        
        changeSeachBtnStatus(sender.tag - 1000)
        
    }
    
    func changeSeachBtnStatus(index: Int) {
        
        for var i = 0 ; i < 3 ; i++ {
            // 其他按钮恢复默认的状态
            let button = searchBtnArray[i]
            button.cancelSelectButtonStatus(serchBtnDefaultImg[i])
            
            if i == index {
                
                searchBtnArray[i].selectButtonStatus(searchBtnImage[i])
                self.scrollView.setContentOffset(CGPointMake(ez.screenWidth * CGFloat(i), 0), animated: true)
                
            }
            
        }

    }
    
    
    // 按钮事件
    func requestAction() {
        
        let requestVC = StoryboardScene.Contacts.instantiateRquestView()
        self.pushVC(requestVC)
        
        
    }
    
   
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 66
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsSearchTVCell", forIndexPath: indexPath) as! ContactsSearchTVCell
            
        let viewMode = SearchCellViewModel()
        cell.configure(viewMode, delegate: viewMode)
        cell.requestBtn.addTarget(self, action: "requestAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        let cellBgView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, 66))
        cellBgView.backgroundColor = UIColor(named: .ContactsCellSelect)
        cell.selectedBackgroundView = cellBgView
        
        return cell
    }
    
    
    // MARK: - Scroll view data source
    // 完成拖拽
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let moveX = scrollView.contentOffset.x
        let currentIndex = Int(moveX / ez.screenWidth)
        print(currentIndex)
        
        
        if moveX > 2 * ez.screenWidth || moveX < 0 {
            return
        }
        
        changeSeachBtnStatus(currentIndex)
        
    }
    
    // 点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        Log.info("cell点击事件到联系人详情页")
        
    }
    
    @IBAction func backActon(sender: AnyObject) {
        self.popVC()
    }
    
    
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
