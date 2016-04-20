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


class GuideViewController: UIViewController, UserViewControllerPresentable {
    
    var dataSource: GuideViewDataSource?
    var delegate: GuideViewDelegate?
    
    /// 大标题详情
    @IBOutlet weak var infoLabel: UILabel!
    
    /// 中间底视图
    @IBOutlet weak var middleView: UIView!
    
    /// 确定按钮
    @IBOutlet weak var guideButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allViewsLayOut()

        updateViewStyle()
        
    }
    
    deinit {
        Log.error("deinit GuideViewController")
    }
    
    /**
     布局全部视图
     */
    func allViewsLayOut(){
        
        infoLabel.textColor = UIColor(named: .GuideColor66)
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(ez.screenWidth * 0.2 + 11)
        }
        
        middleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(ez.screenWidth * 0.32)
        }
        
        guideButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(ez.screenWidth * 1.32)
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
        self.updateNavigationItemUI(viewDataSource.title, rightBtnTitle: viewDataSource.rightItemBtnTitle)
        self.middleView.addSubview(viewDataSource.centerView)
        self.infoLabel.text = dataSource?.subTitle
  
    }
   
    func onClickRightBtn() {
        
        delegate?.onClickRight(self)
        
    }
    
    /**
     中间按钮事件
     */
    @IBAction func guideBtnClick(sender: AnyObject) {
        
        delegate?.onClickGuideOkBtn(self)
        
    }
    
}

