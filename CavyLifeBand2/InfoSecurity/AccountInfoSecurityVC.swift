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

class AccountInfoSecurityVC: ContactsBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var realm: Realm = try! Realm()
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId}
    
    var dataSources = [AccountInfoSecurityListDataSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        self.navBar?.translucent = false
        
        loadFriendData()
        
        addTableView()
        
    }
    
    /**
     加载数据
     */
    func loadFriendData() {

        let userInfoModel = UserInfoOperate().queryUserInfo(userId)
        
        if userInfoModel != nil {
            
            self.dataSources = [AccountInfoSecurityCellViewModel(title: L10n.ContactsShowInfoHeight.string, isOpenOrNot: userInfoModel!.isOpenHeight), AccountInfoSecurityCellViewModel(title: L10n.ContactsShowInfoWeight.string, isOpenOrNot: userInfoModel!.isOpenWeight), AccountInfoSecurityCellViewModel(title: L10n.ContactsShowInfoBirth.string, isOpenOrNot: userInfoModel!.isOpenBirthday)]

        }

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
      func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCellWithIdentifier("infoSecurityIdentifier") as! AccountInfoSecurityCell

        cell.configure(dataSources, index: indexPath.row)
        
        return cell
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
