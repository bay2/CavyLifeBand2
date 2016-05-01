//
//  IntelligentClockViewController.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift
import EZSwiftExtensions

class IntelligentClockViewController: UIViewController, BaseViewControllerPresenter {
    
    var navTitle: String { return L10n.AlarmClockTitle.string }
    
    lazy var rightBtn: UIButton? =  {
        
        let button = UIButton(type: .System)
        button.frame = CGRectMake(0, 0, 30, 30)
        button.setBackgroundImage(UIImage(asset: .AlarmClockAdd), forState: .Normal)
        
        return button
        
    }()
    
    let tableViewMargin: CGFloat            = 20.0

    let tableSectionHederHeight: CGFloat    = 10.0

    let tableSevtionFooterHeight: CGFloat   = 50.0

    let intelligentClockCellHeight: CGFloat = 50.0
    
    let intelligentClockCellID = "IntelligentClockCell"
    
    var emptyView: EmptyClockView?
    
    var realm: Realm = try! Realm()
    
    var dataSource: IntelligentClockVCViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let alarmlist = dataSource?.alarmListModel.alarmRealmList {
            if  alarmlist.count > 0{
                self.tableView.hidden = false
                self.emptyView?.hidden = true
                return
            }
            
        }
        
        self.tableView.hidden = true
        self.emptyView?.hidden = false
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //用于UITest查找Table
        self.tableView.accessibilityIdentifier = "AlarmClockTable"
        
        updateNavUI()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        dataSource = IntelligentClockVCViewModel(realm: realm)
        
        tableBaseSetting()
        
        if let empty = NSBundle.mainBundle().loadNibNamed("EmptyClockView", owner: nil, options: nil).first as? EmptyClockView {
            emptyView = empty
            
            self.view.addSubview(emptyView!)
            
            emptyView?.snp_makeConstraints(closure: {(make) in
                make.width.equalTo(self.view)
                make.height.equalTo(150)
                make.center.equalTo(self.view.snp_center)
                
            })
            
        }
        
    }
    
    /**
     返回按钮处理
     */
    func onLeftBtnBack() {
        
        self.navigationController?.popViewControllerAnimated(false)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeRightOnClickMenu.rawValue, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     跳转添加闹钟
     */
    func onRightBtn() {
        
        let targetVC = StoryboardScene.AlarmClock.instantiateAddClockViewController()
        
        targetVC.addNewClock = true
        
        targetVC.updateAlarmBlock = {(alarm: AlarmRealmModel, isUpdate: Bool) -> Void in
            
            self.dataSource?.addAlarm(alarm)
            
            self.tableView.reloadData()
        }
        
        self.pushVC(targetVC)
    }
    
    /**
     TableView初始设置
     */
    func tableBaseSetting() -> Void {
        
        tableView.rowHeight       = intelligentClockCellHeight
        tableView.backgroundColor = UIColor(named: .HomeViewMainColor)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        tableView.showsVerticalScrollIndicator = false
        
        tableView.snp_makeConstraints { make in
            make.trailing.equalTo(self.view).offset(-tableViewMargin)
            make.leading.equalTo(self.view).offset(tableViewMargin)
        }
        
        tableView.registerNib(UINib.init(nibName: intelligentClockCellID, bundle: nil), forCellReuseIdentifier: intelligentClockCellID)
    }

}

// MARK: - UITableViewDataSource
extension IntelligentClockViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = dataSource?.alarmListModel.alarmRealmList.count else {
            return 0
        }
        
        return count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(intelligentClockCellID, forIndexPath: indexPath) as? IntelligentClockCell
        
        cell?.configure(IntelligentClockCellViewModel(alarm: dataSource!.alarmListModel.alarmRealmList[indexPath.row], index: indexPath.row))
        
        cell?.delegate = self
        
        return cell!
        
    }
    
}

// MARK: - UITableViewDelegate
extension IntelligentClockViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableSectionHederHeight
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableSevtionFooterHeight
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let tableFooterView = IntelligentClockTableFooterView(frame: CGRect(x: 0, y: 0, w: ez.screenWidth - tableViewMargin * 2, h: tableSevtionFooterHeight))
        
        return tableFooterView
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableHeaderView = IntelligentClockTableHeaderView(frame: CGRect(x: 0, y: 0, w: ez.screenWidth - tableViewMargin * 2, h: tableSectionHederHeight))
        
        return tableHeaderView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let targetVC = StoryboardScene.AlarmClock.instantiateAddClockViewController()
        
        targetVC.alarmModel = (dataSource?.getAlarmModelCopyByIndex(indexPath.row))!
        
        targetVC.updateAlarmBlock = {(alarm: AlarmRealmModel, isUpdate: Bool) -> Void in
            
            Log.info(alarm)
            
            if isUpdate {
                self.dataSource?.updateAlarm(alarm, index: indexPath.row)
            } else {
                self.dataSource?.deleteAlarm(indexPath.row)
            }
            
            self.tableView.reloadData()
            
        }
        
        self.pushVC(targetVC)
    }

}

// MARK: - IntelligentClockCellDelegate
extension IntelligentClockViewController: IntelligentClockCellDelegate {

    func changeAlarmOpenStatus(index: Int) {
        dataSource?.changeAlarmOpenStatus(index)
    }
    
}

