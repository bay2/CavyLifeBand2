//
//  ContactsFriendInfoVC.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import JSONJoy

class ContactsFriendInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var contectView: UIView!
    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var qualityTableView: UITableView!
    
    var friendId: String = ""
    
    var friendNickName: String = ""
    
    var webJsonModel: ContactPsersonInfoResponse?
    
    // TableView Identifier
    let infoHeadIdentifier = "FriendInfoHeadIdentifier"
    let infoBodyIdentifier = "FriendInfoBodyIdentifier"
    let infoWhiteIdentifier = "FriendInfoWhiteIdentifier"
    let qualityIdentifier = "FriendQualityIdentifier"
    let qualityWhiteIdentifier = "FriendQualityWhiteIdentifier"
    
    var infoCellCount: Int = 8    // cell个数 八个为身高体重年龄全部可见
    let infoTitleArray = [L10n.ContactsShowInfoTransformNotes.string, L10n.ContactsShowInfoNotesName.string, L10n.ContactsShowInfoCity.string, L10n.ContactsShowInfoOld.string, L10n.ContactsShowInfoGender.string, L10n.ContactsShowInfoHeight.string, L10n.ContactsShowInfoWeight.string, L10n.ContactsShowInfoBirth.string]
    let qualityTitleArray = [L10n.ContactsShowInfoPK.string, L10n.ContactsShowInfoStep.string, L10n.ContactsShowInfoSleep.string]
    
    var infoTableDS: [String: String] = [String: String]()
    
    lazy var infoTableCellVM: [PresonInfoListCellViewModel] = {
        
        return [PresonInfoListCellViewModel(title: L10n.ContactsShowInfoTransformNotes.string),
                PresonInfoListCellViewModel(title: L10n.ContactsShowInfoNotesName.string),
                PresonInfoListCellViewModel(title: L10n.ContactsShowInfoCity.string),
                PresonInfoListCellViewModel(title: L10n.ContactsShowInfoOld.string),
                PresonInfoListCellViewModel(title: L10n.ContactsShowInfoGender.string),
                PresonInfoListCellViewModel(title: L10n.ContactsShowInfoHeight.string),
                PresonInfoListCellViewModel(title: L10n.ContactsShowInfoWeight.string),
                PresonInfoListCellViewModel(title: L10n.ContactsShowInfoBirth.string)]
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        addAllViews()
        
        loadFriendInfoByNet()
        
    }
    
    /**
     返回按钮处理
     */
    func onLeftBtnBack() {
        
        self.navigationController?.popViewControllerAnimated(false)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeLeftOnClickMenu.rawValue, object: nil)
        
    }
    
    /**
     添加 全部视图
     */
    func addAllViews() {
        
        // InfoTableView高度
        // |-infoListCell-136-|-cellCount-1[infoListCell] * 50-|-边10-|
        let tableViewHeight = CGFloat(136 + (infoCellCount - 1) * 50 + 10)
        
        // contentView 
        contectView.backgroundColor = UIColor(named: .HomeViewMainColor)
        contectView.snp_makeConstraints { make in
            // |-16-|-infoTableView-|-10-|-qualityTableView-170-|-20-|
            make.height.equalTo(tableViewHeight + 216)
        }
        
        infoTableView.snp_makeConstraints { make -> Void in
            make.height.equalTo(tableViewHeight)
        }
        tableViewBaseSetting(infoTableView)
        infoTableView.registerNib(UINib(nibName: "ContactsPersonInfoCell", bundle: nil), forCellReuseIdentifier: infoHeadIdentifier)
        infoTableView.registerNib(UINib(nibName: "ContactsPersonInfoListCell", bundle: nil), forCellReuseIdentifier: infoBodyIdentifier)
        
        // qualityTableView
        tableViewBaseSetting(qualityTableView)
        qualityTableView.registerNib(UINib(nibName: "ContactsFriendQualityCell", bundle: nil), forCellReuseIdentifier: qualityIdentifier)
        
    }
    
//    func archiveInfoDS() {
//        for i in 0..<infoTitleArray.count {
//            guard let value = webJsonModel
//        }
//    }
    
    /**
     通过网络加载数据
     */
    func loadFriendInfoByNet() {
        
        do {
            
            try ContactsWebApi.shareApi.getContactPersonInfo(friendId: friendId) {(result)  in
                
                guard result.isSuccess else {
                    Log.error(result.error?.description ?? "")
                    return
                }
                
                self.webJsonModel = try! ContactPsersonInfoResponse(JSONDecoder(result.value!))
                
                guard self.webJsonModel?.commendMsg.code == WebApiCode.Success.rawValue else {
                    Log.error(WebApiCode(apiCode: self.webJsonModel!.commendMsg.code).description)
                    return
                }
                
                self.infoTableView.reloadData()
                
                
            }
            
        } catch let error {
            Log.error(error as? UserRequestErrorType ?? UserRequestErrorType.UnknownError)
        }
        
    }
    
    
    /**
     tableView的基本设置
     */
    func tableViewBaseSetting(tableView: UITableView) {
        
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.separatorStyle = .None
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Tableview Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.isEqual(infoTableView) {
            
            return infoTableCellVM.count + 1
            
        } else {
            
            return 5
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView.isEqual(infoTableView) {
            
            if indexPath.row == 0 {
                
                return 136
                
            } else if indexPath.row == infoCellCount {
                
                return 10
                
            }
            
            return 50
            
        } else {
            
            if indexPath.row == 0 || indexPath.row == 4 {
                
                return 10
            }
            
            return 50
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.isEqual(infoTableView) {
            
            if indexPath.row == 0 {
                
                // 个人信息
                let cell = tableView.dequeueReusableCellWithIdentifier(infoHeadIdentifier, forIndexPath: indexPath) as! ContactsPersonInfoCell
                
                cell.configCell(ContactsFriendInfoCellDS(model: webJsonModel, nickName: friendNickName), delegate: self)
                
                return cell
                
            } else if indexPath.row == infoCellCount {
                
                // 最下面边空白
                tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: infoWhiteIdentifier)
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(infoWhiteIdentifier)!
                return cell
                
            }
            
            // 其他数值
            let cell = tableView.dequeueReusableCellWithIdentifier(infoBodyIdentifier, forIndexPath: indexPath) as! ContactsPersonInfoListCell
            
            if indexPath.row == 1 {
                
                cell.addData(infoTitleArray[indexPath.row], titleInfo: infoTitleArray[0], cellEditOrNot: true)
                
                cell.configCell(infoTableCellVM[indexPath.row])
                
            } else {
                
                cell.addData(infoTitleArray[indexPath.row], titleInfo: "160", cellEditOrNot: false)
                
                cell.configCell(infoTableCellVM[indexPath.row])
                
            }
            return cell
            
        } else {
            
            if indexPath.row == 0 || indexPath.row == 4 {
                
                tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: qualityWhiteIdentifier)
                let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(qualityWhiteIdentifier)!
                cell.backgroundColor = UIColor.whiteColor()
                return cell
                
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier(qualityIdentifier, forIndexPath: indexPath) as! ContactsFriendQualityCell
            if indexPath.row == 1 {
                cell.cellEditOrNot = true
            }
            return cell
 
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.isEqual(infoTableView) && indexPath.row == 1 {

            // 跳转到修改备注
            let requestVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
            requestVC.requestStyle = .ChangeNotesName
            self.pushVC(requestVC)
            
        }
        
        if tableView.isEqual(qualityTableView) && indexPath.row == 0 {
    
            Log.info("PK页面")
            
        }
        
    }

}

// MARK: - ContactsPersonInfoCellDelegate
extension ContactsFriendInfoVC: ContactsPersonInfoCellDelegate {
    
    func onClickHeadView() {
        Log.info("放大头像？")
    }
    
}
