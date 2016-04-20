//
//  ContactsAccountInfoVC.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/23.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import SnapKit
import Log
import JSONJoy
import RealmSwift
import EZSwiftExtensions

protocol AccountItemDataSource {
    associatedtype viewModeType
}

class ContactsAccountInfoVC: UIViewController, BaseViewControllerPresenter, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UserInfoRealmOperateDelegate
{
    
    var realm: Realm = try! Realm()
    
    /// scrollView的ContectView
    @IBOutlet weak var contectView: UIView!
    
    /// tableView
    @IBOutlet weak var tableView: UITableView!
    
    ///  徽章视图
    @IBOutlet weak var badgeView: UIView!
    
    /// 成就数值
    @IBOutlet weak var badgeInfo: UILabel!
    
    /// 成就
    @IBOutlet weak var badgeTitle: UILabel!
    
    /// 徽章视图
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// 退出登录
    @IBOutlet weak var logoutButton: UIButton!
    
    /// 成就步数
    let badgeStep: Int = 500000
    
    /// 徽章个数
    var badgeCount: Int = 6
    
    var navTitle: String = L10n.AccountInfoTitle.string
    
    var accountInfos: Array<AnyObject?> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        accountInfoQuery()
        
        addAllViews()
        
        self.updateNavUI()
        
    }
    
    /**
     加载账户信息
     */
    func accountInfoQuery() {
        
        guard let accountInfo = queryUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) else {
            Log.error("Get account info error !")
            return
        }
        
        let userName = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername
        let gender = CavyDefine.definiteAccountSex(accountInfo.sex.toString)
        
        let headCellViewModle  = PresonInfoCellViewModel(title: accountInfo.nickname, subTitle: userName, avatarUrl: accountInfo.avatarUrl)
        let genderCellViewModel = PresonInfoListCellViewModel(title: L10n.ContactsShowInfoGender.string, info: gender)
        let heightCellViewModel = PresonInfoListCellViewModel(title: L10n.ContactsShowInfoHeight.string, info: "\(accountInfo.height)cm")
        let weightCellViewModel = PresonInfoListCellViewModel(title: L10n.ContactsShowInfoWeight.string, info: "\(accountInfo.weight)kg")
        let birthCellViewModel = PresonInfoListCellViewModel(title: L10n.ContactsShowInfoBirth.string, info: accountInfo.birthday)
        let addressCellViewModel = PresonInfoListCellViewModel(title: L10n.ContactsShowInfoAddress.string, info: accountInfo.address)
        
        accountInfos.append(headCellViewModle)
        accountInfos.append(genderCellViewModel)
        accountInfos.append(heightCellViewModel)
        accountInfos.append(weightCellViewModel)
        accountInfos.append(birthCellViewModel)
        accountInfos.append(addressCellViewModel)
        
    }
    
    
    /**
     添加 TableView视图
     */
    func addAllViews() {
        
        // InfoTableView高度
        // |-infoListCell-136-|-cellCount-1[infoListCell] * 50-|-边10-|
        let tableViewHeight = CGFloat(136 + (accountInfos.count - 1) * 50 + 10)
        
        // collectionView 高度
        // |-(badgeCount / 3） *（20 + 112）-|
        let collectionViewHeight = CGFloat((badgeCount / 3) * 132)

        // contentView
        contectView.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        contectView.backgroundColor = UIColor(named: .HomeViewMainColor)
        contectView.snp_makeConstraints { (make) in
            
            // |-16-|-tableView-|-10-|-badgeView-10- -50- -8- collectionView -|-20-|-logoutButton-50-|-20-|
            make.height.equalTo(16 + tableViewHeight + 10 + 68 + collectionViewHeight + 20 + 50 + 20)
        }
        
        
        addTableView()
        addBadgeView(collectionViewHeight)
        
        // 退出登录按钮
        logoutButton.setTitle(L10n.AccountInfoLoginoutButtonTitle.string, forState: .Normal)
        logoutButton.layer.cornerRadius = CavyDefine.commonCornerRadius
        logoutButton.backgroundColor = UIColor(named: .ContactsAccountLogoutButton)
        logoutButton.setBackgroundColor(UIColor(named: .ContactsAccountLogoutButton), forState: .Normal)
        
        logoutButton.addTapGesture { _ in
            
            CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = ""
            
            self.presentVC(UINavigationController(rootViewController: StoryboardScene.Main.instantiateMainPageView()))
            
        }
        
    }

    /**
     添加TableView
     */
    func  addTableView(){
        
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
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
        
        badgeView.layer.cornerRadius = CavyDefine.commonCornerRadius
        badgeView.snp_makeConstraints { (make) in
            
            // |-16-|-tableView-|-10-|-badgeView-10- -50- -8- collectionView -|-20-|-logoutButton-50-|-20-|
            make.height.equalTo(68 + height)
        }
        badgeTitle.textColor = UIColor(named: .ContactsTitleColor)
        badgeTitle.text = L10n.ContactsShowInfoAchievement.string
        
        // 成就数值显示
        let string = String.numberDecimalFormatter(badgeStep)
        badgeInfo.text = "\(string)\(L10n.GuideStep.string)"
        badgeInfo.font = UIFont.italicFontWithSize(16)
        badgeInfo.textColor = UIColor(named: .ContactsAccountLogoutButton)
        
        collectionView.layer.cornerRadius = CavyDefine.commonCornerRadius
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
        
        return accountInfos.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 136
            
        } else {
            
            return 50
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cellViewModel = accountInfos[indexPath.row] as? PresonInfoListCellViewModel {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonInfoListCell", forIndexPath: indexPath) as! ContactsPersonInfoListCell
            cell.configCell(cellViewModel)
            return cell
            
        }
        
        if let cellViewModel = accountInfos[indexPath.row] as? PresonInfoCellViewModel {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonInfoCell", forIndexPath: indexPath) as! ContactsPersonInfoCell
            cell.configCell(cellViewModel)
            return cell
            
        }
        
        return tableView.dequeueReusableCellWithIdentifier("ContactsPersonInfoListCell", forIndexPath: indexPath) as! ContactsPersonInfoListCell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        return

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

