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

class RemindersSettingViewController: UIViewController, BaseViewControllerPresenter {

    @IBOutlet weak var tableView: UITableView!
    
    let tableViewMargin: CGFloat       = 20.0

    let tableSectionHeight: CGFloat    = 10.0

    let tableSwitchCellHeight: CGFloat = 50.0

    let tableScrollCellHeight: CGFloat = 60.0 + 20 + 20

    var tableExpandHeight: CGFloat     = 220.0

    var tableUnExpandHeight: CGFloat   = 120.0
    
    let reminderSettingCell = "SettingSwitchTableViewCell"
    
    let reminderSeondesCell = "SecondsTableViewCell"
    
    var tableExpandCellCount: Int?
    
    var tableList: [String]?
    
    var dataSource: RemindersSettingVCDataSource?
    
    
    var navTitle: String { return L10n.HomeRightListTitleNotification.string }
    
    deinit {
        Log.info("dealloc")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        tableExpandCellCount = 2
        
        tableUnExpandHeight = tableSwitchCellHeight * CGFloat(tableExpandCellCount! - 1) + 2 * tableSectionHeight
        
        tableExpandHeight = tableUnExpandHeight + tableScrollCellHeight
        
        setDataSource()
        
        setTableView()
        
        updateNavUI()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     返回按钮处理
     */
    func onLeftBtnBack() {
        
        self.navigationController?.popViewControllerAnimated(false)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeRightOnClickMenu.rawValue, object: nil)
        
    }
    
    //Table与DataSource有关的设置
    func setDataSource() -> Void {
        
        dataSource = ReminderSettingVCViewModel(realm: realm)
        
        if dataSource?.settingListModel.settingRealmList[0].isOpenSetting == true {
            tableList = Array(count: tableExpandCellCount!, repeatedValue: "")
            
            self.tableView.snp_updateConstraints(closure: { make in
                make.height.equalTo(tableExpandHeight)
            })
        } else {
            tableList = Array(count: tableExpandCellCount! - 1, repeatedValue: "")
            
            self.tableView.snp_updateConstraints(closure: { make in
                make.height.equalTo(tableUnExpandHeight)
            })
        }
    }
    
    //Table基础设置
    func setTableView() -> Void {
        
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        tableView.backgroundColor = UIColor.whiteColor()
        
        tableView.snp_makeConstraints { make in
            make.trailing.equalTo(self.view).offset(-tableViewMargin)
            make.leading.equalTo(self.view).offset(tableViewMargin)
        }
        
        tableView.registerNib(UINib.init(nibName: reminderSettingCell, bundle: nil), forCellReuseIdentifier: reminderSettingCell)
        tableView.registerClass(SecondsTableViewCell.classForCoder(), forCellReuseIdentifier: reminderSeondesCell)
    }

}

// MARK: - SettingSwitchTableViewCelldDelegate
extension RemindersSettingViewController: SettingSwitchTableViewCelldDelegate {
    
    func changeSwitchState(sender: UISwitch) -> Void {
        
        if sender.on {
            tableList?.insertAsFirst("")
            
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Top)
            
            self.tableView.layoutIfNeeded()
            
            UIView.animateWithDuration(0.3, animations: {
                self.tableView.snp_updateConstraints(closure: { make in
                    make.height.equalTo(self.tableExpandHeight)
                })
                self.tableView.layoutIfNeeded()
            })
            
        } else {
            tableList?.removeLast()
            
            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Top)
            
            self.tableView.layoutIfNeeded()
            
            UIView.animateWithDuration(0.3, animations: {
                self.tableView.snp_updateConstraints(closure: { make in
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
                
        if tableList?.count == tableExpandCellCount && indexPath.row == 1 {
            let sencondsCell = tableView.dequeueReusableCellWithIdentifier(reminderSeondesCell, forIndexPath: indexPath) as? SecondsTableViewCell
            
            sencondsCell?.index = dataSource?.settingListModel.settingRealmList[0].settingInfo
            
            return sencondsCell!
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reminderSettingCell, forIndexPath: indexPath) as? SettingSwitchTableViewCell
        
        cell?.delegate = nil

        if tableList?.count == tableExpandCellCount {
            switch indexPath.row {
            case 0:
                cell?.configure(SettingSwitchPhoneCellViewModel(realm: realm, realmSetting: (dataSource?.settingListModel.settingRealmList[0])!))
                cell?.delegate = self
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                cell?.configure(SettingSwitchPhoneCellViewModel(realm: realm, realmSetting: (dataSource?.settingListModel.settingRealmList[0])!))
                cell?.delegate = self
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
        if tableList?.count == tableExpandCellCount && indexPath.row == 1 {
            return tableScrollCellHeight
        }
        
        return tableSwitchCellHeight
    }
    
}