//
//  GuideViewController.swift
//  CavyLifeBand2
//
//  Created by 李艳楠 on 16/3/1.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SnapKit
import Gifu


class GuideViewController: UIViewController, BaseViewControllerPresenter {
    
    var dataSource: GuideViewDataSource?
    var delegate: GuideViewDelegate?
    
    /// 大标题详情
    @IBOutlet weak var infoLabel: UILabel!
    
    /// 中间底视图
    @IBOutlet weak var middleView: UIView!
    
    /// 确定按钮
    @IBOutlet weak var guideButton: UIButton!
    
    var navTitle: String = ""
    
    var leftBtn: UIButton? = {
        
        let leftItemBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        leftItemBtn.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
        return leftItemBtn
        
    }()
    
    var rightBtn: UIButton? = {
        
        let rightBtn = UIButton(type: .System)
        rightBtn.setTitleColor(UIColor(named: .SignInMainTextColor), forState: .Normal)
        rightBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        rightBtn.frame = CGRectMake(0, 0, 60, 30)
        
        return rightBtn
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allViewsLayOut()

        updateViewStyle()
        
        updateNavUI()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        updateNavUI()
        
    }
    
    deinit {
        Log.error("deinit GuideViewController")
    }
    
    func onLeftBtnBack() {
        
        if self.navigationController?.viewControllers.count > 1 {
            self.popVC()
        } else {
            self.dismissVC(completion: nil)
        }
        
    }
    
    /**
     布局全部视图
     */
    func allViewsLayOut(){
        
        infoLabel.textColor = UIColor(named: .GuideColor66)
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
        }
        
    }
    
    /**
     配置视图
     
     - parameter dataSource:
     */
    func configView(dataSource: GuideViewDataSource, delegate: GuideViewDelegate) {
        
        self.dataSource = dataSource
        self.delegate = delegate
        
    }
    
    /**
     更新视图风格
     */
    func updateViewStyle() {
        
        guard let viewDataSource = dataSource else {
            return
        }
        
        self.view.backgroundColor = viewDataSource.bgColor
        self.guideButton.setImage(viewDataSource.guideBtnImage, forState: .Normal)
        self.guideButton.setImage(viewDataSource.guideBtnImagePress, forState: .Highlighted)
        self.middleView.addSubview(viewDataSource.centerView)
        
        self.infoLabel.text = dataSource?.subTitle
        navTitle = viewDataSource.title
        rightBtn?.setTitle(viewDataSource.rightItemBtnTitle, forState: .Normal)
  
    }
   
    func onRightBtn() {
        
        delegate?.onClickRight(self)
        
    }
    
    /**
     中间按钮事件
     */
    @IBAction func guideBtnClick(sender: AnyObject) {
        
        delegate?.onClickGuideOkBtn(self)
        
    }
    
}

