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
    
    var datasource: ContactsPersonInfoListCellPresenter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.textColor = UIColor(named: .EColor)
        titleLabel.font = UIFont.systemFontOfSize(16.0)
        
        titleInfoLabel.textColor = UIColor(named: .EColor)
        titleInfoLabel.font = UIFont.systemFontOfSize(16.0)
        
        self.selectionStyle = .None

        
    }
    
    func addData(title: String, titleInfo: String, cellEditOrNot: Bool) {
        
        if cellEditOrNot {
            // 可编辑状态时候 右边是浅色的
            titleInfoLabel.textColor = UIColor(named: .ContactsIntrouduce)
            
        }
        titleLabel.text = title
        titleInfoLabel.text = titleInfo
    }
    
    func configCell(datasource: ContactsPersonInfoListCellPresenter, cellEditOrNot: Bool = false) {
        
        self.datasource = datasource
        
        titleLabel.text = datasource.title
        titleInfoLabel.text = datasource.info
        
        titleInfoLabel.textColor = datasource.infoTextColor
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}


