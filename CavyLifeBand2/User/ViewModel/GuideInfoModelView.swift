//
//  GuideInfoModelView.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/7.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

/**
 *  @author xuemincai
 *
 *  性别view model
 */
struct GuideGenderViewModel: GuideViewDataSource, GuideViewDelegate {
    
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView { return GenderView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight)) }
    
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
struct GuideBirthdayViewModel: GuideViewDataSource, GuideViewDelegate {
    
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView { return BirthdayView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight)) }
    
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
struct GuideHeightViewModel: GuideViewDataSource, GuideViewDelegate {
    
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView { return HightView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight)) }
    
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
struct GuideWeightViewModel: GuideViewDataSource, GuideViewDelegate {
    
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView { return WeightView(frame: CGRectMake(0, 0, middleViewWidth, middleViewHeight)) }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let weightView = centerView as? WeightView else {
            return
        }
        
        GuideUserInfo.userInfo.weight = weightView.weightString
        
        let nextVC = StoryboardScene.Guide.instantiateGuideView()
        let goalVM = GuideGoalViewModel()
        
        nextVC.configView(goalVM, delegate: goalVM)
        
        viewController.pushVC(nextVC)
        
    }
    
}

/**
 *  @author xuemincai
 *
 *  目标设置view Model
 */
struct GuideGoalViewModel: GuideViewDataSource, GuideViewDelegate {
    
    var title: String { return L10n.GuideMyInfo.string }
    var subTitle: String { return L10n.GuideIntroduce.string }
    var centerView: UIView
    
    init() {
        
        guard let goalView = NSBundle.mainBundle().loadNibNamed("GoalView", owner: nil, options: nil).first as? GoalView else {
            self.centerView = UIView()
            return
        }
        
        goalView.size = CGSizeMake(middleViewWidth, middleViewHeight)
        
        goalView.goalViewLayout()
        
        goalView.sliderStepAttribute(6000, recommandValue: 8000, minValue: 0, maxValue: 20000)
        goalView.sliderSleepAttribute(5, avgM: 30, recomH: 8, recomM: 30, minH: 2, minM: 0, maxH: 12, maxM: 00)
        
        self.centerView = goalView
        
    }
    
    func onClickGuideOkBtn(viewController: UIViewController) {
        
        guard let goalView = centerView as? GoalView else {
            return
        }
        
        GuideUserInfo.userInfo.sleepTime = goalView.sleepTimeString
        GuideUserInfo.userInfo.stepNum = goalView.stepCurrentValue
        
        let nextVC = StoryboardScene.Guide.instantiateGuideView()
        
        let setVM = GuideSetNoticeViewModel()
        
        nextVC.configView(setVM, delegate: setVM)
        
        viewController.pushVC(nextVC)
        
    }
    
}