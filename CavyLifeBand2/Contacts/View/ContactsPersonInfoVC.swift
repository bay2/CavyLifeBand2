//
//  ContactsRequestAddFriendInfoVC.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Log

class ContactsPersonInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    /// 请求添加好友按钮
    @IBOutlet weak var requestButton: UIButton!
    
    @IBAction func requestAddFriend(sender: AnyObject) {
        
        /// 跳到添加好友 验证信息发送 页面
        let requestVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
        requestVC.requestStyle = .AddFriend
        self.pushVC(requestVC)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)

        addTableView()
        
    }
    
    /**
     tableView 信息
     */
    func addTableView() {
        // 注册
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius

        tableView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(326)
        }
        // 隐藏分隔线
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "ContactsPersonInfoCell", bundle: nil), forCellReuseIdentifier: "ContactsPersonInfoCell")
        tableView.registerNib(UINib(nibName: "ContactsPersonInfoListCell", bundle: nil), forCellReuseIdentifier: "ContactsPersonInfoListCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }

    // MARK: UITableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {

            return 136
            
        } else if indexPath.row == 4{
            
            return 40
        } else {
            
            return 50 
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonInfoCell", forIndexPath: indexPath) as! ContactsPersonInfoCell
            cell.personRealtion(.StrangerRelation)
            return cell
            
        } else if indexPath.row == 4 {
        
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ListwhiteCell")
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ListwhiteCell")!
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonInfoListCell", forIndexPath: indexPath) as! ContactsPersonInfoListCell
            
            cell.titleLabel.text = "身高"
            cell.titleInfoLabel.text = "160"
            
            return cell
        }
        
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
