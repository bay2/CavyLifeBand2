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
        
        view
        
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
        
        dataSource = PKInvitationVCViewModel(realm: realm)
        
        baseSetting()
        
        dataSouceSetting()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAction(sender: UIButton) {
        
        Log.warning("选择对手 未完成")
        
        Log.warning("push 的 VC 需要抛出一个block给我 数据为选择的人的userId，avatarUrl，nickname")
        
//        dataSource?.setPKWaitCompetitorInfo(<#T##userId: String##String#>, nickName: <#T##String#>, avatarUrl: <#T##String#>)
        
    }

    @IBAction func commitAction(sender: UIButton) {
        Log.warning("提交 未完成")
        
        let challenge = NSBundle.mainBundle().loadNibNamed("PKInfoOrResultView", owner: nil, options: nil).first as? PKInfoOrResultView
                
        self.view .addSubview(challenge!)
        
        challenge?.snp_makeConstraints(closure: {(make) in
            make.leading.equalTo(self.view).offset(20)
            make.trailing.equalTo(self.view).offset(-20)
            make.height.equalTo(380)
            make.centerY.equalTo(self.view.snp_centerY)
        })
        
    }
        
    @IBAction func changeSeeAbleType(sender: UIButton) {
        
        if lastBtn != nil {
            dataSource?.pkWaitRealmModel.isAllowWatch = !(dataSource?.pkWaitRealmModel.isAllowWatch)!
        }
        
        sender.selected = true
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
        
        selectFriendLabel.textColor = UIColor(named: .PKIntroduceVCLabelColor)
        selectTimeLabel.textColor   = UIColor(named: .PKIntroduceVCLabelColor)
        timeUnitLabel.textColor     = UIColor(named: .PKIntroduceVCLabelColor)
        PKStateLabel.textColor      = UIColor(named: .PKIntroduceVCLabelColor)
        
        addBtn.clipsToBounds      = true
        addBtn.layer.cornerRadius = addBtn.frame.size.width / 2
        
        addBtn.setImage(UIImage(named: "PKInvitationAddBtn"), forState: .Normal)
        commitBtn.setImage(UIImage(named: "GuideRightBtn"), forState: .Normal)
        
        otherSeeUnableBtn.setTitle(L10n.PKInvitationVCPKOtherSeeUnable.string, forState: .Normal)
        otherSeeAbleBtn.setTitle(L10n.PKInvitationVCPKOtherSeeAble.string, forState: .Normal)
        
        otherSeeAbleBtn.setTitleColor(UIColor(named: .PKInvitationVCSeeStateBtnSelectedColor), forState: .Selected)
        otherSeeAbleBtn.setTitleColor(UIColor(named: .PKInvitationVCSeeStateBtnNormalColor), forState: .Normal)
        
        otherSeeUnableBtn.setTitleColor(UIColor(named: .PKInvitationVCSeeStateBtnSelectedColor), forState: .Selected)
        otherSeeUnableBtn.setTitleColor(UIColor(named: .PKInvitationVCSeeStateBtnNormalColor), forState: .Normal)
        
        timePickerContainerView.addSubview(timePicker)
        
        timePicker.snp_makeConstraints {(make) in
            make.center.equalTo(timePickerContainerView.snp_center)
            make.width.equalTo(timePickerContainerView.snp_width)
            make.height.equalTo(timePickerContainerView.snp_height)
            
        }
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        timePicker.font = UIFont(name: "HelveticaNeue-Light", size: 30)!
        timePicker.highlightedFont = UIFont(name: "HelveticaNeue", size: 44)!
        timePicker.textColor = UIColor(named: .AlarmClockTableCellDescriptionColor)
        timePicker.highlightedTextColor = UIColor(named: .AlarmClockTableCellTitleColor)
        timePicker.pickerViewStyle = .Flat
        timePicker.maskDisabled = false
    }
    
    func dataSouceSetting() -> Void {
        
        
        self.timePicker.selectItem(dataSource!.selectIndex)
        
        changeSeeAbleType(dataSource!.pkWaitRealmModel.isAllowWatch ? otherSeeAbleBtn : otherSeeUnableBtn)
        
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
