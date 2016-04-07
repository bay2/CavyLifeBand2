//
//  GuideViewController.swift
//  CavyLifeBand2
//
//  Created by 李艳楠 on 16/3/1.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SnapKit
import Gifu

class GuideViewController: BaseViewController {
    
    var birthView: BirthdayView?
    var highView: HightView?
    var weightView: WeightView?
    var goalView: GoalView?
    
    /**
     style标签
     
     - GuideGender:          我的信息 性别页面
     - GuideBirthday:        我的信息 生日
     - GuideHeight:          我的信息 身高
     - GuideWeight:          我的信息 体重
     - SettingNotice:        设置 开启智能通知
     - SettingLocationShare: 设置 开启位置分享
     - BandBluetooth:        连接手环 打开蓝牙
     - BandopenBand:         连接手环 打开手环
     - BandLinking:          连接手环 正在连接
     - BandSuccess:          连接手环 连接成功
     - BandFail:             连接手环 连接失败
     */
    enum GuideViewStyle {
        
        case GuideGender
        case GuideBirthday
        case GuideHeight
        case GuideWeight
        case GuideGoal
        case SettingNotice
        case SettingLocationShare
        case BandBluetooth
        case BandopenBand
        case BandLinking
        case BandSuccess
        case BandFail
    }
    
    /// 大标题详情
    @IBOutlet weak var infoLabel: UILabel!
    
    /// 中间底视图
    @IBOutlet weak var middleView: UIView!
    
    /// 确定按钮
    @IBOutlet weak var guideButton: UIButton!
    
    // 视图风格
    var viewStyle: GuideViewStyle = .BandBluetooth
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allViewsLayOut()

        updateViewStyle()
        
        
    }
    
    /**
     布局全部视图
     */
    func allViewsLayOut(){
        
        infoLabel.textColor = UIColor(named: .GuideColor66)
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(ez.screenWidth * 0.2 + 11)
        }
        
        middleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(ez.screenWidth * 0.32)
        }
        
        guideButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(ez.screenWidth * 1.32)
        }
        
    }
    
    /**
     更新视图风格
     */
    func updateViewStyle() {
        
        var guideBgColor = UIColor(named: .GuideSetInfoColor)
        var titleInfoText = L10n.GuideIntroduce.string
        var guideBtnImage = UIImage(asset: .GuideRightBtn)
        var guideBtnImagePress = UIImage(asset: .GuideRightBtnPressed)
        
        switch viewStyle {
            
        case .GuideGender:
            
            infoLabel.hidden = false
            updateNavigationItemUI(L10n.GuideMyInfo.string)
            upDateGenderView()
            guideBgColor = UIColor(named: .GuideSetInfoColor)
            titleInfoText = L10n.GuideIntroduce.string
            
        case .GuideBirthday:
            
            infoLabel.hidden = false
            updateNavigationItemUI(L10n.GuideMyInfo.string)
            upDateBirthdayView()
            titleInfoText = L10n.GuideIntroduce.string
            
        case .GuideHeight:
            
            infoLabel.hidden = false
            updateNavigationItemUI(L10n.GuideMyInfo.string)
            upDateHeightView()
            titleInfoText = L10n.GuideIntroduce.string
            
        case .GuideWeight:
            
            infoLabel.hidden = false
            updateNavigationItemUI(L10n.GuideMyInfo.string)
            upDateWeightView()
            titleInfoText = L10n.GuideIntroduce.string
            
        case .GuideGoal:
            
            infoLabel.hidden = false
            updateNavigationItemUI(L10n.GuideMyInfo.string)
            upDateGoalView()
            titleInfoText = L10n.GuideIntroduce.string
            
        case .SettingNotice:
            
            updateNavigationItemUI(L10n.GuideSetting.string, rightBtnText: L10n.GuidePassButton.string, isNeedBack: true)
            guideBgColor = UIColor(named: .GuideSetPermission)
            upDatePictureView(L10n.GuideOpenNotice.string, titleInfo: L10n.GuideOpenNoticeInfo.string, midImage: UIImage(asset: .GuideNotice), bottomLab: "")
            
        case .SettingLocationShare:
            
            updateNavigationItemUI(L10n.GuideSetting.string, rightBtnText: L10n.GuidePassButton.string, isNeedBack: true)
            guideBgColor = UIColor(named: .GuideSetPermission)
            upDatePictureView(L10n.GuideOpenLocationShare.string, titleInfo: L10n.GuideOpenLocationShareInfo.string, midImage: UIImage(asset: .GuideLocation), bottomLab: "")
            
        case .BandBluetooth:
            
            guideBgColor = UIColor(named: .GuideBandBluetoothColor)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            upDatePictureView(L10n.GuideOpenBluetooth.string, titleInfo: L10n.GuideOpenBluetoothInfo.string, midImage: UIImage(asset: .GuideBluetooth), bottomLab: "")
            
        case .BandopenBand:
            
            guideBgColor = UIColor(named: .GuideBandBluetoothColor)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            upDatePictureView(L10n.GuideOpenCavy.string, titleInfo: L10n.GuideOpenCavyInfo.string, midImage: UIImage(asset: .GuideOpenBand), bottomLab: L10n.GuideOpenCavySugg.string)
            
        case .BandLinking:
            
            guideBgColor = UIColor(named: .GuideBandBluetoothColor)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            upDatePictureView(L10n.GuideLinking.string, titleInfo: "", midImage: UIImage(named: "GuideLinking.gif")!, bottomLab: "")
            
        case .BandSuccess:
            
            guideBgColor = UIColor(named: .GuideBandBluetoothColor)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            upDatePictureView(L10n.GuidePairSuccess.string, titleInfo: L10n.GuidePairSuccessInfo.string, midImage: UIImage(asset: .GuidePairSeccuss), bottomLab: "")
            
        case .BandFail:
            
            guideBgColor = UIColor(named: .GuideBandBluetoothColor)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            guideBtnImage = UIImage(asset: .GuigeFlashBtn)
            guideBtnImagePress = UIImage(asset: .GuigeFlashBtnPressed)
            upDatePictureView(L10n.GuidePairFail.string, titleInfo: L10n.GuidePairFailInfo.string, midImage: UIImage(asset: .GuidePairFail), bottomLab: "")
        }
        
        self.view.backgroundColor = guideBgColor
        self.infoLabel.text = titleInfoText
        self.guideButton.setImage(guideBtnImage, forState: .Normal)
        self.guideButton.setImage(guideBtnImagePress, forState: .Highlighted)
    }
    
    /**
     点击右侧按钮
     */
    override func onClickRight(sender: AnyObject) {
        
        super.onClickRight(sender)
        let nextView = StoryboardScene.Guide.instantiateGuideView()
        
        switch viewStyle {
            
        case .SettingNotice:
            
            nextView.viewStyle = .SettingLocationShare
            self.pushVC(nextView)
            
        case .SettingLocationShare:
            
            let accountVC = StoryboardScene.Main.instantiateAccountManagerView()
            accountVC.configView(PhoneSignUpViewModel())
            self.pushVC(accountVC)
            
        default:
            print(#function)
        }
        
    }
    
    /**
     中间按钮事件
     */
    @IBAction func guideBtnClick(sender: AnyObject) {
        
        differentJumpMode()
        userInfoSetting()
        
    }
    
    // 不同状态的跳转顺序
    func differentJumpMode() {
        
        let nextView = StoryboardScene.Guide.instantiateGuideView()
        
        switch viewStyle {
            
        case .BandBluetooth:
            nextView.viewStyle = .BandopenBand
            self.pushVC(nextView)
        case .BandopenBand:
            nextView.viewStyle = .BandLinking
            self.pushVC(nextView)
        case .BandLinking:
            nextView.viewStyle = .BandSuccess
            self.pushVC(nextView)
        case .BandSuccess:
            
            if CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId == "" {
                nextView.viewStyle = .GuideGender
                self.pushVC(nextView)
                return
            }
            
            // 新用户 或者没有个人信息的 就去添加个人信息
            UserInfoModelView.shareInterface.queryInfo(self) {
                
                if $0 {
                    
                    if UserInfoModelView.shareInterface.userInfo!.sleepTime.isEmpty {
                        
                        nextView.viewStyle = .GuideGender
                        self.pushVC(nextView)
                    } else {
                        
                        UserInfoModelView.shareInterface.updateInfo()
                        // 如果有个人信息 就是直接跳到主页
                        self.pushVC(StoryboardScene.Home.instantiateRootView())
                    }
                }
            }
            
        case .BandFail:
            nextView.viewStyle = .BandSuccess
            self.pushVC(nextView)
        case .GuideGender:
            nextView.viewStyle = .GuideBirthday
            self.pushVC(nextView)
        case .GuideBirthday:
            nextView.viewStyle = .GuideHeight
            self.pushVC(nextView)
        case .GuideHeight:
            nextView.viewStyle = .GuideWeight
            self.pushVC(nextView)
        case .GuideWeight:
            nextView.viewStyle = .GuideGoal
            self.pushVC(nextView)
        case .GuideGoal:
            nextView.viewStyle = .SettingNotice
            self.pushVC(nextView)
        case .SettingNotice:
            nextView.viewStyle = .SettingLocationShare
            self.pushVC(nextView)
        case .SettingLocationShare:
            
            if CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId.isEmpty {
                let nextVC = StoryboardScene.Main.instantiateAccountManagerView()
                nextVC.configView(PhoneSignUpViewModel())
                pushVC(nextVC)
            } else {
                UserInfoModelView.shareInterface.updateInfo(self)
                let nextVC = StoryboardScene.Home.instantiateRootView()
                pushVC(nextVC)
            }
            
            
        }
        
    }
    
    // 传数据
    func userInfoSetting() {
        
        switch viewStyle {
            
        case .GuideBirthday:
            
            let birthString = "\(birthView!.yymmRuler.nowYear + 1901)-\(birthView!.yymmRuler.nowMonth)-\(birthView!.dayRuler.nowDay)"
            UserInfoModelView.shareInterface.userInfo?.birthday = birthString
            
        case .GuideHeight:
            
            let heightString = "\(highView!.heightRuler.nowHeight)"
            UserInfoModelView.shareInterface.userInfo?.height = heightString
            
        case .GuideWeight:
            let weightString = weightView?.valueLabel.text
            UserInfoModelView.shareInterface.userInfo?.weight = weightString!
            
        case .GuideGoal:
            
            let goalStepNum = goalView!.stepCurrentValue
            let sleepHour = goalView!.hhCurrentValue
            let sleepMinutes = goalView!.mmCurrentValue
            UserInfoModelView.shareInterface.userInfo?.stepNum = goalStepNum
            UserInfoModelView.shareInterface.userInfo?.sleepTime = "\(sleepHour):\(sleepMinutes)"
            
        default:
            break
        }
        
    }
    
    /**
     更新性别视图
     */
    func  upDateGenderView(){
        
        let genderView = GenderView(frame: CGRectMake(0, 0, ez.screenWidth * 0.92, ez.screenWidth * 1.12))//spacingWidth25 * 23, spacingWidth25 * 28))
        middleView.addSubview(genderView)
        
    }
    
    /**
     更新生日视图
     */
    func  upDateBirthdayView(){
        
        birthView = BirthdayView(frame: CGRectMake(0, 0, ez.screenWidth * 0.92, ez.screenWidth * 1.12))
        middleView.addSubview(birthView!)
        
    }
    
    /**
     更新身高视图
     */
    func  upDateHeightView(){
        
        highView = HightView(frame: CGRectMake(0, 0, ez.screenWidth * 0.92, ez.screenWidth * 1.12))
        middleView.addSubview(highView!)
        
    }
    
    /**
     更新体重视图
     */
    func  upDateWeightView(){
        
        weightView = WeightView(frame: CGRectMake(0, 0, ez.screenWidth * 0.92, ez.screenWidth * 1.12))
        middleView.addSubview(weightView!)
        
    }
    
    /**
     更新目标视图
     */
    func upDateGoalView() {
        
        goalView = NSBundle.mainBundle().loadNibNamed("GoalView", owner: nil, options: nil).first as? GoalView
        
        goalView!.size = middleView.size
        
        goalView!.goalViewLayout()
        
        goalView!.sliderStepAttribute(6000, recommandValue: 8000, minValue: 0, maxValue: 20000)
        goalView!.sliderSleepAttribute(5, avgM: 30, recomH: 8, recomM: 30, minH: 2, minM: 0, maxH: 12, maxM: 00)
        
        middleView.addSubview(goalView!)
        
        
    }
    
    /**
     更新目标视图
     */
    func upDatePictureView(titleLab: String, titleInfo: String, midImage: UIImage, bottomLab: String){
        
        let pictureView = PictureView(frame: CGRectMake(0, 0, ez.screenWidth * 0.92, ez.screenWidth * 1.12))
        
        pictureView.titleLab.text = titleLab
        pictureView.titleInfo.text = titleInfo
        pictureView.bottomLab.text = bottomLab
        
        if viewStyle == .BandLinking {
            
            pictureView.middleImgView.animateWithImage(named: "GuideLinking.gif")
            
        }else {
            
            pictureView.middleImgView.image = midImage
        }
        
        middleView.addSubview(pictureView)
        
        
    }
    
    
    
}
