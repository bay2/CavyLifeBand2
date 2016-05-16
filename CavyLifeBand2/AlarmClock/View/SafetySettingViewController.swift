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
    
    let tableSectionHeaderHeight: CGFloat = 20.0
    
    let tableSectionFooterHeight: CGFloat = 100.0
    
    let safetySwitchCell  = "SettingSwitchTableViewCell"

    let safetyContactCell = "EmergencyContactPersonCell"
    
    let ContactInfoCell   = "EmergencyContactInfoCell"
    
    var realm: Realm = try! Realm()
    
    var notificationToken: NotificationToken?
    
    var userId: String = { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }()
    
    var navTitle: String { return L10n.HomeRightListTitleSecurity.string }
    
    var contactModels: [EmergencyContactInfoCellViewModel] = [EmergencyContactInfoCellViewModel]()
    
    var contactRealms: EmergencyContactRealmListModel?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = L10n.SettingSafetyTitle.string
        
        loadContactFromRealm()
        
        notificationToken = realm.addNotificationBlock { _, _ in
            
            self.loadContactFromRealm()
            
            self.tableView.reloadData()
            
        }
        
        Log.info(realm.configuration.fileURL)

        tableView.rowHeight       = 50.0
        tableView.backgroundColor = UIColor(named: .HomeViewMainColor)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        tableView.showsVerticalScrollIndicator = false
        
        tableView.registerNib(UINib(nibName: safetySwitchCell, bundle: nil), forCellReuseIdentifier: safetySwitchCell)
        
        tableView.registerNib(UINib(nibName: safetyContactCell, bundle: nil), forCellReuseIdentifier: safetyContactCell)
        
        tableView.registerNib(UINib(nibName: ContactInfoCell, bundle: nil), forCellReuseIdentifier: ContactInfoCell)
        
        tableView.snp_makeConstraints { make in
            
            make.trailing.equalTo(self.view).offset(-tableViewMargin)
            
            make.leading.equalTo(self.view).offset(tableViewMargin)
            
        }
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        contactPicker.pickerDelegate = self
        
        updateNavUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadContactFromRealm() -> Void {
        contactRealms = queryEmergencyContactList()
        
        contactModels.removeAll()

        if let count = contactRealms?.emergencyContactRealmList.count {
            
            for i in 0..<count {
                
                let contactVM = EmergencyContactInfoCellViewModel(model: contactRealms!.emergencyContactRealmList[i], realm: self.realm)
                
                contactModels.append(contactVM)
            }
            
        }
        
        
    }
    
    /**
     返回按钮处理
     */
    func onLeftBtnBack() {
        
        self.navigationController?.popViewControllerAnimated(false)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeRightOnClickMenu.rawValue, object: nil)
        
    }
    
    var contactPicker = SCAddressBookPicker()
    
    func addEmergencyContact(sender: UIButton) {
        
        if contactModels.count == 3 {
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(message: "紧急联系人上限三人")
            
        } else {
            
            //展示系统通讯录 选择联系人
            contactPicker.showAddressBoolPicker(self)
        }
        
    }
    
}

// MARK: - SCAddressBookPickerDelegate
extension SafetySettingViewController: SCAddressBookPickerDelegate {
    
    func contactPicker(didSelectContact contact: SCAddressBookContact) {
        
        let reamlModel = EmergencyContactRealmModel()
        reamlModel.userId = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
        reamlModel.contactName = contact.name
        reamlModel.phoneNumber = contact.phoneName
        
        self.addEmergencyContact(reamlModel, listModel: contactRealms!)
        
    }
    
}


// MARK: - UITableViewDataSource
extension SafetySettingViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return contactModels.count + 1
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(safetySwitchCell, forIndexPath: indexPath) as? SettingSwitchTableViewCell
            cell?.setWithStyle(.NoneDescription)
            cell?.titleLabel.text = L10n.SettingSafetyTableCellGPSTitle.string
            cell?.layer.cornerRadius = CavyDefine.commonCornerRadius
            cell?.clipsToBounds = true
            return cell!
            
        } else {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(safetyContactCell, forIndexPath: indexPath) as? EmergencyContactPersonCell
                cell?.selectionStyle = .None
                return cell!
                
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier(ContactInfoCell, forIndexPath: indexPath) as? EmergencyContactInfoCell
            
            cell?.configure(contactModels[indexPath.row - 1])
            
            return cell!
            
        }
        
    }
    
}

// MARK: - UITableViewDelegate
extension SafetySettingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        
        return tableSectionFooterHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        
        return tableSectionHeaderHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let whiteView = IntelligentClockTableHeaderView(frame: CGRect(x: 0, y: 0, w: self.tableView.size.width, h: 10))
        
        let tableHeaderView = UIView()
        
        tableHeaderView.frame = CGRect(x: 0, y: 0, w: self.tableView.size.width, h: tableSectionHeaderHeight)
        
        tableHeaderView.addSubview(whiteView)
        
        whiteView.snp_makeConstraints {(make) in
            make.bottom.equalTo(tableHeaderView.snp_bottom)
            make.height.equalTo(10)
            make.leading.equalTo(tableHeaderView.snp_leading)
            make.trailing.equalTo(tableHeaderView.snp_trailing)
        }
        
        return tableHeaderView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let tableFooterView = SafetySettingTableFooterView(frame: CGRect(x: 0, y: 0, w: self.tableView.size.width, h: tableSectionFooterHeight))
        
        return tableFooterView
    }
    
}
