//
//  LeftViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import SnapKit
import EZSwiftExtensions

struct LeftListViewModel: LeftListCellDateSource, LeftListCellDelegate, LeftMenuPushViewDelegate {

    var title: String
    var icon: UIImage
    var nextView: UIViewController

    init(icon: UIImage, title: String, nextView: UIViewController) {

        self.icon = icon
        self.title = title
        self.nextView = nextView

    }

}

protocol LeftMenuPushViewDelegate {
    
    var nextView: UIViewController { get }
    
    func pushView()

}

extension LeftMenuPushViewDelegate {
    
    func pushView() {
        
        let userInfo = ["nextView": self.nextView] as [NSObject: AnyObject]

        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeLeftOnClickCellPushView.rawValue, object: nil, userInfo: userInfo)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeLeftHiddenMenu.rawValue, object: nil)

    }
    
}


class LeftViewController: UIViewController, HomeUserDelegate {
  
    @IBOutlet weak var userInfoView: HomeUserInfo!
    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var accountLab: UILabel!
    @IBOutlet weak var userNameLab: UILabel!
    
    var iconImage: UIImageView { return iconImageView }
    var userName: UILabel { return userNameLab }
    var account: UILabel { return accountLab }

    // 列表信息
    var listTitleViewModel = [[LeftListViewModel(icon: UIImage(asset: .LeftMenuTarget), title: L10n.HomeLifeListTitleTarget.string, nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()),
    LeftListViewModel(icon: UIImage(asset: .LeftMenuInformation), title: L10n.HomeLifeListTitleInfoOpen.string, nextView: StoryboardScene.InfoSecurity.AccountInfoSecurityVCScene.viewController()),
    LeftListViewModel(icon: UIImage(asset: .LeftMenuFriend), title: L10n.HomeLifeListTitleFriend.string, nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()),
    LeftListViewModel(icon: UIImage(asset: .LeftMenuPK), title: L10n.HomeLifeListTitlePK.string, nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController())],
    [LeftListViewModel(icon: UIImage(asset: .LeftMenuAbout), title: L10n.HomeLifeListTitleAbout.string, nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()),
    LeftListViewModel(icon: UIImage(asset: .LeftMenuHelp), title: L10n.HomeLifeListTitleHelp.string, nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()),
    LeftListViewModel(icon: UIImage(asset: .LeftMenuApp), title: L10n.HomeLifeListTitleRelated.string, nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController())]]

    override func viewDidLoad() {
        super.viewDidLoad()

        setTableViewStyle()
        
        userInfoView.configuration(self)
        
        iconImageView.addTapGesture { _ in
            
            self.userInfoView.pushView()
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setTableViewStyle() {

        leftTableView.backgroundColor = UIColor(named: .HomeViewMainColor)
        leftTableView.tableFooterView = UIView()
        leftTableView.tableHeaderView = UIView()

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



extension LeftViewController {
    

    /**
     创建cell
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let listCell = tableView.dequeueReusableCellWithIdentifier("LeftCell", forIndexPath: indexPath) as! LeftTableViewCell

        listCell.configure(listTitleViewModel[indexPath.section][indexPath.row], delegate: listTitleViewModel[indexPath.section][indexPath.row])

        return listCell
    }

    /**
     行数
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listTitleViewModel[section].count

    }

    /**
     section 个数
     
     - parameter tableView:
     
     - returns:
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return listTitleViewModel.count }
    
    /**
     高度
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return 50 }

    /**
     header 视图
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UIView()
        }
        
        return LeftHeaderView(frame: CGRectMake(0, 0, ez.screenWidth, 20))

    }

    /**
     cell 点击处理
     
     - parameter tableView:
     - parameter indexPath:
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        listTitleViewModel[indexPath.section][indexPath.row].pushView()

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
