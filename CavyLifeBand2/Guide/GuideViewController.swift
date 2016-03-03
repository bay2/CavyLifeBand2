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
    var viewStyle: GuideViewStyle = .GuideBirthday
    
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
            make.top.equalTo(self.view).offset(spacingWidth25 * 6)
        }
        
        middleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(spacingWidth25 * 9)
        }
        
        guideButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(spacingWidth25 * 34)
        }

    }
    
    /**
     更新视图风格
     */
    func updateViewStyle() {
        
        var guideBgColor = UIColor(named: .GuideColorBlue)
        var titleInfoText = L10n.GuideIntroduce.string
        var subTitleText = L10n.GuideMine.string
        var subTitleInfoText = L10n.GuideOpenNoticeInfo.string
        var addMiddleImage = UIImage(asset: .GuideRightBtn)
        var guideBtnImage = UIImage(asset: .GuideRightBtn)
        
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
            
        case .SettingNotice:
            
            updateNavigationItemUI(L10n.GuideSetting.string, rightBtnText: L10n.GuidePassButton.string, isNeedBack: true)
            guideBgColor = UIColor(named: .GuideColorcyanColor)
            subTitleText = L10n.GuideOpenNotice.string
            subTitleInfoText = L10n.GuideOpenNoticeInfo.string
            
        case .SettingLocationShare:
            
            updateNavigationItemUI(L10n.GuideSetting.string, rightBtnText: L10n.GuidePassButton.string, isNeedBack: true)
            guideBgColor = UIColor(named: .GuideColorcyanColor)
            subTitleText = L10n.GuideOpenLocationShare.string
            subTitleInfoText = L10n.GuideOpenLocationShareInfo.string
            
        case .BandBluetooth:
            
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            subTitleText = L10n.GuideOpenBluetooth.string
            subTitleInfoText = L10n.GuideOpenBluetoothInfo.string
            
        case .BandopenBand:
            
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            subTitleText = L10n.GuideOpenCavy.string
            subTitleInfoText = L10n.GuideOpenCavyInfo.string
            
        case .BandLinking:
            
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            subTitleText = L10n.GuideLinking.string
            
        case .BandSuccess:
           
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            subTitleText = L10n.GuidePairSuccess.string
            subTitleInfoText = L10n.GuidePairSuccessInfo.string
            
        case .BandFail:
            
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            addMiddleImage = UIImage(asset: .GuideRightBtn)
            guideBtnImage = UIImage(asset: .GuideRightBtn)
            subTitleText = L10n.GuidePairFail.string
            subTitleInfoText = L10n.GuidePairFailInfo.string
   
        }
        
        self.view.backgroundColor = guideBgColor
        self.infoLabel.text = titleInfoText
        self.guideButton.setImage(guideBtnImage, forState: .Normal)
        
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
                
        let genderView = GenderView(frame: CGRectMake(0, 0, spacingWidth25 * 23, spacingWidth25 * 28))
        middleView.addSubview(genderView)
 
    }
    
    /**
     更新生日视图
     */
    func  upDateBirthdayView(){
        
        let birthView = BirthdayView(frame: CGRectMake(0, 0, spacingWidth25 * 23, spacingWidth25 * 28))
        middleView.addSubview(birthView)

    }
    
    /**
     更新身高视图
     */
    func  upDateHeightView(){
        
        let highView = HightView(frame: CGRectMake(0, 0, spacingWidth25 * 23, spacingWidth25 * 28))
        middleView.addSubview(highView)
  
    }
    
    /**
     更新体重视图
     */
    func  upDateWeightView(){
        
        let weightView = WeightView(frame: CGRectMake(0, 0, spacingWidth25 * 23, spacingWidth25 * 28))
        middleView.addSubview(weightView)
    
    }
    
    
    
    
    
    
}
