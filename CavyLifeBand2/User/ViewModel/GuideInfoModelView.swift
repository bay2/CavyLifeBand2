//
//  GuideInfoModelView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/7.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import RealmSwift
import JSONJoy

/**
 *  @author xuemincai
 *
 *  性别view model
 */
struct GuideGenderViewModel: GuideViewModelPotocols {
    
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView = GenderView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight)) 
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let genderView = centerView as? GenderView else {
            return
        }
        
        let nextVC = StoryboardScene.Guide.instantiateGuideView()
        let brithdayVM = GuideBirthdayViewModel()
        
        
        GuideUserInfo.userInfo.gender = genderView.MOrG ? 0 : 1
        
        nextVC.configView(brithdayVM, delegate: brithdayVM)
        
        viewController.pushVC(nextVC)
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  生日 view model
 */
struct GuideBirthdayViewModel: GuideViewModelPotocols {
    
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView = BirthdayView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight))
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let birthdayView = centerView as?  BirthdayView else {
            return
        }
        
        GuideUserInfo.userInfo.birthday = birthdayView.birthdayString
        
        let nextVC = StoryboardScene.Guide.instantiateGuideView()
        let heightVM = GuideHeightViewModel()
        
        nextVC.configView(heightVM, delegate: heightVM)
        
        viewController.pushVC(nextVC)
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  身高 view model
 */
struct GuideHeightViewModel: GuideViewModelPotocols {
    
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView = HightView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight))
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let heightView = centerView as? HightView else {
            return
        }
        
        GuideUserInfo.userInfo.height = heightView.heightString
        
        let nextVC = StoryboardScene.Guide.instantiateGuideView()
        let weightVM = GuideWeightViewModel()
        
        nextVC.configView(weightVM, delegate: weightVM)
        
        viewController.pushVC(nextVC)
    }
    
}

/**
 *  @author xuemincai
 *
 *  体重 view model
 */
struct GuideWeightViewModel: GuideViewModelPotocols {
    
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView = WeightView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight))
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let weightView = centerView as? WeightView else {
            return
        }
        
        GuideUserInfo.userInfo.weight = weightView.weightString
        
        let nextVC = StoryboardScene.Guide.instantiateGuideView()
        let goalVM = GuideGoalViewModel(viewStyle: .Guide)
        
        nextVC.configView(goalVM, delegate: goalVM)
        
        viewController.pushVC(nextVC)
        
    }
    
}

enum GoalViewStyle {
    case Guide
    case RightMenu
}

/**
 *  @author xuemincai
 *
 *  目标设置view Model
 */
struct GuideGoalViewModel: GuideViewModelPotocols, UserInfoRealmOperateDelegate, QueryUserInfoRequestsDelegate {
    
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView
    var viewStyle: GoalViewStyle
    var realm: Realm = try! Realm()
    
    init(viewStyle: GoalViewStyle) {
        
        self.viewStyle = viewStyle
        
        guard let goalView = NSBundle.mainBundle().loadNibNamed("GoalView", owner: nil, options: nil).first as? GoalView else {
            self.centerView = UIView()
            return
        }
        
        goalView.size = CGSizeMake(middleViewWidth, middleViewHeight)
        
        goalView.goalViewLayout()
        
        goalView.sliderStepAttribute(6000, recommandValue: 8000, minValue: 0, maxValue: 20000)
        goalView.sliderSleepAttribute(5, avgM: 30, recomH: 8, recomM: 30, minH: 2, minM: 0, maxH: 12, maxM: 00)

        self.centerView = goalView
        
        switch viewStyle {
        case .Guide:
            break
        case .RightMenu:
            
            queryUserInfoByNet{ resultUserInfo in
                
                guard let userInfo = resultUserInfo else {
                    return
                }
                
                goalView.sliderStepToValue(userInfo.stepNum)
                
                self.setGoalViewSleepValue(userInfo.sleepTime, view: goalView)
                
            }
            
           
        }

    }
    
    func setGoalViewSleepValue(value: String, view: GoalView) {
        
        let sleepArr = value.componentsSeparatedByString(":")
        
        switch sleepArr.count {
        case 0:
            view.sliderSleepToValue(0, minute: 0)
        case 1:
            view.sliderSleepToValue(sleepArr[0].toInt() ?? 0, minute: 0)
        case 2:
            view.sliderSleepToValue(sleepArr[0].toInt() ?? 0, minute: 0)
        default:
            view.sliderSleepToValue(sleepArr[0].toInt() ?? 0, minute: sleepArr[1].toInt() ?? 0)
        }

    }
    
    /**
     为两种style区分返回方法的不同
     
     作为左边侧栏进入时，按返回将数据改为不保存返回，将数值改为用户上次设置的数据
     
     - parameter viewController:
     */
    func onCilckBack(viewController: UIViewController) {
        
        switch viewStyle {
        case .Guide:
            break
        case .RightMenu:
            let goalView = self.centerView as? GoalView
            
            guard let userInfo: UserInfoModel = queryUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) else {
                return
            }
            
            goalView!.sliderStepToValue(userInfo.stepNum)
            
            setGoalViewSleepValue(userInfo.sleepTime, view: goalView!)
            
            break
        }
        
        if viewController.navigationController?.viewControllers.count > 1 {
            
            viewController.popVC()
            
        } else {
            
            viewController.dismissVC(completion: nil)
            
        }
        
    }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let goalView = centerView as? GoalView else {
            return
        }
        
        if self.viewStyle == .Guide {
            
            GuideUserInfo.userInfo.sleepTime = goalView.sleepTimeString
            GuideUserInfo.userInfo.stepNum = goalView.stepCurrentValue
        
            let nextVC = StoryboardScene.Guide.instantiateGuideView()
            
            let setVM = GuideSetNoticeViewModel()
            
            nextVC.configView(setVM, delegate: setVM)
            
            viewController.pushVC(nextVC)
            
        } else {
            
            // 调接口上传目标设置
            uploadGoalData {
                // 返回主页
                viewController.popVC()
            }
            
        }
        
    }
    
    /**
     上传目标设置到服务器
     
     - parameter completeHandler:
     */
    func uploadGoalData(completeHandler: (Void -> Void)) {
        
        guard let userInfo: UserInfoModel = queryUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) else {
            return
        }
        
        let goalView = self.centerView as? GoalView
        
        let updateUserInfoPara: [String: AnyObject] = [UserNetRequsetKey.UserID.rawValue: CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId,
                                                       UserNetRequsetKey.StepNum.rawValue: goalView!.stepCurrentValue,
                                                       UserNetRequsetKey.SleepTime.rawValue: goalView!.sleepTimeString,
                                                       UserNetRequsetKey.Sex.rawValue: userInfo.sex.toString,
                                                       UserNetRequsetKey.Height.rawValue: userInfo.height,
                                                       UserNetRequsetKey.Weight.rawValue: userInfo.weight,
                                                       UserNetRequsetKey.Birthday.rawValue: userInfo.birthday,
                                                       UserNetRequsetKey.Address.rawValue: userInfo.address,
                                                       UserNetRequsetKey.IsNotification.rawValue: userInfo.isNotification,
                                                       UserNetRequsetKey.IsLocalShare.rawValue: userInfo.isLocalShare,
                                                       UserNetRequsetKey.IsOpenBirthday.rawValue: userInfo.isOpenBirthday,
                                                       UserNetRequsetKey.IsOpenHeight.rawValue: userInfo.isOpenHeight,
                                                       UserNetRequsetKey.IsOpenWeight.rawValue: userInfo.isOpenWeight]
        
        UserNetRequestData.shareApi.setProfile(updateUserInfoPara) { result in
            
            guard result.isSuccess else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(userErrorCode: result.error!)
                return
            }
            
            let resultMsg = try! CommenMsg(JSONDecoder(result.value!))
            
            guard resultMsg.code == WebApiCode.Success.rawValue else {
                CavyLifeBandAlertView.sharedIntance.showViewTitle(webApiErrorCode: resultMsg.code)
                return
            }
            
            Log.info("Update user info success")
            
            self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                $0.sleepTime = goalView!.sleepTimeString
                $0.stepNum = goalView!.stepCurrentValue
                return $0
            }
            
            completeHandler()
            
        }

    }
    
}