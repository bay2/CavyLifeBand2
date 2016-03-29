//
//  ContactsAccountInfoVC.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/23.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import SnapKit

class ContactsAccountInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    /// scrollView的ContectView
    @IBOutlet weak var contectView: UIView!
    
    /// tableView
    @IBOutlet weak var tableView: UITableView!
    
    // 徽章视图
    @IBOutlet weak var badgeView: UIView!
    
    // 成就
    @IBOutlet weak var badgeInfo: UILabel!
    @IBOutlet weak var badgeTitle: UILabel!
    
    /// 徽章视图
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// 退出登录
    @IBOutlet weak var logoutButton: UIButton!
    
    var accountDelegate: AccountInfoDelegate?
    
    
    /// tableView 的 cell个数
    let cellCount: Int = 6
    
    /// 徽章个数
    var badgeCount: Int = 6
    
    let infoTitleArray = [L10n.ContactsShowInfoGender.string, L10n.ContactsShowInfoHeight.string, L10n.ContactsShowInfoBirth.string, L10n.ContactsShowInfoWeight.string, L10n.ContactsShowInfoAddress.string]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        addAllViews()
        
        accountDelegate = self
        
        accountInfoQuery()
    }
    
    /**
     加载账户信息
     */
    func accountInfoQuery() {
        
        /// 本地取出 账户信息
//        let accountInfo = UserInfoOperate().queryUserInfo("56d6ea3bd34635186c60492b")
//        print(accountInfo!)
        
        /// 网络获取 账户信息
        let paras = [UserNetRequsetKey.UserID.rawValue: "56d6ea3bd34635186c60492b"]

        userNetReq.queryProfile(paras, completionHandler: { (result) -> Void in
            
            print(result)

        })
        
    }
    
    
    /**
     添加 TableView视图
     */
    func addAllViews() {
        
        // InfoTableView高度
        // |-infoListCell-136-|-cellCount-1[infoListCell] * 50-|-边10-|
        let tableViewHeight = CGFloat(136 + (cellCount - 1) * 50 + 10)
        
        // collectionView 高度
        // |-(badgeCount / 3） *（20 + 112）-|
        let collectionViewHeight = CGFloat((badgeCount / 3) * 132)

        // contentView
        contectView.layer.cornerRadius = commonCornerRadius
        contectView.backgroundColor = UIColor(named: .HomeViewMainColor)
        contectView.snp_makeConstraints { (make) in
            
            // |-16-|-tableView-|-10-|-badgeView-10- -50- -8- collectionView -|-20-|-logoutButton-50-|-20-|
            make.height.equalTo(16 + tableViewHeight + 10 + 68 + collectionViewHeight + 20 + 50 + 20)
        }
        
        
        addTableView()
        
        
        addBadgeView(collectionViewHeight)
        
        // 退出登录按钮
        logoutButton.layer.cornerRadius = commonCornerRadius
        logoutButton.backgroundColor = UIColor(named: .ContactsAccountLogoutButton)
        
        }

    /**
     添加TableView
     */
    func  addTableView(){
        
        tableView.layer.cornerRadius = commonCornerRadius
        tableView.backgroundColor = UIColor(named: .HomeViewMainColor)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.registerNib(UINib(nibName: "ContactsPersonInfoCell", bundle: nil), forCellReuseIdentifier: "ContactsPersonInfoCell")
        tableView.registerNib(UINib(nibName: "ContactsPersonInfoListCell", bundle: nil), forCellReuseIdentifier: "ContactsPersonInfoListCell")
        
    }
    
    /**
     添加 CollectionView
     */
    func addBadgeView(height: CGFloat) {
        
        
        badgeView.snp_makeConstraints { (make) in
            
            // |-16-|-tableView-|-10-|-badgeView-10- -50- -8- collectionView -|-20-|-logoutButton-50-|-20-|
            make.height.equalTo(68 + height)
        }
        badgeInfo.text = "\(L10n.ContactsShowInfoAchievement.string)\(500000)\(L10n.GuideStep.string)"
        badgeInfo.textColor = UIColor(named: .ContactsAccountLogoutButton)
        badgeTitle.text = L10n.ContactsShowInfoAchievement.string
        
        collectionView.layer.cornerRadius = commonCornerRadius
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: "ContactsAccountBadgeCell", bundle: nil), forCellWithReuseIdentifier: "collectionIdentifier")
        collectionView.snp_makeConstraints { (make) in
            // |-10-|-50-|-8-|-(badgeCount / 3 * 112 + 20)-|
            make.height.equalTo(height)
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - UITableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellCount
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 136
            
        } else {
            
            return 50
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 第一个
        if indexPath.row == 0 {
            
            // 个人信息
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonInfoCell", forIndexPath: indexPath) as! ContactsPersonInfoCell
            cell.personRealtion(.OwnRelation)
            cell.addAccountData("hahahhah", accountName: "2768682000")
            return cell
                        
            
        } else {
            
            // 其他数值
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonInfoListCell", forIndexPath: indexPath) as! ContactsPersonInfoListCell
            cell.addData(infoTitleArray[indexPath.row - 1], titleInfo: "11000", cellEditOrNot: false)
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row ==  cellCount - 1 {
            // 退出登录
            
        } else {
            
            //无点击效果
            return
            
        }
        
    }
    
    
    // MARK: - UICollectionView Delegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return badgeCount
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionIdentifier", forIndexPath: indexPath)
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(90, 132)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    

}

extension ContactsAccountInfoVC: AccountInfoDelegate {
    
    var userId: String { return "56d6ea3bd34635186c60492b" }
    
    var viewController: UIViewController?
    {
        return self
    }
}

