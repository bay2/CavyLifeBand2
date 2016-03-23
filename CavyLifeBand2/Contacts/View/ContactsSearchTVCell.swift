//
//  ContectSeachTVCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import SnapKit

protocol ContactsSearchCellDataSource {
    
    var headImage: UIImage { get }
    var name: String { get }
    var introudce: String { get }
    var requestBtnTitle: String { get }
    
}

protocol ContactsSearchCellDelegate {
    
    var nameTextColor: UIColor { get }
    var introductTextColor: UIColor { get }
    var nameFont: UIFont { get }
    var introduceFont: UIFont { get }
    var requestBtnColor: UIColor { get }
    var requestBtnFont: UIFont { get }
    var changeRequestBtnName: ((String) -> Void)? { get }

}


class ContactsSearchTVCell: UITableViewCell {

    private var dataSource: ContactsSearchCellDataSource?
    private var delegate: ContactsSearchCellDelegate?
    
    // 头像ImgView && 名字Lab && 签名Lab && 请求添加好友Btn
    
    @IBOutlet weak var headView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    
    // 按钮响应
    @IBAction func requestAddFriend(sender: AnyObject) {
        
        delegate?.changeRequestBtnName?("name")
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        headView.layer.masksToBounds = true
        headView.layer.cornerRadius = 20
        nameLabel.textColor = UIColor(named: .ContactsName)
        introduceLabel.textColor = UIColor(named: .ContactsIntrouduce)
        
        let cellBgView = UIView()
        cellBgView.backgroundColor = UIColor(named: .ContactsCellSelect)
        self.selectedBackgroundView = cellBgView
        
    }

    func configure(dataSource: ContactsSearchCellDataSource, delegate: ContactsSearchCellDelegate?){
        
        self.dataSource = dataSource
        self.delegate = delegate
        
        self.nameLabel.text = dataSource.name
        self.introduceLabel.text = dataSource.introudce
        self.headView.image = dataSource.headImage
        self.requestBtn.setTitle(dataSource.requestBtnTitle, forState: .Normal)
        
    }

}
