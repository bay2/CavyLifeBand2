//
//  AccountInfoSecurityCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/30.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class AccountInfoSecurityCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoSwitch: UISwitch!
    
    
    @IBAction func switchAction(sender: AnyObject) {
        
        if sender.on! {
            
            print("\(titleLabel.text!)当前状态是： 打开")
            
        } else {
            
            print("\(titleLabel.text!)当前状态是： 关闭")

        }
        
    }
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.textColor = UIColor(named: .ContactsName)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
