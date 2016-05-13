//
//  AccountInfoSecurityVC.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/30.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Log
import RealmSwift
import EZSwiftExtensions
                                                               
class AccountInfoSecurityVC: UIViewController, UITableViewDelegate, UITableViewDataSource, BaseViewControllerPresenter {

    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var navTitle: String { return L10n.HomeLifeListTitleInfoOpen.string }
    
    var realm: Realm = try! Realm()
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    var dataSources = [AccountInfoSecurityListDataSource]()
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        self.navBar?.translucent = false
        self.bottomView.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        addCellDataSource(AccountInfoSecurityHeightCellViewModel(realm: realm))
        addCellDataSource(AccountInfoSecurityWeightCellViewModel(realm: realm))
        addCellDataSource(AccountInfoSecurityBirthdayCellViewModel(realm: realm))
        
        addTableView()
        
        updateNavUI()
        
        
    }
    
    /**
     添加数据源
     
     - parameter dataSource:
     */
    func addCellDataSource(dataSource: AccountInfoSecurityListDataSource) {
        
        dataSources.append(dataSource)
        
    }
    
    /**
     添加TableView
     */
    func addTableView() {
        
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        tableView.registerNib(UINib(nibName: "AccountInfoSecurityCell", bundle: nil), forCellReuseIdentifier: "infoSecurityIdentifier")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    /**
     返回按钮处理
     */
    func onLeftBtnBack() {
        
        self.navigationController?.popViewControllerAnimated(false)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeLeftOnClickMenu.rawValue, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension AccountInfoSecurityVC {
    
    // MARK: - UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("infoSecurityIdentifier") as! AccountInfoSecurityCell
        
        cell.configure(dataSources[indexPath.row])
        
        return cell
    }
    
}
