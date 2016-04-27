//
//  HomeStepDetailVC.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/26.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class HomeStepDetailVC: UIViewController, BaseViewControllerPresenter, UIScrollViewDelegate {
    
    /// 日 周 年 索引
    var upperButtonArray: [HomeDetailTimeButton] = [HomeDetailTimeButton(selectIndex: 0), HomeDetailTimeButton(selectIndex: 1), HomeDetailTimeButton(selectIndex: 2)]
    
    /// ScrollView
    var scrollView = UIScrollView()
    

    lazy var leftBtn: UIButton? = {

        let leftItemBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        leftItemBtn.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
        return leftItemBtn
        
        
    }()
    
    lazy var rightBtn: UIButton? = {
        
        let button = UIButton(frame: CGRectMake(0, 0, 60, 30))
        button.setTitle("分享", forState: .Normal)
        return button

    }()
    
    var navTitle: String = "计步"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: .HomeDetailBackground)
        
        self.updateNavUI()
        
        allViewLayout()
        
    }
    
    /**
     所有视图的布局
     */
    func allViewLayout() {
        
        /**
         周日年
         */
      
        
        for i in 0 ..< 3 {
            
            let button = upperButtonArray[i]
            button.frame = CGRectMake(ez.screenWidth / 3 * CGFloat(i), 0, ez.screenWidth / 3, 50)
            button.addTarget(self, action: #selector(changeButtonStatus(_:)), forControlEvents: .TouchUpInside)
            self.view.addSubview(button)
        }
        upperButtonArray[0].selectStatus()
        
        self.view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(50)
            make.left.right.bottom.equalTo(self.view)
        }
        scrollView.contentSize = CGSizeMake(ez.screenWidth * 3, 0)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.whiteColor()
        
        for i in 0 ..< 3 {
            let detailView = HomeDetailStepView(frame: CGRectMake(ez.screenWidth  * CGFloat(i), 0, ez.screenWidth, self.scrollView.frame.size.height))
        scrollView.addSubview(detailView)
        }
   
    }
    
    
    
    /**
     更改 年月日按钮状态
     */
    func changeButtonStatus(button: UIButton) {
        
        
        let index = (button as! HomeDetailTimeButton).selectedIndex
        
        changeButtonStatusWithIndex(index)
       
    }
    
    func changeButtonStatusWithIndex(index: Int) {
        
        let _ = upperButtonArray.map {
            $0.deselectStatus()
        }
        
        upperButtonArray[index].selectStatus()
        
        scrollView.setContentOffset(CGPointMake(ez.screenWidth * CGFloat(index), 0), animated: true)
    }
    
    /**
     分享
     */
    func onRightBtn() {
         Log.info("分享")
    }
    
    
    // MARK: --UIScrollViewDelegate
    
    // 停止拖拽
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        scrollViewEndAction(scrollView)
        
    }
    
    // 滑动拖拽
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        scrollViewEndAction(scrollView)
        
    }

    /**
     滑动结束事件
     */
    func scrollViewEndAction(scrollView: UIScrollView) {
        
        let count = Int(scrollView.contentOffset.x / ez.screenWidth)
        
        changeButtonStatusWithIndex(count)
        
    }

    
    
    
}
