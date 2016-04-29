//
//  ChartBaseViewController.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ChartBaseViewController: UIViewController, BaseViewControllerPresenter{
    
    var viewStyle: ChartViewStyle = .StepChart
    
    /// 日 周 年 索引
    var upperButtonArray: [ChartTimeButton] = [ChartTimeButton(selectIndex: 0), ChartTimeButton(selectIndex: 1), ChartTimeButton(selectIndex: 2)]
    
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
    
    var navTitle: String = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()

        allViewLayout()
        
        parserData()
        
    }
    
    func configChartBaseView(dataSource: ChartViewProtocol) {
        
        navTitle = dataSource.title
        viewStyle = dataSource.chartStyle
        
        self.updateNavUI()
        
    }
    
    /**
     所有视图的布局
     */
    func allViewLayout() {
        
        self.view.backgroundColor = UIColor(named: .ChartBackground)
        
        // 周日年
        for i in 0 ..< 3 {
            
            let button = upperButtonArray[i]
            button.frame = CGRectMake(ez.screenWidth / 3 * CGFloat(i), 0, timeButtonWidth, timeButtonHeight)
            button.addTarget(self, action: #selector(changeButtonStatus(_:)), forControlEvents: .TouchUpInside)
            self.view.addSubview(button)
        }
        upperButtonArray[0].selectStatus()
        
        self.view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(timeButtonHeight)
            make.left.right.bottom.equalTo(self.view)
        }
        scrollView.backgroundColor = UIColor(named: .ChartBackground)
        scrollView.contentSize = CGSizeMake(ez.screenWidth * 3, 0)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.whiteColor()
        
        for i in 0 ..< 3 {
            let detailView = ChartBaseView(frame: CGRectMake(ez.screenWidth  * CGFloat(i), 0, ez.screenWidth, ez.screenHeight - navHeight - timeButtonHeight))
            scrollView.addSubview(detailView)
        }
        
    }
    
    /**
     解析数据 加到数据库
     */
    func parserData() {
        
        
        let arrayDay = ["4.18","4.19","4.20","4.21","4.22","4.23","4.24","4.25","4.26","4.27","4.28","4.29"]
        let arrayWeak = ["3.15-21","3.22-29","4.1-7","4.8-14","4.15-21","4.22-29"]
        let arrayMonths = ["11","12","1","2","3","4"]
        
        
        
        
    }
    
    
    /**
     更改 年月日按钮状态
     */
    func changeButtonStatus(button: UIButton) {
        
        let index = (button as! ChartTimeButton).selectedIndex
        changeButtonStatusWithIndex(index)
        
    }
    
    /**
     更改按钮状态
     */
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
    

}

// MARK: --UIScrollViewDelegate
extension ChartBaseViewController: UIScrollViewDelegate {
    
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