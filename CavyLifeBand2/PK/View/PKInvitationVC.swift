//
//  PKInvitationVC.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class PKInvitationVC: UIViewController, BaseViewControllerPresenter {
    
    var navTitle: String { return L10n.PKInvitationVCTitle.string }

    var lastBtn: UIButton?
    
    let timePicker: TimePickerView = {
        return TimePickerView.init(frame: CGRectZero, dataSource: nil)
    }()
    
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
        
        baseSetting()
        
        timePicker.pickerDelegate = self
        
        timePicker.scrollToIndex(1)
        
        changeSeeAbleType(otherSeeUnableBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addAction(sender: UIButton) {
    }

    @IBAction func commitAction(sender: UIButton) {
    }
    
    
    @IBAction func changeSeeAbleType(sender: UIButton) {
        sender.selected = true
        lastBtn?.selected = false
        lastBtn = sender
    }
    
    func baseSetting() -> Void {
        
        invitationView.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        selectFriendLabel.text = L10n.PKInvitationVCSelectFriend.string
        selectTimeLabel.text   = L10n.PKInvitationVCSelectTime.string
        timeUnitLabel.text     = "(\(L10n.PKInvitationVCTimeUnit))"
        PKStateLabel.text      = L10n.PKInvitationVCPKState.string
        
        selectFriendLabel.textColor = UIColor(named: .PKIntroduceVCLabelColor)
        selectTimeLabel.textColor   = UIColor(named: .PKIntroduceVCLabelColor)
        timeUnitLabel.textColor     = UIColor(named: .PKIntroduceVCLabelColor)
        PKStateLabel.textColor      = UIColor(named: .PKIntroduceVCLabelColor)
        
        
        
        addBtn.setImage(UIImage(named: "PKInvitationAddBtn"), forState: .Normal)
        commitBtn.setImage(UIImage(named: "GuideRightBtn"), forState: .Normal)
        
        otherSeeUnableBtn.setTitle(L10n.PKInvitationVCPKOtherSeeUnable.string, forState: .Normal)
        otherSeeAbleBtn.setTitle(L10n.PKInvitationVCPKOtherSeeAble.string, forState: .Normal)
        
        otherSeeAbleBtn.setTitleColor(UIColor(named: .PKInvitationVCSeeStateBtnSelectedColor), forState: .Selected)
        otherSeeAbleBtn.setTitleColor(UIColor(named: .PKInvitationVCSeeStateBtnNormalColor), forState: .Normal)
        
        otherSeeUnableBtn.setTitleColor(UIColor(named: .PKInvitationVCSeeStateBtnSelectedColor), forState: .Selected)
        otherSeeUnableBtn.setTitleColor(UIColor(named: .PKInvitationVCSeeStateBtnNormalColor), forState: .Normal)
        
        timePickerContainerView.addSubview(timePicker)
        
        timePicker.snp_makeConstraints { (make) in
            make.center.equalTo(timePickerContainerView.snp_center)
            make.width.equalTo(timePickerContainerView.snp_width)
            make.height.equalTo(timePickerContainerView.snp_height)
            
        }
    }

}

extension PKInvitationVC: TimePickerViewDelegate {
    
    func timePickerView(timePickerView: TimePickerView, didSelectItemAtIndex index: Int) {
        Log.info("\(index)")
    }
    
}
