//
//  ChartsBaseView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/6/22.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import RealmSwift

class ChartsBaseView: UIView, UICollectionViewDelegateFlowLayout, ChartsRealmProtocol{
    
    var realm: Realm = try! Realm()
    var userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    var viewStyle: ChartViewStyle = .StepChart
    
    var timeBucketStyle: TimeBucketStyle = .Day
    
    /// 时间间隔选择
    var timeView: UICollectionView?
    
    /// 详情页
    var infoView: UICollectionView?
    
    var dates: [String] = []
    
    /**
     入口
     */
    func configView() {
        
        dates = setData()
        
        addTimeBucketView()
        
        addInfoView()
        
        timeView!.setContentOffset(CGPointMake(subTimeButtonWidth * CGFloat(dates.count - 1), 0), animated: false)
        changeButtonStauts(timeView!, indexPath: NSIndexPath(forItem: dates.count - 1, inSection: 0))
        
    }
    
    /**
     添加数据
     */
    func setData() -> [String] {
        
        let dateStringArray = queryTimeBucketFromFirstDay()!
        var returnArray: [String] = [dateStringArray[0]]
        
        let firstDate = NSDate(fromString: dateStringArray[0], format: "yyyy.M.d")
        let indexInWeek = firstDate!.indexInArray() // 1-7 对应周一到周日
        var monthArray = [firstDate!.toString(format: "M")]
        
        for i in 1 ..< dateStringArray.count {
            
            switch timeBucketStyle {
                
            case .Day:
                
                returnArray = dateStringArray
                
            case .Week:
                
                if (i + indexInWeek) % 7 == 1 {
                    
                    returnArray.append(dateStringArray[i])
                }
                
            case .Month:
                
                let month: String = NSDate(fromString: dateStringArray[i], format: "yyyy.M.d")!.toString(format: "M")
                if monthArray.contains(month) == false {
                    
                    monthArray.append(month)
                    returnArray.append(dateStringArray[i])
                }
            }
            
        }
        
        return returnArray
        
    }
    
    // 添加时间段的视图
    func addTimeBucketView() {
        
        self.backgroundColor = UIColor.clearColor()
        
        let layout = ChartsSubTimeBucketFlowLayout()
        
        // 上面的CollectionView
        timeView = UICollectionView(frame: CGRectMake(0, 0, ez.screenWidth, subTimeButtonHeight), collectionViewLayout: layout)
        timeView!.backgroundColor = UIColor(named: .ChartSubTimeBucketViewBg)
        timeView!.alwaysBounceHorizontal = true
        timeView!.showsHorizontalScrollIndicator = false
        timeView!.contentSize = CGSizeMake(CGFloat(dates.count) * subTimeButtonWidth, subTimeButtonHeight)
        timeView!.contentOffset = CGPointMake(CGFloat(dates.count) * subTimeButtonWidth, subTimeButtonHeight)
        timeView!.dataSource = self
        timeView!.delegate = self
        timeView!.registerClass(ChartsSubTimeBucketCell.self, forCellWithReuseIdentifier: "ChartsSubTimeBucketCell")
        self.addSubview(timeView!)
        timeView!.snp_makeConstraints { make in
            make.left.right.top.equalTo(self)
            make.height.equalTo(subTimeButtonHeight)
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
        infoView!.backgroundColor = UIColor.whiteColor()
        infoView!.alwaysBounceHorizontal = true
        infoView!.showsHorizontalScrollIndicator = false
        infoView!.contentSize = CGSizeMake(CGFloat(dates.count) * ez.screenWidth, subTimeButtonHeight)
        infoView!.contentOffset = CGPointMake(CGFloat(dates.count) * ez.screenWidth, subTimeButtonHeight)
        infoView!.dataSource = self
        infoView!.delegate = self
        infoView!.scrollEnabled = false
        infoView!.registerClass(ChartsInfoCollectionCell.self, forCellWithReuseIdentifier: "ChartsInfoCollectionCell")
        self.addSubview(infoView!)
        infoView!.snp_makeConstraints { make in
            make.top.equalTo(timeView!).offset(subTimeButtonHeight)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: ez.screenWidth, height: infoViewHeight))
        }
        
    }
    
}

// MARK: -- collectionView Delegate
extension ChartsBaseView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dates.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 时间 横滑 cell
        if collectionView == timeView! {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ChartsSubTimeBucketCell", forIndexPath: indexPath) as! ChartsSubTimeBucketCell
            
            cell.label.text = NSDate(fromString: dates[indexPath.item], format: "yyyy.M.d")!.dateChangeToLabelText(timeBucketStyle)
            
//            if indexPath.item == dates.count - 1 {
//                cell.selectStatus()
//            }
            
            return cell
            
        } else {
            
            // 数据 List Cell
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ChartsInfoCollectionCell", forIndexPath: indexPath) as! ChartsInfoCollectionCell
            
            cell.timeString = dates[indexPath.item]
            
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
extension ChartsBaseView: UIScrollViewDelegate {
    
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
        
        let countFloat = collView.contentOffset.x / subTimeButtonWidth
        var count = Int(countFloat)
        
        if count < 0 || count > dates.count - 1 {
            
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
        
//        // 更改 选中日期的状态
//        for i in 0 ..< dates.count {
//            guard let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? ChartsSubTimeBucketCell else {
//                continue
//            }
//            cell.unSlectStatus()
//        }
//        
//        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ChartsSubTimeBucketCell else {
//            return
//        }
//        cell.selectStatus()

        collectionView.setContentOffset(CGPointMake(CGFloat(indexPath.item) * subTimeButtonWidth, 0), animated: true)

        infoView!.setContentOffset(CGPointMake(CGFloat(indexPath.item) * ez.screenWidth, 0), animated: false)
        
    }
    

}
