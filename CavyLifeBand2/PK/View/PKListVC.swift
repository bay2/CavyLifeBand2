//
//  PKListVC.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/5/3.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import RealmSwift

class PKListVC: UIViewController, BaseViewControllerPresenter, PKRecordsUpdateFormWeb {

    @IBOutlet weak var pkListTableView: UITableView!
    
    var loginUserId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    let realm = try! Realm()
    
    private var dataSources: [PKListDataDelegateProtocols] = []
    
    var navTitle: String = L10n.PKPKTitle.string
    
    @IBOutlet weak var launchPKBtn: MainPageButton!
    
    var notificationToken: NotificationToken?
    
    var pkInfoView: UIView?
    
    @IBOutlet weak var bottomSeparatorLine: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateNavUI()
        
        bottomSeparatorLine.backgroundColor = UIColor(named: .LColor)
        
        pkListTableView.registerNib(UINib(nibName: "ContactsAddFriendCell", bundle: nil), forCellReuseIdentifier: "ContactsAddFriendCell")
        pkListTableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        pkListTableView.separatorStyle = .SingleLine
        pkListTableView.separatorColor = UIColor(named: .LColor)
        pkListTableView.tableFooterView = UIView()
        
        //添加数据源
        addDataSource(PKWaitListDataSource(realm: self.realm))
        addDataSource(PKDueListDataSource(realm: self.realm))
        addDataSource(PKFinishListDataSource(realm: self.realm))
        
        //修改PK按钮UI
        launchPKBtn.setBackgroundColor(UIColor(named: .JColor), forState: .Normal)
        launchPKBtn.setTitleColor(UIColor(named: .AColor), forState: .Normal)
        launchPKBtn.setTitle(L10n.PKRecordsVCLaunchPkTitle.string, forState: .Normal)
        
        loadItemData()
        
        notificationToken = realm.addNotificationBlock {[unowned self] _, _ in
            self.loadItemData()
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //未同步的删除pk
        if self.getUnSyncPKList(PKFinishRealmModel.self) != nil {
            return
        }
        
        //未同步的接受pk
        if self.getUnSyncPKList(PKDueRealmModel.self) != nil {
           return
        }
        
        //未同步的撤销pk
        if self.getUnSyncWaitPKListWithType(.UndoWait) != nil {
            return
        }

        self.loadDataFromWeb()
        
    }
    
    lazy var rightBtn: UIButton? =  {
        
        let button = UIButton(type: .System)
        button.frame = CGRectMake(0, 0, 30, 30)
        button.setBackgroundImage(UIImage(asset: .PKHelp), forState: .Normal)
        
        return button
        
    }()
    
    func onRightBtn() -> Void {
        
        self.pushVC(StoryboardScene.PK.instantiatePKRulesVC())
        
    }
    
    func loadItemData() {
        
        dataSources = dataSources.map {
            var data = $0
            data.loadData()
            return data
        }
        
        pkListTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     添加数据源
     
     - parameter dataSource: 数据源
     */
    func addDataSource<T: PKListDataDelegateProtocols where T: PKListDataSource>(dataSource: T) {
        
        dataSources.append(dataSource)
        
    }
    
    @IBAction func onClickLaunchPK(sender: AnyObject) {
        
        self.pushVC(StoryboardScene.PK.instantiatePKInvitationVC())
        
    }
    
    /**
     返回按钮处理
     */
    func onLeftBtnBack() {
        
        self.navigationController?.popToViewController(self.navigationController!.viewControllers[0], animated: false)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeLeftOnClickMenu.rawValue, object: nil)
        
    }
    
}

// MARK: - TableView
extension PKListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return dataSources[indexPath.section].createCell(tableView, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources[section].rowCount
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSources.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dataSources[indexPath.section].cellHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSources[section].sectionView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSources[section].sectionHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        //展示pk详情的View
        guard let pkView = dataSources[indexPath.section].getPKInfoView(indexPath) else {
            return
        }
        
        pkInfoView = pkView
        
        pkInfoView!.addTapGesture { [unowned self] _ in
            self.pkInfoView?.removeFromSuperview()
        }

        UIApplication.sharedApplication().keyWindow?.addSubview(pkInfoView!)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        return dataSources[indexPath.section].createRowActions(indexPath)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return dataSources[indexPath.section].isCanEditRow
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
