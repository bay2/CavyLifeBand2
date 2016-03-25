//
//  ContactsViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

struct ContactsModelView: ContactsListTVCellDataSource {

    var name: String
    var headImage: UIImage
    var hiddenCare: Bool
    var viewController: UIViewController?

    init(name: String, headImage: UIImage = UIImage(asset: .GuidePairSeccuss), hiddenCare: Bool = true) {

        self.name = name
        self.headImage = headImage
        self.hiddenCare = hiddenCare

    }

    func onClickCell(viewController: UIViewController) {

    }

}

struct ContactsAddFriendModelView: ContactsListTVCellDataSource {

    var name: String { return L10n.ContactsAddFriendsCell.string }
    var headImage: UIImage { return UIImage(asset: .ContactsListAdd) }
    var hiddenCare: Bool = true

    func onClickCell(viewController: UIViewController) {

        viewController.pushVC(StoryboardScene.Contacts.instantiateSearchView())

    }

}


struct ContactsNewFriendCellModelView: ContactsListTVCellDataSource {

    var name: String { return L10n.ContactsNewFriendsCell.string }
    var headImage: UIImage { return UIImage(asset: .ContactsListNew) }
    var hiddenCare: Bool = true
    
    func onClickCell(viewController: UIViewController) {

        viewController.pushVC(StoryboardScene.Contacts.instantiateContactsNewFriend())
        
    }

}

struct ContactsCavyModelView: ContactsListTVCellDataSource {

    var name: String { return L10n.ContactsListCellCavy.string }
    var headImage: UIImage { return UIImage(asset: .ContactsListCavy) }
    var hiddenCare: Bool = true

    func onClickCell(viewController: UIViewController) {

    }

}

class ContactsViewController: ContactsBaseViewController, UISearchResultsUpdating {

    let defulatDataSource: [ContactsListTVCellDataSource] = [ContactsAddFriendModelView(), ContactsNewFriendCellModelView(), ContactsCavyModelView()]

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var contactsTable: UITableView!

    var searchCtrl  = ContactsSearchController(searchResultsController: StoryboardScene.Contacts.instantiateSearchResultView())
    var searchCtrlView = StoryboardScene.Contacts.instantiateSearchResultView().view
    
    var dataSource: [ContactsListTVCellDataSource] = [ContactsModelView(name: "吖吖的"), ContactsModelView(name: "闭包"),
                                                      ContactsModelView(name: "八卦镇"), ContactsModelView(name: "东波排骨")]
    var dataGroup: ContactsSortAndGroup?

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        

        dataGroup = ContactsSortAndGroup(contactsList: dataSource)
        
        dataGroup!.contactsGroupList!.insertAsFirst(("", defulatDataSource))
        
        configureSearchController()
        

    }

    func pushAddFriendView() {

        self.pushVC(StoryboardScene.Contacts.instantiateSearchView())

    }

    /**
     配置搜索Controller
     */
    func configureSearchController() {

        searchView.addSubview(searchCtrl.contactsSearchBar!)

        searchCtrl.searchResultsUpdater = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func requestAction() {
        
        let requestVC = StoryboardScene.Contacts.instantiateRquestView()
        self.pushVC(requestVC)

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

extension ContactsViewController {
    
    /**
     cell 编辑结束
     
     - parameter tableView:
     - parameter indexPath:
     */
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? ContactsListTVCell
        cell?.showEditing(false)
        
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
        
        var names = self.dataGroup!.contactsGroupList![indexPath.section].1
        
        let deletRowAction = UITableViewRowAction(style: .Default, title: L10n.ContactsListCellDelete.string) { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            if names.count == 1 {
                
                tableView.beginUpdates()
                self.dataSource.removeAtIndex(indexPath.section)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
                tableView.endUpdates()
                
            } else {
                
                names.removeAtIndex(indexPath.row)
                
                self.dataGroup!.contactsGroupList![indexPath.section].1 = names
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
            }
            
        }
        
        deletRowAction.backgroundColor = UIColor(named: .ContactsDeleteBtnColor)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? ContactsListTVCell
        
        let concernActionTitle = cell!.hiddenCare ? L10n.ContactsListCellCare.string : L10n.ContactsListCellUndoCare.string
        let concernActionColor = cell!.hiddenCare ? UIColor(named: .ContactsCareBtnColor) : UIColor(named: .ContactsUndoCareBtnColor)
        
        let concernAction = UITableViewRowAction(style: .Default, title: concernActionTitle) {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            tableView.editing = false
            
            cell?.hiddenCare = !cell!.hiddenCare
            names[indexPath.row].hiddenCare = cell!.hiddenCare
            
        }

        concernAction.backgroundColor = concernActionColor
        
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
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? ContactsListTVCell
        
        cell?.showEditing(true)
        
        return .Delete
        
    }
    
    /**
     row 数
     
     - parameter tableView:
     - parameter section:
     
     - returns:
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let names = self.dataGroup!.contactsGroupList![section].1
        
        return names.count
        
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
        
        return 28
    }
    
    /**
     创建cell
     
     - parameter tableView:
     - parameter indexPath:
     
     - returns:
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerNib(UINib(nibName: "ContactsListTVCell", bundle: nil), forCellReuseIdentifier: "ContactsListTVCell")
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsListTVCell", forIndexPath: indexPath) as! ContactsListTVCell
        
        var names = self.dataGroup!.contactsGroupList
        
        
        cell.configure(names![indexPath.section].1[indexPath.row])
        
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
        letterView?.title.text = dataGroup?.contactsGroupList![section].0
        
        return letterView
        
    }
    
    /**
     点击事件cell
     
     - parameter tableView:
     - parameter indexPath:
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let names = dataGroup?.contactsGroupList![indexPath.section].1
        names![indexPath.row].onClickCell(self)
        
    }
    
    /**
     sections 个数
     
     - parameter tableView:
     
     - returns:
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return dataGroup!.contactsGroupList!.count
        
    }
    
}
