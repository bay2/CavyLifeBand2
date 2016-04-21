//
//  RightMenuViewModel.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/21.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit
import EZSwiftExtensions

/**
 *  菜单项 view model
 */
struct MenuViewModel: MenuProtocol {
    
    var title: String
    var icon: UIImage?
    var nextView: UIViewController
    
    init(icon: UIImage? = nil, title: String, nextView: UIViewController) {
        
        self.icon = icon
        self.title = title
        self.nextView = nextView
        
    }
    
}

/**
 *  手环功能菜单项
 */
struct BandFeatureMenuGroupDataModel: MenuGroupDataSource {
    
    var items: [MenuProtocol] = []
    var sectionView: UIView = UIView()
    var sectionHeight: CGFloat = 16
    
    init() {
        
        items.append(MenuViewModel(icon: UIImage(asset: .RightMenuCamera),
            title: L10n.HomeRightListTitleCamera.string,
            nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()))
        
        items.append(MenuViewModel(icon: UIImage(asset: .RightMenuNotice),
            title: L10n.HomeRightListTitleNotification.string,
            nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()))
        
        items.append(MenuViewModel(icon: UIImage(asset: .RightMenuAlarmClock),
            title: L10n.HomeRightListTitleAlarmClock.string,
            nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()))
        
        items.append(MenuViewModel(icon: UIImage(asset: .RightMenuSecurity),
            title: L10n.HomeRightListTitleSecurity.string,
            nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()))
        
    }
    
}

/**
 *  手环硬件相关菜单项
 */
struct BandHardwareMenuGroupDataModel: MenuGroupDataSource {
    
    var items: [MenuProtocol] = []
    var sectionView: UIView = LeftHeaderView(frame: CGRectMake(0, 0, ez.screenWidth, 20))
    var sectionHeight: CGFloat = 10
    
    init() {
        
        items.append(MenuViewModel(title: L10n.HomeRightListTitleFirmwareUpgrade.string,
            nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()))
        
    }
    
}

/**
 *  手环绑定相关菜单项
 */
struct BindingBandMenuGroupDataModel: MenuGroupDataSource {
    
    var items: [MenuProtocol] = []
    var sectionView: UIView = LeftHeaderView(frame: CGRectMake(0, 0, ez.screenWidth, 20))
    var sectionHeight: CGFloat = 10
    
    init() {
        
        items.append(MenuViewModel(title: L10n.HomeRightListTitleBindingBand.string,
            nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()))
        
    }
    
}