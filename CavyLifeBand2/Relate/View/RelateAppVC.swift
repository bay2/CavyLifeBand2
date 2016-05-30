//
//  RelateAppVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
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
        
        tableView.backgroundColor = UIColor(named: .RalateAppTableBGColor)
        
        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib.init(nibName: relateAppCellID, bundle: nil), forCellReuseIdentifier: relateAppCellID)
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(RelateAppVC.loadDataByIndex))
        
    }
    
    func goDetailInfoWeb(index: Int) {
        
        let targetVC = WebViewController()
        
        targetVC.dataSource = RelateAppDetailInfoWebViewModel(webUrlStr: tableDataSource[index].webUrlStr)
        
        self.pushVC(targetVC)
        
    }

    func loadDataByIndex() {
                
        do {
            
            try RelateAppWebApi.shareApi.getRelateAppList(currentIndex) { result in
                
                guard result.isSuccess else {
                    return
                }
                
                let resultMsg = try! RelateAppResponse(JSONDecoder(result.value!))
                
                guard resultMsg.commonMsg.code == WebGetApiCode.Success.rawValue else {
                    return
                }
                
                self.currentIndex += 1
                
                if resultMsg.data.gamelist.count == 0 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    return
                }
                
                let gameList = resultMsg.data.gamelist
                
                for i in 0..<gameList.count {
                    
                    self.tableDataSource.append(RelateAppCellModel(gameModel: gameList[i]))
                    
                }
                
                self.tableView.mj_footer.endRefreshing()
                
                self.tableView.reloadData()
                
            }
            
        } catch let error {
            Log.error(error)
        }
        
    }

}

// MARK: - UITableViewDelegate
extension RelateAppVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 92.0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        goDetailInfoWeb(indexPath.row)
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
    }
    
}

// MARK: - UITableViewDelegate
extension RelateAppVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(relateAppCellID, forIndexPath: indexPath) as? RelateAppCell
        
        cell?.configure(tableDataSource[indexPath.row])
        
        return cell!
        
    }
    
}