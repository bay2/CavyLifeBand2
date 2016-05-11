//
//  RelateAppVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import MJRefresh

class RelateAppVC: UIViewController, BaseViewControllerPresenter {
    
    @IBOutlet weak var tableView: UITableView!
    
    var navTitle: String { return L10n.RelateRelateAppNavTitle.string }
    
    let relateAppCellID = "RelateAppCell"
    
    var tableDataSource: [RelateAppCellDataSource] = [RelateAppCellDataSource]()
    
    var totalIndex: Int = Int(MAXINTERP)
    
    var currentIndex: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        tableDataSource = [RelateAppCellModel(info: "这是豚鼠游戏", size: "11.0", title: "豚鼠游戏", logoStr: "", index: 0),
                           RelateAppCellModel(info: "这是豚鼠手环", size: "12.0", title: "豚鼠手环", logoStr: "", index: 1)]
        
        updateNavUI()
        
        baseTableSetting()
        
        loadDataByIndex()
        
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
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(RelateAppVC.loadDataByIndex))
        
    }
    
    func downloadAction(sender: UIButton) {
        
        goDetailInfoWeb(sender.tag)
        
    }
    
    func goDetailInfoWeb(index: Int) {
        
        //TODO:前往查看详情H5
        Log.info("前往查看详情H5 - \(index)")
        
        let targetVC = WebViewController()
        
        targetVC.dataSource = RelateAppDetailInfoWebViewModel()
        
        self.pushVC(targetVC)
        
    }

    func loadDataByIndex() {
        
        //TODO:调接口加载数据"
        Log.info("调接口加载数据")
        
//        totalIndex =
        
//        currentIndex = 
        
//        tableDataSource.append(<#T##newElement: Element##Element#>)
        
//        if currentIndex == totalIndex {
//            self.tableView.mj_footer.endRefreshingWithNoMoreData()
//        } else {
//            self.tableView.mj_footer.endRefreshing()
//        }
        
//        tableView.insertRowsAtIndexPaths(<#T##indexPaths: [NSIndexPath]##[NSIndexPath]#>, withRowAnimation: .None)
        
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
        
        goDetailInfoWeb(indexPath.section)
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