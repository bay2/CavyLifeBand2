//
//  HomeDateTimeLineCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/15.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import RealmSwift
import JSONJoy
import Datez

class HomeDateTimeLineCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, HomeListRealmProtocol, ChartsRealmProtocol {
    
    var realm: Realm = try! Realm()
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    var tableView =  UITableView()
    
    // 当日的时间
    var timeString: String = ""
    
    var notificationHomeListToken: NotificationToken?
    var notificationStepToken: NotificationToken?
    var notificationSleepToken: NotificationToken?
    
    // VM 数组
    private var datasViewModels: [HomeListViewModelProtocol] = [HomeListStepViewModel(stepNumber: 0), HomeListSleepViewModel(sleepTime: 0)]
    
    override func awakeFromNib() {
        addCollectionView()
        
        // 跟随上面的环的数值再变化一下
        // 接收通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeStepNumber), name: NumberFollowUpper.FollowUpperStep.rawValue, object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeSleepNumber), name: NumberFollowUpper.FollowUpperSleep.rawValue, object: nil)
    }
    
    deinit {
        notificationHomeListToken?.stop()
        notificationStepToken?.stop()
        notificationSleepToken?.stop()
    }
    
    /**
     入口
     */
    func configLayout() {
        
        parseDataToHomeListRealm()
        
        initNotificationHomeList()
        initNotificationStep()
        initNotificationSleep()
        
    }
    
    
    /**
     主页列表数据库数据监控
     
     - author: sim cai
     - date: 2016-06-02
     
     - returns:
     */
    func initNotificationHomeList() {
        
        notificationHomeListToken = self.queryHomeList(timeString).addNotificationBlock { [unowned self] change in
            
            switch change {
            case .Initial(let value):
                self.datasViewModels = self.queryRealmGetViewModelLists(value)
                self.tableView.reloadData()
            case .Update(let value, deletions: _, insertions: _, modifications: _):
                self.datasViewModels = self.queryRealmGetViewModelLists(value)
                self.tableView.reloadData()
            default:
                break
            }
            
        }
        
    }
    
    /**
     睡眠数据库数据监控
     
     - author: sim cai
     - date: 2016-06-02
     
     - returns:
     */
    func initNotificationSleep() {
        
        guard let curDate = NSDate(fromString: timeString, format: "yyyy.M.d") else {
            fatalError("时间格式不正确\(timeString)")
        }
        
        let endDate = curDate.gregorian.isToday ? NSDate() : (curDate.gregorian.beginningOfDay + 24.hour).date
        
        Log.info("\(curDate.toString(format: "yyyy.M.d HH:mm:ss")) -------- \(endDate.toString(format: "yyyy.M.d HH:mm:ss"))")
        
        
        notificationSleepToken = self.queryAllStepInfo(userId).addNotificationBlock { [unowned self] chage in
            
            switch chage {
                
            case .Initial(_):
                self.datasViewModels[1] = HomeListSleepViewModel(sleepTime: Int(self.querySleepInfoDay(curDate, endTime: endDate).0))
                self.tableView.reloadData()
                
            case .Update(_, deletions: _, insertions: _, modifications: _):
                if curDate.gregorian.isToday {
                    self.datasViewModels[1] = HomeListSleepViewModel(sleepTime: Int(self.querySleepInfoDay(curDate, endTime: endDate).0))
                    self.tableView.reloadData()
                }
                
            default:
                break
                
                
            }
            
        }
        
    }
    
    /**
     计步数据库数据监控
     
     - author: sim cai
     - date: 2016-06-02
     
     - returns:
     */
    func initNotificationStep() {
        
        guard let curDate = NSDate(fromString: timeString, format: "yyyy.M.d") else {
            fatalError("时间格式不正确\(timeString)")
        }
        
        let endDate = curDate.gregorian.isToday ? NSDate() : (curDate.gregorian.beginningOfDay + 24.hour).date
        
        
        notificationStepToken = self.queryAllStepInfo(userId).addNotificationBlock { [unowned self] chage in
            
            switch chage {
                
            case .Initial(_):
                self.datasViewModels[0] = HomeListStepViewModel(stepNumber: self.queryStepNumber(curDate, endTime: endDate, timeBucket: TimeBucketStyle.Day).totalStep)
                self.tableView.reloadData()

            case .Update(_, deletions: _, insertions: _, modifications: _):
                if curDate.gregorian.isToday {
                    self.datasViewModels[0] = HomeListStepViewModel(stepNumber: self.queryStepNumber(curDate, endTime: endDate, timeBucket: TimeBucketStyle.Day).totalStep)
                    self.tableView.reloadData()
                }
                
            default:
                break
                
                
            }
            
        }
        
    }

    func addCollectionView() {
        
        tableView.backgroundColor = UIColor.whiteColor()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        
        tableView.registerNib(UINib(nibName: "HomeTimeLineTableCell", bundle: nil), forCellReuseIdentifier: "HomeTimeLineTableCell")
        
        self.addSubview(tableView)
        
        tableView.snp_makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        
    }
    
    /**
     解析数据
     */
    func parseDataToHomeListRealm(){
        
        // 如果数据库存在数据 就直接返回
        if isExistHomeList(timeString) { return }
        
        let date = NSDate(fromString: timeString, format: "yyyy.M.d")
        let time = date!.toString(format: "yyyy-MM-dd")
        
        // 不存在 解析数据 并保存
        HomeListWebApi.shareApi.parseHomeListData(time) { result in
            
            guard result.isSuccess else {
                Log.error("Parse Home Lists Data Error")
                return
            }
            
            do {
                
                let netResult = try HomeListMsg(JSONDecoder(result.value!))
                Log.info(netResult)
                
                // 保存到数据库
                self.saveHomeListRealm(netResult)
                
            } catch let error {
                
                Log.error("\(#function) result error: \(error)")
                
            }
            
        }
        
    }
    
    /**
     将解析的HomeListMsg数据保存到Realm
     */
    func saveHomeListRealm(result: HomeListMsg) {
        
        guard result.commonMsg.code == WebApiCode.Success.rawValue else {
            
            Log.error("Query home list error \(result.commonMsg.code)")
            return
            
        }
        
        let homeListRealm = HomeListRealm()
        
        homeListRealm.userId = self.userId
        homeListRealm.time = timeString
        homeListRealm.sleepTime = result.sleepTime
        homeListRealm.stepCount = result.stepCount
        
        // 成就
        for infoList in result.achieveList {
            
            let achieveRealm = AchieveListRealm()
            achieveRealm.achieve = infoList
            
            homeListRealm.achieveList.append(achieveRealm)
        }
        
        // pk
        for infoList in result.pkList {
            
            let pkRealm = PKListRealm()
            
            pkRealm.friendName = infoList.friendName!
            pkRealm.pkId = infoList.pkId!
            pkRealm.status = infoList.status!
            
            homeListRealm.pkList.append(pkRealm)
            
        }
        
        // 健康
        for infoList in result.healthList {
            
            let healthRealm = HealthListRealm()
            
            healthRealm.friendId = infoList.friendId!
            healthRealm.iconUrl = infoList.iconUrl!
            healthRealm.friendName = infoList.friendName!
            homeListRealm.healthList.append(healthRealm)
            
        }
        
        // 存储
        addHomeList(homeListRealm)
    }

    /**
     数据库数据 转换 VM数组
     */
    func queryRealmGetViewModelLists(homeListRealm: Results<(HomeListRealm)>) -> [HomeListViewModelProtocol] {
    
        // 转成 VM数组
        var listVM: [HomeListViewModelProtocol] = [HomeListStepViewModel(stepNumber: 0), HomeListSleepViewModel(sleepTime: 0)]
        
        guard let listRealm = homeListRealm.first else {
            return listVM
        }
        
        listVM[0] = self.datasViewModels[0]
        listVM[1] = self.datasViewModels[1]

        // 隐藏PK模块
//        // PK
//        if listRealm.pkList.count > 0 {
//
//            for list in listRealm.pkList {
//                
//                // PK状态：1:进行中 2：已完成
//                let pkStaus = list.status == 1 ? L10n.PKRecordsVCDueSectionTitle.string : L10n.PKRecordsVCFinishSectionTitle.string
//                listVM.append(HomeListPKViewModel(friendName: list.friendName, pkId: list.pkId, result: pkStaus))
//            }
//            
//        }
        
        // 成就列表
        if listRealm.achieveList.count > 0 {
            
            for list in listRealm.achieveList {
                
                listVM.append(HomeListAchiveViewModel(medalIndex: list.achieve))
            }
        }
        
        // 健康列表
        if listRealm.healthList.count > 0 {
            
            for list in listRealm.healthList {
                listVM.append(HomeListHealthViewModel(othersName: list.friendName, iconUrl: list.iconUrl, friendId: list.friendId))
            }
        }

        return listVM
    }
    
    /**
     接受通知更新计步值
     */
    func changeStepNumber() {
        
        guard let curDate = NSDate(fromString: timeString, format: "yyyy.M.d") else {
            fatalError("时间格式不正确\(timeString)")
        }
        
        let endDate = curDate.gregorian.isToday ? NSDate() : (curDate.gregorian.beginningOfDay + 24.hour).date
        
        self.datasViewModels[0] = HomeListStepViewModel(stepNumber: self.queryStepNumber(curDate, endTime: endDate, timeBucket: TimeBucketStyle.Day).totalStep)
        
        self.tableView.reloadData()
    }
    
    /**
     接受通知更新睡眠值
     */
//    func changeSleepNumber() {
//        
//        guard let curDate = NSDate(fromString: timeString, format: "yyyy.M.d") else {
//            fatalError("时间格式不正确\(timeString)")
//        }
//        
//        let endDate = curDate.gregorian.isToday ? NSDate() : (curDate.gregorian.beginningOfDay + 24.hour).date
//
//        self.datasViewModels[1] = HomeListSleepViewModel(sleepTime: Int(self.querySleepInfoDay(curDate, endTime: endDate).0))
//        self.tableView.reloadData()
//        
//    }
    
}

// MARK: UITableViewDelegate
extension HomeDateTimeLineCell {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        Log.info("\(datasViewModels.count)")
        
        return datasViewModels.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = NSBundle.mainBundle().loadNibNamed("HomeTimeLineSection", owner: nil, options: nil).first as! HomeTimeLineSection
        
        if section == 0 {
            sectionView.lineView.hidden = true
        } else {
            sectionView.lineView.hidden = false
        }
        
        return sectionView

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 66
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 16
        }
        
        return 10
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTimeLineTableCell", forIndexPath: indexPath) as! HomeTimeLineTableCell

        cell.headLine.hidden = false
        cell.bottomLine.hidden = false

        if indexPath.section == 0 {
            cell.headLine.hidden = true
        }

        if indexPath.section == datasViewModels.count - 1 {
            
            cell.bottomLine.hidden = true
        }
        
        let viewModel = datasViewModels[indexPath.section]
        
        cell.configVM(viewModel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        datasViewModels[indexPath.section].onClickCell()

    }
    
    /**
     section不悬浮
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let sectionHeight: CGFloat = 16
        
        if scrollView.contentOffset.y <= sectionHeight && scrollView.contentOffset.y >= 0{
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
            
        } else if scrollView.contentOffset.y >= sectionHeight {
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeight, 0, 0, 0)
            
        }

    }

}
