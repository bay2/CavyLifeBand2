//
//  ContectsListTVCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ContactsFriendListCell: UITableViewCell {
    
    // 头像
    @IBOutlet weak var headView: UIImageView!
    
    // 名字
    @IBOutlet weak var nameLabel: UILabel!
    
    // 右边小图标
    @IBOutlet weak var microView: UIImageView!
    
    var hiddenCare: Bool = true {
        
        didSet {
            microView.hidden = hiddenCare
        }
        
    }
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    private var dataSource: ContactsFriendListDataSource?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

        headView.roundSquareImage()

        nameLabel.textColor = UIColor(named: .ContactsName)
        nameLabel.font = UIFont.systemFontOfSize(16)
        let cellBgView = UIView()
        cellBgView.backgroundColor = UIColor(named: .ContactsCellSelect)
        self.selectedBackgroundView = cellBgView

    }

    func configure(dataSource: ContactsFriendListDataSource) {
        
        self.dataSource = dataSource

        nameLabel.text = dataSource.name
        hiddenCare = dataSource.hiddenCare
        dataSource.setHeadImageView(self.headView)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


        // Configure the view for the selected state
    }
    
    func showEditing(show: Bool) {
       
        topLine.hidden = !show
        bottomLine.hidden = !show
        
    }

}

protocol ContactsFriendListDataSource {

    var name: String { get }
    var hiddenCare: Bool { set get }

    func onClickCell(viewController: UIViewController)
    func setHeadImageView(headImage: UIImageView)

}

