//
//  HomeDetailStepView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class HomeDetailStepView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    /// label宽度
    var labelWidth = ez.screenWidth / 3

    /// 时间间隔选择
    var timeView = UICollectionView()
    
    /// 数据个数
    var dateCount: Int = 20
    
    /// 详情页
//    var infoView = UICollectionView()
    
    
    override init(frame: CGRect) {
   
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: .HomeDetailBackground)
        
        addAllViewLayout()
        
   
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    


    
    func addAllViewLayout() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(ez.screenWidth / 3, 50)
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // 上面的CollectionView
        timeView = UICollectionView(frame: CGRectMake(0, 0, ez.screenWidth, 50), collectionViewLayout: layout)
        self.addSubview(timeView)
        
        timeView.backgroundColor = UIColor(named: .HomeDetailBackground)
        timeView.showsHorizontalScrollIndicator = false
        timeView.alwaysBounceHorizontal = true
        timeView.contentSize = CGSizeMake(CGFloat(dateCount) * labelWidth, 0)
        timeView.contentOffset = CGPointMake(CGFloat(dateCount) * labelWidth, 0)
        timeView.snp_makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        timeView.dataSource = self
        timeView.delegate = self
        timeView.registerClass(HomeDatilTimeCollectionCell.self, forCellWithReuseIdentifier: "HomeDatilTimeCollectionCell")
        
        
    }
    
    // MARK: -- collectionView Delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dateCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeDatilTimeCollectionCell", forIndexPath: indexPath) as! HomeDatilTimeCollectionCell
        cell.button.setTitle("4.\(indexPath.section)", forState: .Normal)
        
        return cell
    }
    
}
/*
// MARK: - UIScrollViewDelegate
extension HomeDetailStepView: UIScrollViewDelegate {
    
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
        
        let count = Int(scrollView.contentOffset.x / labelWidth)
        
        
        scrollView.setContentOffset(CGPointMake(CGFloat(count) * labelWidth, 0), animated: true)
        
    }
    
}

*/
