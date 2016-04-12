//
//  SettingSwitchTableViewCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class SettingSwitchTableViewCell: UITableViewCell {
    
    

    private var dataSource: SettingCellDataSource?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var selectSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.descriptionLabel.hidden = true
        
        self.descriptionLabel.text = "我是来电提醒lalal"
        
        self.titleLabel.text = "来电提醒"
        
        titleLabel.textColor = UIColor(named: .SettingTableCellTitleColor)
        
//        selectSwitch.addTarget(nil, action: Selector("changeSwitchState:"), forControlEvents: .ValueChanged)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setWithStyle(style: CavyLifeBand2SwitchStyle) -> Void {
        switch style {
            
        case .RedDescription:
            descriptionLabel.hidden = false
            descriptionLabel.font = UIFont.systemFontOfSize(14.0)
            descriptionLabel.textColor = UIColor(named: .SettingTableCellInfoYellowColor)
            
        case .GrayDescription:
            descriptionLabel.hidden = false
            descriptionLabel.font = UIFont.systemFontOfSize(12.0)
            descriptionLabel.textColor = UIColor(named: .SettingTableCellInfoGrayColor)
            
        case .NoneDescription:
            descriptionLabel.hidden = true
            
        }
    }
    
    func configure(dataSource: SettingCellDataSource) {
        
        self.dataSource = dataSource
        
        //设置样式
        switch dataSource.cellStyle {
            
        case .RedDescription:
            descriptionLabel.hidden = false
            descriptionLabel.font = UIFont.systemFontOfSize(14.0)
            descriptionLabel.textColor = UIColor(named: .SettingTableCellInfoYellowColor)
            
        case .GrayDescription:
            descriptionLabel.hidden = false
            descriptionLabel.font = UIFont.systemFontOfSize(12.0)
            descriptionLabel.textColor = UIColor(named: .SettingTableCellInfoGrayColor)
            
        case .NoneDescription:
            descriptionLabel.hidden = true
       
        }
        
        titleLabel.text = dataSource.title
        
        descriptionLabel.text = dataSource.description
        
        selectSwitch.setOn(dataSource.isOpen, animated: true)
        
        
        
//        switch dataSource.title {
//        case L10n.SettingReminderPhoneCallTitle.string:
//            descriptionLabel.hidden = false
//            descriptionLabel.font = UIFont.systemFontOfSize(14.0)
//            descriptionLabel.textColor = UIColor(named: .SettingTableCellInfoYellowColor)
//        case L10n.SettingReminderMessageTitle.string:
//            descriptionLabel.hidden = false
//            descriptionLabel.font = UIFont.systemFontOfSize(12.0)
//            descriptionLabel.textColor = UIColor(named: .SettingTableCellInfoGrayColor)
//        case L10n.SettingReminderReconnectTitle.string:
//            descriptionLabel.hidden = true
//        default:
//            break
//        }
        
        
        
    }
    
    @IBAction func changeSwitchValue(sender: AnyObject) {
        
        dataSource?.changeSwitchStatus(sender as! UISwitch)
        
    }

}

enum CavyLifeBand2SwitchStyle {
    case RedDescription
    case GrayDescription
    case NoneDescription
}

protocol SettingCellDataSource {
    
    var title: String { get }
    
    var description: String { get }
    
    var isOpen: Bool { get }
    
    var cellStyle: CavyLifeBand2SwitchStyle { get }
    
    func changeSwitchStatus(sender: UISwitch)
    
}
