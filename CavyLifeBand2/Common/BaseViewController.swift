//
//  BaseViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

/*
 使用说明:
 1.集成BaseViewControllerPresenter
 2.定义navTitle —— title字符串
 3.调用updateNavUI
 override func viewDidLoad() {
 
 super.viewDidLoad()
 
 self.updateNavUI()
 
 ......
 
 }
 
 */
protocol BaseViewControllerPresenter {
    
    //title 名
    var navTitle: String { get }
    
    func onClickBack()
    func updateNavUI()
    
}

extension BaseViewControllerPresenter where Self: UIViewController {
    
    /**
     更新导航栏UI
     */
    func updateNavUI() {
        
        configNavBar()
        configNavItem()
        
    }
    
    /**
     配置Item
     */
    func configNavItem() {
        
        let backBtn = UIButton(type: .System)
        backBtn.addTapGesture { _ in
            self.onClickBack()
        }
        
        backBtn.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
        
        backBtn.frame = CGRectMake(0, 0, 30, 30)
        let backButtonItem = UIBarButtonItem(customView: backBtn)
        let spacingBtnItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacingBtnItem.width = 14
        
        self.navigationItem.leftBarButtonItems = [spacingBtnItem, backButtonItem]
        
    }
    
    /**
     配置bar
     */
    func configNavBar() {
        
        self.navBar?.shadowImage = UIImage.imageWithColor(UIColor(named: .HomeViewMainColor), size: CGSizeMake(ez.screenWidth, 1))
        self.navBar?.setBackgroundImage(UIImage.imageWithColor(UIColor(named: .HomeViewMainColor), size: CGSizeMake(ez.screenWidth, 64)), forBarPosition: .Any, barMetrics: .Default)
        
        let titleLable = UILabel(frame: CGRectMake(0, 0, 60, 44))
        titleLable.text = navTitle
        titleLable.textColor = UIColor(named: .ContactsTitleColor)
        titleLable.font = UIFont.systemFontOfSize(18)
        
        self.navigationItem.titleView = titleLable
    }
    
    /**
     返回按钮处理
     */
    func onClickBack() {
        
        self.popVC()
        
    }
    
}
