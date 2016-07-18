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

/**
 *  添加好友cell数据源
 */
protocol ContactsAddFriendCellDataSource {
    
    var friendId: String { get }
    var headImageUrl: String { get }
    var name: String { get }
    var introudce: String { get }
    var bottonTitle: String { get }
    
}

/**
 *  添加好友cell代理
 */
protocol ContactsAddFriendCellDelegate {
    
    var nameTextColor: UIColor { get }
    var introductTextColor: UIColor { get }
    var nameFont: UIFont { get }
    var introduceFont: UIFont { get }
    var btnBGColor: UIColor { get }
    var btnFont: UIFont { get }
    
    func clickCellBtn(sender: UIButton) -> Void
    

}

class ContactsAddFriendCell: UITableViewCell {

    private var delegate: ContactsAddFriendCellDelegate?
    
    // 头像ImgView && 名字Lab && 签名Lab && 请求添加好友Btn
    
    @IBOutlet weak var headView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var requestBtn: UIButton!
    
    // 按钮响应
    @IBAction func requestAddFriend(sender: UIButton) {
        
        delegate?.clickCellBtn(sender)
        
    }
    
    override func awakeFromNib() {

        super.awakeFromNib()

        headView.roundSquareImage()
        headView.layer.borderWidth = 1
        headView.layer.borderColor = UIColor.whiteColor().CGColor
        
        nameLabel.textColor = UIColor(named: .EColor)
        nameLabel.font = UIFont.mediumSystemFontOfSize(16.0)
        
        introduceLabel.textColor = UIColor(named: .FColor)
        introduceLabel.font = UIFont.systemFontOfSize(12.0)
        
        requestBtn.setCornerRadius(radius: CavyDefine.commonCornerRadius)
        requestBtn.titleLabel?.font = UIFont.mediumSystemFontOfSize(16.0)
        requestBtn.titleLabel?.textColor = UIColor(named: .AColor)
        
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
        
        if dataSource.bottonTitle.isEmpty {
            self.requestBtn.hidden = true
        }

        self.requestBtn.setTitle(dataSource.bottonTitle, forState: .Normal)
        self.requestBtn.setBackgroundColor(delegate.btnBGColor, forState: .Normal)
        self.requestBtn.backgroundColor = delegate.btnBGColor

        self.labelLayout(dataSource)
        headView.af_setCircleImageWithURL(NSURL(string: dataSource.headImageUrl)!, placeholderImage: UIImage(asset: .DefaultHead_small))
        
    }

    
    /**
     label 布局
     
     - parameter dataSource: 数据
     */
    func labelLayout(dataSource: ContactsAddFriendCellDataSource) {

        if dataSource.introudce.isEmpty {

            self.nameLabel.snp_makeConstraints(closure: { make in
                make.centerY.equalTo(self)
            })

        } else {

            self.nameLabel.snp_makeConstraints(closure: { make in
                make.bottom.equalTo(self.headView.snp_centerY)
            })
            
            self.introduceLabel.snp_makeConstraints(closure: { make in
                make.top.equalTo(self.nameLabel.snp_bottom).offset(8)
            })
            
        }

    }

}

