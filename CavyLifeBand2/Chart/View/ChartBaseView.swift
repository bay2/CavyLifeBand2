//
//  HomeDeatilBaseView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ChartBaseView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var viewStyle: ChartViewStyle = .StepChart

    var timeBucketStyle: TimeBucketStyle = .Day
    
    /// 时间间隔选择
    var timeView: UICollectionView?
    
    /// 详情页
    var infoView: UICollectionView?
    
    var datas: [NSDate] = []
    
    var oldDeletDatas: [StepCharts] = []

    func setOldDeletData(datas: [StepCharts]) {
        
        self.oldDeletDatas = datas
        
        addTimeBucketView()
        
        addInfoView()
    }
    
    
    /**
     添加数据
     */
    func setData(datas: [NSDate]) {
        
        self.datas = datas
        
        addTimeBucketView()
        
        addInfoView()
    }
    
    
    // 添加时间段的视图
    func addTimeBucketView() {
        
        self.backgroundColor = UIColor(named: .ChartBackground)
        
        // 标记背景图片 70 * 30
        let timeFlagView = UIView()
        timeFlagView.layer.masksToBounds = true
        timeFlagView.layer.cornerRadius = 15
        timeFlagView.backgroundColor = UIColor(named: .HomeViewMainColor)
        self.addSubview(timeFlagView)
        timeFlagView.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.size.equalTo(CGSizeMake(70, 30))
            make.top.equalTo(self).offset((timeButtonHeight - 30) / 2)
        }
        
        // 时间段CollectionView
        let timeLayout = UICollectionViewFlowLayout()
        timeLayout.itemSize = CGSizeMake(timeButtonWidth, timeButtonHeight)
        timeLayout.scrollDirection = .Horizontal
        timeLayout.minimumLineSpacing = 0
        let inset = ez.screenWidth  * 0.5 - timeButtonWidth * 0.5
        timeLayout.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
        
        // 上面的CollectionView
        timeView = UICollectionView(frame: CGRectMake(0, 0, ez.screenWidth, timeButtonHeight), collectionViewLayout: timeLayout)
        timeView!.backgroundColor = UIColor.clearColor()
        timeView!.alwaysBounceHorizontal = true
        timeView!.showsHorizontalScrollIndicator = false
        timeView!.contentSize = CGSizeMake(CGFloat(oldDeletDatas.count - 1) * timeButtonWidth, timeButtonHeight)
        timeView!.contentOffset = CGPointMake(CGFloat(oldDeletDatas.count - 1) * timeButtonWidth, timeButtonHeight)
//        timeView!.contentSize = CGSizeMake(CGFloat(datas.count - 1) * timeButtonWidth, timeButtonHeight)
//        timeView!.contentOffset = CGPointMake(CGFloat(datas.count - 1) * timeButtonWidth, timeButtonHeight)
        timeView!.dataSource = self
        timeView!.delegate = self
        timeView!.registerClass(ChartTimeCollectionCell.self, forCellWithReuseIdentifier: "ChartTimeCollectionCell")
        self.addSubview(timeView!)
        timeView!.snp_makeConstraints { make in
            make.left.right.top.equalTo(self)
            make.height.equalTo(timeButtonHeight)
        }
      
    }
    
    // 添加详情页面
    func addInfoView() {
        
        var infoViewHeight: CGFloat = 0
        
        switch viewStyle {
            
        case .SleepChart:

            infoViewHeight  = chartViewHight + listcellHight * 3 + 20
            
        case .StepChart:
            
            infoViewHeight = chartViewHight + listcellHight * 4 + 20
        }
        
        // 详情的CollectionView
        let timeLayout = UICollectionViewFlowLayout()
        timeLayout.itemSize = CGSizeMake(ez.screenWidth, infoViewHeight)
        timeLayout.scrollDirection = .Horizontal
        timeLayout.minimumLineSpacing = 0
        timeLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        infoView = UICollectionView(frame: CGRectMake(0, 0, ez.screenWidth, infoViewHeight), collectionViewLayout: timeLayout)
        infoView!.backgroundColor = UIColor(named: .ChartBackground)
        infoView!.alwaysBounceHorizontal = true
        infoView!.showsHorizontalScrollIndicator = false
        infoView!.contentSize = CGSizeMake(CGFloat(oldDeletDatas.count) * ez.screenWidth, timeButtonHeight)
        infoView!.contentOffset = CGPointMake(CGFloat(oldDeletDatas.count) * ez.screenWidth, timeButtonHeight)
//        infoView!.contentSize = CGSizeMake(CGFloat(datas.count) * ez.screenWidth, timeButtonHeight)
//        infoView!.contentOffset = CGPointMake(CGFloat(datas.count) * ez.screenWidth, timeButtonHeight)
        infoView!.dataSource = self
        infoView!.delegate = self
        infoView!.scrollEnabled = false
        infoView!.registerClass(ChartInfoCollectionCell.self, forCellWithReuseIdentifier: "ChartInfoCollectionCell")
        self.addSubview(infoView!)
        infoView!.snp_makeConstraints { make in
            make.top.equalTo(timeView!).offset(timeButtonHeight)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: ez.screenWidth, height: infoViewHeight))
        }

    }
    
    // MARK: -- collectionView Delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        return datas.count
        
        return oldDeletDatas.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 时间标注
        if collectionView == timeView! {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ChartTimeCollectionCell", forIndexPath: indexPath) as! ChartTimeCollectionCell
            
            cell.deselectStatus()
            
            cell.label.text = oldDeletDatas[indexPath.row].time
            
//            cell.label.text = NSDate().dateChangeToLabelText(datas[indexPath.row], timeBucket: timeBucketStyle)
            
            if indexPath.item == datas.count - 1 {
                cell.selectStatus()
            }
            
            return cell
            
        } else {
            
            // 数据cell
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ChartInfoCollectionCell", forIndexPath: indexPath) as! ChartInfoCollectionCell
            
             cell.oldDeletData = oldDeletDatas[indexPath.row]
//            cell.timeData = NSDate().dateChangeToLabelText(datas[indexPath.row], timeBucket: timeBucketStyle)
            
            cell.viewStyle = self.viewStyle
            cell.timeBucketStyle = self.timeBucketStyle
            cell.configAllView()
            
            return cell

        }
        
    }
    
    // 点击事件
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        changeButtonStauts(collectionView, indexPath: indexPath)
        
    }
    
    // 可以点击
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if collectionView == timeView {
            
            return true
        }
        
        return false
    }
    
}

// MARK: - UIScrollViewDelegate
extension ChartBaseView: UIScrollViewDelegate {
    
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
        
        let collView = scrollView as! UICollectionView
        
        let countFloat = collView.contentOffset.x / timeButtonWidth
        var count = Int(countFloat)
        
        if count < 1 || count > datas.count - 2 {
            return
        }
        if countFloat - CGFloat(count) >= 0.5 {
            
            count += 1
        }
        
        changeButtonStauts(collView, indexPath: NSIndexPath(forItem: count, inSection: 0))

    }
    
    /**
     切换时间段按钮状态改变
     */
    func changeButtonStauts(collectionView: UICollectionView, indexPath: NSIndexPath) {
        
        // 更改 选中日期的状态
        for i in 0 ..< datas.count {
            guard let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? ChartTimeCollectionCell else {
                continue
            }
            cell.deselectStatus()
        }
        
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ChartTimeCollectionCell else {
            return
        }
        cell.selectStatus()
        
        collectionView.setContentOffset(CGPointMake(CGFloat(indexPath.item) * timeButtonWidth, 0), animated: true)
        infoView!.setContentOffset(CGPointMake(CGFloat(indexPath.item) * ez.screenWidth, 0), animated: true)

    }
    
    
}