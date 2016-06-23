//
//  PKInvitationVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import RealmSwift

class PKInvitationVC: UIViewController, BaseViewControllerPresenter {
    
    var navTitle: String { return L10n.PKInvitationVCTitle.string }

    var lastBtn: UIButton?
    
    lazy var timePicker: AKPickerView = {
        let view = AKPickerView()
        
        return view

    }()
    
    var realm: Realm = try! Realm()
    
    var dataSource: PKInvitationVCViewModel?
    
    @IBOutlet weak var invitationView: UIView!
    @IBOutlet weak var timePickerContainerView: UIView!
    
    @IBOutlet weak var selectFriendLabel: UILabel!
    @IBOutlet weak var selectTimeLabel: UILabel!
    @IBOutlet weak var PKStateLabel: UILabel!
    @IBOutlet weak var timeUnitLabel: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var otherSeeUnableBtn: UIButton!
    @IBOutlet weak var otherSeeAbleBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        if dataSource == nil {
            dataSource = PKInvitationVCViewModel(realm: realm)
        } else {
            addBtnSetCompetitor(dataSource!.pkWaitRealmModel.avatarUrl)
        }
        
        baseSetting()
        
        dataSouceSetting()
        
        updateNavUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var rightBtn: UIButton? =  {
        
        let button = UIButton(type: .System)
        button.frame = CGRectMake(0, 0, 30, 30)
        button.setBackgroundImage(UIImage(asset: .PKHelp), forState: .Normal)
        
        return button
        
    }()
    
    func onRightBtn() -> Void {
        
        self.pushVC(StoryboardScene.PK.instantiatePKRulesVC())
   
    }
    
    @IBAction func addAction(sender: UIButton) {
        
        let pkSelectVC = StoryboardScene.PK.instantiatePKSelectOppTVC()
        
        pkSelectVC.delegate = self
        
        self.pushVC(pkSelectVC)
        
    }

    @IBAction func commitAction(sender: UIButton) {
    
        guard dataSource?.pkWaitRealmModel.userId.characters.count != 0 else {
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, message: L10n.PKInvitationVCSelectFriend.string)
            
            return
        }
        
        dataSource?.launchPK()
                
        self.pushVC(StoryboardScene.PK.instantiatePKListVC())
        
    }
        
    @IBAction func changeSeeAbleType(sender: UIButton) {
        
        if lastBtn != nil {
            
            switch dataSource?.pkWaitRealmModel.isAllowWatch ?? PKAllowWatchState.AllWatch.rawValue {
            case PKAllowWatchState.AllWatch.rawValue:
                dataSource?.pkWaitRealmModel.isAllowWatch = PKAllowWatchState.OtherNoWatch.rawValue
            case PKAllowWatchState.OtherNoWatch.rawValue:
                dataSource?.pkWaitRealmModel.isAllowWatch = PKAllowWatchState.AllWatch.rawValue
            default:
                break
            }
      
        }
        
        sender.selected   = true
        lastBtn?.selected = false
        
        lastBtn = sender
        
    }
    
    func baseSetting() -> Void {
        
        invitationView.clipsToBounds = true
        invitationView.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        selectFriendLabel.text = L10n.PKInvitationVCSelectFriend.string
        selectTimeLabel.text   = L10n.PKInvitationVCSelectTime.string
        timeUnitLabel.text     = "(\(L10n.PKInvitationVCTimeUnit))"
        PKStateLabel.text      = L10n.PKInvitationVCPKState.string
        
        selectFriendLabel.textColor = UIColor(named: .EColor)
        selectTimeLabel.textColor   = UIColor(named: .EColor)
        timeUnitLabel.textColor     = UIColor(named: .EColor)
        PKStateLabel.textColor      = UIColor(named: .EColor)
        
        selectFriendLabel.font = UIFont.mediumSystemFontOfSize(16.0)
        selectTimeLabel.font   = UIFont.mediumSystemFontOfSize(16.0)
        timeUnitLabel.font     = UIFont.mediumSystemFontOfSize(12.0)
        PKStateLabel.font      = UIFont.mediumSystemFontOfSize(16.0)
        
        addBtn.clipsToBounds      = true
        addBtn.layer.cornerRadius = addBtn.frame.size.width / 2

        addBtn.setBackgroundImage(UIImage(asset: .PKInvitationAddBtn), forState: .Normal)
        addBtn.setBackgroundImage(UIImage(asset: .PKInvitationAddBtnHighLight), forState: .Highlighted)
        
        commitBtn.setImage(UIImage(asset: .GuideRightBtn), forState: .Normal)
        commitBtn.setImage(UIImage(asset: .GuideRightBtnHighLight), forState: .Normal)
        
        otherSeeUnableBtn.setTitle(L10n.PKInvitationVCPKOtherSeeUnable.string, forState: .Normal)
        otherSeeAbleBtn.setTitle(L10n.PKInvitationVCPKOtherSeeAble.string, forState: .Normal)
        
        otherSeeAbleBtn.setTitleColor(UIColor(named: .EColor), forState: .Selected)
        otherSeeAbleBtn.setTitleColor(UIColor(named: .GColor), forState: .Normal)
        otherSeeAbleBtn.titleLabel?.font = UIFont.mediumSystemFontOfSize(14.0)
        
        otherSeeUnableBtn.setTitleColor(UIColor(named: .EColor), forState: .Selected)
        otherSeeUnableBtn.setTitleColor(UIColor(named: .GColor), forState: .Normal)
        otherSeeUnableBtn.titleLabel?.font = UIFont.mediumSystemFontOfSize(14.0)
        
        timePickerContainerView.addSubview(timePicker)
        
        let topLine = UIView()
        let bottomLine = UIView()
        
        topLine.backgroundColor = UIColor(named: .LColor)
        bottomLine.backgroundColor = UIColor(named: .LColor)
        
        timePickerContainerView.addSubview(topLine)
        timePickerContainerView.addSubview(bottomLine)
        
        topLine.snp_makeConstraints { make in
            make.leading.equalTo(timePickerContainerView)
            make.trailing.equalTo(timePickerContainerView)
            make.top.equalTo(timePickerContainerView)
            make.height.equalTo(1.0)
        }
        
        bottomLine.snp_makeConstraints { make in
            make.leading.equalTo(timePickerContainerView)
            make.trailing.equalTo(timePickerContainerView)
            make.bottom.equalTo(timePickerContainerView)
            make.height.equalTo(1.0)
        }
        
        timePicker.snp_makeConstraints { make in
            make.center.equalTo(timePickerContainerView.snp_center)
            make.width.equalTo(timePickerContainerView.snp_width)
            make.height.equalTo(timePickerContainerView.snp_height)
            
        }
        
        timePicker.delegate   = self
        timePicker.dataSource = self
        
        timePicker.font            = UIFont.mediumSystemFontOfSize(30.0)
        timePicker.highlightedFont = UIFont.mediumSystemFontOfSize(42.0)
        
        timePicker.textColor            = UIColor(named: .GColor)
        timePicker.highlightedTextColor = UIColor(named: .EColor)
        
        timePicker.pickerViewStyle = .Flat
        timePicker.maskDisabled    = false
    }
    
    func dataSouceSetting() -> Void {
        
        self.timePicker.selectItem(dataSource!.selectIndex)
        
        switch dataSource!.pkWaitRealmModel.isAllowWatch {
        case PKAllowWatchState.AllWatch.rawValue:
            changeSeeAbleType(otherSeeAbleBtn)
        case PKAllowWatchState.OtherNoWatch.rawValue:
            changeSeeAbleType(otherSeeUnableBtn)
        default:
            break
        }
        
    }

}

extension PKInvitationVC: AKPickerViewDataSource {
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return dataSource!.timeArr.count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return dataSource!.timeArr[item]
    }
    
}

extension PKInvitationVC: AKPickerViewDelegate {
    
    func pickerView(pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        return CGSizeMake(15, 10)
    }
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        dataSource?.selectIndex = item
    }
    
}

extension PKInvitationVC: PKSelectOppTVCDelegate {
    
    func selectPKOpp(userId: String, nikeName: String, avatarUrl: String) {
        
        addBtnSetCompetitor(avatarUrl)
        dataSource?.setPKWaitCompetitorInfo(userId, nickName: nikeName, avatarUrl: avatarUrl)
        
    }
    
    
    func addBtnSetCompetitor(avatarUrl: String) {
        addBtn.af_setBackgroundImageForState(.Normal, URL: NSURL(string: avatarUrl)!, placeHolderImage: UIImage(asset: .DefaultHead_small))
    }
    
}
