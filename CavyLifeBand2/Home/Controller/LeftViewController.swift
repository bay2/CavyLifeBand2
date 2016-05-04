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


class LeftMenViewController: UIViewController, HomeUserDelegate {
  
    @IBOutlet weak var userInfoView: HomeUserInfo!
    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var accountLab: UILabel!
    @IBOutlet weak var userNameLab: UILabel!
    
    var menuGroup: [MenuGroupDataSource] = []
    
    var iconImage: UIImageView { return iconImageView }
    var userName: UILabel { return userNameLab }
    var account: UILabel { return accountLab }

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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        
        let nextView = menuGroup[indexPath.section].items[indexPath.row].nextView
        
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

        if section == 0 {
            return 16
        }

        return 10

    }


}
