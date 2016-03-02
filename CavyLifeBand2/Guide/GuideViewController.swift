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
    
    /// 小标题
    @IBOutlet weak var subTitle: UILabel!
    
    /// 小标题详情
    @IBOutlet weak var subTitleInfo: UILabel!
    
    /// 中间的图片
    @IBOutlet weak var middleImage: UIImageView!
    /// 性别图片上面
    @IBOutlet weak var genderUpImage: UIButton!
    /// 性别图片下面
    @IBOutlet weak var genderDownImage: UIButton!
    
    /// 下面附属提醒信息
    @IBOutlet weak var subSuggtion: UILabel!
    
    /// 确定按钮
    @IBOutlet weak var guideButton: UIButton!

    // 视图风格
    var viewStyle: GuideViewStyle = .GuideGender
    
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
            make.top.equalTo(self.view).offset(spacingWidth25 * 6)
        }
        
        middleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(spacingWidth25 * 9)
        }
        
        genderUpImage.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(middleView).offset(spacingWidth25 * 5)
        }
        genderDownImage.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(middleView).offset(spacingWidth25 * 15)
        }
        
        
        subTitle.textColor = UIColor(named: .GuideColor99)
        subTitle.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(middleView).offset(spacingWidth25 * 2)
        }
        
        subTitleInfo.textColor = UIColor(named: .GuideColor99)
        
        subSuggtion.textColor = UIColor(named: .GuideColor66)
        subSuggtion.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(middleImage.bottom).offset(spacingWidth25 * 23)
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
            ///我的信息 性别页面
        case .GuideGender:
            updateNavigationItemUI(L10n.GuideMyInfo.string)
            guideBgColor = UIColor(named: .GuideColorBlue)
            titleInfoText = L10n.GuideIntroduce.string
            subTitleText = L10n.GuideMine.string
            genderUpImage.hidden = false
            genderDownImage.hidden = false
            
            ///我的信息 生日
        case .GuideBirthday:
            updateNavigationItemUI(L10n.GuideMyInfo.string)
            subTitleText = L10n.GuideBirthday.string
            
            ///我的信息 身高
        case .GuideHeight:
            updateNavigationItemUI(L10n.GuideMyInfo.string)
            subTitleText = L10n.GuideHeight.string
            
            ///我的信息 体重
        case .GuideWeight:
            updateNavigationItemUI(L10n.GuideMyInfo.string)
            subTitleText = L10n.GuideWeight.string
            
            ///设置 开启智能通知
        case .SettingNotice:
            infoLabel.hidden = true
            subTitleInfo.hidden = false
            middleImage.hidden = false
            updateNavigationItemUI(L10n.GuideSetting.string, rightBtnText: L10n.GuidePassButton.string, isNeedBack: true)
            guideBgColor = UIColor(named: .GuideColorcyanColor)
            subTitleText = L10n.GuideOpenNotice.string
            subTitleInfoText = L10n.GuideOpenNoticeInfo.string
            
            ///设置 开启位置分享
        case .SettingLocationShare:
            infoLabel.hidden = true
            middleImage.hidden = false
            updateNavigationItemUI(L10n.GuideSetting.string, rightBtnText: L10n.GuidePassButton.string, isNeedBack: true)
            guideBgColor = UIColor(named: .GuideColorcyanColor)
            subTitleText = L10n.GuideOpenLocationShare.string
            subTitleInfoText = L10n.GuideOpenLocationShareInfo.string
            subTitleInfo.hidden = false
            
            ///连接手环 打开蓝牙
        case .BandBluetooth:
            infoLabel.hidden = true
            subTitleInfo.hidden = false
            middleImage.hidden = false
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            subTitleText = L10n.GuideOpenBluetooth.string
            subTitleInfoText = L10n.GuideOpenBluetoothInfo.string
            
            ///连接手环 打开手环
        case .BandopenBand:
            infoLabel.hidden = true
            middleImage.hidden = false
            subTitleInfo.hidden = false
            subSuggtion.hidden = false // 没有电？充电试试看
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            subTitleText = L10n.GuideOpenCavy.string
            subTitleInfoText = L10n.GuideOpenCavyInfo.string
            subSuggtion.text = L10n.GuideOpenCavySugg.string
            
            ///连接手环 正在连接
        case .BandLinking:
            infoLabel.hidden = true
            subSuggtion.hidden = true
            middleImage.hidden = false
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            subTitleText = L10n.GuideLinking.string
            
            ///连接手环 连接成功
        case .BandSuccess:
            infoLabel.hidden = true
            subTitleInfo.hidden = false
            middleImage.hidden = false
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            subTitleText = L10n.GuidePairSuccess.string
            subTitleInfoText = L10n.GuidePairSuccessInfo.string
            
            ///连接手环 连接失败
        case .BandFail:
            infoLabel.hidden = true
            subTitleInfo.hidden = false
            middleImage.hidden = false
            guideBgColor = UIColor(named: .GuideColorGreen)
            updateNavigationItemUI(L10n.GuideLinkCavy.string)
            addMiddleImage = UIImage(asset: .GuideRightBtn)
            guideBtnImage = UIImage(asset: .GuideRightBtn)
            subTitleText = L10n.GuidePairFail.string
            subTitleInfoText = L10n.GuidePairFailInfo.string
   
        }
        
        self.view.backgroundColor = guideBgColor
        self.infoLabel.text = titleInfoText
        self.subTitle.text = subTitleText
        self.subTitleInfo.text = subTitleInfoText
        self.middleImage = UIImageView(image: addMiddleImage)
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
    

}
