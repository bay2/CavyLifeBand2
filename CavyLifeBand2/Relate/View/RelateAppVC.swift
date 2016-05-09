//
//  RelateAppVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class RelateAppVC: UIViewController, BaseViewControllerPresenter {
    
    @IBOutlet weak var tableView: UITableView!
    
    var navTitle: String { return L10n.RelateRelateAppNavTitle.string }
    
    let relateAppCellID = "RelateAppCell"
    
    var tableDataSource: [RelateAppCellDataSource] = [RelateAppCellDataSource]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableDataSource = [RelateAppCellModel(info: "这是豚鼠游戏", size: "11.0", title: "豚鼠游戏", logoStr: "", index: 0),
                           RelateAppCellModel(info: "这是豚鼠手环", size: "12.0", title: "豚鼠手环", logoStr: "", index: 1)]
        
        updateNavUI()
        
        baseTableSetting()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func baseTableSetting() {
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        tableView.separatorStyle = .None
        
        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib.init(nibName: relateAppCellID, bundle: nil), forCellReuseIdentifier: relateAppCellID)
    }
    
    func downloadAction(sender: UIButton) {
        Log.info("download action - \(sender.tag)")
    }

}

// MARK: - UITableViewDelegate
extension RelateAppVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 92.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
}

// MARK: - UITableViewDelegate
extension RelateAppVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableDataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(relateAppCellID, forIndexPath: indexPath) as? RelateAppCell
        
        cell?.configure(tableDataSource[indexPath.section])
        
        return cell!
        
    }
    
}