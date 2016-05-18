//
//  ContactsRequestAddFriendInfoVC.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy

class ContactsPersonInfoVC: UIViewController, BaseViewControllerPresenter {
    

    @IBOutlet weak var tableView: UITableView!
    
    /// 请求添加好友按钮
    @IBOutlet weak var requestButton: UIButton!
    
    @IBAction func requestAddFriend(sender: AnyObject) {
        
        /// 跳到添加好友 验证信息发送 页面
        let requestVC = StoryboardScene.Contacts.instantiateContactsReqFriendVC()
        requestVC.requestStyle = .AddFriend
        self.pushVC(requestVC)
        
    }
    
    var navTitle: String { return L10n.ContactsNavTitleAccountInfo.string }
    
    var friendId: String = ""
    
    var friendNickName: String = ""
    
    var webJsonModel: ContactPsersonInfoResponse?
    
    lazy var cellVM: [PresonInfoListCellViewModel] = {
        
        return [PresonInfoListCellViewModel(title: L10n.ContactsShowInfoCity.string),
                PresonInfoListCellViewModel(title: L10n.ContactsShowInfoOld.string),
                PresonInfoListCellViewModel(title: L10n.ContactsShowInfoGender.string)]
    
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)

        updateNavUI()
        
        addTableView()
        
        loadFriendInfoByNet()
        
    }
    
    /**
     tableView 信息
     */
    func addTableView() {
        
        // 注册
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius

        tableView.snp_makeConstraints { make -> Void in
            make.height.equalTo(326)
        }
        
        // 隐藏分隔线
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "ContactsPersonInfoCell", bundle: nil), forCellReuseIdentifier: "ContactsPersonInfoCell")
        tableView.registerNib(UINib(nibName: "ContactsPersonInfoListCell", bundle: nil), forCellReuseIdentifier: "ContactsPersonInfoListCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
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
                
                self.analyzeWebData()
                
                self.tableView.reloadData()
                
            }
            
        } catch let error {
            Log.error(error as? UserRequestErrorType ?? UserRequestErrorType.UnknownError)
        }
        
    }

    func analyzeWebData() {
        self.cellVM[0] = PresonInfoListCellViewModel(title: L10n.ContactsShowInfoCity.string, info: self.webJsonModel!.address)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let birthDate = dateFormatter.dateFromString(self.webJsonModel!.birthday) ?? NSDate()
        
        let age = NSDate().yearsInBetweenDate(birthDate).toString
        
        self.cellVM[1] = PresonInfoListCellViewModel(title: L10n.ContactsShowInfoOld.string, info: age)
        self.cellVM[2] = PresonInfoListCellViewModel(title: L10n.ContactsShowInfoGender.string, info: self.webJsonModel!.sex == "0" ? "男" : "女")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UITableViewDelegate
extension ContactsPersonInfoVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 136
        } else if indexPath.row == 4{
            return 40
        } else {
            return 50
        }
        
    }
    
}

// MARK: - UITableViewDataSource
extension ContactsPersonInfoVC: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonInfoCell", forIndexPath: indexPath) as! ContactsPersonInfoCell
            cell.configCell(ContactsStrangerInfoCellDS(model: webJsonModel, nickName: friendNickName), delegate: self)
            return cell
            
        } else if indexPath.row == 4 {
            
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ListwhiteCell")
            let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ListwhiteCell")!
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ContactsPersonInfoListCell", forIndexPath: indexPath) as! ContactsPersonInfoListCell
            
            cell.configCell(cellVM[indexPath.row - 1])
            
            return cell
        }
        
    }
    
}

// MARK: - ContactsPersonInfoCellDelegate
extension ContactsPersonInfoVC: ContactsPersonInfoCellDelegate {
    
    func onClickHeadView() {
        Log.info("放大头像？")
    }
    
}
