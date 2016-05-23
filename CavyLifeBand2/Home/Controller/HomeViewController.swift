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
    
    var realm: Realm = try! Realm()
    
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    // MARK: -- viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        parseHomeListData()
        parseChartListData()
        
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
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
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
    
    // MARK: --- 解析数据 保存数据库
    
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
    
    /**
     解析主页时间轴数据 并保存
     */
    func parseHomeListData() {
        
        HomeListWebApi.shareApi.parseHomeListsData { result in
            
            guard result.isSuccess else {
                Log.error("Parse Home Lists Data Error")
                return
            }
            
            do {
                
                Log.info(result.value!)
                let netResult = try HomeListMsgs(JSONDecoder(result.value!))
                
                for list in netResult.msgLists {
                    
                    self.saveHomeListRealm(list)
                }
                
            } catch let error {
                
                Log.error("\(#function) result error: \(error)")
                
            }
            
        }
    }
    
    /**
     将数据保存Realm
     */
    func saveHomeListRealm(result: HomeListMsg) {
        
        guard result.commonMsg.code == WebApiCode.Success.rawValue else {
            
            Log.error("Query home list error \(result.commonMsg.code)")
            return
            
        }
        
        let homeListRealm = HomeListRealm()
        
        homeListRealm.userId = userId
        
        for infoList in result.achieveList {
            
            let achieveRealm = AchieveListRealm()
            achieveRealm.achieve = infoList
            
            homeListRealm.achieveList.append(achieveRealm)
        }
        
        for infoList in result.pkList {
            
            let pkRealm = PKListRealm()
            
            pkRealm.friendName = infoList.friendName!
            pkRealm.pkId = infoList.pkId!
            pkRealm.status = infoList.status!
            
            homeListRealm.pkList.append(pkRealm)
            
            
        }
        
        for infoList in result.healthList {
            
            let healthRealm = HealthListRealm()
            
            healthRealm.friendId = infoList.friendId!
            healthRealm.friendName = infoList.friendName!
            
            homeListRealm.healthList.append(healthRealm)
            
        }
        
        // 存储
        
        try! realm.write {
            
            realm.add(homeListRealm, update: false)
            
        }
        
    }
    
    /**
     解析 计步睡眠数据 并保存Realm
     */
    func parseChartListData() {
        
        // 计步
        ChartsWebApi.shareApi.parseSleepChartData { result in
            
            let chartStepRealm = ChartStepDataRealm()
            
            guard result.isSuccess else {
                Log.error("Parse Home Lists Data Error")
                return
            }
            
            do {
                
                Log.info(result.value!)
                
                let netResult = try ChartStepMsg(JSONDecoder(result.value!))
                
                for list in netResult.stepList {
                    
                    chartStepRealm.userId = self.userId
                    chartStepRealm.step = list.stepCount
                    chartStepRealm.kilometer = Int(CGFloat(list.stepCount) * 0.0006)  // 相当于一部等于0.6米 公里数 = 步数 * 0.6 / 1000
                    chartStepRealm.time = NSDate(fromString: list.dateTime, format: "yyyy-MM-dd hh:mm:ss")
                }
                
            } catch let error {
                
                Log.error("\(#function) result error: \(error)")
            }
            
            try! self.realm.write{
                
                self.realm.add(chartStepRealm, update: false)
                
            }
                
        }
        
        // 睡眠
        ChartsWebApi.shareApi.parseSleepChartData { result in
            
            let chartSleepRealm = ChartSleepDataRealm()
            
            guard result.isSuccess else {
                Log.error("Parse Home Lists Data Error")
                return
            }
            
            do {
                
                Log.info(result.value!)
                
                let netResult = try ChartSleepMsg(JSONDecoder(result.value!))
                
                for list in netResult.sleepList {
                    
                    chartSleepRealm.userId = self.userId
                    chartSleepRealm.time = NSDate(fromString: list.dateTime, format: "yyyy-MM-dd hh:mm:ss")
                    // 根据翻身情况判断深睡浅睡
                    let condition = self.sleepCondition(list.rollCount)
                    chartSleepRealm.deepSleep = condition.0
                    chartSleepRealm.lightSleep = condition.1
                    
                }
                
            } catch let error {
                
                Log.error("\(#function) result error: \(error)")
            }
            
            try! self.realm.write{
                
                self.realm.add(chartSleepRealm, update: false)
                
            }
            
        }
        
    }
    
    /**
     根据翻身次数 确定 深睡浅睡的时间 单位： 分钟
     
     - parameter rollCount: 翻身次数
     
     - returns: （深睡， 浅睡）
     */
    func sleepCondition(rollCount: Int) -> (Int, Int) {
        
        return (123, 243)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
