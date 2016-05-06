//
//  ChartBaseViewController.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import JSONJoy

let dayTime           = ["00:00", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
let dayData: [Double] = [0.1, 0, 0, 0, 0, 0.3, 0, 1, 1, 2, 1.2, 1, 1.5, 1, 2.4, 0, 0, 0.3, 0, 1.3, 2.5, 0, 0, 0]


class ChartBaseViewController: UIViewController, BaseViewControllerPresenter{
    
    var viewStyle: ChartViewStyle = .StepChart
    var stepData: ChartsForStep?
    
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

        parserData()
        
        allViewLayout()
        
        parserData()
        
    }
    
    func configChartBaseView(dataSource: ChartViewProtocol) {
        
        navTitle = dataSource.title
        viewStyle = dataSource.chartStyle
        
        self.updateNavUI()
        
    }
    
    /**
     解析数据 加到数据库
     */
    func parserData() {
        
        let path = NSBundle.mainBundle().pathForResource("Charts", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        
        do {
            
            stepData = try ChartsForStep(JSONDecoder(data!))
            
        } catch {
            
            print("unable to parse the JSON")
            
        }
        
        // 添加到数据库
        
        
        
        
        
        
        
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
        scrollView.backgroundColor = UIColor.clearColor()
        
        for i in 0 ..< 3 {
            let detailView = ChartBaseView(frame: CGRectMake(ez.screenWidth  * CGFloat(i), 0, ez.screenWidth, ez.screenHeight - navHeight - timeButtonHeight))
            detailView.viewStyle = self.viewStyle
            detailView.setData(stepData!.datas![i].stepCharts!)
            scrollView.addSubview(detailView)
        }
        
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