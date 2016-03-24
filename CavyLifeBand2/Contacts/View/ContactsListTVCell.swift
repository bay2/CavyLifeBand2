//
//  ContectsListTVCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ContactsListTVCell: UITableViewCell {
    
    // 头像
    @IBOutlet weak var headView: UIImageView!
    
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    // 右边小图标
    @IBOutlet weak var microView: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

        headView.roundSquareImage()

        nameLabel.textColor = UIColor(named: .ContactsName)
        nameLabel.font = UIFont.systemFontOfSize(16)
        let cellBgView = UIView()
        cellBgView.backgroundColor = UIColor(named: .ContactsCellSelect)
        self.selectedBackgroundView = cellBgView
        self.selectionStyle = .None

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


        // Configure the view for the selected state
    }

}
