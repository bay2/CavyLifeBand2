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

class AccountInfoSecurityVC: ContactsBaseViewController, UITableViewDelegate, UITableViewDataSource, AccountInfoSecurityDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var realm: Realm = try! Realm()
    var userId: String { return loginUserId }
    let dataArray = [AccountInfoSecurityCellViewModel]()
    
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
        
        // 如果不存在 就添加默认
        if isExistInfoSecurityList() ==  false {
            
            addDefaultAccountInfoSecurityRealm()
        }
        
        queryAccountInfoSecurity()

    }
    
    /**
     解析账户信息 的信息公开List
     */
    func parserFriendListData(result: AccountInfoSecurityCellViewModel) {
        
        
        
        
    }
    
    /**
     添加TableView
     */
    func addTableView() {
        
        tableView.layer.cornerRadius = commonCornerRadius
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
//        let dataSourceVM = AccountInfoSecurityCellViewModel(realm: self.realm, title: titleArray[indexPath.row], isOpenOrNot: true)
        cell.configure(dataArray)
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
