//
//  HomeTimeLineView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/15.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import RealmSwift

class HomeTimeLineView: UIView, ChartsRealmProtocol, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    var realm: Realm = try! Realm()
    var userId: String { return CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId}
    
    /// 时间轴滑块
    var collectionView: UICollectionView?
    
    var dateArray: [String] = []
    
    var notificationTimeStringArrayToken: NotificationToken?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dateArray = queryTimeBucketFromFirstDay()!
        
        collectionViewLayOut(frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        notificationTimeStringArrayToken?.stop()
        
    }
    
    func collectionViewLayOut(frame: CGRect) {
        // 下面的时间轴
        let lineLayout = UICollectionViewFlowLayout()
        lineLayout.itemSize = CGSizeMake(ez.screenWidth, ez.screenHeight - 96 - ez.screenWidth * 0.55 - 50 - 64)
        lineLayout.scrollDirection = .Horizontal
        lineLayout.minimumLineSpacing = 0
        lineLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: lineLayout)
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.alwaysBounceHorizontal = false
        collectionView!.scrollEnabled = false
        collectionView!.contentSize = CGSizeMake(CGFloat(dateArray.count) * ez.screenWidth, 200)
        collectionView!.contentOffset = CGPointMake(CGFloat(dateArray.count) * ez.screenWidth, 200)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "HomeDateTimeLineCell", bundle: nil), forCellWithReuseIdentifier: "HomeDateTimeLineCell")
        self.addSubview(collectionView!)
        collectionView!.snp_makeConstraints { make in
            make.left.top.right.bottom.equalTo(self)
        }
        
        // 接收通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeTimeLinePage), name: "changeTimeLinePage", object: nil)

    }
    
    // MARK: -- collectionView Delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dateArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeDateTimeLineCell", forIndexPath: indexPath) as! HomeDateTimeLineCell
        
        Log.info(indexPath)
        
        cell.timeString = dateArray[indexPath.item]
        cell.configLayout()
        return cell
    }

    /**
     改变页数 并重新解析数据
     
     - parameter sender: 通知
     */
    func changeTimeLinePage(sender: NSNotification){
        
        let count = sender.userInfo!["currentPage"] as! CGFloat
        
        // 如果只有一条 需要从数据库去监听是否加载完毕 添加其他的数据
        if self.dateArray.count == 1 {
        
            initNotificationDateStringArrayAction()
            
        }
        
        self.collectionView!.setContentOffset(CGPointMake(count * ez.screenWidth, 0), animated: true)
        
    }
    
    /**
     数据库下载完更新视图监控
     */
    func initNotificationDateStringArrayAction() {
        
        let userInfos: Results<UserInfoModel> = queryUserInfo(CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId)
        
        notificationTimeStringArrayToken = userInfos.addNotificationBlock{ (change: RealmCollectionChange) in
            switch change {
                
            case .Initial(_):
                
                self.dateArray = self.queryTimeBucketFromFirstDay()!
                self.collectionView!.reloadData()
                
            case .Update(_, deletions: _, insertions: _, modifications: _):
                
                self.dateArray = self.queryTimeBucketFromFirstDay()!
                self.collectionView!.reloadData()
                
            default:
                break
            }
            
        }
        
    }
    


}
