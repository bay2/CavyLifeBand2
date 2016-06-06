//
//  UserViewControllerPresentable.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/5.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

protocol UserViewControllerPresentable {
    
    func onClickBackBtn()
    func onClickRightBtn()
    func updateNavigationItemUI(title: String, isNeedBack: Bool, rightBtnTitle: String)
    func updateUI(textFieldView: UIView)
    
}

extension UserViewControllerPresentable where Self: UIViewController {
    
    
    func updateNavigationItemUI(title: String = "", isNeedBack: Bool = true, rightBtnTitle: String = "") {
        
        let navItemView = UIView()
        
        self.navigationController?.navigationBarHidden = true
        
        self.view.addSubview(navItemView)
        navItemView.snp_makeConstraints { make -> Void in
            make.height.equalTo(CavyDefine.spacingWidth25 * 8)
            make.top.right.left.equalTo(self.view)
        }
        
        addTitleLabel(navItemView, title: title)
        
        addBackBtn(navItemView, isNeedBack: isNeedBack)
        
        addRightBtn(navItemView, title: rightBtnTitle)
            
        
    }
    
    func updateUI(textFieldView: UIView) {
        
        self.view.backgroundColor = UIColor(named: .SignInBackground)
        self.automaticallyAdjustsScrollViewInsets = false
        textFieldView.backgroundColor = UIColor.whiteColor()
        textFieldView.layer.cornerRadius = CavyDefine.commonCornerRadius
        
    }
    
    /**
     添加title label
     
     - parameter navItemView:
     */
    func addTitleLabel(navItemView: UIView, title: String) {
        
        let titleLeb = UILabel()
        
        titleLeb.text = title
        titleLeb.textColor = UIColor(named: .SignInMainTextColor)
        titleLeb.font = UIFont.systemFontOfSize(22)
        navItemView.addSubview(titleLeb)
        titleLeb.snp_makeConstraints { make -> Void in
            make.centerY.equalTo(navItemView)
            make.centerX.equalTo(navItemView)
        }
        
    }
    
    /**
     添加返回按钮
     
     - parameter navItemView:
     */
    func addBackBtn(navItemView: UIView, isNeedBack: Bool) {
        
        guard isNeedBack else {
            return
        }
        
        let backBtn = UIButton()
        
        backBtn.frame = CGRectMake(0, 0, 30, 30)
        backBtn.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
        
        backBtn.addTapGesture { [weak self]  _ in
            self?.onClickBackBtn()
        }
        
        navItemView.addSubview(backBtn)
        backBtn.snp_makeConstraints { make -> Void in
            make.left.equalTo(CavyDefine.spacingWidth25 * 2)
            make.centerY.equalTo(navItemView)
        }
        
        
    }
    
    /**
     添加右侧按钮
     
     - parameter navItemView:
     */
    func addRightBtn(navItemView: UIView, title: String = "") {
        
        let rightBtn = UIButton()
        
        rightBtn.setTitle(title, forState: .Normal)
        rightBtn.frame = CGRectMake(0, 0, 60, 30)
        rightBtn.setTitleColor(UIColor(named: .AColor), forState: .Normal)
        rightBtn.addTapGesture { [unowned self]  _ in
            self.onClickRightBtn()
        }
        
        navItemView.addSubview(rightBtn)
        rightBtn.snp_makeConstraints { make -> Void in
            make.right.equalTo(-(CavyDefine.spacingWidth25 * 2))
            make.centerY.equalTo(navItemView)
        }
        
    }
    
    /**
     返回按钮点击事件
     */
    func onClickBackBtn() {
        
        self.popVC()
        self.dismissVC(completion: nil)
    }
    
    /**
     右侧按钮点击事件
     */
    func onClickRightBtn() { }
    
}
