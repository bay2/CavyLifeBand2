//
//  HelpAndFeedbackListVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class HelpAndFeedbackListVC: UIViewController, BaseViewControllerPresenter {

    @IBOutlet weak var tableView: UITableView!
    
    let tableSectionHeight: CGFloat = 10.0
    
    var navTitle: String { return L10n.RelateHelpAndFeedbackNavTitle.string }
    
    lazy var rightBtn: UIButton? =  {
        
        let button = UIButton(type: .System)
        
        button.frame = CGRectMake(0, 0, 58, 30)
        button.setTitle(L10n.RelateHelpAndFeedbackNavRightBtnTitle.string, forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
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
        
        tableDataSource = [AboutCellModel(title: "手环连接失败？"),
                           AboutCellModel(title: "按了手环按钮没有亮灯？"),
                           AboutCellModel(title: "安全功能如何使用？"),
                           AboutCellModel(title: "手环不能记录睡眠？"),
                           AboutCellModel(title: "手环不能记录计步？")]
        
        tableViewSetting()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRightBtn() {
        
        let targetVC = StoryboardScene.Relate.instantiateHelpAndFeedbackVC()
        
        self.pushVC(targetVC)
        
    }
    
    func tableViewSetting() {
        
        tableView.delegate           = self

        tableView.dataSource         = self

        tableView.separatorStyle     = .None

        tableView.tableFooterView    = UIView()

        tableView.tableFooterView    = UIView()

        tableView.backgroundColor    = UIColor.clearColor()

        tableView.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        tableView.registerNib(UINib.init(nibName: HelpAndFeedbackCellID, bundle: nil), forCellReuseIdentifier: HelpAndFeedbackCellID)
        
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
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
                
        targetVC.dataSource = HelpAndFeedBackWebViewModel(webUrlStr: "http://www.baidu.com", navAction: navHandler)
        
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

