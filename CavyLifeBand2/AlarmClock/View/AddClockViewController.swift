//
//  AddClockViewController.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class AddClockViewController: UIViewController, BaseViewControllerPresenter {

    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var alarmCircleTitleLabel: UILabel!
    
    @IBOutlet weak var alarmCircleSubTitleLabel: UILabel!
    
    @IBOutlet weak var alarmCircleDescriptionLabel: UILabel!
    
    @IBOutlet weak var separatorLineOne: UIView!
    
    @IBOutlet weak var separatorLineTwo: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var bottomViewHeightLC: NSLayoutConstraint!
    
    let AddClockCollectionViewCell = "AlarmClockDateCollectionViewCell"
    
    lazy var addNewClock: Bool = {
        return false
    }()
        
    var dataSource: AddClockVCViewModel?
    
    lazy var alarmModel: AlarmRealmModel = {
        
        let alarm = AlarmRealmModel()
        
        return alarm
    }()
    
    lazy var rightBtn: UIButton? =  {
        
        let button = UIButton(type: .System)
        button.frame = CGRectMake(0, 0, 30, 30)
        button.setBackgroundImage(UIImage(asset: .AlarmClockNavSave), forState: .Normal)
        
        return button
        
    }()
    
    //更新闹钟的回调，使用isUpdate来判断是删除、添加、更新操作
    var updateAlarmBlock: ((model: AlarmRealmModel, isUpdate: Bool) -> Void)?
    
    var navTitle: String { return L10n.AlarmClockTitle.string }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        collectionView.registerNib(UINib(nibName: AddClockCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: AddClockCollectionViewCell)
        
        updateNavUI()
        
        baseSetView()

        setByData()
        
    }
    
    deinit {
        Log.info("dealloc")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onRightBtn() -> Void {
        
//        if dataSource?.alarmModel.alarmDay == 0{
//            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, message: L10n.AlarmClockAlarmCircleAlertTitle.string)
//            return
//        }
//        
//        updateAlarmBlock!(model:dataSource!.alarmModel, isUpdate: true)
        
        updateAlarmBlock!(model: dataSource!.alarmModel, isUpdate: true)
        
        self.popVC()
    }
    
    /**
     视图的基本样式设置
     */
    func baseSetView() -> Void {
        
        separatorLineOne.backgroundColor = UIColor(named: .LColor)
        separatorLineTwo.backgroundColor = UIColor(named: .LColor)
        
        alarmCircleTitleLabel.text      = L10n.AlarmClockAlarmCircleTitle.string
        alarmCircleTitleLabel.textColor = UIColor(named: .EColor)
        alarmCircleTitleLabel.font      = UIFont.mediumSystemFontOfSize(16.0)
        
        alarmCircleSubTitleLabel.text      = L10n.AlarmClockAlarmCircleSubTitle.string
        alarmCircleSubTitleLabel.textColor = UIColor(named: .FColor)
        alarmCircleSubTitleLabel.font      = UIFont.mediumSystemFontOfSize(14.0)
        
        alarmCircleDescriptionLabel.text      = L10n.AlarmClockAlarmCircleDescription.string
        alarmCircleDescriptionLabel.textColor = UIColor(named: .GColor)
        alarmCircleDescriptionLabel.font      = UIFont.systemFontOfSize(12.0)
        
        deleteBtn.layer.cornerRadius = CavyDefine.commonCornerRadius
        deleteBtn.backgroundColor    = UIColor(named: .NColor)
        deleteBtn.titleLabel?.font = UIFont.mediumSystemFontOfSize(18.0)
        deleteBtn.setTitleColor(UIColor(named: .AColor), forState: .Normal)
    }
    
    /**
     用数据设置控件
     */
    func setByData() -> Void {
        
        dataSource = AddClockVCViewModel(alarmModel: alarmModel)
        
        datePicker.datePickerMode = .Time
        
        datePicker.addTarget(self, action: #selector(AddClockViewController.datePickerValueChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        datePicker.date = (dataSource?.getAlarmTimeDate())!
                
        deleteBtn.setTitle(L10n.AlarmClockDeleteBtnTitle.string, forState: .Normal)
        
        if addNewClock {
            bottomViewHeightLC.constant = 0
            bottomView.hidden = true
        } else {
            bottomViewHeightLC.constant = 90
            bottomView.hidden = false
        }

    }
    
    /**
     Action of DatePicker Value Change
     
     - parameter sender: picker控件
     */
    func datePickerValueChange(sender: UIDatePicker) -> Void {
        dataSource?.setAlarmTimeStr(sender.date)
    }
    
    //action of the delete button
    @IBAction func deleteAlarm(sender: AnyObject) {
        
        updateAlarmBlock!(model: dataSource!.alarmModel, isUpdate: addNewClock)

        self.popVC()
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
    }
    
}
