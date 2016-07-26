//
//  HomeViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Log
import JSONJoy
import SnapKit
import EZSwiftExtensions
import RealmSwift
import MJRefresh

let dateViewHeight: CGFloat = 50.0
// 大环是 0.55 大环顶部距离NavBar高度是 96
let ringViewHeight: CGFloat = 96 + ez.screenWidth * 0.55
let navBarHeight: CGFloat = 64.0

class HomeViewController: UIViewController, BaseViewControllerPresenter, ChartsRealmProtocol, SinglePKRealmModelOperateDelegate, ChartStepRealmProtocol, QueryUserInfoRequestsDelegate {
    
    var leftBtn: UIButton? = {
        
        let button = UIButton(type: .System)

        button.setBackgroundImage(UIImage(asset: .HomeLeftMenu), forState: .Normal)
        
        return button
    }()
    
    var rightBtn: UIButton? = {
        
        let button = UIButton(type: .System)
        button.size = CGSizeMake(30, 30)
        
        if LifeBandBle.shareInterface.getConnectState() == .Connected {
            button.setBackgroundImage(UIImage(asset: .HomeBandMenu), forState: .Normal)
        } else {
            button.setBackgroundImage(UIImage(asset: .HomeDisBandMenu), forState: .Normal)
        }
        
        return button
        
    }()
    
    var navTitle: String { return "" }
    
    var scrollView = UIScrollView()
    
    /// 上部分 计步睡眠天气页面
    var upperView: HomeUpperView?
    
    /// 日期滑动View
    var dateView = HomeDateView()
    
    /// 下面时间轴View
    var timeLineView = HomeTimeLineView()
    
    var realm: Realm = try! Realm()
    
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
        
    static var shareInterface = HomeViewController()
    
    deinit {
        removeNotificationObserver()
    }
    
    // MARK: -- viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()

        parseChartListData()

        addAllView()
        
        self.updateNavUI()
        
        addNotificationObserver(NotificationName.HomePushView.rawValue, selector: #selector(HomeViewController.pushNextView))
        addNotificationObserver(NotificationName.HomeShowStepView.rawValue, selector: #selector(HomeViewController.showStepDetailView))
        addNotificationObserver(NotificationName.HomeShowSleepView.rawValue, selector: #selector(HomeViewController.showSleepDetailView))
        addNotificationObserver(NotificationName.HomeShowPKView.rawValue, selector: #selector(HomeViewController.showPKDetailView))
        addNotificationObserver(NotificationName.HomeShowAchieveView.rawValue, selector: #selector(HomeViewController.showAchieveDetailView))
        addNotificationObserver(NotificationName.HomeShowHealthyView.rawValue, selector: #selector(HomeViewController.showHealthyDetailView))
        
        addNotificationObserver(BandBleNotificationName.BandDesconnectNotification.rawValue, selector: #selector(HomeViewController.bandDesconnect))
        addNotificationObserver(BandBleNotificationName.BandConnectNotification.rawValue, selector: #selector(HomeViewController.bandConnect))
        
        // 刷新
        addRefershHeader()
        addNotificationObserver(RefreshStyle.BeginRefresh.rawValue, selector: #selector(beginBandRefersh))
        addNotificationObserver(RefreshStyle.StopRefresh.rawValue, selector: #selector(endBandRefersh))
 
    }

    /**
     手环断线通知
     
     - author: sim cai
     - date: 2016-05-31
     */
    func bandDesconnect() {
        rightBtn?.setBackgroundImage(UIImage(asset: .HomeDisBandMenu), forState: .Normal)
    }
    
    /**
     手环连接
     
     - author: sim cai
     - date: 2016-05-31
     */
    func bandConnect() {
        

        // 手环连接 自动同步数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue ()) {
            // 等待两秒 连接手环的时间
            self.scrollView.mj_header.beginRefreshing()
            
        }
        rightBtn?.setBackgroundImage(UIImage(asset: .HomeBandMenu), forState: .Normal)
        
    }
    
    /**
     添加子视图
     */
    func addAllView() {
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSizeMake(ez.screenWidth, navBarHeight + navBarHeight)
        scrollView.backgroundColor = UIColor(named: .HomeViewMainColor)
        scrollView.delegate = self
        scrollView.snp_makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(self.view)
        }
        
        upperView = NSBundle.mainBundle().loadNibNamed("HomeUpperView", owner: nil, options: nil).first as? HomeUpperView
        upperView?.viewController = self
        scrollView.addSubview(upperView!)
        upperView!.snp_updateConstraints { make in
            make.top.left.right.equalTo(0)
            make.size.equalTo(CGSizeMake(ez.screenWidth, ringViewHeight))
            make.centerX.equalTo(0)
            
        }
        
        scrollView.addSubview(dateView)
        dateView.backgroundColor = UIColor(named: .HomeViewMainColor)
        dateView.snp_updateConstraints { make in
            make.top.equalTo(scrollView).offset(ringViewHeight)
            make.left.right.equalTo(scrollView)
            make.height.equalTo(dateViewHeight)
        }
        
        scrollView.addSubview(timeLineView)
        timeLineView.snp_updateConstraints { make in
            make.top.equalTo(dateView.snp_bottom)
            make.size.equalTo(CGSizeMake(ez.screenWidth, ez.screenHeight - navBarHeight - ringViewHeight - dateViewHeight))
            make.centerX.equalTo(0)
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
        
        if let guide = viewController as? GuideViewController {
            
            if guide.dataSource is GuideBandBluetooth {
                
                CavyDefine.bluetoothPresentViewController(UINavigationController(rootViewController: viewController))
                
                return
            }
        
        }
        
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }

    
    // MARK: 解析数据 保存数据库
    
    /**
     解析 计步睡眠数据 并保存Realm 每次请求前前先删除最后一条数据 在获取时间同步
     */
    func parseChartListData() {
        

        // MARK: 睡眠相关
        SleepWebApi.shareApi.fetchSleepWebData()
        
        // MARK: 计步相关
        StepWebApi.shareApi.fetchStepWebData()
        
    }
    
            
    // MARK: 加载详情
    /**
     显示计步页面
     */
    func showStepDetailView(){
        
        let stepVM = ChartViewModel(title: L10n.ContactsShowInfoStep.string, chartStyle: .StepChart)
        let chartVC = ChartsViewController()
        chartVC.configChartsView(stepVM)
        self.pushVC(chartVC)
        
    }
    
    /**
     显示睡眠页面
     */
    func showSleepDetailView(){
        
        let sleepVM = ChartViewModel(title: L10n.ContactsShowInfoSleep.string, chartStyle: .SleepChart)
        let chartVC = ChartsViewController()
        chartVC.configChartsView(sleepVM)
        self.pushVC(chartVC)
        
    }
    
    /**
     显示PK页面
     */
    func showPKDetailView(notification: NSNotification) {
        // SinglePKRealmModelOperateDelegate
        let status = notification.userInfo!["status"] as! String
        let pkId = notification.userInfo!["pkId"] as! String
        
        // 在进行 PK状态：1:进行中 2：已完成
        if status.contains("\(L10n.PKRecordsVCDueSectionTitle.string)") {
            
            let pkModel = self.getPKDueRecordByPKId(pkId)! as PKDueRealmModel
            
            popPKVC(pkModel)
            
        } else {
            // 已经结束
            
            let pkModel: PKFinishRealmModel = getPKFinishRecordByPKId(pkId)!
            
            popPKVC(pkModel)
        }
        
    }
    
    /**
     显示成就页面
     */
    func showAchieveDetailView(notification: NSNotification){
        
        
        let maskView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight))
        maskView.backgroundColor = UIColor(named: .HomeViewMaskColor)
        
        maskView.addTapGesture { tap in
            maskView.removeFromSuperview()
        }

        let achieveView = NSBundle.mainBundle().loadNibNamed("UserAchievementView", owner: nil, options: nil).first as? UserAchievementView
        
        // TODO 数据结构有变
        achieveView?.configWithAchieveIndexForUser()

        maskView.addSubview(achieveView!)
        
        let collectionViewHeight = ez.screenWidth <= 320 ? CGFloat(3 * 132) : CGFloat(2 * 132)

        achieveView!.snp_makeConstraints(closure: { make in
            make.leading.equalTo(maskView).offset(20.0)
            make.trailing.equalTo(maskView).offset(-20.0)
            make.centerY.equalTo(maskView)
            make.height.equalTo(68 + collectionViewHeight)
        })
        
        UIApplication.sharedApplication().keyWindow?.addSubview(maskView)
        
        queryUserInfoByNet { resultUserInfo in
            
            achieveView?.configWithAchieveIndexForUser()
            
        }
        
    }
    
    /**
     显示健康页面
     */
    func showHealthyDetailView(notification: NSNotification) {
        
        let requestVC = StoryboardScene.Contacts.instantiateContactsFriendInfoVC()

        let userInfo = notification.userInfo
        
        guard let friendName = userInfo?["friendName"] as? String else {
            return
        }
        
        guard let friendId = userInfo?["friendId"] as? String else {
            return
        }
        
        if friendName != "" && friendId != "" {
        
            requestVC.friendNickName = friendName
            requestVC.friendId = friendId

        }

        self.pushVC(requestVC)
        
    }
    
    /**
     显示PK View
     */
    func popPKVC(pkModel: PKRecordRealmDataSource) {
        
        let maskView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight))
        maskView.backgroundColor = UIColor(named: .HomeViewMaskColor)
        
        maskView.addTapGesture { tap in
            maskView.removeFromSuperview()
        }
        
        guard let pkInfoView = NSBundle.mainBundle().loadNibNamed("PKInfoOrResultView", owner: nil, options: nil).first as? PKInfoOrResultView else {
            return
        }
        
        pkInfoView.configure(PKInfoOrResultViewModel(pkRealm: pkModel))
        
        pkInfoView.addTapGesture { sender in }
        
        maskView.addSubview(pkInfoView)
        
        pkInfoView.snp_makeConstraints(closure: { make in
            make.leading.equalTo(maskView).offset(20.0)
            make.trailing.equalTo(maskView).offset(-20.0)
            make.centerY.equalTo(maskView)
            make.height.equalTo(380.0)
        })
        
        UIApplication.sharedApplication().keyWindow?.addSubview(maskView)
        
    }
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



