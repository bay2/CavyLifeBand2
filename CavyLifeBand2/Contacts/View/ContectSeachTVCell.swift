//
//  ContectSeachTVCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class ContectSeachTVCell: UITableViewCell {

    // 头像
    @IBOutlet weak var headView: UIImageView!
    
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    // 介绍 签名
    @IBOutlet weak var introduceLabel: UILabel!
    
    // 请求添加好友
    @IBOutlet weak var requestBtn: UIButton!
    
    @IBAction func requestAddFriend(sender: AnyObject) {
        print(__FUNCTION__)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        headView.layer.masksToBounds = true
        headView.layer.cornerRadius = 20
        nameLabel.textColor = UIColor(named: .ContactsName)
        introduceLabel.textColor = UIColor(named: .ContactIntrouduce)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
