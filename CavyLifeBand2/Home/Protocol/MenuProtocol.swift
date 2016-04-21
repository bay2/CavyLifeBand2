//
//  MenuProtocol.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/21.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

typealias MenuProtocol = protocol<MenuCellDateSource, MenuCellDelegate, MenuPushViewDelegate>

/**
 *  菜单组数据协议
 */
protocol MenuGroupDataSource {
    
    var items: [MenuProtocol] { get }
    
    var rowCount: Int { get }
    
    var sectionHeight: CGFloat { get }
    
    var sectionView: UIView { get }
}

extension MenuGroupDataSource {
    
    var rowCount: Int {
        return items.count
    }
    
}


protocol MenuPushViewDelegate {
    
    var nextView: UIViewController { get }
    
    func pushView()
    
}

extension MenuPushViewDelegate {
    
    func pushView() {
        
        let userInfo = ["nextView": self.nextView] as [NSObject: AnyObject]
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomePushView.rawValue, object: nil, userInfo: userInfo)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowHomeView.rawValue, object: nil)
        
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
    
    var titleColor: UIColor {
        return UIColor.whiteColor()
    }
    
    var titleFont: UIFont {
        
        let font = UIFont.systemFontOfSize(16)
        font.fontWithSize(0.23)
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
    
    var nextView: UIViewController { get }
    
}

