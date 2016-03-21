//
//  ContactsViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

var testDataSource = [["aaaab", "aaac"], ["bbbbc", "bbbba"], ["cbbbc", "cbbba"], ["dbbbc", "dbbba"], ["ebbbc", "ebbba"], ["fbbbc", "fbbba"], ["gbbbc", "gbbba"], ["hbbbc", "hbbba"], ["ibbbc", "ibbba"], ["jbbbc", "jbbba"], ["kbbbc", "kbbba"], ["lbbbc", "lbbba"], ["nbbbc", "nbbba"], ["mbbbc", "mbbba"], ["obbbc", "obbba"], ["pbbbc", "pbbba"], ["qbbbc", "qbbba"], ["rbbbc", "rbbba"], ["sbbbc", "sbbba"], ["tbbbc", "tbbba"], ["ubbbc", "ubbba"], ["vbbbc", "vbbba"], ["wbbbc", "wbbba"], ["xbbbc", "xbbba"], ["ybbbc", "ybbba"], ["zbbbc", "zbbba"]]
    
struct SearchCellViewModel: ContactsSearchCellDataSource, ContactsSearchCellDelegate{
    
    var headImage: UIImage { return UIImage(asset: .GuidePairSeccuss) }
    var name: String { return "strawberry❤️" }
    var introudce: String { return " 我爱吃草莓啊~~~" }
    var requestBtnTitle: String { return "添加" }
    
    
    var nameTextColor: UIColor { return UIColor(named: .ContactsName) }
    var introductTextColor: UIColor { return UIColor(named: .ContactsIntrouduce) }
    var nameFont: UIFont { return UIFont.systemFontOfSize(14) }
    var introduceFont: UIFont { return UIFont.systemFontOfSize(12) }
    var requestBtnColor: UIColor { return UIColor(named: .ContactsName) }
    var requestBtnFont: UIFont { return UIFont.systemFontOfSize(14) }
    
    func changeRequestBtnName(name: String) {
        
        var requestBtnTitle: String { return name }
//        ContactsViewController.requestAction()
    }
    
}


class ContactsViewController: ContactsBaseViewController, UISearchResultsUpdating {

    let defulatDataSource = [L10n.ContactsAddFriendsCell.string, L10n.ContactsListCellCavy.string]

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var contactsTable: UITableView!
    var searchCtrl  = ContactsSearchController(searchResultsController: StoryboardScene.Contacts.instantiateSearchResultView())
    var searchCtrlView = StoryboardScene.Contacts.instantiateSearchResultView().view

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)

        configureSearchController()

    }

    func configureSearchController() {

        searchView.addSubview(searchCtrl.contactsSearchBar!)

        searchCtrl.searchResultsUpdater = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     sections 个数
     
     - parameter tableView:
     
     - returns:
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return testDataSource.count + 1

    }

    func requestAction() {
        
        print("添加好友啊")
        let requestVC = StoryboardScene.Contacts.instantiateRquestView()
        self.pushVC(requestVC)
        
        
    }

    /**
     row 数
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }
        
        return testDataSource[section - 1].count
    }
    
    /**
     cell 高度
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 66
    }
    
    /**
     section 高度
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        
        return 30
    }
    
    /**
     创建cell
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerNib(UINib(nibName: "ContactsListTVCell", bundle: nil), forCellReuseIdentifier: "ContactsListTVCell")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsListTVCell", forIndexPath: indexPath)  as! ContactsListTVCell
        
        if indexPath.section == 0 {
            
            cell.nameLabel.text = defulatDataSource[indexPath.row]
            cell.editing = false
            
        } else {
            
            cell.nameLabel.text = testDataSource[indexPath.section - 1][indexPath.row]

        }

/*
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsSearchTVCell", forIndexPath: indexPath) as! ContactsSearchTVCell

        cell.selectionStyle = .Gray
        
        let viewMode = SearchCellViewModel()
        cell.configure(viewMode, delegate: viewMode)
        cell.requestBtn.addTarget(self, action: "requestAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        let cellBgView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, 66))
        cellBgView.backgroundColor = UIColor(named: .ContactsCellSelect)
        cell.backgroundView = cellBgView
        
        */

        return cell
    }
    
    /**
     创建section
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }
        
        let letterView = NSBundle.mainBundle().loadNibNamed("ContactsLetterView", owner: nil, options: nil).first as? ContactsLetterView
        
        return letterView
        
    }
    
    /**
     点击事件cell
     
     - parameter tableView:
     - parameter indexPath:
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    /**
     左滑按钮
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.section == 0 {
            return nil
        }
        
        let deletRowAction = UITableViewRowAction(style: .Default, title: L10n.ContactsListCellDelete.string) {
            
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            if testDataSource[indexPath.section - 1].count == 1 {
                
                tableView.beginUpdates()
                testDataSource[indexPath.section - 1].removeAtIndex(indexPath.row)
                testDataSource.removeAtIndex(indexPath.section - 1)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
                tableView.endUpdates()
                
            } else {
                
                testDataSource[indexPath.section - 1].removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
            }
            
        }

        deletRowAction.backgroundColor = UIColor(named: .ContactsDeleteBtnColor)
        
        let concernAction = UITableViewRowAction(style: .Default, title: L10n.ContactsListCellAttention.string) {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            tableView.editing = false
        }

        concernAction.backgroundColor = UIColor(named: .ContactsAttentionBtnColor)

        let pkRowAction = UITableViewRowAction(style: .Default, title: " PK ") {_, _ in

            tableView.editing = false

        }

        pkRowAction.backgroundColor = UIColor(named: .ContactsPKBtnColor)


        return [deletRowAction, concernAction, pkRowAction]
    }
    
    /**
     cell 编辑类型
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
       
        if indexPath.section == 0 {
            return .None
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.backgroundColor = UIColor(named: .ContactsCellSelect)
        
        return .Delete
        
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.backgroundColor = UIColor.whiteColor()

    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {

        if searchCtrl.isSearching {

//            self.view.addSubview(searchCtrlView)
            self.navigationController?.setNavigationBarHidden(true, animated: true)

        } else {

//            searchCtrlView.removeFromSuperview()
            self.navigationController?.setNavigationBarHidden(false, animated: true)

        }

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
