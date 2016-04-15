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

class IntelligentClockViewController: ContactsBaseViewController {

    let tableViewMargin: CGFloat            = 20.0

    let tableSectionHederHeight: CGFloat    = 10.0

    let tableSevtionFooterHeight: CGFloat   = 50.0

    let intelligentClockCellHeight: CGFloat = 50.0
    
    let intelligentClockCellID = "IntelligentClockCell"
    
    var realm: Realm = try! Realm()
    
    var dataSource: IntelligentClockVCViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = L10n.AlarmClockTitle.string
        Log.warning("|\(self.className)| ---- NavigationBar Title 待修改")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "AlarmClockAdd"),
                                                                 style: .Plain,
                                                                 target: self,
                                                                 action: #selector(rightBarBtnAciton(_:)))
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        dataSource = IntelligentClockVCViewModel(realm: realm)
        
        tableBaseSetting()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     跳转添加闹钟
     */
    func rightBarBtnAciton(sender: UIBarButtonItem) -> Void {
        
        let targetVC = StoryboardScene.AlarmClock.instantiateAddClockViewController()
        
        targetVC.addNewClock = true
        
        targetVC.updateAlarmBlock = { (alarm: AlarmRealmModel, isUpdate: Bool) -> Void in
            
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
        
        tableView.snp_makeConstraints { (make) in
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
        return (dataSource?.alarmListModel.alarmRealmList.count)!
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
        
        targetVC.updateAlarmBlock = { (alarm: AlarmRealmModel, isUpdate: Bool) -> Void in
            
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

