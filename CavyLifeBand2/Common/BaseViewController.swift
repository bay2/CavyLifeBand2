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
    var leftBtn: UIButton? { get }
    var rightBtn: UIButton? { get }
    
    func onRightBtn()
    func onLeftBtnBack()
    func updateNavUI()
    func configNavBar()
    func configNavItem()
    
    var barBgColor: UIColor { get }
    
}

extension BaseViewControllerPresenter where Self: UIViewController {
    
    var leftBtn: UIButton? {
        return nil
    }
    
    var rightBtn: UIButton? {
        return nil
    }
    
    var barBgColor: UIColor {
        return UIColor(named: .HomeViewMainColor)
    }
    
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
        
        let spacingBtnItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacingBtnItem.width = 14
        
        self.navigationController?.navigationBarHidden = false
        
        if leftBtn == nil && self.navigationController?.viewControllers.count > 1 {
            
            let leftItemBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
            leftItemBtn.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
            leftItemBtn.addTapGesture { [unowned self] _ in
                self.onLeftBtnBack()
            }
            
            let backButtonItem = UIBarButtonItem(customView: leftItemBtn)
            self.navigationItem.leftBarButtonItems = [backButtonItem]
        
        } else if let leftItemBtn = leftBtn {
            
            leftItemBtn.frame = CGRectMake(0, 0, 30, 30)
            
            leftItemBtn.addTapGesture { [unowned self] _ in
                self.onLeftBtnBack()
            }
            
            let backButtonItem = UIBarButtonItem(customView: leftItemBtn)
            self.navigationItem.leftBarButtonItems = [backButtonItem]
            
        }
        
        guard let rightItemBtn = rightBtn else {
            return
        }
        
        rightItemBtn.addTapGesture { [unowned self] _ in
            self.onRightBtn()
        }
        
        let rightButtonItem = UIBarButtonItem(customView: rightItemBtn)
        self.navigationItem.rightBarButtonItems = [rightButtonItem, spacingBtnItem]
    
    }
    
    /**
     配置bar
     */
    func configNavBar() {
        
        
        self.navBar?.shadowImage = UIImage.imageWithColor(barBgColor, size: CGSizeMake(ez.screenWidth, 1))
        self.navBar?.setBackgroundImage(UIImage.imageWithColor(barBgColor, size: CGSizeMake(ez.screenWidth, 64)), forBarPosition: .Any, barMetrics: .Default)
        
        let titleLable = UILabel(frame: CGRectMake(0, 0, 60, 44))
        titleLable.text = navTitle
        titleLable.textAlignment = .Center
        titleLable.textColor = UIColor(named: .AColor)
        
        titleLable.font = UIFont.mediumSystemFontOfSize(18)
        
        self.navigationItem.titleView = titleLable
    }
    
    /**
     返回按钮处理
     */
    func onLeftBtnBack() {
        
        self.popVC()
        
    }
    
    /**
     点击右侧按钮
     */
    func onRightBtn() { }
    
}
