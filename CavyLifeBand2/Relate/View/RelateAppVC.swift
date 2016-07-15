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
    
    lazy var loadingView: UIActivityIndicatorView = {
        
        let loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
        
        loadingView.hidesWhenStopped = true
        
        loadingView.activityIndicatorViewStyle = .Gray
        
        self.view.addSubview(loadingView)
        
        loadingView.snp_makeConstraints { make in
            make.center.equalTo(self.view)
            make.width.equalTo(50.0)
            make.height.equalTo(50.0)
        }
        
        return loadingView

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        updateNavUI()
        
        baseTableSetting()
        
        loadDataByIndex()
        
    }
    
    /**
     返回按钮处理
     */
    func onLeftBtnBack() {
        
        self.navigationController?.popViewControllerAnimated(false)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeLeftOnClickMenu.rawValue, object: nil)
        
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
        
//        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(RelateAppVC.loadDataByIndex))
//        
//        self.tableView.mj_footer.beginRefreshing()
        
    }
    
    func goDetailInfoWeb(index: Int) {
        
        let targetVC = WebViewController()
        
        targetVC.dataSource = RelateAppDetailInfoWebViewModel(webUrlStr: tableDataSource[index].webUrlStr)
        
        self.pushVC(targetVC)
        
    }

    func loadDataByIndex() {
        
        loadingView.startAnimating()
        
        RelateAppWebApi.shareApi.getRelateAppList(self.currentIndex, successHandler: { [unowned self] (gameList) in
            
            // 分页加载功能暂时注释
            
//            self.currentIndex += 1
//            
//            if gameList.count == 0 {
//                self.tableView.mj_footer.endRefreshingWithNoMoreData()
//                return
//            }
            
            for i in 0..<gameList.count {
                
                self.tableDataSource.append(RelateAppCellModel(gameModel: gameList[i]))
                
            }
            
//            self.tableView.mj_footer.endRefreshing()
            
            self.loadingView.stopAnimating()
            
            self.tableView.reloadData()
            
        }) { (msg) in
            
//            self.tableView.mj_footer.endRefreshing()
            
            self.loadingView.stopAnimating()
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(message: msg.msg)
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