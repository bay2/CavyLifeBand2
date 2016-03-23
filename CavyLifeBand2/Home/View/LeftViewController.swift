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

class LeftViewController: UIViewController, HomeUserDelegate {

    @IBOutlet weak var userInfoView: HomeUserInfo!
    @IBOutlet weak var leftTableView: UITableView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var accountLab: UILabel!
    @IBOutlet weak var userNameLab: UILabel!
    
    var iconImage: UIImageView { return iconImageView }
    var userName: UILabel { return userNameLab }
    var account: UILabel { return accountLab }
    
    let listTitle = [[L10n.HomeLifeListTitleTarget.string, L10n.HomeLifeListTitleInfoOpen.string, L10n.HomeLifeListTitleFriend.string, L10n.HomeLifeListTitlePK.string],
        [L10n.HomeLifeListTitleAbout.string, L10n.HomeLifeListTitleHelp.string, L10n.HomeLifeListTitleRelated.string]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableViewStyle()
        
        userInfoView.configuration(self)

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

struct LeftListViewModel: LeftListCellDateSource, LeftListCellDelegate {
    
    var title: String
    var icon: UIImage

    init() {

        icon = UIImage(asset: .LeftMenuAbout)
        title = ""

    }

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

        var viewModel = LeftListViewModel()
        viewModel.title = listTitle[indexPath.section][indexPath.row]

        listCell.configure(viewModel, delegate: viewModel)

        return listCell
    }

    /**
     行数
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listTitle[section].count

    }

    /**
     section 个数
     
     - parameter tableView:
     
     - returns:
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 2 }
    
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
