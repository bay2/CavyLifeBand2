//
//  AddClockViewController.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = L10n.AlarmClockTitle.string
        
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
        
        datePicker.datePickerMode = .Time
        
        collectionView.registerNib(UINib(nibName: AddClockCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: AddClockCollectionViewCell)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
                
        cell?.setWithNumber(Int(indexPath.row + 1))
        
        return cell!
    }

}

extension AddClockViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 16.0
    }
    
}








