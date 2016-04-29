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
    
    /// 时间间隔选择
    var timeView: UICollectionView?
    
    /// 详情页
    var infoView: UICollectionView?
    
    /// 数据个数
    var dateCount: Int = 20
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        addTimeBucketView()
        
        addInfoView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        timeView!.contentSize = CGSizeMake(CGFloat(dateCount) * timeButtonWidth, timeButtonHeight)
        timeView!.contentOffset = CGPointMake(CGFloat(dateCount - 1) * timeButtonWidth, timeButtonHeight)
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
        infoView!.contentSize = CGSizeMake(CGFloat(dateCount - 1) * ez.screenWidth, timeButtonHeight)
        infoView!.contentOffset = CGPointMake(CGFloat(dateCount - 1) * ez.screenWidth, timeButtonHeight)
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
        
        return dateCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == timeView! {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ChartTimeCollectionCell", forIndexPath: indexPath) as! ChartTimeCollectionCell
            
            cell.deselectStatus()
            cell.label.text = "4.\(indexPath.item)"
            
            if indexPath.item == dateCount - 1 {
                cell.selectStatus()
            }
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ChartInfoCollectionCell", forIndexPath: indexPath) as! ChartInfoCollectionCell
            
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
        
        if count < 1 || count > dateCount - 2 {
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
        for i in 0 ..< dateCount {
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