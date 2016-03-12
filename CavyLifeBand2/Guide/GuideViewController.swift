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

class GuideViewController: BaseViewController {
    
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
    var viewStyle: GuideViewStyle = .GuideGender
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewStyle()
        
        allViewsLayOut()
        
        
    }
    
    /**
     布局全部视图
     */
    func allViewsLayOut(){
        

        infoLabel.textColor = UIColor(named: .GuideColor66)
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(boundsWidth * 0.2 + 11)
        }
        
        middleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(boundsWidth * 0.32)
        }
        
        guideButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(boundsWidth * 1.32)
        }

    }
    
    /**
     更新视图风格
     */
    func updateViewStyle() {
        
        var guideBgColor = UIColor(named: .GuideColorBlue)
        var titleInfoText = L10n.GuideIntroduce.string
        var guideBtnImage = UIImage(asset: .GuideRightBtn)
        var guideBtnImagePress = UIImage(asset: .GuideRightBtnPressed)
        
//        var subTitleText = L10n.GuideMine.string
//        var subTitleInfoText = L10n.GuideOpenNoticeInfo.string
//        var bottomLabText = ""
        switch viewStyle {

        case .GuideGender:
            infoLabel.hidden = false
            updateNavigationItemUI(L10n.GuideMyInfo.string)
            upDateGenderView()
            guideBgColor = UIColor(named: .GuideColorBlue)
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
            guideBgColor = UIColor(named: .GuideColorcyanColor)
            upDatePictureView(L10n.GuideOpenNotice.string, titleInfo: L10n.GuideOpenNoticeInfo.string, midImage: UIImage(asset: .GuideWeightBg), bottomLab: " ")
        case .SettingLocationShare:
            
            updateNavigationItemUI(L10n.GuideSetting.string, rightBtnText: L10n.GuidePassButton.string, isNeedBack: true)
            guideBgColor = UIColor(named: .GuideColorcyanColor)
            upDatePictureView(L10n.GuideOpenLocationShare.string, titleInfo: L10n.GuideOpenLocationShareInfo.string, midImage: UIImage(asset: .GuideWeightBg), bottomLab: "")
            
        case .BandBluetooth:
            
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            upDatePictureView(L10n.GuideOpenBluetooth.string, titleInfo: L10n.GuideOpenBluetoothInfo.string, midImage: UIImage(asset: .GuideWeightBg), bottomLab: "")
        case .BandopenBand:
            
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            upDatePictureView(L10n.GuideOpenCavy.string, titleInfo: L10n.GuideOpenCavyInfo.string, midImage: UIImage(asset: .GuideWeightBg), bottomLab: L10n.GuideOpenCavySugg.string)
        case .BandLinking:
            
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            upDatePictureView(L10n.GuideLinking.string, titleInfo: "", midImage: UIImage(asset: .GuideWeightBg), bottomLab: "")
        case .BandSuccess:
           
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            upDatePictureView(L10n.GuidePairSuccess.string, titleInfo: L10n.GuidePairSuccessInfo.string, midImage: UIImage(asset: .GuideWeightBg), bottomLab: "")
        case .BandFail:
            
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            guideBtnImage = UIImage(asset: .GuigeFlashBtn)
            guideBtnImagePress = UIImage(asset: .GuigeFlashBtnPressed)
            upDatePictureView(L10n.GuidePairFail.string, titleInfo: L10n.GuidePairFailInfo.string, midImage: UIImage(asset: .GuideWeightBg), bottomLab: "")
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
            nextView.viewStyle = .BandBluetooth
            self.pushVC(nextView)
            
        default:
            print(__FUNCTION__)
        }
        
    }
    
    /**
     中间按钮事件
     */
    @IBAction func guideBtnClick(sender: AnyObject) {
        
        let nextView = StoryboardScene.Guide.instantiateGuideView()
        
        switch viewStyle {
            
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
            nextView.viewStyle = .BandBluetooth
            self.pushVC(nextView)
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
            nextView.viewStyle = .BandFail
            self.pushVC(nextView)
        case .BandFail:
            print(__FUNCTION__)
            break
        }
        

        
        
    }
    
    /**
     更新性别视图
     */
    func  upDateGenderView(){
                
        let genderView = GenderView(frame: CGRectMake(0, 0, boundsWidth * 0.92, boundsWidth * 1.12))//spacingWidth25 * 23, spacingWidth25 * 28))
        middleView.addSubview(genderView)
 
    }
    
    /**
     更新生日视图
     */
    func  upDateBirthdayView(){
        
        let birthView = BirthdayView(frame: CGRectMake(0, 0, boundsWidth * 0.92, boundsWidth * 1.12))
        middleView.addSubview(birthView)

    }
    
    /**
     更新身高视图
     */
    func  upDateHeightView(){
        
        let highView = HightView(frame: CGRectMake(0, 0, boundsWidth * 0.92, boundsWidth * 1.12))
        middleView.addSubview(highView)
  
    }
    
    /**
     更新体重视图
     */
    func  upDateWeightView(){
        
        let weightView = WeightView(frame: CGRectMake(0, 0, boundsWidth * 0.92, boundsWidth * 1.12))
        middleView.addSubview(weightView)
        weightView.rotaryView.backgroundImage = UIImage(asset: .GuideWeightBg)
    
    }
    
    /**
     更新目标视图
     */
    func upDateGoalView() {
        
        let goalView  = NSBundle.mainBundle().loadNibNamed("GoalView", owner: nil, options: nil).first as! GoalView
        
        goalView.size = middleView.size
        
        goalView.goalViewLayout()
        
        goalView.sliderStepAttribute(5000, recommandValue: 8000, minValue: 0, maxValue: 18000)
        goalView.sliderSleepAttribute(5, avgM: 30, recomH: 8, recomM: 30, minH: 0, minM: 0, maxH: 20, maxM: 00)
        middleView.addSubview(goalView)
        
        
    }

    /**
     更新目标视图
     */
    func upDatePictureView(titleLab: String, titleInfo: String, midImage: UIImage, bottomLab: String){
        
        let pictureView = PictureView(frame: CGRectMake(0, 0, boundsWidth * 0.92, boundsWidth * 1.12))
        
        pictureView.titleLab.text = titleLab
        pictureView.titleInfo.text = titleInfo
        pictureView.middleImgView = UIImageView(image: midImage)
        pictureView.bottomLab.text = bottomLab
                
        middleView.addSubview(pictureView)
        
        
    }
    
    
    
}
