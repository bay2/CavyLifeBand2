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

class RootViewController: UIViewController, CoordinateReport, AddressBookDataSource {

    var homeVC: UINavigationController?
    var leftVC: LeftViewController?
    let homeMaskView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight))
    var realm: Realm = try! Realm()
    var updateUserInfoPara: [String: AnyObject] = [UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId]
    
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftVC = StoryboardScene.Home.instantiateLeftView()
        homeVC = UINavigationController(rootViewController: StoryboardScene.Home.instantiateHomeView())

        self.view.addSubview(leftVC!.view)
        self.view.addSubview(homeVC!.view)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RootViewController.onClickMenu), name: NotificationName.HomeLeftOnClickMenu.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RootViewController.hiddenLeftView), name: NotificationName.HomeLeftHiddenMenu.rawValue, object: nil)
        
        syncUserInfo()
        
        getAddresBookPhoneInfo {
            Log.info("\($0)\($1) -- \($2)")
        }
        
        
        
        
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
        
        guard let userInfo = queryUserInfo(queryUserId) else {
            
            querySyncDate()
            return
        }
        
        userCoordinateReport(userInfo.isLocalShare)
        
        updateSyncDate(userInfo)
        
    }
    
    /**
     将本地数据同步到服务器
     
     - parameter userInfo: 用户信息
     */
    func updateSyncDate(userInfo: UserInfoModel) {
        
        guard userInfo.isSync != true else {
            return
        }
        
        updateUserInfoPara += [UserNetRequsetKey.NickName.rawValue: userInfo.nickname,
                               UserNetRequsetKey.Sex.rawValue: userInfo.sex.toString,
                               UserNetRequsetKey.Height.rawValue: userInfo.height,
                               UserNetRequsetKey.Weight.rawValue: userInfo.weight,
                               UserNetRequsetKey.Birthday.rawValue: userInfo.birthday,
                               UserNetRequsetKey.Address.rawValue: userInfo.address,
                               UserNetRequsetKey.StepNum.rawValue: userInfo.stepNum,
                               UserNetRequsetKey.SleepTime.rawValue: userInfo.sleepTime,
                               UserNetRequsetKey.IsNotification.rawValue: userInfo.isNotification,
                               UserNetRequsetKey.IsLocalShare.rawValue: userInfo.isLocalShare,
                               UserNetRequsetKey.IsOpenBirthday.rawValue: userInfo.isOpenBirthday,
                               UserNetRequsetKey.IsOpenHeight.rawValue: userInfo.isOpenHeight,
                               UserNetRequsetKey.IsOpenWeight.rawValue: userInfo.isOpenWeight]
        
        self.setUserInfo {
            
            guard $0 else {
                return
            }
            
            self.updateUserInfo(self.queryUserId) {
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
            
            let userInfoModel = UserInfoModel(userId: self.queryUserId, userProfile: userInfo)
            
            self.userCoordinateReport(userInfoModel.isLocalShare)
            
            self.addUserInfo(userInfoModel)
            
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


        homeMaskView.backgroundColor = UIColor.clearColor()

        homeMaskView.addTapGesture { _ in

            self.hiddenLeftView()

        }

        homeVC!.view.addSubview(homeMaskView)

        UIView.animateWithDuration(0.5) {

            self.homeVC!.view.frame.origin = CGPointMake(ez.screenWidth - (ez.screenWidth / 6), 0)
            self.homeMaskView.backgroundColor = UIColor(named: .HomeViewMaskColor)

        }

    }

    /**
     隐藏左侧菜单
     */
    func hiddenLeftView() {
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.homeVC!.view.frame.origin = CGPointMake(0, 0)
            self.homeMaskView.backgroundColor = UIColor.clearColor()
        
        }) {
                
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
    
    var queryUserId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId }
    
    var userInfoPara: [String: AnyObject] {
        return updateUserInfoPara
    }
    
}

extension UserInfoModel {
    
    convenience init(userId: String, userProfile: UserProfile) {
        
        self.init()
        
        self.userId = userId
        self.nickname = userProfile.nickName!
        self.sex = userProfile.sex!.toInt() ?? 0
        self.address = userProfile.address!
        self.avatarUrl = userProfile.avatarUrl!
        self.birthday = userProfile.birthday!
        self.height = userProfile.height!
        self.weight = userProfile.weight!
        self.sleepTime = userProfile.sleepTime!
        self.stepNum = userProfile.stepNum!
        
        self.isLocalShare = userProfile.isLocalShare!
        self.isNotification = userProfile.isNotification!
        self.isOpenHeight = userProfile.isOpenHeight!
        self.isOpenWeight = userProfile.isOpenWeight!
        self.isOpenBirthday = userProfile.isOpenBirthday!
        self.isSync = true
        
    }
    
}
