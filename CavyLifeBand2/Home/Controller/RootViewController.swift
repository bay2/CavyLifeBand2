//
//  RootViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import RealmSwift
import Log
import AddressBook
import Contacts
import KeychainAccess
import Datez
import CoreTelephony

class RootViewController: UIViewController, CoordinateReport, PKWebRequestProtocol, PKRecordsRealmModelOperateDelegate, PKRecordsUpdateFormWeb  {
    
    var vibrateSeconds: Int = 0
    
    enum MoveDirection {
        
        case LeftMove
        case RightMove
        
        var movePoint: CGPoint {
            
            switch self {
                
            case .LeftMove:
                return CGPointMake(-(ez.screenWidth * 5 / 6), 0)
                
            case .RightMove:
                return CGPointMake(ez.screenWidth - (ez.screenWidth / 6), 0)
                
            }
            
        }
        
    }

    var homeVC: UINavigationController?
    
    var leftVC: LeftMenViewController?
    var bandMenuVC: RightViewController?
    let homeMaskView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight))
    var realm: Realm = try! Realm()
    var updateUserInfoPara: [String: AnyObject] = [String: AnyObject]()
    
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    var loginUserId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    var syncDataTime: NSTimer?
    
    var callCenter: CTCallCenter?
    
    var notificationSetingList: NotificationToken?
    
    var pkSycnCount: Int = 0 {
        
        didSet {
            
            if pkSycnCount == 3 {
                
                self.loadDataFromWeb()
                
                pkSycnCount = 0
            
            }
            
        }
        
    }
    
    deinit {
        removeNotificationObserver()
        syncDataTime?.invalidate()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Log.info("\(realm.configuration.fileURL)")
        
        
        loadHomeView()
            
        addNotificationObserver(NotificationName.HomeLeftOnClickMenu.rawValue, selector: #selector(RootViewController.onClickMenu))
        addNotificationObserver(NotificationName.HomeRightOnClickMenu.rawValue, selector: #selector(RootViewController.onClickBandMenu))
        addNotificationObserver(NotificationName.HomeShowHomeView.rawValue, selector: #selector(RootViewController.showHomeView))
        addNotificationObserver(LifeBandCtrlNotificationName.BandButtonEvenClick4.rawValue, selector: #selector(RootViewController.callEmergency))
        
        // 断线之后尝试连接
        addNotificationObserver(BandBleNotificationName.BandDesconnectNotification.rawValue, selector: #selector(RootViewController.bandConnect))
        
        bandInit()
        
        phoneCallInit()
        
    }
    
    /**
     加载主页面视图
     */
    func loadHomeView() {
        
        leftVC = StoryboardScene.Home.instantiateLeftView()
        homeVC = UINavigationController(rootViewController: StoryboardScene.Home.instantiateHomeView())
        bandMenuVC = StoryboardScene.Home.instantiateRightView()
        
        self.view.addSubview(leftVC!.view)
        self.view.addSubview(bandMenuVC!.view)
        self.view.addSubview(homeVC!.view)
        
        bandMenuVC!.view.snp_makeConstraints {
            $0.top.bottom.right.equalTo(self.view)
            $0.left.equalTo(self.view).offset(ez.screenWidth / 6)
        }
        
        syncUserInfo()
        
        syncPKRecords()
        
    }
    
    /**
     上报坐标
     
     - parameter isLocalShare:
     */
    func userCoordinateReport(isLocalShare: Bool) {
        
        guard isLocalShare else {
            return
        }
        
        self.coordinateReportServer()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     从服务器将数据更新到本地
     */
    func syncUserInfo() {
        
//        guard let userInfo: UserInfoModel = queryUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) else {
        
            querySyncDate()
//            return
//        }
//        
//        userCoordinateReport(userInfo.isLocalShare)
//        
//        updateSyncDate(userInfo)
//        
//        CavyDefine.userNickname = userInfo.nickname
//        CavyDefine.loginUserBaseInfo.loginUserInfo.loginAvatar = userInfo.avatarUrl
        
    }
    
    /**
     将本地数据同步到服务器
     
     - parameter userInfo: 用户信息
     */
    func updateSyncDate(userInfo: UserInfoModel) {
        
        if userInfo.isSync == true {
            return
        }
        
        updateUserInfoPara += [NetRequsetKey.Sex.rawValue: userInfo.sex,
                               NetRequsetKey.Height.rawValue: userInfo.height,
                               NetRequsetKey.Weight.rawValue: userInfo.weight,
                               NetRequsetKey.Birthday.rawValue: userInfo.birthday,
                               NetRequsetKey.Address.rawValue: userInfo.address,
                               NetRequsetKey.StepsGoal.rawValue: userInfo.stepGoal,
                               NetRequsetKey.SleepTimeGoal.rawValue: userInfo.sleepGoal,
                               NetRequsetKey.EnableNotification.rawValue: userInfo.isNotification,
                               NetRequsetKey.ShareLocation.rawValue: userInfo.isLocalShare,
                               NetRequsetKey.ShareBirthday.rawValue: userInfo.isOpenBirthday,
                               NetRequsetKey.ShareHeight.rawValue: userInfo.isOpenHeight,
                               NetRequsetKey.ShareWeight.rawValue: userInfo.isOpenWeight]
        
        self.setUserInfo {
            
            guard $0 else {
                return
            }
            
            self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                $0.isSync = true
                return $0
            }
            
        }
        
    }
    
    /**
     将服务器的用户信息同步到本地
     */
    func querySyncDate() {
        
        queryUserInfoByNet{ resultUserInfo in
            
            guard let userInfo = resultUserInfo else {
                return
            }
            
            CavyDefine.userNickname = userInfo.nickName ?? ""
            
            let userInfoModel = UserInfoModel(userId: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId, userProfile: userInfo)
            
            self.userCoordinateReport(userInfoModel.isLocalShare)
            
            if let _: UserInfoModel = self.queryUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                self.updateUserInfo(userInfoModel)
            } else {
                self.addUserInfo(userInfoModel)
            }
            
        }
        
    }
    
    /**
     将数据库未同步的pk记录同步到服务器
     */
    func syncPKRecords() {
        
        //删除pk
        if let finishList: [PKFinishRealmModel] = self.getUnSyncPKList(PKFinishRealmModel.self) {
            self.deletePKFinish(finishList, loginUserId: self.loginUserId, callBack: {
                
                for finish in finishList {
                    self.syncPKRecordsRealm(PKFinishRealmModel.self, pkId: finish.pkId)
                }
                
                self.pkSycnCount += 1
                
            }, failure: { (errorMsg) in
                Log.warning(errorMsg)
            })
        } else {
            self.pkSycnCount += 1
        }
        
        //接受pk
        if let acceptList: [PKDueRealmModel] = self.getUnSyncPKList(PKDueRealmModel.self) {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFromString("yyyy-MM-dd HH:mm:ss")
            
            self.acceptPKInvitation(acceptList, loginUserId: self.loginUserId, callBack: {
                for accept in acceptList {
                    
                    self.changeDueBeginTime(accept, time: dateFormatter.stringFromDate(NSDate()))
                    self.syncPKRecordsRealm(PKDueRealmModel.self, pkId: accept.pkId)
                }
                
                self.pkSycnCount += 1
            }, failure: { (errorMsg) in
                Log.warning(errorMsg)
            })
        } else {
            self.pkSycnCount += 1
        }
        
        //撤销pk
        if let undoList: [PKWaitRealmModel] = self.getUnSyncWaitPKListWithType(.UndoWait) {
            self.undoPK(undoList, loginUserId: self.loginUserId, callBack: {
                for undo in undoList {
                    self.syncPKRecordsRealm(PKWaitRealmModel.self, pkId: undo.pkId)
                }
                
                self.pkSycnCount += 1
            }, failure: { (errorMsg) in
                Log.warning(errorMsg)
            })
        } else {
            self.pkSycnCount += 1
        }

    }

    /**
     点击菜单按钮
     */
    func onClickMenu() {

        showLeftView()

    }

    /**
     显示左侧列表视图
     */
    func showLeftView() {

        hiddenHomeView(.RightMove)

    }
    
    /**
     显示手环设置菜单
     */
    func onClickBandMenu() {
        
        hiddenHomeView(.LeftMove)
        
    }
    
    /**
     隐藏主页
     
     - parameter direction: 主页移动的方向
     */
    func hiddenHomeView(direction: MoveDirection) {
        
        homeMaskView.backgroundColor = UIColor.clearColor()
        
        if direction == .LeftMove {
            bandMenuVC?.view.hidden = false
            leftVC?.view.hidden = true
        } else {
            bandMenuVC?.view.hidden = true
            leftVC?.view.hidden = false
        }
        
        homeMaskView.addTapGesture { [unowned self] _ in
            
            self.showHomeView()
            
        }
        
        homeVC!.view.addSubview(homeMaskView)
        
        UIView.animateWithDuration(0.5) { [unowned self] _ in
            
            self.homeVC!.view.frame.origin = direction.movePoint
            self.homeMaskView.backgroundColor = UIColor(named: .HomeViewMaskColor)
            
        }
        
    }

    /**
     隐藏左侧菜单
     */
    func showHomeView() {
        
        UIView.animateWithDuration(0.5, animations: { [unowned self] in
            
            self.homeVC!.view.frame.origin = CGPointMake(0, 0)
            self.homeMaskView.backgroundColor = UIColor.clearColor()
        
        }) { [unowned self] in
                
            if $0 == true {
                
                self.homeMaskView.removeFromSuperview()
                    
            }
        }

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RootViewController: QueryUserInfoRequestsDelegate, UserInfoRealmOperateDelegate, SetUserInfoRequestsDelegate {
    
    var userInfoPara: [String: AnyObject] {
        get {
            return updateUserInfoPara
        }
        
        set { }
    }
    
}

extension UserInfoModel {
    
    convenience init(userId: String, userProfile: UserProfile) {
        
        self.init()
        
        self.userId         = userId
        self.nickname       = userProfile.nickName
        self.sex            = userProfile.sex ?? 0
        self.address        = userProfile.address
        self.avatarUrl      = userProfile.avatarUrl
        self.birthday       = userProfile.birthday
        self.height         = userProfile.height
        self.weight         = userProfile.weight
        self.sleepGoal      = userProfile.sleepGoal
        self.stepGoal        = userProfile.stepGoal
        self.coins       = userProfile.coins
        self.phone       = userProfile.phone
        self.signUpDate = userProfile.signUpDate
        
        for data in userProfile.awards {
            let award = UserAwardsModel()
            
            award.date = data.date
            award.number = data.number
            
            self.awards.append(award)
        }
        
        self.isLocalShare   = userProfile.isLocalShare
        self.isNotification = userProfile.isNotification
        self.isOpenHeight   = userProfile.isOpenHeight
        self.isOpenWeight   = userProfile.isOpenWeight
        self.isOpenBirthday = userProfile.isOpenBirthday
        self.isSync         = true

    }
    
}
