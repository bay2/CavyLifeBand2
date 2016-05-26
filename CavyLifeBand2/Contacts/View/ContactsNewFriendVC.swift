//
//  ContactsNewFriendVC.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

extension ContactsNewFriendData: ContactsTableViewSectionDataSource {
    
    var rowCount: Int { return items.count }
    
    func createCell(tableView: UITableView, index: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("ContactsAddFriendCell", forIndexPath: index) as? ContactsAddFriendCell else {
            fatalError()
        }
        
        cell.configure(items[index.row], delegate: items[index.row])
        
        return cell
        
    }
    
}

class ContactsNewFriendVC: UIViewController, BaseViewControllerPresenter {
    
    var navTitle: String { return L10n.ContactsTitle.string }

    @IBOutlet weak var newFriendTableView: UITableView!
    
    var newFriendData: ContactsNewFriendData!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.updateNavUI()

        newFriendTableView.registerNib(UINib(nibName: "ContactsAddFriendCell", bundle: nil), forCellReuseIdentifier: "ContactsAddFriendCell")
        
        newFriendData = ContactsNewFriendData(viewController: self, tableView: newFriendTableView)
        
        newFriendData.loadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ContactsNewFriendVC {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        return newFriendData.createCell(tableView, index: indexPath)

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return newFriendData?.rowCount ?? 0

    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 66

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let requestVC = StoryboardScene.Contacts.instantiateContactsPersonInfoVC()
        requestVC.friendId = newFriendData.items[indexPath.row].friendId
        requestVC.friendNickName = newFriendData.items[indexPath.row].name
        self.pushVC(requestVC)

    }


}
