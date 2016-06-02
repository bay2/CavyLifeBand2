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
    
    var realm: Realm = try! Realm()
    var userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    var viewStyle: ChartViewStyle = .StepChart

    /// 日 周 年 按钮
    var upperButtonArray: [ChartTimeButton] = [ChartTimeButton(selectIndex: 0), ChartTimeButton(selectIndex: 1), ChartTimeButton(selectIndex: 2)]
    
    /// ScrollView
    var scrollView = UIScrollView()
    
    lazy var leftBtn: UIButton? = {
        
        let leftItemBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        leftItemBtn.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
        return leftItemBtn
        
    }()
    
    lazy var rightBtn: UIButton? = {
        
        let rightItemBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        rightItemBtn.setBackgroundImage(UIImage(asset: .NavShare), forState: .Normal)
        return rightItemBtn
        
    }()
    
    var navTitle: String = ""

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allViewLayout()
        
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
            detailView.configView()
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
    
    // MARK: 分享
    /**
     分享
     */
    func onRightBtn() {
        
        clipImage()
        
        let shareView = ShareView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight))
        
        UIApplication.sharedApplication().keyWindow?.addSubview(shareView)
                
    }
    
    /**
     截图
     
     - returns: UIImage
     */
    func clipImage() {
        
        UIGraphicsBeginImageContextWithOptions(self.view.size, false, 0);
        
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        image.writeToChacheDocument(CavyDefine.shareImageName)
        
    }
    
}

// MARK: UIScrollViewDelegate
extension ChartBaseViewController: UIScrollViewDelegate {
    
    // 停止拖拽
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
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
