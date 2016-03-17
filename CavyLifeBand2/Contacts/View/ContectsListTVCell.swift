//
//  ContectsListTVCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class ContectsListTVCell: UITableViewCell {
    
    // 头像
    @IBOutlet weak var headView: UIImageView!
    
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    // 右边小图标
    @IBOutlet weak var microView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headView.layer.masksToBounds = true
        headView.layer.cornerRadius = 20
        nameLabel.textColor = UIColor(named: .ContactsName)
        
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
