//
//  SafetySettingViewController.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class SafetySettingViewController: UIViewController, BaseViewControllerPresenter, EmergencyContactRealmListOperateDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let tableViewMargin: CGFloat          = 20.0
    
    let tableSectionHeaderHeight: CGFloat = 10.0
    
    let tableSectionFooterHeight: CGFloat = 100.0
    
    let safetySwitchCell  = "SettingSwitchTableViewCell"

    let safetyContactCell = "EmergencyContactPersonCell"
    
    var realm: Realm = try! Realm()
    
    var userId: String = { return "12" }()
    
    var navTitle: String { return L10n.HomeRightListTitleSecurity.string }
    
    var emergencyContactModel: EmergencyContactRealmListModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = L10n.SettingSafetyTitle.string
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "AlarmClockAdd"),
                                                                 style: .Plain,
                                                                 target: self,
                                                                 action: #selector(rightBarBtnAciton(_:)))
        
        emergencyContactModel = queryEmergencyContactList()
        
        tableView.rowHeight       = 50.0
        tableView.backgroundColor = UIColor(named: .HomeViewMainColor)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        tableView.showsVerticalScrollIndicator = false
        
        tableView.registerNib(UINib(nibName: safetySwitchCell, bundle: nil), forCellReuseIdentifier: safetySwitchCell)
        
        tableView.registerNib(UINib(nibName: safetyContactCell, bundle: nil), forCellReuseIdentifier: safetyContactCell)
        
        tableView.snp_makeConstraints { make in
            
            make.trailing.equalTo(self.view).offset(-tableViewMargin)
            
            make.leading.equalTo(self.view).offset(tableViewMargin)
            
        }
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        updateNavUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func rightBarBtnAciton(sender: UIBarButtonItem) -> Void {
        Log.warning("|\(self.className)| -- 右上角添加")
    }
    
    /**
     返回按钮处理
     */
    func onLeftBtnBack() {
        
        self.navigationController?.popViewControllerAnimated(false)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeRightOnClickMenu.rawValue, object: nil)
        
    }
    
    func addEmergencyContact(sender: UIButton) {
        
        if emergencyContactModel?.emergencyContactRealmList.count == 3 {
            Log.error("上限三人，不能再添加，据说要用弹框提示")
        } else {
            //展示系统通讯录 选择联系人
//            addEmergencyContact(<#T##emergencyContact: EmergencyContactRealmModel##EmergencyContactRealmModel#>, listModel: emergencyContactModel)
        }
        
    }

}


// MARK: - UITableViewDataSource
extension SafetySettingViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(safetySwitchCell, forIndexPath: indexPath) as? SettingSwitchTableViewCell
            cell?.setWithStyle(.NoneDescription)
            cell?.titleLabel.text = L10n.SettingSafetyTableCellGPSTitle.string
            return cell!
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(safetyContactCell, forIndexPath: indexPath) as? EmergencyContactPersonCell
            
            return cell!
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row > 1 {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - UITableViewDelegate
extension SafetySettingViewController: UITableViewDelegate {
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        guard let list = self.emergencyContactModel else {
         
            return nil
            
        }
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "删除") {(action, indexPath) in
            Log.info("删除")
            self.deleteEmergencyContactRealm(indexPath.row - 2, listModel: list)
        }
        
//        deleteAction.backgroundColor = UIColor(named: .PKRecordsCellDeleteBtnBGColor)
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableSectionFooterHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableSectionHeaderHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeaderView = IntelligentClockTableHeaderView(frame: CGRect(x: 0, y: 0, w: self.tableView.size.width, h: tableSectionHeaderHeight))
        
        return tableHeaderView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let tableFooterView = SafetySettingTableFooterView(frame: CGRect(x: 0, y: 0, w: self.tableView.size.width, h: tableSectionFooterHeight))
        
        return tableFooterView
    }
    
}
