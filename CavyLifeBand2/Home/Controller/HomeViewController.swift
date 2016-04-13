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


class HomeViewController: BaseViewController {

    /// 上部分 计步睡眠天气页面
    var upperView: HomeUpperView?
    
    /// 日期滑动View
    
    /// 时间轴 TableView

    
    var edgesLong: CGFloat?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.pushNextView), name: NotificationName.HomeLeftOnClickCellPushView.rawValue, object: nil)

        addAllView()
        
        // Do any additional setup after loading the view.
    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        upperView!.frame = CGRectMake(0, 0, ez.screenWidth, 96 + ez.screenWidth * 0.55)

    }
    
    
    func addAllView() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navBar?.translucent = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .Plain, target: self, action: #selector(showLeftView))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right", style: .Plain, target: self, action: #selector(showLeftView))
        
        upperView = NSBundle.mainBundle().loadNibNamed("HomeUpperView", owner: nil, options: nil).first as? HomeUpperView
        upperView!.allViewLayout()
        view.addSubview(upperView!)
        
    }
    
    
    
    
    
    /**
     计步视图
     */
    func addStepView() {
        
    }
    
    /**
     睡眠视图
     */
    func addSleepView() {
        
    }
    
    
    /**
     天气视图
     */
    func addWeatherView() {
        
    }
    
    /**
     日期选择视图
     */
    func addDateView() {
        
    }
    
    /**
     时间轴视图
     */
    func addTimeline() {
        
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showLeftView() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeLeftOnClickMenu.rawValue, object: nil)
        
    }
    
    func pushNextView(userInfo: NSNotification) {

        guard let viewController = userInfo.userInfo?["nextView"] as? UIViewController else {
            return
        }
        
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }

}
