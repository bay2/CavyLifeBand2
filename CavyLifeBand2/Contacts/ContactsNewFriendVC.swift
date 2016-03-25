//
//  ContactsNewFriendVC.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class ContactsNewFriendVC: ContactsBaseViewController {

    @IBOutlet weak var newFriendTableView: UITableView!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        newFriendTableView.registerNib(UINib(nibName: "ContactsSearchTVCell", bundle: nil), forCellReuseIdentifier: "ContactsSearchTVCell")

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

        guard let contactsCell = tableView.dequeueReusableCellWithIdentifier("ContactsSearchTVCell", forIndexPath: indexPath) as? ContactsSearchTVCell else {
            return tableView.dequeueReusableCellWithIdentifier("ContactsSearchTVCell", forIndexPath: indexPath)
        }

        let viewModel = ContactsNewFriendTableViewModel()

        contactsCell.configure(viewModel, delegate: viewModel)
        
        return contactsCell

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5

    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 66

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: false)

    }


}
