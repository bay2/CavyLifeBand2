//
//  HelpAndFeedbackListVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import EZSwiftExtensions

class HelpAndFeedbackListVC: UIViewController, BaseViewControllerPresenter {

    @IBOutlet weak var tableView: UITableView!
    
    let tableSectionHeight: CGFloat = 10.0
    
    var navTitle: String { return L10n.RelateHelpAndFeedbackNavTitle.string }
    
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    lazy var rightBtn: UIButton? =  {
        
        let button = UIButton(type: .System)
        
        let titleSize = L10n.RelateHelpAndFeedbackNavRightBtnTitle.string.boundingRectWithSize(CGSizeMake(100, 20), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.mediumSystemFontOfSize(14.0)], context: nil)
        
        button.frame = CGRectMake(0, 0, titleSize.width, 30)
        button.setTitle(L10n.RelateHelpAndFeedbackNavRightBtnTitle.string, forState: .Normal)
        button.titleLabel?.font = UIFont.mediumSystemFontOfSize(14.0)
        button.setTitleColor(UIColor(named: .AColor), forState: .Normal)
        
        return button
        
    }()
    
    let HelpAndFeedbackCellID = "AboutCell"
    
    var tableDataSource: [AboutCellDataSource] = [AboutCellDataSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        updateNavUI()
        
        addLodingView()
        
        tableViewSetting()
        
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRightBtn() {
        
        let targetVC = StoryboardScene.Relate.instantiateHelpAndFeedbackVC()
        
        self.pushVC(targetVC)
        
    }
    
    /**
     返回按钮处理
     */
    func onLeftBtnBack() {
        
        self.navigationController?.popViewControllerAnimated(false)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeLeftOnClickMenu.rawValue, object: nil)
        
    }
    
    func tableViewSetting() {
        
        tableView.delegate           = self

        tableView.dataSource         = self

        tableView.separatorStyle     = .None

        tableView.tableFooterView    = UIView()

        tableView.tableFooterView    = UIView()

        tableView.backgroundColor    = UIColor.clearColor()

        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        tableView.estimatedRowHeight = 50.0
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.registerNib(UINib.init(nibName: HelpAndFeedbackCellID, bundle: nil), forCellReuseIdentifier: HelpAndFeedbackCellID)
        
    }
    
    //添加转圈圈提示view
    func addLodingView() {
        
        self.view.addSubview(loadingView)
        
        loadingView.hidesWhenStopped = true
        
        loadingView.activityIndicatorViewStyle = .Gray
        
        loadingView.snp_makeConstraints { make in
            make.center.equalTo(self.view)
            make.width.equalTo(50.0)
            make.height.equalTo(50.0)
        }
        
    }
    
    func loadData() {
        
        loadingView.startAnimating()
        
        HelpFeedbackWebApi.shareApi.getHelpFeedbackList({
            
            for help in $0.helpList {
                
                let celVM = HelpFeedbackCellModel(title: help.title, webStr: help.webUrl)
                
                self.tableDataSource.append(celVM)
                
                self.tableView.reloadData()
            }
            
            self.loadingView.stopAnimating()
            
        }) {
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(message: $0.msg)
            self.loadingView.stopAnimating()
            
        }

    }

}

// MARK: - UITableViewDelegate
extension HelpAndFeedbackListVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableSectionHeight
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableSectionHeight
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFrame = CGRect(x: 0, y: 0, w: tableView.frame.width, h: tableSectionHeight)
        
        let tableFooterView = AboutSectionEmptyView(frame: viewFrame, cornerType: .Bottom)
        
        return tableFooterView
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewFrame = CGRect(x: 0, y: 0, w: tableView.frame.width, h: tableSectionHeight)
        
        let tableHeaderView = AboutSectionEmptyView(frame: viewFrame, cornerType: .Top)
        
        return tableHeaderView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let targetVC = WebViewController()
        
        //消除引用循环
        weak var weakTargetVC = targetVC
        
        let navHandler: navBtnHandle =  {
            weakTargetVC!.pushVC(StoryboardScene.Relate.instantiateHelpAndFeedbackVC())
        }
        
        let cellVM = tableDataSource[indexPath.row] as? HelpFeedbackCellModel
                
        targetVC.dataSource = HelpAndFeedBackWebViewModel(webUrlStr: cellVM?.webUrlStr ?? "www.baidu.com", navAction: navHandler)
        
        self.pushVC(targetVC)

    }
    
    
    
}

// MARK: - UITableViewDelegate
extension HelpAndFeedbackListVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HelpAndFeedbackCellID, forIndexPath: indexPath) as? AboutCell
        
        cell?.configure(tableDataSource[indexPath.row])
        
        return cell!
        
    }
    
}

