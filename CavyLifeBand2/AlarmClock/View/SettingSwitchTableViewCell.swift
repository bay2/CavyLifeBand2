//
//  SettingSwitchTableViewCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

protocol SettingSwitchTableViewCelldDelegate {
    func changeSwitchState(sender: UISwitch) -> Void
}

class SettingSwitchTableViewCell: UITableViewCell {

    private var dataSource: SettingCellDataSource?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var selectSwitch: UISwitch!
    
    var delegate: SettingSwitchTableViewCelldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        descriptionLabel.hidden = true
        
        titleLabel.textColor = UIColor(named: .SettingTableCellTitleColor)
        
        self.selectionStyle = .None
        
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
        self.setWithStyle(dataSource.cellStyle)
        
        titleLabel.text = dataSource.title
        
        descriptionLabel.text = dataSource.description
        
        selectSwitch.setOn(dataSource.isOpen, animated: true)
        
    }
    
    @IBAction func changeSwitchValue(sender: UISwitch) {
        
        dataSource?.changeSwitchStatus(sender)
        
        if dataSource?.title == L10n.SettingReminderPhoneCallTitle.string {
            
            delegate?.changeSwitchState(sender)
            
        }
        
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



