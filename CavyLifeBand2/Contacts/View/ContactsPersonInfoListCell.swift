//
//  ContactsPersonInfoListCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class ContactsPersonInfoListCell: UITableViewCell {

    /// 左边Label
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 右边Label
    @IBOutlet weak var titleInfoLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.textColor = UIColor(named: .ContactsTitleColor)
        self.selectionStyle = .None
        
            titleInfoLabel.textColor = UIColor(named: .ContactsName)
            

        
    }
    
    func addData(title: String, titleInfo: String, cellEditOrNot: Bool) {
        
        if cellEditOrNot {
            // 可编辑状态时候 右边是浅色的
            titleInfoLabel.textColor = UIColor(named: .ContactsIntrouduce)
            
        }
        titleLabel.text = title
        titleInfoLabel.text = titleInfo
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
