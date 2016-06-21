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

class ContactsFriendInfoVC: UIViewController, BaseViewControllerPresenter{

    @IBOutlet weak var contectView: UIView!
    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var qualityTableView: UITableView!
    
    var navTitle: String { return L10n.ContactsTitle.string }
    
    let sectionCornerViewHeight: CGFloat = 10.0
    
    let sectionView16Height: CGFloat = 16.0
    
    let normalCellHeight: CGFloat = 50.0
    
    let avatarCellHeight: CGFloat = 120.0
    
    var infoTableViewHeight: CGFloat {
        // |-infoListCell-120-|-16-|-infoTableCellVM.count * 50-|-底10-|
        return avatarCellHeight + CGFloat(infoTableCellVM.count) * normalCellHeight + sectionCornerViewHeight + sectionView16Height
    }
    
    var friendId: String = ""
    
    var friendNickName: String = ""
    
    var webJsonModel: ContactPsersonInfoResponse?
    
    // TableView Identifier
    let infoHeadIdentifier = "FriendInfoHeadIdentifier"
    let infoBodyIdentifier = "FriendInfoBodyIdentifier"
    let infoWhiteIdentifier = "FriendInfoWhiteIdentifier"
    let qualityIdentifier = "FriendQualityIdentifier"
    let qualityWhiteIdentifier = "FriendQualityWhiteIdentifier"
    
    //个人信息cell VMs
    lazy var infoTableCellVM: [PresonInfoListCellViewModel] = {
        
        return defaultInfoTableCellVM
        
    }()
    
    //生活信息Cell VMs
    lazy var qualityTableCellVM: [ContactsFriendQualityCellDataSource] = {
        return [StepQualityCellVM(),
                SleepQualityCellVM(),
                PKQualityCellVM()]
    
    }()
    
    static var defaultInfoTableCellVM = {
        
        return [PresonInfoListCellViewModel(title: L10n.ContactsShowInfoNotesName.string, info: L10n.ContactsShowInfoTransformNotes.string, infoTextColor: UIColor(named: .GColor)),
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
        
        updateNavUI()
        
        addAllViews()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadFriendInfoByNet()
    }
    
    
    /**
     添加 全部视图
     */
    func addAllViews() {
        
        // contentView 
        contectView.backgroundColor = UIColor(named: .HomeViewMainColor)
        contectView.snp_makeConstraints { make in
            // |-16-|-infoTableView-|-10-|-qualityTableView-170-|-20-|
            make.height.equalTo(infoTableViewHeight + 216)
        }
        
        infoTableView.snp_makeConstraints { make -> Void in
            make.height.equalTo(infoTableViewHeight)
        }
        
        tableViewBaseSetting(infoTableView)
        tableViewBaseSetting(qualityTableView)
        
        infoTableView.registerNib(UINib(nibName: "ContactsPersonInfoCell", bundle: nil), forCellReuseIdentifier: infoHeadIdentifier)
        infoTableView.registerNib(UINib(nibName: "ContactsPersonInfoListCell", bundle: nil), forCellReuseIdentifier: infoBodyIdentifier)
        
        qualityTableView.registerNib(UINib(nibName: "ContactsFriendQualityCell", bundle: nil), forCellReuseIdentifier: qualityIdentifier)
        
    }
    
    /**
     解析网络数据 -> 模型
     */
    func archiveInfoDS() {
        
        let dateF = NSDateFormatter()
        dateF.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let birthDate = dateF.dateFromString(self.webJsonModel?.birthday ?? "") ?? NSDate()
        let age = NSDate().yearsInBetweenDate(birthDate)
        
        dateF.dateFormat = "yyyy.MM.dd"
        
        let birthStr = dateF.stringFromDate(birthDate)
        
        infoTableCellVM = ContactsFriendInfoVC.defaultInfoTableCellVM
        
        infoTableCellVM[1].info = self.webJsonModel?.address ?? ""
        infoTableCellVM[2].info = age.toString
        infoTableCellVM[3].info = (self.webJsonModel?.sex ?? 0) == 0 ? "男" : "女"
        infoTableCellVM[4].info = self.webJsonModel?.height ?? ""
        infoTableCellVM[5].info = self.webJsonModel?.weight ?? ""
        infoTableCellVM[6].info = birthStr
        
        //这三个字段为空代表设置了不可显示
        if self.webJsonModel?.birthday == "" {
            infoTableCellVM.removeLast()
        }
        
        if self.webJsonModel?.weight == "" {
            infoTableCellVM.removeAtIndex(5)
        }
        
        if self.webJsonModel?.height == "" {
            infoTableCellVM.removeAtIndex(4)
        }
        
        contectView.snp_updateConstraints { make in
            make.height.equalTo(infoTableViewHeight + 216)
        }
        
        infoTableView.snp_updateConstraints { make -> Void in
            make.height.equalTo(infoTableViewHeight)
        }
        
        qualityTableCellVM[0].infoValue = self.webJsonModel?.stepNum.toString ?? ""
        qualityTableCellVM[1].infoValue = self.webJsonModel?.sleepTime ?? ""
        
    }
    
    /**
     通过网络加载数据
     */
    func loadFriendInfoByNet() {
        
        do {
            
            try ContactsWebApi.shareApi.getContactPersonInfo(friendId: friendId) { (result)  in
                
                guard result.isSuccess else {
                    Log.error(result.error?.description ?? "")
                    return
                }
                
                self.webJsonModel = try! ContactPsersonInfoResponse(JSONDecoder(result.value!))
                
                guard self.webJsonModel?.commendMsg.code == WebApiCode.Success.rawValue else {
                    Log.error(WebApiCode(apiCode: self.webJsonModel!.commendMsg.code).description)
                    return
                }
                
                self.archiveInfoDS()
                
                self.infoTableView.reloadData()
                
                self.qualityTableView.reloadData()
                
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
    
}


// MARK: - UITableViewDelegate
extension ContactsFriendInfoVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if tableView.isEqual(infoTableView) && indexPath.section == 0 {
            
            return avatarCellHeight
            
        } else {  return normalCellHeight }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView.isEqual(infoTableView) && indexPath.row == 0 {
            
            // 跳转到修改备注
            let requestVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
            
            let changeRemarkVM = ContactsChangeRemarkViewModel(viewController: requestVC, friendId: self.friendId)
            
            requestVC.viewConfig(changeRemarkVM)
            
            self.pushVC(requestVC)
            
        }
        
        if tableView.isEqual(qualityTableView){
            
            if qualityTableCellVM[indexPath.row] is PKQualityCellVM {
                Log.info("PK页面")
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if tableView.isEqual(infoTableView) && section == 0 {
            return sectionView16Height
        }
        
        return sectionCornerViewHeight
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView.isEqual(qualityTableView) {
            return sectionCornerViewHeight
        }
        
        return 0.01
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if tableView.isEqual(infoTableView) {
            let view = UIView.init(frame: CGRect(x: 0, y: 0, w: tableView.frame.width, h: sectionView16Height))
            
            return view
        }
        
        let viewFrame = CGRect(x: 0, y: 0, w: tableView.frame.width, h: sectionCornerViewHeight)
        
        let view = AboutSectionEmptyView(frame: viewFrame, cornerType: .Bottom)
        
        return view
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewFrame = CGRect(x: 0, y: 0, w: tableView.frame.width, h: sectionCornerViewHeight)
        
        let view = AboutSectionEmptyView(frame: viewFrame, cornerType: .Top)
        
        return view
    }

}

// MARK: - UITableViewDataSource
extension ContactsFriendInfoVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if tableView.isEqual(infoTableView) {
            return 2
        }
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.isEqual(infoTableView) {
            
            if section == 0 {
                return 1
            }
            
            return infoTableCellVM.count
            
        } else {
            
            return qualityTableCellVM.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.isEqual(infoTableView) {
            
            if indexPath.section == 0 {
                // 个人信息
                let cell = tableView.dequeueReusableCellWithIdentifier(infoHeadIdentifier, forIndexPath: indexPath) as! ContactsPersonInfoCell
                
                cell.configCell(ContactsFriendInfoCellDS(model: webJsonModel, nickName: friendNickName), delegate: self)
                
                return cell
                
            }
            
            // 其他
            let cell = tableView.dequeueReusableCellWithIdentifier(infoBodyIdentifier, forIndexPath: indexPath) as! ContactsPersonInfoListCell
            
            cell.configCell(infoTableCellVM[indexPath.row])
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(qualityIdentifier, forIndexPath: indexPath) as! ContactsFriendQualityCell
            
            cell.configure(qualityTableCellVM[indexPath.row])
            
            return cell
            
        }
    }
    
}

// MARK: - ContactsPersonInfoCellDelegate
extension ContactsFriendInfoVC: ContactsPersonInfoCellDelegate {
    
    func onClickHeadView() {
        
        let viewFrame = CGRect(x: 0, y: 0, w: ez.screenWidth, h: ez.screenHeight)
        
        let view = FullScreenImageView(frame: viewFrame, imageUrlStr: self.webJsonModel?.avatarUrl ?? "")
        
        UIApplication.sharedApplication().keyWindow?.addSubview(view)
        
    }
    
}
