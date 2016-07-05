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
        
        GuideUserInfo.userInfo.height = heightView.heightValue.toDouble
        
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
        
        GuideUserInfo.userInfo.weight = weightView.weightString.toDouble() ?? 0.0
        
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
                
                goalView.sliderStepToValue(userInfo.stepGoal)
                
                self.setGoalViewSleepValue(userInfo.sleepGoal, view: goalView)
                
            }
            
           
        }

    }
    
    func setGoalViewSleepValue(value: Int, view: GoalView) {
        
        view.sliderSleepToValue(value/60, minute: value%60)
        
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
            
            goalView!.sliderStepToValue(userInfo.stepGoal)
            
            setGoalViewSleepValue(userInfo.sleepGoal, view: goalView!)
            
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
            
            GuideUserInfo.userInfo.sleepGoal = goalView.sleepTimeValue
            GuideUserInfo.userInfo.stepGoal = goalView.stepCurrentValue
        
            let nextVC = StoryboardScene.Guide.instantiateGuideView()

            let setVM = GuideSetLocationShare()

            nextVC.configView(setVM, delegate: setVM)

            viewController.pushVC(nextVC)
            
        } else {
            
            // 调接口上传目标设置
            uploadGoalData {
                // 返回主页
                viewController.popVC()
                // 目标值改变 通知 主页圆环更新
                NSNotificationCenter.defaultCenter().postNotificationName("updateUpperViewRing", object: nil)
            }
            
        }
        
    }
    
    /**
     上传目标设置到服务器
     
     - parameter completeHandler:
     */
    func uploadGoalData(completeHandler: (Void -> Void)) {
        
        let goalView = self.centerView as? GoalView
        
        let updateUserInfoPara: [String: AnyObject] = [NetRequsetKey.StepsGoal.rawValue: goalView!.stepCurrentValue,
                                                       NetRequsetKey.SleepTimeGoal.rawValue: goalView!.sleepTimeValue]
        
        let parameters: [String: AnyObject] = [NetRequsetKey.Profile.rawValue: updateUserInfoPara]

        NetWebApi.shareApi.netPostRequest(WebApiMethod.UsersProfile.description, para: parameters, modelObject: CommenMsgResponse.self, successHandler: { data in
            
            self.updateUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId) {
                $0.sleepGoal = goalView!.sleepTimeValue
                $0.stepGoal = goalView!.stepCurrentValue
                return $0
            }
            
            completeHandler()
            
        }) { (msg) in
            
        }

    }
    
}