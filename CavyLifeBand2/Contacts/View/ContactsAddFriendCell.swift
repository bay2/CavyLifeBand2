//
//  ContectSeachTVCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/17.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import SnapKit
import EZSwiftExtensions

protocol ContactsAddFriendCellDataSource {
    
    var headImageUrl: String { get }
    var name: String { get }
    var introudce: String { get }
    var requestBtnTitle: String { get }
    
}

protocol ContactsAddFriendCellDelegate {
    
    var nameTextColor: UIColor { get }
    var introductTextColor: UIColor { get }
    var nameFont: UIFont { get }
    var introduceFont: UIFont { get }
    var requestBtnColor: UIColor { get }
    var requestBtnFont: UIFont { get }
    var changeRequestBtnName: ((String) -> Void)? { get }
    

}


class ContactsAddFriendCell: UITableViewCell {

    private var delegate: ContactsAddFriendCellDelegate?
    
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

        headView.roundSquareImage()
        nameLabel.textColor = UIColor(named: .ContactsName)
        introduceLabel.textColor = UIColor(named: .ContactsIntrouduce)
        requestBtn.setCornerRadius(radius: CavyDefine.commonCornerRadius)
        
        let cellBgView = UIView()
        cellBgView.backgroundColor = UIColor(named: .ContactsCellSelect)
        self.selectedBackgroundView = cellBgView
        
    }

    /**
     配置cell
     
     - parameter dataSource: 数据
     - parameter delegate:   代理
     */
    func configure(dataSource: ContactsAddFriendCellDataSource, delegate: ContactsAddFriendCellDelegate) {
        
        self.delegate = delegate
        
        self.nameLabel.text = dataSource.name
        self.nameLabel.font = delegate.nameFont
        self.nameLabel.textColor = delegate.nameTextColor

        self.introduceLabel.text = dataSource.introudce
        self.introduceLabel.font = delegate.introduceFont
        self.introduceLabel.textColor = delegate.introductTextColor


        self.requestBtn.setTitle(dataSource.requestBtnTitle, forState: .Normal)
        self.requestBtn.backgroundColor = delegate.requestBtnColor
        headView.af_setImageWithURL(NSURL(string: dataSource.headImageUrl)!)

        self.labelLayout(dataSource)
        

    }

    
    /**
     label 布局
     
     - parameter dataSource: 数据
     */
    func labelLayout(dataSource: ContactsAddFriendCellDataSource) {

        if dataSource.introudce.isEmpty {

            self.nameLabel.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(self)
            })

        } else {

            self.nameLabel.snp_makeConstraints(closure: { (make) in
                make.bottom.equalTo(self.headView.snp_centerY)
            })
            
            self.introduceLabel.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(self.nameLabel.snp_bottom).offset(8)
            })
            
        }

    }

}

