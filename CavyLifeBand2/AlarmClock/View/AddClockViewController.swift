//
//  AddClockViewController.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class AddClockViewController: UIViewController {

    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var awakeTitleLabel: UILabel!
    
    @IBOutlet weak var awakeDescriptionLabel: UILabel!
    
    @IBOutlet weak var alarmCircleTitleLabel: UILabel!
    
    @IBOutlet weak var alarmCircleSubTitleLabel: UILabel!
    
    @IBOutlet weak var alarmCircleDescriptionLabel: UILabel!
    
    @IBOutlet weak var separatorViewSeconde: UIView!
    
    @IBOutlet weak var separatorViewFisrt: UIView!
    
    @IBOutlet weak var awakeSwitch: UISwitch!
    
    let AddClockCollectionViewCell = "AlarmClockDateCollectionViewCell"
    
    lazy var addNewClock: Bool = {
        return false
    }()
        
    var dataSource: AddClockVCViewModel?
    
    lazy var alarmModel: AlarmRealmModel = {
        
        let alarm = AlarmRealmModel()
        
        Log.warning("用户ID 写死了")
        alarm.userId = "12"
        
        return alarm
    }()
    
    //更新闹钟的回调，使用isUpdate来判断是删除、添加、更新操作
    var updateAlarmBlock: ((model: AlarmRealmModel, isUpdate: Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = L10n.AlarmClockTitle.string
        
        collectionView.registerNib(UINib(nibName: AddClockCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: AddClockCollectionViewCell)
        
        baseSetView()

        setByData()
    }
    
    deinit {
        Log.info("dealloc")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     视图的基本样式设置
     */
    func baseSetView() -> Void {
        separatorViewFisrt.backgroundColor = UIColor(named: .SettingSeparatorColor)
        
        separatorViewSeconde.backgroundColor = UIColor(named: .SettingSeparatorColor)
        
        awakeTitleLabel.text = L10n.AlarmClockAwakeTitle.string
        
        awakeTitleLabel.textColor = UIColor(named: .AlarmClockSettingTitleColor)
        
        awakeDescriptionLabel.text = L10n.AlarmClockAwakeDescription.string
        
        awakeDescriptionLabel.textColor = UIColor(named: .AlarmClockSettingDescriptionColor)
        
        alarmCircleTitleLabel.text = L10n.AlarmClockAlarmCircleTitle.string
        
        alarmCircleTitleLabel.textColor = UIColor(named: .AlarmClockSettingTitleColor)
        
        alarmCircleSubTitleLabel.text = L10n.AlarmClockAlarmCircleSubTitle.string
        
        alarmCircleSubTitleLabel.textColor = UIColor(named: .AlarmClockSettingDescriptionColor)
        
        alarmCircleDescriptionLabel.text = L10n.AlarmClockAlarmCircleDescription.string
        
        alarmCircleDescriptionLabel.textColor = UIColor(named: .AlarmClockSettingDescription2Color)
        
        confirmBtn.layer.cornerRadius = CavyDefine.commonCornerRadius
    }
    
    /**
     用数据设置控件
     */
    func setByData() -> Void {
        dataSource = AddClockVCViewModel(alarmModel: alarmModel)
        
        datePicker.datePickerMode = .Time
        
        datePicker.addTarget(self, action:#selector(AddClockViewController.datePickerValueChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        datePicker.date = (dataSource?.getAlarmTimeDate())!
        
        awakeSwitch.on = (dataSource?.alarmModel.isOpenAwake)!
        
        if addNewClock {
            confirmBtn.setTitle("确定", forState: .Normal)
        } else {
            confirmBtn.setTitle("删除", forState: .Normal)
        }

    }
    
    /**
     Action of DatePicker Value Change
     
     - parameter sender: picker控件
     */
    func datePickerValueChange(sender: UIDatePicker) -> Void {
        dataSource?.setAlarmTimeStr(sender.date)
        
        if !addNewClock {
            updateAlarmBlock!(model:dataSource!.alarmModel, isUpdate: true)
        }
    }
    
    //action of the button which at the bottom
    @IBAction func confirm(sender: AnyObject) {
        updateAlarmBlock!(model:dataSource!.alarmModel, isUpdate: addNewClock)
    }
    
    //action of switch
    @IBAction func changeAwakeSwitch(sender: UISwitch) {
        dataSource?.alarmModel.isOpenAwake = sender.on
        
        if !addNewClock {
            updateAlarmBlock!(model:dataSource!.alarmModel, isUpdate: true)
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension AddClockViewController: UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AddClockCollectionViewCell, forIndexPath: indexPath) as? AlarmClockDateCollectionViewCell
        
        cell?.setWithNumber(Int(indexPath.row), isOpen: (dataSource?.alarmDayDic![indexPath.row])!)
        
        cell?.delegate = self
      
        return cell!
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension AddClockViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 16.0
    }
    
}

// MARK: - AlarmClockDateCellDelegate
extension AddClockViewController: AlarmClockDateCellDelegate {

    func changeDateSelectState(day: Int, state: Bool) {
        dataSource?.changeAlarmDay(day, selected: state)
        
        if !addNewClock {
            updateAlarmBlock!(model:dataSource!.alarmModel, isUpdate: true)
        }
    }
    
}