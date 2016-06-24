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

class HomeViewController: UIViewController, BaseViewControllerPresenter, ChartsRealmProtocol, HomeListRealmProtocol, SinglePKRealmModelOperateDelegate {
    
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
    
    var aphlaView: UIView?
    var activityView: UIActivityIndicatorView?
    
    deinit {
        removeNotificationObserver()
    }
    
    // MARK: -- viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        parseChartListData()

        addAllView()
        addRefresh()
        scrollView.mj_header.beginRefreshing()

        self.updateNavUI()
        
        addNotificationObserver(NotificationName.HomePushView.rawValue, selector: #selector(HomeViewController.pushNextView))
        addNotificationObserver(NotificationName.HomeShowStepView.rawValue, selector: #selector(HomeViewController.showStepDetailView))
        addNotificationObserver(NotificationName.HomeShowSleepView.rawValue, selector: #selector(HomeViewController.showSleepDetailView))
        addNotificationObserver(NotificationName.HomeShowPKView.rawValue, selector: #selector(HomeViewController.showPKDetailView))
        addNotificationObserver(NotificationName.HomeShowAchieveView.rawValue, selector: #selector(HomeViewController.showAchieveDetailView))
        addNotificationObserver(NotificationName.HomeShowHealthyView.rawValue, selector: #selector(HomeViewController.showHealthyDetailView))
        addNotificationObserver(BandBleNotificationName.BandDesconnectNotification.rawValue, selector: #selector(HomeViewController.bandDesconnect))
        addNotificationObserver(BandBleNotificationName.BandConnectNotification.rawValue, selector: #selector(HomeViewController.bandConnect))
        // 后台进入前台 同步数据
        addNotificationObserver("updateHomeViewData", selector: #selector(refreshingStatus))
 

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
     添加下拉刷新
     */
    func addRefresh() {
        
        let header = MJRefreshHeader(refreshingBlock: {
            
            //MARK: 手动刷新
            RootViewController().syncDataFormBand(false)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue ()) {
                
                self.scrollView.mj_header.endRefreshing()
            }

        })

        header.backgroundColor = UIColor(named: .HomeViewMainColor)
        scrollView.mj_header = header
        
    }
    
    /**
     同步数据
     */
    func refreshingStatus() {
        
        scrollView.mj_header.beginRefreshing()
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
    
    // MARK: --- 解析数据 保存数据库
    
    /**
     解析 计步睡眠数据 并保存Realm
     */
    func parseChartListData() {
        
        var startDate = ""
        var endDate = ""
        
        if isNeedUpdateStepData() {
            
            let personalList = realm.objects(ChartStepDataRealm).filter("userId = '\(userId)'")
            
            if personalList.count != 0 {
                
                startDate = personalList.last!.time.toString(format: "yyyy-MM-dd HH:mm:ss")
                endDate = NSDate().toString(format: "yyyy-MM-dd HH:mm:ss")
                
            }
            
            parseStepDate(startDate, endDate: endDate)
            
        }
        
        
        if isNeedUpdateSleepData() {
            
            let personalList = realm.objects(ChartSleepDataRealm).filter("userId = '\(userId)'")
            
            if personalList.count != 0 {
                
                startDate = personalList.last!.time.toString(format: "yyyy-MM-dd HH:mm:ss")
                endDate = NSDate().toString(format: "yyyy-MM-dd HH:mm:ss")
                
            }
            
            parseSleepDate(startDate, endDate: endDate)
            
        }
        
 
    }
    
      /**
     解析计步数据
     时间格式： yyyy-MM-dd
     有时间：更新数据
     没有时间：解析全部数据
     */
    func parseStepDate(startDate: String, endDate: String) {

        ChartsWebApi.shareApi.parseStepChartsData(startDate, endDate: endDate) { result in

            guard result.isSuccess else {
                Log.error("Parse Home Lists Data Error")
                return
            }
            
            do {
                
                let netResult = try ChartStepMsg(JSONDecoder(result.value!))

                
                for list in netResult.stepList {
                    // 保存到数据库
                    self.addStepListRealm(list)
                }
                
            } catch let error {
                
                Log.error("\(#function) result error: \(error)")
            }
            
        }

    }
    
    /**
     解析睡眠数据
     时间格式： yyyy-MM-dd
     有时间：更新数据
     没有时间：解析全部数据
     */
    func parseSleepDate(startDate: String, endDate: String) {

        ChartsWebApi.shareApi.parseSleepChartsData(startDate, endDate: endDate) { result in
            
            guard result.isSuccess else {
                Log.error("Parse Home Lists Data Error")
                return
            }
            do {
                Log.info(result.value!)
                let netResult = try ChartSleepMsg(JSONDecoder(result.value!))
                for list in netResult.sleepList {
                    
                    Log.info(list)
                    // 保存到数据库
                    self.addSleepListRealm(list)
                }
                
            } catch let error {
                Log.error("\(#function) result error: \(error)")
            }
            
        }

    }
    
      /**
     添加计步信息
     
     - author: sim cai
     - date: 16-05-27 10:05:27
     
     
     - parameter list: 计步信息JSON
     */
    func addStepListRealm(list: StepMsg) {
        
        guard let date = NSDate(fromString: list.dateTime, format: "yyyy-MM-dd HH:mm:ss") else {
            return
        }
        
        self.addStepData(ChartStepDataRealm(userId: self.userId, time: date, step: list.stepCount))

    }
    
    func addSleepListRealm(list: SleepMsg) {
        
        guard let time = NSDate(fromString: list.dateTime, format: "yyyy-MM-dd HH:mm:ss") else {
            Log.error("Time from erro [\(list.dateTime)]")
            return
        }
        
        self.addSleepData(ChartSleepDataRealm(userId: self.userId, time: time, tilts: list.rollCount))

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
        
        achieveView?.configWithAchieveIndex((notification.object as? Int) ?? 0)

        maskView.addSubview(achieveView!)

        achieveView!.snp_makeConstraints(closure: { make in
            make.leading.equalTo(maskView).offset(20.0)
            make.trailing.equalTo(maskView).offset(-20.0)
            make.centerY.equalTo(maskView)
            make.height.equalTo(380.0)
        })
        
        UIApplication.sharedApplication().keyWindow?.addSubview(maskView)
        
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

// MARK: UIScrollViewDelegate

var oldOffSet: CGFloat = 0

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // 禁止上拉
        if scrollView.contentOffset.y > 0 {
            
            scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
            return
        }
        
        // head 最高60
        if scrollView.contentOffset.y < -60 {
            
            scrollView.setContentOffset(CGPointMake(0, -60), animated: false)
            return
        }
        
        // 判断 下滑时候
        scrollView.mj_header.removeSubviews()
        let label = UILabel()
        scrollView.mj_header.addSubview(label)
        label.snp_makeConstraints { make in
            make.center.equalTo(0)
            make.size.equalTo(CGSizeMake(ez.screenWidth, 20))
        }
        label.text = ""
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        if scrollView.mj_header.state == MJRefreshState.Idle {
            
            label.text = L10n.HomeRefreshIdle.string
            
        }
        
        if scrollView.mj_header.state == MJRefreshState.Pulling {
            
            label.text = L10n.HomeRefreshPulling.string

        }
        
        if scrollView.mj_header.state == MJRefreshState.Refreshing {
            
            // 添加活动指示器旋转
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            scrollView.mj_header.addSubview(activityView)
            activityView.snp_makeConstraints{ make in
                make.centerX.equalTo(0).offset(-40)
                make.size.equalTo(CGSizeMake(20, 20))
                make.centerY.equalTo(0)
            }
            // 添加文字
            activityView.startAnimating()
            
            label.snp_remakeConstraints{ make in
                make.left.equalTo(activityView.snp_right)
                make.centerY.equalTo(0)
            }
            label.text = L10n.HomeRefreshRefreshing.string

        }
        
    }
    
    
}



