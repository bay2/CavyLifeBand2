//
//  ChartBaseViewController.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import Realm
import RealmSwift
import JSONJoy
import Alamofire

class ChartBaseViewController: UIViewController, BaseViewControllerPresenter, ChartsRealmProtocol {
    
    
    var stepOldDeletData: ChartsForStep?

    
    
    var realm: Realm = try! Realm()
    var userId: String = "" 
    
    var viewStyle: ChartViewStyle = .StepChart

    /// 日 周 年 按钮
    var upperButtonArray: [ChartTimeButton] = [ChartTimeButton(selectIndex: 0), ChartTimeButton(selectIndex: 1), ChartTimeButton(selectIndex: 2)]
    
    /// ScrollView
    var scrollView = UIScrollView()
    
    lazy var leftBtn: UIButton? = {
        
        let leftItemBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        leftItemBtn.setBackgroundImage(UIImage(asset: .NavBack), forState: .Normal)
        return leftItemBtn
        
        
    }()
    
    lazy var rightBtn: UIButton? = {
        
        let rightItemBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        rightItemBtn.setBackgroundImage(UIImage(asset: .NavShare), forState: .Normal)
        return rightItemBtn
        
    }()
    
    var navTitle: String = ""
    
    // 懒加载数据
    private lazy var timeBucketDatasArray: [[NSDate]] = {
        
        let list = self.realm.objects(ChartStepDataRealm).filter("userId = '\(self.userId)'")
        
        var chartData: [[NSDate]] = []
        var dayDataArray: [NSDate] = []
        var weekDateArray: [NSDate] = []
        var monthDateArray: [NSDate] = []
        
        for i in 0 ... list.count {
            
            // 日 一个小时也 的时间段 一小时 6条 * 24 小时 = 一天的数据
            dayDataArray.append(list.first!.time!)
            // 余数
            var mod = 5
            
            if i / 6 == mod {
                
                dayDataArray.append(list[i].time!)
            }
            
            /// 周 的时间段
            
            weekDateArray.append(list.first!.time!)
            
            let index: Int = NSDate().indexInArray(list[i].time!)
            
            if  index != 0 {
                
                mod = (7 - (index + 1)) * 24 * 6
            }
            
            if i / (6 * 24 * 7) == mod {
                weekDateArray.append(list[i].time!)
            }
            
            // 月 的时间段
            dayDataArray.append(list.first!.time!)
            
            var monthArray: [String] = []
            
            monthArray.append(NSDate().dateChangeToMonthText(list.first!.time!))
            if  monthArray.contains("\(NSDate().dateChangeToMonthText(list[i].time!))") == false {
                
                dayDataArray.append(list[i].time!)
                
            }
            
        }
        
        chartData.append(dayDataArray)
        chartData.append(weekDateArray)
        chartData.append(monthDateArray)
        
        return chartData
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        parserData()
        
        allViewLayout()
        
        parserData()
        
    }
    
    /**
     配置VC的VM
     */
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
            
            
            stepOldDeletData = try ChartsForStep(JSONDecoder(data!))
            
        } catch {
            
            print("unable to parse the JSON")
            
        }
        
        
        // 先判断 有数据 直接返回 有没有数据 然后 请求数据
        if isExistChartsData() {
            
            return
        }
        
//        请求数据   添加到数据库
//        let urlString = ""
//        let request = Alamofire.request(.POST, urlString).responseJSON { (response) in
//            
//        }
        // 假设有啊
        let request1: [ChartStepDataRealm] = []
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            for date in request1 {
                
                self.addStepData(date)
            }
            
        }
        
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
            let timeBucketStyleArray = [TimeBucketStyle.Day, TimeBucketStyle.Week, TimeBucketStyle.Month]
            let detailView = ChartBaseView(frame: CGRectMake(ez.screenWidth  * CGFloat(i), 0, ez.screenWidth, ez.screenHeight - navHeight - timeButtonHeight))
            detailView.viewStyle = self.viewStyle
            detailView.timeBucketStyle = timeBucketStyleArray[i]
//            detailView.setData(timeBucketDatasArray[i])
            
            detailView.setOldDeletData(stepOldDeletData!.datas![i].stepCharts!)
            
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
        
        let shareView = ShareView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight))
        
        UIApplication.sharedApplication().keyWindow?.addSubview(shareView)
        
        
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