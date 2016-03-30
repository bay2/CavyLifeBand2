//
//  AccountInfoSecurityVC.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/30.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class AccountInfoSecurityVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let titleArray = ["", L10n.ContactsShowInfoHeight.string, L10n.ContactsShowInfoWeight.string, L10n.ContactsShowInfoBirth.string, ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        addTableView()
        
    }
    
    
    func addTableView() {
        
        tableView.registerNib(UINib(nibName: "AccountInfoSecurityCell", bundle: nil), forCellReuseIdentifier: "infoSecurityIdentifier")
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 4 {
            return 10
        }
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 || indexPath.row == 4 {
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "infoSecurityWhiteCell")
            let cell = tableView.dequeueReusableCellWithIdentifier("infoSecurityWhiteCell")
            
            return cell!
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("infoSecurityIdentifier") as! AccountInfoSecurityCell
        
        cell.titleLabel.text = titleArray[indexPath.row]
    
        return cell
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
