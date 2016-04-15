//
//  HomeTimeLineView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/15.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class HomeTimeLineView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    /// 时间轴滑块
    var collectionView: UICollectionView?
    
    var dataArray: Array<HomeDateMoudle> = []
    var dateCount = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionViewLayOut(frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionViewLayOut(frame: CGRect) {
        // 下面的时间轴
        let lineLayout = UICollectionViewFlowLayout()
        lineLayout.itemSize = CGSizeMake(ez.screenWidth, ez.screenHeight - 96 - ez.screenWidth * 0.55 - 50 - 64)
        Log.info(lineLayout.itemSize)
        lineLayout.scrollDirection = .Horizontal
        lineLayout.minimumLineSpacing = 0
        lineLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: lineLayout)
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.alwaysBounceHorizontal = true
        collectionView!.contentSize = CGSizeMake(CGFloat(dateCount - 1) * ez.screenWidth, 0)
        collectionView!.contentOffset = CGPointMake(CGFloat(dateCount - 1) * ez.screenWidth, 0)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(HomeDateTimeLineCell.self, forCellWithReuseIdentifier: "HomeDateTimeLineCell")
        self.addSubview(collectionView!)
        collectionView!.snp_makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        

    }
    
    // MARK: -- collectionView Delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dateCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeDateTimeLineCell", forIndexPath: indexPath) as! HomeDateTimeLineCell
        
        
        return cell
    }

}

// MARK: - UIScrollViewDelegate
extension HomeTimeLineView: UIScrollViewDelegate {
    
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
        
        let countFloat = collView.contentOffset.x / ez.screenWidth
        
        var count = Int(countFloat)
        Log.info(count)
        
        if count < 1 || count > dateCount - 2 {
            return
        }
        
        
        if countFloat - CGFloat(count) >= 0.5 {
            
            count += 1
        }
        
        collView.setContentOffset(CGPointMake(CGFloat(count) * ez.screenWidth, 0), animated: true)
        


    }
    
}


