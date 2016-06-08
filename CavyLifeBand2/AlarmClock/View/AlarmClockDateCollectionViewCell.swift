//
//  AlarmClockDateCollectionViewCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

@objc protocol AlarmClockDateCellDelegate {
    optional func changeDateSelectState(day: Int, state: Bool) -> Void
}

class AlarmClockDateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateBtn: UIButton!
    
    var number: Int? {
        didSet {
            let numberStr = getDateStrByInt(number ?? 0)
            
            dateBtn.setTitle(numberStr, forState: .Normal)
            dateBtn.setTitle(numberStr, forState: .Selected)
        }
    }
    
    func getDateStrByInt(number: Int) -> String {
        switch number {
        case 1:
            return L10n.AlarmDayMonday.string
        case 2:
            return L10n.AlarmDayTuesday.string
        case 3:
            return L10n.AlarmDayWednesday.string
        case 4:
            return L10n.AlarmDayThursday.string
        case 5:
            return L10n.AlarmDayFriday.string
        case 6:
            return L10n.AlarmDaySaturday.string
        case 7:
            return L10n.AlarmDaySunday.string
        default:
            return ""
        }
    }
    
    weak var delegate: AlarmClockDateCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dateBtn.setTitleColor(UIColor(named: .FColor), forState: .Normal)
        dateBtn.setTitleColor(UIColor(named: .AColor), forState: .Selected)
        
        dateBtn.titleLabel?.font = UIFont.mediumSystemFontOfSize(16.0)
        
        dateBtn.setBackgroundColor(UIColor(named: .MColor), forState: .Normal)
        dateBtn.setBackgroundColor(UIColor(named: .JColor), forState: .Selected)
        
        dateBtn.highlighted = false
        
        self.layer.cornerRadius = 25.0
        
    }

    @IBAction func changeSelectState(sender: UIButton) {
        
        sender.selected = !sender.selected
        
        self.delegate?.changeDateSelectState?(self.number! - 1, state: sender.selected)
         
    }
    
    func setWithNumber(number: Int, isOpen: Bool) -> Void {
        
        self.number = number+1
        
        self.dateBtn.selected = isOpen
        
    }
    
}
