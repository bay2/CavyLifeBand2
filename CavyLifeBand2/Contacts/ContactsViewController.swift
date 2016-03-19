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

class ContactsViewController: ContactsBaseViewController {
    
    let defulatDataSource = [L10n.ContactsListCellAddFriendrTitle.string, L10n.ContactsListCellCavy.string]

    @IBOutlet weak var contactSearch: UISearchBar!
    @IBOutlet weak var contactsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactSearch.tintColor = UIColor(named: .ContactsSearchBarColor)
        contactSearch.placeholder = L10n.ContactsSearchBarSearch.string
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsListTVCell", forIndexPath: indexPath)
        
        let myCell = cell as! ContactsListTVCell
        
        if indexPath.section == 0 {
            
            myCell.nameLabel.text = defulatDataSource[indexPath.row]
            myCell.editing = false
            
        } else {
            
            myCell.nameLabel.text = testDataSource[indexPath.section - 1][indexPath.row]
            
        }
        
        return myCell
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
        
        return [concernAction, deletRowAction]
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
        
        return .Delete
        
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
