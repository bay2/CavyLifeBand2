//
//  MenuTableViewCell.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import SnapKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var listTitle: UILabel!

    override func awakeFromNib() {

        super.awakeFromNib()

        self.backgroundColor = UIColor(named: .HomeViewMainColor)

        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(named: .HomeViewLeftSelected)
        self.selectedBackgroundView = selectedView
        
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(dataSource: MenuCellDateSource, delegate: MenuCellDelegate) {

        listIcon.image = dataSource.icon
        listTitle.text = dataSource.title

        listTitle.font = dataSource.titleFont
        listTitle.textColor = dataSource.titleColor
        
        configLayoutView()

    }
    
    /**
     自动布局视图
     */
    func configLayoutView() {
        
        let listTitleOffset = listIcon.image == nil ? 32 : 62
        
        listTitle.snp_makeConstraints {
            $0.left.equalTo(self).offset(listTitleOffset)
        }
        
    }
    
}



