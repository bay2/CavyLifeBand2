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
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .SpellOutStyle
            let numberStr = numberFormatter.stringFromNumber(NSNumber.init(integer: number!))
            
            dateBtn.setTitle(numberStr, forState: .Normal)
            dateBtn.setTitle(numberStr, forState: .Selected)
        }
    }
    
    weak var delegate: AlarmClockDateCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dateBtn.setTitleColor(UIColor(named: .AlarmClockDateBtnTextNormalColor), forState: .Normal)
        dateBtn.setTitleColor(UIColor(named: .AlarmClockDateBtnTextSelectedColor), forState: .Selected)
        
        dateBtn.setBackgroundColor(UIColor(named: .AlarmClockDateBtnBGNormalColor), forState: .Normal)
        dateBtn.setBackgroundColor(UIColor(named: .AlarmClockDateBtnBGSelectedColor), forState: .Selected)
        
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
