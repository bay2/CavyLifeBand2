//
//  ContactsViewController.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions


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
        
        let contactVC = ContactsViewController()
        
        contactVC.requestAction()
        
    }
    
}


class ContactsViewController: UITableViewController{


    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.separatorStyle = .None
        self.tableView.showsVerticalScrollIndicator = false
//        self.tableView.delaysContentTouches = false
        //注册cell
        tableView.registerNib(UINib(nibName: "ContactsSearchTVCell", bundle: nil), forCellReuseIdentifier: "ContactsSearchTVCell")
        
        
        
    }
    
    @IBAction func backAction(sender: AnyObject) {
        
        print(__FUNCTION__)
        
    }

    @IBAction func searchAction(sender: AnyObject) {
        
        print(__FUNCTION__)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestAction() {
        print(__FUNCTION__)
        let requestVC = StoryboardScene.Contacts.instantiateRquestView()
        self.pushVC(requestVC)
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 66
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsListTVCell") as! ContactsListTVCell
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactsSearchTVCell", forIndexPath: indexPath) as! ContactsSearchTVCell
//        
//        cell.selectionStyle = .Default
//        
//        
//        
//        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let viewMode = SearchCellViewModel()
        cell.configure(viewMode, delegate: viewMode)
        
        
        return cell
    }
    
    // 点击事件
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        print(__FUNCTION__)
        
        
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deletRowAction = UITableViewRowAction(style: .Default, title: L10n.ContactsListCellDelete.string) {
        
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            tableView.editing = false
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        
        deletRowAction.backgroundColor = UIColor(named: .ContactsDeleteBtnColor)
        
        let concernAction = UITableViewRowAction(style: .Default, title: L10n.ContactsListCellAttention.string) {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            tableView.editing = false
        }
        
        concernAction.backgroundColor = UIColor(named: .ContactsAttentionBtnColor)
        
        return [concernAction, deletRowAction]
    }
       
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.

            return true

    }
        
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
