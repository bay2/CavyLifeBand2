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
    
    let AddClockCollectionViewCell = "AlarmClockDateCollectionViewCell"
    
    var realm: Realm = try! Realm()
    
    var dataSource: AddClockVCViewModel?
    
    var addAlarmBlock: ((model: AlarmRealmModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = L10n.AlarmClockTitle.string
        
        baseSetView()
        
        collectionView.registerNib(UINib(nibName: AddClockCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: AddClockCollectionViewCell)
        
        let alarmModel = AlarmRealmModel()
        alarmModel.alarmDay = 87
        
        dataSource = AddClockVCViewModel(realm: realm, alarmModel: alarmModel)
        
        datePicker.datePickerMode = .Time
        
        datePicker.addTarget(self, action:#selector(AddClockViewController.datePickerValueChange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        datePicker.date = (dataSource?.getAlarmTimeDate())!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func datePickerValueChange(sender: UIDatePicker) -> Void {
        dataSource?.setAlarmTimeStr(sender.date)
    }

    @IBAction func confirm(sender: AnyObject) {
        
        addAlarmBlock!(model:dataSource!.alarmModel)

    }
    
}

// MARK: - UICollectionViewDelegate
extension AddClockViewController: UICollectionViewDelegate {

    
    
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

extension AddClockViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 16.0
    }
    
}

extension AddClockViewController: AlarmClockDateCellDelegate {

    func changeDateSelectState(day: Int, state: Bool) {
        dataSource?.changeAlarmDay(day, selected: state)
    }
    
}








