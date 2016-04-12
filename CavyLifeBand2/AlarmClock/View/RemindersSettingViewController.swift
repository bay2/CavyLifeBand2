//
//  RemindersSettingViewController.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class RemindersSettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let tableViewMargin: CGFloat    = 20.0
    
    let tableSectionHeight: CGFloat = 10.0
    
    let tableSwitchCellHeight: CGFloat = 50.0
    
    let tableScrollCellHeight: CGFloat = 75.0 + 20 + 20
    
    let reminderSettingCell = "SettingSwitchTableViewCell"
    
    let reminderSeondesCell = "SecondsTableViewCell"
    
    var tableList = {
        return ["", "", "", ""]
    }()
    
    var realm: Realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        tableView.backgroundColor = UIColor.whiteColor()
        
        tableView.snp_makeConstraints { (make) in
            
            make.trailing.equalTo(self.view).offset(-tableViewMargin)
            
            make.leading.equalTo(self.view).offset(tableViewMargin)
            
        }
        
        tableView.registerNib(UINib.init(nibName: reminderSettingCell, bundle: nil), forCellReuseIdentifier: reminderSettingCell)
        
        tableView.registerClass(SecondsTableViewCell.classForCoder(), forCellReuseIdentifier: reminderSeondesCell)
        
//        tableView.registerNib(UINib.init(nibName: reminderSeondesCell, bundle: nil), forCellReuseIdentifier: reminderSeondesCell)
        
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeSwitchState(sender: UISwitch) -> Void {
        Log.warning("todo")
        
        if sender.on {
            Log.info("on")
            tableList.insertAsFirst("")
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Top)
            self.tableView.layoutIfNeeded()
            UIView.animateWithDuration(0.3, animations: {
                self.tableView.snp_updateConstraints(closure: { (make) in
                    make.height.equalTo(285.0)
                })
                self.tableView.layoutIfNeeded()
            })
            
        } else {
            Log.info("off")
            
            tableList.removeLast()
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Top)
            
            self.tableView.layoutIfNeeded()
            
            UIView.animateWithDuration(0.3, animations: {
                self.tableView.snp_updateConstraints(closure: { (make) in
                    make.height.equalTo(170.0)
                })
                self.tableView.layoutIfNeeded()
            })

        }
    }

}

// MARK: - UITableViewDataSource
extension RemindersSettingViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                
        if tableList.count == 4 && indexPath.row == 1 {
            let sencondsCell = tableView.dequeueReusableCellWithIdentifier(reminderSeondesCell, forIndexPath: indexPath) as? SecondsTableViewCell
            
            return sencondsCell!
        }
        
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reminderSettingCell, forIndexPath: indexPath) as? SettingSwitchTableViewCell
        
        

        if tableList.count == 4 {
            switch indexPath.row {
            case 0:
                cell?.configure(SettingSwitchPhoneCellViewModel(realm: realm))
            case 2:
                cell?.configure(SettingSwitchMessageCellViewModel(realm: realm))
            case 3:
                cell?.configure(SettingSwitchReconnectCellViewModel(realm: realm))
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                cell?.configure(SettingSwitchPhoneCellViewModel(realm: realm))
            case 1:
                cell?.configure(SettingSwitchMessageCellViewModel(realm: realm))
            case 2:
                cell?.configure(SettingSwitchReconnectCellViewModel(realm: realm))
            default:
                break
            }
        }
        
        
        return cell!
        
        
    }

}

// MARK: - UITableViewDelegate
extension RemindersSettingViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableSectionHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableSectionHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        
        header.backgroundColor = UIColor.whiteColor()
        
        return header
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let header = UIView()
        
        header.backgroundColor = UIColor.whiteColor()
        
        return header
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableList.count == 4 && indexPath.row == 1 {
            return tableScrollCellHeight
        }
        
        return tableSwitchCellHeight
    }
    
}
