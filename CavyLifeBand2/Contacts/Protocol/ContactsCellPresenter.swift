//
//  ContactsCellPresenter.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/9.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit

/**
 *  个人信息cell 协议
 */
protocol ContactsPersonInfoListCellPresenter {
    
    var title: String { get }
    var info: String { get }
    var infoTextColor: UIColor { get }
    var onClick: (Void -> Void)? { get }
    
}

/**
 *  个人信息带头像 cell  协议
 */
protocol ContactsPersonInfoCellPresenter {
    
    var title: String { get }
    var subTitle: String { get }
    var avatarUrl: String { get }
    var relation: PersonRelation { get }
    
}

protocol ContactsPersonInfoCellDelegate: class {
    func onClickHeadView()
}