//
//  LeftMenViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import SnapKit
import EZSwiftExtensions
import RealmSwift


class LeftMenViewController: UIViewController, HomeUserDelegate, UserInfoRealmOperateDelegate {
  
    @IBOutlet weak var userInfoView: HomeUserInfo!
    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var accountLab: UILabel!
    @IBOutlet weak var userNameLab: UILabel!
    
    var realm = try! Realm()
    
    var menuGroup: [MenuGroupDataSource] = []
    
    var userName: UILabel { return userNameLab }
    var account: UILabel { return accountLab }
    
    var notificationToken: NotificationToken? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        setTableViewStyle()
        
        userInfoView.configuration(self)
        
        iconImageView.addTapGesture { _ in
            
            let userInfo = ["nextView": StoryboardScene.AccountInfo.instantiateContactsAccountInfoVC()] as [NSObject: AnyObject]
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomePushView.rawValue, object: nil, userInfo: userInfo)
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowHomeView.rawValue, object: nil)
            
        }
        
        addMenumenuGroupData(AppFeatureMenuGroupDataModel())
        addMenumenuGroupData(AppAboutMenuGroupDataModel())
        
        let userInfos: Results<UserInfoModel> = queryUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId)
        
        
        notificationToken = userInfos.addNotificationBlock { (changes: RealmCollectionChange) in
            
            switch changes {
                
            case .Initial(let value):
                self.updateUI(value)
                
            case .Update(let value, deletions: _, insertions: _, modifications: _):
                self.updateUI(value)
                
            default:
                break
                
            }
            
        }
        
    }
    
    func updateUI(result: Results<UserInfoModel>) {
        
             self.userName.text = result.first?.nickname ?? ""
        self.iconImageView.af_setCircleImageWithURL(NSURL(string: result.first?.avatarUrl ?? "")!, placeholderImage: UIImage(asset: .DefaultHead_big))
        self.account.text = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUsername
    
    }
    
    /**
     添加菜单组数据
     
     - parameter menuGroup:
     */
    func addMenumenuGroupData(menuGroup: MenuGroupDataSource) {
        self.menuGroup.append(menuGroup)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     设置tableview
     */
    func setTableViewStyle() {

        leftTableView.backgroundColor = UIColor(named: .HomeViewMainColor)
        leftTableView.tableFooterView = UIView()
        leftTableView.tableHeaderView = UIView()
        leftTableView.registerNib(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")

    }

}



extension LeftMenViewController {
    

    /**
     创建cell
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuTableViewCell", forIndexPath: indexPath)
        
        guard let cellMenu = cell  as? MenuTableViewCell else {
            return cell
        }
        
        let menuViewModel = menuGroup[indexPath.section].items[indexPath.row]
        
        cellMenu.configure(menuViewModel, delegate: menuViewModel)
            
        return cellMenu
    }

    /**
     行数
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuGroup[section].rowCount

    }

    /**
     section 个数
     
     - parameter tableView:
     
     - returns:
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return menuGroup.count }
    
    /**
     高度
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return menuGroup[indexPath.section].items[indexPath.row].cellHeight
    }

    /**
     header 视图
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return menuGroup[section].sectionView
    }

    /**
     cell 点击处理
     
     - parameter tableView:
     - parameter indexPath:
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        menuGroup[indexPath.section].refurbishNextView()
        
        guard let nextView = menuGroup[indexPath.section].items[indexPath.row].nextView else {
            return
        }
        
        let userInfo = ["nextView": nextView] as [NSObject: AnyObject]
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomePushView.rawValue, object: nil, userInfo: userInfo)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowHomeView.rawValue, object: nil)

    }

    /**
     section 高度
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return menuGroup[section].sectionHeight

    }


}
