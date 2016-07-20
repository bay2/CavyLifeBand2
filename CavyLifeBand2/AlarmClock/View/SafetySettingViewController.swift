//
//  SafetySettingViewController.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift
import JSONJoy

class SafetySettingViewController: UIViewController, BaseViewControllerPresenter {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tableViewMargin: CGFloat          = 20.0
    
    let tableSectionHeaderHeight: CGFloat    = 20.0

    let tableSectionFooterHeight: CGFloat = 100.0

    let safetySwitchCell  = "SettingSwitchTableViewCell"
    
    let safetyContactCell = "EmergencyContactPersonCell"
    
    let ContactInfoCell   = "EmergencyContactInfoCell"
    
    var userId: String = { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }()
    
    var navTitle: String { return L10n.HomeRightListTitleSecurity.string }
    
    var contactModels: [EmergencyContactInfoCellViewModel] = [EmergencyContactInfoCellViewModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = L10n.SettingSafetyTitle.string
        
        loadContactFromWeb()
        
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
        
        loadContactFromWeb()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadContactFromWeb() {
        
        EmergencyWebApi.shareApi.netGetRequest(WebApiMethod.EmergencyContacts.description, modelObject: EmergencyListResponse.self, successHandler: { (data) in
            
            if data.phoneList.count > 0 {
                
                self.contactModels.removeAll()
                
                for i in 0..<data.phoneList.count {
                    
                    let contactVM = EmergencyContactInfoCellViewModel(name: data.phoneList[i].name, phone: data.phoneList[i].phoneNum)
                    
                    self.contactModels.append(contactVM)
                    
                }
                
                self.tableView.reloadData()
                
            }
            
        }) { (msg) in
            
            Log.error(msg)
            
        }
        
    }
    
    /**
     如果有多个号码 添加提示
     
     - parameter contact: 返回的联系人信息
     */
    
    func addEmergency(contact: SCAddressBookContact) {
        
        guard  contact.phoneList.count > 0 else {
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(message: L10n.SettingSafetyPhoneNumberError.string)
            
            return
        }
        //MARK: 单个联系人
        if contact.phoneList.count == 1
        {
            
            configSendPara(contact.name, phoneNumber: contact.phoneList[0])
            
            //MARK: 多个联系人
        }else
            
        {
            
            let  sheet = UIActionSheet(title: contact.name, delegate: self, cancelButtonTitle: L10n.SettingSafetyPhoneNumberCancel.string, destructiveButtonTitle: nil)
            
            for phoneNumber in contact.phoneList {
                
                sheet.addButtonWithTitle(phoneNumber)
            }
            
            sheet.showInView(self.view)
        }
        
    }
    
    
    
    func configSendPara(name: String, phoneNumber: String) {
        
        var phoneArr: Array<[String: String]> = []
        
        for model in self.contactModels {
            
            if phoneNumber ==  model.phoneNumber{
                
                Log.info("联系人重复，已添加")
                return
            }
            
            let dic = [NetRequestKey.Name.rawValue: model.name,
                       NetRequestKey.Phone.rawValue: model.phoneNumber]
            
            phoneArr.append(dic)
        }
        
        phoneArr.append([NetRequestKey.Name.rawValue: name,
                         NetRequestKey.Phone.rawValue: phoneNumber])
        
        setEmergencyList(phoneArr) {
            
            let cellVM = EmergencyContactInfoCellViewModel(name: name, phone: phoneNumber)
            
            self.contactModels.insertAsFirst(cellVM)
            
            self.tableView.reloadData()
            
        }
        
    }
    
    
    func deleteEmergency(index: Int) {
        
        // 防止点击过快造成数组越界的情况
        if index >= self.contactModels.count {
            return
        }
        
        var phoneArr: [[String: String]] = [[String: String]]()
        
        for model in self.contactModels {
            let dic = [NetRequestKey.Name.rawValue: model.name,
                       NetRequestKey.Phone.rawValue: model.phoneNumber]
            phoneArr.append(dic)
        }
        
        phoneArr.removeAtIndex(index)
        
        setEmergencyList(phoneArr) {
            self.contactModels.removeAtIndex(index)
            
            self.tableView.reloadData()
        }
        
    }
    
    func setEmergencyList(phoneList: [[String: String]], callBack: (Void -> Void)) {
        
        do {
            
            try EmergencyWebApi.shareApi.setEmergencyPhoneList(phoneList) { result in
                
                callBack()
                
            }
            
        } catch let error  {
            Log.error(error)
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
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(message: L10n.SettingSafetyTableEmergencyAlertMsg.string)
            
        } else {
            
            //展示系统通讯录 选择联系人
            contactPicker.showAddressBoolPicker(self)
        }
        
    }
    
}

// MARK: - SCAddressBookPickerDelegate
extension SafetySettingViewController: SCAddressBookPickerDelegate {
    
    func contactPicker(didSelectContact contact: SCAddressBookContact) {
        
        let
        newContact = contact
        
        Log.info(newContact.phoneList)
        addEmergency(newContact)
        
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
            
            cell?.configure(contactModels[indexPath.row - 1], delegate: self, indexPath: indexPath)
            
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
        
        whiteView.snp_makeConstraints { (make) in
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

extension SafetySettingViewController: EmergencyContactInfoDelegate {
    
    func cancelEmergencyContact(index: NSIndexPath) {
        deleteEmergency(index.row - 1)
    }
    
}


// MARK:  -UIActionSheetDelegate
extension SafetySettingViewController: UIActionSheetDelegate
{
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        guard buttonIndex != 0 else {
            return
        }
        
        configSendPara(actionSheet.title, phoneNumber: actionSheet.buttonTitleAtIndex(buttonIndex)!)
        
    }
    
}
