//
//  ContactsPersonInfoCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

/**
 联系人关系
 
 - OwnRelation:      自己
 - FriendRelation:   朋友
 - StrangerRelation: 陌生人
 */
enum PersonRelation{
    
    case OwnRelation
    case FriendRelation
    case StrangerRelation
}


class ContactsPersonInfoCell: UITableViewCell {

    
    /// 头像
    @IBOutlet weak var headView: UIImageView!
    
    /// 上面的Lable
    @IBOutlet weak var titleLab: UILabel!
    
    // 编辑图标
    @IBOutlet weak var editImage: UIImageView!
    
    /// 徽章
    @IBOutlet weak var badgeView: UIImageView!
    
    /// 下面的Label
    @IBOutlet weak var subTitleLab: UILabel!
    
    /// 分割线
    @IBOutlet weak var lineView: UIView!
    
    weak var delegate: ContactsPersonInfoCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        headView.roundSquareImage()
        titleLab.textColor = UIColor(named: .EColor)
        subTitleLab.textColor = UIColor(named: .FColor)
        
        titleLab.font = UIFont.mediumSystemFontOfSize(18.0)
        subTitleLab.font = UIFont.mediumSystemFontOfSize(12.0)
        
        lineView.backgroundColor = UIColor(named: .LColor)
        self.selectionStyle = .None
        
        headView.addTapGesture {[unowned self] _ in
            
            self.delegate?.onClickHeadView()
            
        }
        
    }
    
    func configCell(datasource: ContactsPersonInfoCellPresenter, delegate: ContactsPersonInfoCellDelegate) {
        
        headView.af_setCircleImageWithURL(NSURL(string: datasource.avatarUrl)!, placeholderImage: UIImage(asset: .DefaultHead_small))
        
        /**
         如果备注名称为空字符串则主标题显示用户昵称，副标题为空字符串；
         反之主标题显示备注，副标题显示用户昵称
         */
        if datasource.title == "" {
            titleLab.text = datasource.subTitle
            
            subTitleLab.text = ""
        } else {
            titleLab.text = datasource.title
            
            subTitleLab.text = datasource.subTitle
        }
                
        personRealtion(datasource.relation)
        
        self.delegate = delegate
        
    }

    /**
     不同页面的不同视图
     */
    func personRealtion(relation: PersonRelation) {
                
        switch relation {
            
        case .OwnRelation:
            
            // 自己的账户信息
            editImage.hidden = false
            badgeView.hidden = true
            
            subTitleLab.snp_makeConstraints(closure: { make -> Void in
                make.left.equalTo(badgeView)
            })
            
        case .FriendRelation:
            
            // 朋友的信息
            subTitleLab.snp_makeConstraints(closure: { make -> Void in
                make.left.equalTo(badgeView).offset(24)
            })
            
            
        case .StrangerRelation:
            
            // 陌生人的信息
            subTitleLab.hidden = true
            subTitleLab.snp_makeConstraints(closure: { make -> Void in
                make.left.equalTo(badgeView).offset(24)
            })
            
        }
        
    }
    
    
    
    /**
     查看别人信息页面的cell
     
     - parameter headImage: 头像
     - parameter badgeOrNot: 是否获得勋章
     - parameter notesName: 备注名字
     - parameter nickName:  昵称
     */
    func addPersonData(headImage: UIImage, badgeOrNot: Bool, notesName: String, nickName: String) {
        
        headView.image = headImage
        titleLab.text = notesName
        subTitleLab.text = nickName
        
        if badgeOrNot {
            badgeView.image = UIImage(asset: .GuidePairSeccuss)
        }else {
            badgeView.image = UIImage(asset: .GuidePairFail)

        }
        
    }
    
    /**
     自己账户信息页面的cell
     
     - parameter nickName:    昵称
     - parameter accountName: 账户名称
     */
    func addAccountData(nickName: String, accountName: String) {
        
        titleLab.text = nickName
        subTitleLab.text = accountName
   
    }
    
    /**
     编辑个人信息
     
     - parameter sender:
     */
    @IBAction func editAction(sender: AnyObject) {
        
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

struct ContactsFriendInfoCellDS: ContactsPersonInfoCellPresenter {
    
    var title: String
    
    var subTitle: String
    
    var avatarUrl: String
    
    var relation: PersonRelation = .FriendRelation
    
    init(model: ContactPsersonInfoResponse? = nil, nickName: String) {
        
        title = model?.remark ?? ""
        
        avatarUrl = model?.avatarUrl ?? ""
        
        subTitle = nickName
        
    }
    
}

struct ContactsStrangerInfoCellDS: ContactsPersonInfoCellPresenter {
    
    var title: String
    
    var subTitle: String = ""
    
    var avatarUrl: String
    
    var relation: PersonRelation = .FriendRelation
    
    init(model: ContactPsersonInfoResponse? = nil, nickName: String) {
        
        title = nickName
        
        avatarUrl = model?.avatarUrl ?? ""
        
    }
    
}

