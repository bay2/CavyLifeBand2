//
//  SafetySettingViewController.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class SafetySettingViewController: UIViewController, BaseViewControllerPresenter {

    @IBOutlet weak var tableView: UITableView!
    
    let tableViewMargin: CGFloat          = 20.0
    
    let tableSectionHeaderHeight: CGFloat = 10.0
    
    let tableSectionFooterHeight: CGFloat = 100.0
    
    let safetySwitchCell  = "SettingSwitchTableViewCell"

    let safetyContactCell = "EmergencyContactPersonCell"
    
    var navTitle: String { return L10n.HomeRightListTitleSecurity.string }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = L10n.SettingSafetyTitle.string
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "AlarmClockAdd"),
                                                                 style: .Plain,
                                                                 target: self,
                                                                 action: #selector(rightBarBtnAciton(_:)))
        
        tableView.rowHeight       = 50.0
        tableView.backgroundColor = UIColor(named: .HomeViewMainColor)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        tableView.showsVerticalScrollIndicator = false
        
        tableView.registerNib(UINib(nibName: safetySwitchCell, bundle: nil), forCellReuseIdentifier: safetySwitchCell)
        
        tableView.registerNib(UINib(nibName: safetyContactCell, bundle: nil), forCellReuseIdentifier: safetyContactCell)
        
        tableView.snp_makeConstraints { (make) in
            
            make.trailing.equalTo(self.view).offset(-tableViewMargin)
            
            make.leading.equalTo(self.view).offset(tableViewMargin)
            
        }
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        updateNavUI()
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

    func rightBarBtnAciton(sender: UIBarButtonItem) -> Void {
        Log.warning("|\(self.className)| -- 右上角添加")
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
    
}

// MARK: - UITableViewDelegate
extension SafetySettingViewController: UITableViewDelegate {
    
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
