//
//  IntelligentClockViewController.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class IntelligentClockViewController: ContactsBaseViewController {

    let tableViewMargin: CGFloat            = 20.0

    let tableSectionHederHeight: CGFloat    = 10.0

    let tableSevtionFooterHeight: CGFloat   = 50.0

    let intelligentClockCellHeight: CGFloat = 50.0
    
    let intelligentClockCellID = "IntelligentClockCell"
    
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
        
        
        tableBaseSetting()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func rightBarBtnAciton(sender: UIBarButtonItem) -> Void {
        Log.warning("|\(self.className)| -- 右上角添加")
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
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(intelligentClockCellID, forIndexPath: indexPath)
        
        return cell
        
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

}

