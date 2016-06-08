//
//  IntelligentClockCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol IntelligentClockCellDelegate: class {
    func changeAlarmOpenStatus(index: Int) -> Void
}

class IntelligentClockCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var setSwitch: UISwitch!
    
    weak var delegate: IntelligentClockCellDelegate?
    
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle  = .None

        self.backgroundColor = UIColor.whiteColor()
        
        timeLabel.textColor = UIColor(named: .SettingTableCellTitleColor)

        dayLabel.textColor  = UIColor(named: .SettingTableCellInfoGrayColor)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(dataSource: IntelligentClockCellDataSource) -> Void {
        
        timeLabel.text = dataSource.time

        dayLabel.text  = dataSource.day

        setSwitch.on   = dataSource.isOpen

        self.index     = dataSource.index
        
    }
    
    @IBAction func changeSwitchStatus(sender: AnyObject) {
        delegate?.changeAlarmOpenStatus(self.index!)
    }
    
}

protocol IntelligentClockCellDataSource {
    var time: String { get }
    
    var day: String { get }
    
    var isOpen: Bool { get }
    
    var index: Int { get }
}

struct IntelligentClockCellViewModel: IntelligentClockCellDataSource {
    
    var time: String
    
    var day: String
    
    var isOpen: Bool
    
    var index: Int
    
    init(alarm: AlarmRealmModel, index: Int) {
        
        self.time   = alarm.alarmTime

        self.day    = alarm.alarmDayToString()

        self.isOpen = alarm.isOpen

        self.index  = index
    }
}
