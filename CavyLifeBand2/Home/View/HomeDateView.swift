//
//  HomeDateView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/14.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class HomeDateView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// label宽度
    var labelWidth = ez.screenWidth / 3
    
    /// 日期滑块
    var collectionView: UICollectionView?
    
    /// 数据个数
    var dateCount: Int = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addAllViewLayout()
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllViewLayout() {
        
        // 上面的CollectionView
        let layout = HomeDataCellFlowLayout()
        collectionView = UICollectionView(frame: CGRectMake(0, 0, ez.screenWidth, 50), collectionViewLayout: layout)
        self.addSubview(collectionView!)
        
        collectionView!.backgroundColor = UIColor(named: .HomeViewMainColor)
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.alwaysBounceHorizontal = true
        collectionView!.contentSize = CGSizeMake(CGFloat(dateCount) * labelWidth, 0)
        collectionView!.contentOffset = CGPointMake(CGFloat(dateCount - 1) * labelWidth, 0)
        collectionView!.snp_makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "HomeDateViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeDateCell")
        
        // 中间白色三角形
        let imgView = UIImageView()
        self.addSubview(imgView)
        imgView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(20, 10))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(40)
        }
        imgView.image = UIImage(asset: .HomeTimelineCorn)
        
        // 接受通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeDatePage), name: "ChangeDatePage", object: nil)

    }
    
    
    // MARK: -- collectionView Delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dateCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeDateCell", forIndexPath: indexPath) as! HomeDateViewCell
        
        cell.dateLabel.text = "2016.4.\(indexPath.row)"
        
        return cell
    }
    

}

// MARK: - UIScrollViewDelegate
extension HomeDateView: UIScrollViewDelegate {
    
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

        let countFloat = collView.contentOffset.x / labelWidth
        
        var count = Int(countFloat)
        
        if count < 1 || count > dateCount - 2 {
            return
        }
        
        
        if countFloat - CGFloat(count) >= 0.5 {
            
            count += 1
        }
        
        collView.setContentOffset(CGPointMake(CGFloat(count) * labelWidth, 0), animated: true)

        // 通知绑定日期和时间轴的同步
        NSNotificationCenter.defaultCenter().postNotificationName("changeTimeLinePage", object: nil, userInfo: ["currentPage" : count])

    
    }
    
    /**
     改变CollectionView对应页数
     
     - parameter sender:
     */
    func changeDatePage(sender: NSNotification){
        
        let count = sender.userInfo!["currentPage"] as! CGFloat
        
        self.collectionView!.setContentOffset(CGPointMake(count * labelWidth, 0), animated: true)
        
    }
    

}

