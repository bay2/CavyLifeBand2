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
        rightBtn.setTitleColor(UIColor(named: .AColor), forState: .Normal)
        rightBtn.titleLabel?.font = UIFont.mediumSystemFontOfSize(14)
        rightBtn.frame = CGRectMake(0, 0, 60, 30)
        
        return rightBtn
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        allViewsLayOut()

//        updateViewStyle()
        
//        updateNavUI()
        
//        delegate?.onLoadView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViewStyle()
        
        delegate?.onLoadView()
    }
    
    deinit {
        Log.error("deinit GuideViewController")
    }
    
    func onLeftBtnBack() {
        
        delegate?.onCilckBack(self)
        
    }
    
    /**
     布局全部视图
     */
    func allViewsLayOut(){
        
        infoLabel.textColor = UIColor(named: .AColor)
        infoLabel.font = UIFont.systemFontOfSize(14)
        infoLabel.snp_makeConstraints { make -> Void in
            make.top.equalTo(self.view)
        }
        
        middleView.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(ez.screenWidth <= 320 ? -90 : -110)
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
        
        leftBtn?.hidden = dataSource?.hiddeBackBtn ?? false
        
        guard let viewDataSource = dataSource else {
            return
        }
        
        self.view.backgroundColor = viewDataSource.bgColor
        
        self.guideButton.hidden = viewDataSource.hiddeGuideBtn
        self.guideButton.setImage(viewDataSource.guideBtnImage, forState: .Normal)
        self.guideButton.setImage(viewDataSource.guideBtnHighLightImage, forState: .Highlighted)
        
        let centerView = viewDataSource.centerView
        middleView.setCornerRadius(radius: CavyDefine.commonCornerRadius)
        self.middleView.addSubview(centerView)
        
        self.infoLabel.text = dataSource?.subTitle
        navTitle = viewDataSource.title
        
        updateNavUI()
        
        rightBtn?.setTitle(viewDataSource.rightItemBtnTitle, forState: .Normal)
        centerView.snp_makeConstraints { make in
            make.left.top.right.bottom.equalTo(middleView)
        }
  
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

extension GuideViewController: LifeBandBleDelegate {
    
}

