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
import EZSwiftExtensions
import RealmSwift

class HomeViewController: UIViewController, BaseViewControllerPresenter, ChartsRealmProtocol, HomeListRealmProtocol, SinglePKRealmModelOperateDelegate {
    
    var leftBtn: UIButton? = {
        
        let button = UIButton(type: .System)

        button.setBackgroundImage(UIImage(asset: .HomeLeftMenu), forState: .Normal)
        
        return button
    }()
    
    var rightBtn: UIButton? = {
        
        let button = UIButton(type: .System)
        button.size = CGSizeMake(30, 30)
        button.setBackgroundImage(UIImage(asset: .HomeDisBandMenu), forState: .Normal)
        
        return button
        
    }()
    
    var navTitle: String { return "" }
    
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
        
        self.updateNavUI()
        
        addNotificationObserver(NotificationName.HomePushView.rawValue, selector: #selector(HomeViewController.pushNextView))
        addNotificationObserver(NotificationName.HomeShowStepView.rawValue, selector: #selector(HomeViewController.showStepDetailView))
        addNotificationObserver(NotificationName.HomeShowSleepView.rawValue, selector: #selector(HomeViewController.showSleepDetailView))
        addNotificationObserver(NotificationName.HomeShowPKView.rawValue, selector: #selector(HomeViewController.showPKDetailView))
        addNotificationObserver(NotificationName.HomeShowAchieveView.rawValue, selector: #selector(HomeViewController.showAchieveDetailView))
        addNotificationObserver(NotificationName.HomeShowHealthyView.rawValue, selector: #selector(HomeViewController.showHealthyDetailView))
        addNotificationObserver(BandBleNotificationName.BandDesconnectNotification.rawValue, selector: #selector(HomeViewController.bandDesconnect))
        addNotificationObserver(BandBleNotificationName.BandConnectNotification.rawValue, selector: #selector(HomeViewController.bandConnect))
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        upperView!.frame = CGRectMake(0, 0, ez.screenWidth, 96 + ez.screenWidth * 0.55)

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
        
        upperView = NSBundle.mainBundle().loadNibNamed("HomeUpperView", owner: nil, options: nil).first as? HomeUpperView
        
        upperView?.viewController = self
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
    
    // MARK: --- 解析数据 保存数据库
    
    /**
     解析 计步睡眠数据 并保存Realm
     */
    func parseChartListData() {
        
        if isExistStepChartsData() { return }
        
        // 计步
        ChartsWebApi.shareApi.parseStepChartData { result in
            
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
        
        if isExistSleepChartsData() { return }
        
        // 睡眠
        ChartsWebApi.shareApi.parseSleepChartData { result in
            guard result.isSuccess else {
                Log.error("Parse Home Lists Data Error")
                return
            }
            do {
                Log.info(result.value!)
                let netResult = try ChartSleepMsg(JSONDecoder(result.value!))
                for list in netResult.sleepList {
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
    
    
    /**
     根据翻身次数 确定 深睡浅睡的时间 单位： 分钟
     
     - parameter rollCount: 翻身次数
     
     - returns: （深睡， 浅睡）
     */
    func sleepCondition(rollCount: Int) -> (Int, Int) {
        
        return (123, 243)
    }
    
    // MARK: 加载详情
    /**
     显示计步页面
     */
    func showStepDetailView(){
        
        let stepVM = ChartViewModel(title: L10n.ContactsShowInfoStep.string, chartStyle: .StepChart)
        let chartVC = ChartBaseViewController()
        chartVC.configChartBaseView(stepVM)
        self.pushVC(chartVC)
        
    }
    
    /**
     显示睡眠页面
     */
    func showSleepDetailView(){
        
        let sleepVM = ChartViewModel(title: L10n.ContactsShowInfoSleep.string, chartStyle: .SleepChart)
        let chartVC = ChartBaseViewController()
        chartVC.configChartBaseView(sleepVM)
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
            
            pushPKVC(pkModel)
            
        } else {
            // 已经结束
            
            let pkModel: PKFinishRealmModel = getPKFinishRecordByPKId(pkId)!
            
            pushPKVC(pkModel)
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
    
    func addActivityIndicatorView() {
        Log.info("添加指示器")
        aphlaView = UIView(frame: UIScreen.mainScreen().bounds)
        aphlaView!.backgroundColor = UIColor.blackColor()
        aphlaView!.alpha = 0.3
        self.view.addSubview(aphlaView!)
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityView!.center = self.view.center
        aphlaView!.addSubview(activityView!)
        activityView!.startAnimating()
    }
  
    func removeActivityIndicatorView() {
        Log.info("移除指示器")
        activityView?.stopAnimating()
        aphlaView?.removeFromSuperview()
    }
    
    func pushPKVC(pkModel: PKRecordRealmDataSource) {
        
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

