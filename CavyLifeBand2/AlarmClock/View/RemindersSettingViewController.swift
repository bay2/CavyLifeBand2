//
//  RemindersSettingViewController.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

protocol RemindersSettingVCDataSource {
    var settingListModel: SettingRealmListModel { get }
}

class RemindersSettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let tableViewMargin: CGFloat    = 20.0
    
    let tableSectionHeight: CGFloat = 10.0
    
    let tableSwitchCellHeight: CGFloat = 50.0
    
    let tableScrollCellHeight: CGFloat = 60.0 + 20 + 20
    
    let tableExpandHeight: CGFloat = 270.0
    
    let tableUnExpandHeight: CGFloat = 170.0
    
    let reminderSettingCell = "SettingSwitchTableViewCell"
    
    let reminderSeondesCell = "SecondsTableViewCell"
    
    var tableList: [String]?
    
    var dataSource: RemindersSettingVCDataSource?
    
    var realm: Realm = try! Realm()
    
    deinit {
        
        Log.info("dealloc")
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        setDataSource()
        
        setTableView()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDataSource() -> Void {
        
        dataSource = ReminderSettingVCViewModel(realm: realm)
        
        if dataSource?.settingListModel.settingRealmList[0].isOpenSetting == true {
            tableList = ["", "", "", ""]
            self.tableView.snp_updateConstraints(closure: { (make) in
                make.height.equalTo(tableExpandHeight)
            })
        } else {
            tableList = ["", "", ""]
            self.tableView.snp_updateConstraints(closure: { (make) in
                make.height.equalTo(tableUnExpandHeight)
            })
        }
    }
    
    func setTableView() -> Void {
        
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        tableView.backgroundColor = UIColor.whiteColor()
        
        tableView.snp_makeConstraints { (make) in
            
            make.trailing.equalTo(self.view).offset(-tableViewMargin)
            
            make.leading.equalTo(self.view).offset(tableViewMargin)
            
        }
        
        tableView.registerNib(UINib.init(nibName: reminderSettingCell, bundle: nil), forCellReuseIdentifier: reminderSettingCell)
        
        tableView.registerClass(SecondsTableViewCell.classForCoder(), forCellReuseIdentifier: reminderSeondesCell)
    }

}

extension RemindersSettingViewController: SettingSwitchTableViewCelldDelegate {
    
    func changeSwitchState(sender: UISwitch) -> Void {
        
        if sender.on {
            tableList?.insertAsFirst("")
            
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Top)
            
            self.tableView.layoutIfNeeded()
            
            UIView.animateWithDuration(0.3, animations: {
                self.tableView.snp_updateConstraints(closure: { (make) in
                    make.height.equalTo(self.tableExpandHeight)
                })
                self.tableView.layoutIfNeeded()
            })
            
        } else {
            
            tableList?.removeLast()
            
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Top)
            
            self.tableView.layoutIfNeeded()
            
            UIView.animateWithDuration(0.3, animations: {
                self.tableView.snp_updateConstraints(closure: { (make) in
                    make.height.equalTo(self.tableUnExpandHeight)
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
        return (tableList?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                
        if tableList?.count == 4 && indexPath.row == 1 {
            let sencondsCell = tableView.dequeueReusableCellWithIdentifier(reminderSeondesCell, forIndexPath: indexPath) as? SecondsTableViewCell
            
            sencondsCell?.index = dataSource?.settingListModel.settingRealmList[0].settingInfo
            
            return sencondsCell!
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reminderSettingCell, forIndexPath: indexPath) as? SettingSwitchTableViewCell
        
        cell?.delegate = nil

        if tableList?.count == 4 {
            switch indexPath.row {
            case 0:
                cell?.configure(SettingSwitchPhoneCellViewModel(realm: realm, realmSetting: (dataSource?.settingListModel.settingRealmList[0])!))
                cell?.delegate = self
            case 2:
                cell?.configure(SettingSwitchMessageCellViewModel(realm: realm, realmSetting: (dataSource?.settingListModel.settingRealmList[1])!))
            case 3:
                cell?.configure(SettingSwitchReconnectCellViewModel(realm: realm, realmSetting: (dataSource?.settingListModel.settingRealmList[2])!))
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                cell?.configure(SettingSwitchPhoneCellViewModel(realm: realm, realmSetting: (dataSource?.settingListModel.settingRealmList[0])!))
                cell?.delegate = self
            case 1:
                cell?.configure(SettingSwitchMessageCellViewModel(realm: realm, realmSetting: (dataSource?.settingListModel.settingRealmList[1])!))
            case 2:
                cell?.configure(SettingSwitchReconnectCellViewModel(realm: realm, realmSetting: (dataSource?.settingListModel.settingRealmList[2])!))
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
        if tableList?.count == 4 && indexPath.row == 1 {
            return tableScrollCellHeight
        }
        
        return tableSwitchCellHeight
    }
    
}
