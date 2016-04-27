//
//  HomeViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Log
import EZSwiftExtensions


class HomeViewController: UIViewController, BaseViewControllerPresenter {
    
    var leftBtn: UIButton? = {
        
        let button = UIButton(type: .System)
        button.setBackgroundImage(UIImage(asset: .HomeLeftMenu), forState: .Normal)
        
        return button
    }()
    
    var rightBtn: UIButton? = {
        
        let button = UIButton(type: .System)
        button.size = CGSizeMake(30, 30)
        button.setBackgroundImage(UIImage(asset: .HomeBandMenu), forState: .Normal)
        
        return button
        
    }()
    
    var navTitle: String { return "" }
    
    /// 上部分 计步睡眠天气页面
    var upperView: HomeUpperView?
    
    /// 日期滑动View
    var dateView = HomeDateView()
    
    /// 下面时间轴View
    var timeLineView = HomeTimeLineView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.pushNextView), name: NotificationName.HomePushView.rawValue, object: nil)

        addAllView()
        
        self.updateNavUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        upperView!.frame = CGRectMake(0, 0, ez.screenWidth, 96 + ez.screenWidth * 0.55)

    }
    
    /**
     添加子视图
     */
    func addAllView() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        upperView = NSBundle.mainBundle().loadNibNamed("HomeUpperView", owner: nil, options: nil).first as? HomeUpperView
        upperView!.allViewLayout()
        upperView!.viewController = self
        view.addSubview(upperView!)
        
        view.addSubview(dateView)
        dateView.backgroundColor = UIColor.whiteColor()
        dateView.snp_makeConstraints { make in
            make.top.equalTo(self.view).offset(96 + ez.screenWidth * 0.55)
            make.left.right.equalTo(self.view)
            make.height.equalTo(50)
        }
        
        view.addSubview(timeLineView)
        timeLineView.snp_makeConstraints { make in
            make.top.equalTo(dateView).offset(50)
            make.left.right.bottom.equalTo(self.view)
        }
        
        
    }
    
    /**
     点击左侧按钮
     */
    func onLeftBtnBack() {
        self.showLeftView()
    }
    
    /**
     点击手环菜单
     */
    func onRightBtn() {
        self.showRightView()
    }
    
    /**
     展示左侧菜单
     */
    func showLeftView() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeLeftOnClickMenu.rawValue, object: nil)
        
    }
    
    /**
     展示右侧菜单
     */
    func showRightView() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeRightOnClickMenu.rawValue, object: nil)
        
    }
    
    /**
     跳转到新的视图
     
     - parameter userInfo:
     */
    func pushNextView(userInfo: NSNotification) {

        guard let viewController = userInfo.userInfo?["nextView"] as? UIViewController else {
            return
        }
        
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
