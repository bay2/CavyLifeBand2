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

class ContactsAccountInfoVC: UIViewController, BaseViewControllerPresenter, UITableViewDelegate, UITableViewDataSource, UserInfoRealmOperateDelegate {
    
    var realm: Realm = try! Realm()
    
    var notificationToken: NotificationToken? = nil
    
    /// scrollView的ContectView
    @IBOutlet weak var contectView: UIView!
    
    /// tableView
    @IBOutlet weak var tableView: UITableView!
    
    ///  徽章视图
    @IBOutlet weak var badgeView: UIView!
    
    /// 退出登录
    @IBOutlet weak var logoutButton: UIButton!
    
    /// 成就步数
    let badgeStep: Int = 500000
    
    /// 徽章个数
    var badgeCount: Int = 6
    
    var navTitle: String = L10n.AccountInfoTitle.string
    
    var accountInfos: Array<AnyObject?> = []
    
    let achieveView = NSBundle.mainBundle().loadNibNamed("UserAchievementView", owner: nil, options: nil).first as? UserAchievementView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        addAllViews()
        
        accountInfoQuery()
        
        self.updateNavUI()
        
    }
   
    deinit {
        
        notificationToken?.stop()
        
        Log.info("deinit ContactsAccountInfoVC")
        
    }
    
    /**
     加载账户信息
     */
    func accountInfoQuery() {
        
        let userInfos: Results<UserInfoModel> = queryUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId)
        
        notificationToken = userInfos.addNotificationBlock { [weak self] (changes: RealmCollectionChange)  in
            
            switch changes {
                
            case .Initial(let value):
                self?.updateUI(value)
                
            case .Update(let value, deletions: _, insertions: _, modifications: _):
                self?.updateUI(value)
                
            default:
                break
                
            }
        }
        
    }
    
    /**
     更新UI
     
     - parameter userInfos: 用户信息
     */
    func updateUI(userInfos: Results<UserInfoModel>) {
        
        guard let accountInfo = userInfos.first else {
            return
        }
        
        accountInfos.removeAll()
        
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
        
        self.tableView.reloadData()
                
        achieveView?.configWithAchieveIndexForUser([2,3])
        
    }
    
    
    /**
     添加 TableView视图
     */
    func addAllViews() {
        
        // InfoTableView高度
        // |-infoListCell-136-|-cellCount-1[infoListCell] * 50-|-边10-|
        let tableViewHeight = CGFloat(130 + 5 * 50 + 10 + 16)
        
        // collectionView 高度
        // |-(badgeCount / 3） *（20 + 112）-|
        let collectionViewHeight = CGFloat((badgeCount / 3) * 132)

        // contentView
        contectView.setCornerRadius(radius: CavyDefine.commonCornerRadius)
        
        contectView.backgroundColor = UIColor(named: .HomeViewMainColor)
        contectView.snp_makeConstraints { make in
            
            // |-16-|-tableView-|-10-|-badgeView-10- -50- -8- collectionView -|-20-|-logoutButton-50-|-20-|
            make.height.equalTo(16 + tableViewHeight + 10 + 68 + collectionViewHeight + 20 + 50 + 20)
        }
        
        addTableView()
        addBadgeView(collectionViewHeight)
        
        // 退出登录按钮
        logoutButton.setTitle(L10n.AccountInfoLoginoutButtonTitle.string, forState: .Normal)

        logoutButton.layer.cornerRadius = CavyDefine.commonCornerRadius
        logoutButton.clipsToBounds = true
        logoutButton.backgroundColor = UIColor(named: .QColor)
        logoutButton.setBackgroundColor(UIColor(named: .QColor), forState: .Normal)
        logoutButton.titleLabel?.font = UIFont.mediumSystemFontOfSize(18.0)
        logoutButton.setTitleColor(UIColor(named: .AColor), forState: .Normal)
                
        // 退出按钮手势
        logoutButton.addTapGesture { _ in
            
            NetWebApi.shareApi.netPostRequest(WebApiMethod.Logout.description, modelObject: CommenMsgResponse.self, successHandler: { (data) in
                CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId = ""
                CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername = ""
                CavyDefine.loginUserBaseInfo.loginUserInfo.loginAuthToken = ""
                
                UIApplication.sharedApplication().keyWindow?.setRootViewController(StoryboardScene.Main.instantiateMainPageView(), transition: CATransition())
                
                LifeBandBle.shareInterface.bleDisconnect()
            }, failureHandler: { (msg) in
                CavyLifeBandAlertView.sharedIntance.showViewTitle(message: msg.msg)
            })
            
            
            
        }
        
    }

    /**
     添加TableView
     */
    func addTableView(){
        
//        tableView.clipsToBounds = true
        tableView.setCornerRadius(radius: CavyDefine.commonCornerRadius)
        tableView.backgroundColor = UIColor.whiteColor() //(named: .HomeViewMainColor)
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
        
        badgeView.setCornerRadius(radius: CavyDefine.commonCornerRadius)
        badgeView.snp_makeConstraints { make in
            
            // |-16-|-tableView-|-10-|-badgeView-10- -50- -8- collectionView -|-20-|-logoutButton-50-|-20-|
            make.height.equalTo(68 + height)
        }
        
        badgeView.addSubview(achieveView!)
        achieveView!.snp_makeConstraints { make in
            make.left.right.top.bottom.equalTo(badgeView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return accountInfos.count > 0 ? 1 : 0
        }
        
        return accountInfos.count - 1 >= 0 ? accountInfos.count - 1 : 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 130
            
        } else {
            
            return 50
        }
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10
        }
        
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 16
        }
        
        return 0.01
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            let cellViewModel = accountInfos[indexPath.row] as! PresonInfoCellViewModel
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonInfoCell", forIndexPath: indexPath) as! ContactsPersonInfoCell
            cell.configCell(cellViewModel, delegate: cellViewModel)
            return cell
            
        } else {
            
            let cellViewModel = accountInfos[indexPath.row + 1] as? PresonInfoListCellViewModel
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonInfoListCell", forIndexPath: indexPath) as! ContactsPersonInfoListCell
            cell.configCell(cellViewModel!)
            return cell
            
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            // 跳转到修改备注
            let requestVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
            
            let changeNicknameVM = UserChangeNicknameVM(viewController: requestVC)
            
            requestVC.viewConfig(changeNicknameVM)
            
            self.pushVC(requestVC)
        } else {
            
            if indexPath.row == accountInfos.count - 2 {
                // 跳转到修改地址
                let requestVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
                
                let changeRemarkVM = UserChangeAddressVM(viewController: requestVC)
                
                requestVC.viewConfig(changeRemarkVM)
                
                self.pushVC(requestVC)
                
                return
            }
            
            let nextVC = StoryboardScene.Guide.instantiateGuideView()
                    
            switch indexPath.row {
            case 0:
                let nextVM = AccountGenderViewModel()
                nextVC.configView(nextVM, delegate: nextVM)
            case 1:
                let nextVM = AccountHeightViewModel()
                nextVC.configView(nextVM, delegate: nextVM)
            case 2:
                let nextVM = AccountWeightViewModel()
                nextVC.configView(nextVM, delegate: nextVM)
            case 3:
                let nextVM = AccountBirthdayViewModel()
                nextVC.configView(nextVM, delegate: nextVM)
            default:
                break
            }
            
            self.pushVC(nextVC)
        
        }

    }
    
}

