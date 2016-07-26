//
//  MenuProtocol.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/21.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

typealias MenuProtocol = protocol<MenuCellDateSource, MenuCellDelegate>

/**
 *  菜单组数据协议
 */
protocol MenuGroupDataSource {
    
    var items: [MenuProtocol] { get }
    
    var rowCount: Int { get }
    
    var sectionHeight: CGFloat { get }
    
    var sectionView: UIView { get }
    
    var titleColor: UIColor { get }
    
    
    mutating func refurbishNextView()
    
}

extension MenuGroupDataSource {
    
    var rowCount: Int {
        return items.count
    }
    
    mutating func refurbishNextView() {
        
    }
    
}

/**
 *  菜单项数据协议
 */
protocol MenuCellDateSource {
    
    var title: String { get }
    var icon: UIImage? { get }
    var cellHeight: CGFloat { get }
    var titleColor: UIColor { get }
    var titleFont: UIFont { get }
    
}

extension MenuCellDateSource {
    
    
    var titleFont: UIFont {
        
        let font = UIFont.mediumSystemFontOfSize(16)
       
        return font
        
    }
    
    var cellHeight: CGFloat {
        return 50
    }
    
}

/**
 *  菜单项代理协议
 */
protocol MenuCellDelegate {
    
    var nextView: UIViewController? { get set }
    func onClickCell()
    
}

extension MenuCellDelegate {
    
    func onClickCell() {
       
        guard let newNextView = nextView else {
            return
        }
        
        let userInfo = ["nextView": newNextView] as [NSObject: AnyObject]
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomePushView.rawValue, object: nil, userInfo: userInfo)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowHomeView.rawValue, object: nil)
        
    }
    
}

