//
//  UserAchievementView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift
import EZSwiftExtensions

class UserAchievementView: UIView, UserInfoRealmOperateDelegate, ChartsRealmProtocol {

    let userAchievementViewCollectionCell = "UserAchievementCell"
    
    let cellSize  = CGSizeMake(90, 122)
    
    /// 徽章个数
    var medalCount = 6
    
    var achievementsList: [AchievementDataSource]?
    
    var achievementCount: Int? {
        
        didSet {
            infoLabel.text = infoStrFormatter(String.numberDecimalFormatter(achievementCount!))
            self.collectionView.reloadData()
        }
    
    }
    
    var realm: Realm = try! Realm()
    
    var userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    // 判断本地是否需要点灯
    let stepArray = [0, 5000, 20000, 100000, 500000, 1000000, 5000000]

    /// 成就标题Label
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 成就详情Label
    @IBOutlet weak var infoLabel: UILabel!
    
    /// 成就图标展示视图
    @IBOutlet weak var collectionView: UICollectionView!
        
    override func awakeFromNib() {
        
//        for chartsData in queryAllStepInfo(userId) {
//            achievementCount! += chartsData.step
//        }
        
        achievementCount = queryAllStepInfo(userId).reduce(0) {
            $0.0! + $0.1.step
        }
        
        
        infoLabel.text = infoStrFormatter(String.numberDecimalFormatter(achievementCount!))
        Log.info(infoLabel.text)
        
        configWithAchieveIndexForUser()
        
        // 成就标题Label样式设置
        titleLabel.text      = L10n.ContactsShowInfoAchievement.string
        titleLabel.textColor = UIColor(named: .EColor)
        titleLabel.font      = UIFont.mediumSystemFontOfSize(16.0)
        
        // 斜体字体
        let font   = UIFont.mediumSystemFontOfSize(14.0)
        
        // 成就详情Label样式设置
        infoLabel.font      = font
        infoLabel.textColor = UIColor(named: .KColor)
        
        // 成就图标展示视图设置
        collectionView.delegate      = self
        collectionView.dataSource    = self
        collectionView.scrollEnabled = ez.screenWidth <= 320 ? true : false
        collectionView.showsVerticalScrollIndicator = ez.screenWidth <= 320 ? true : false
        collectionView.registerNib(UINib(nibName: userAchievementViewCollectionCell, bundle: nil), forCellWithReuseIdentifier: userAchievementViewCollectionCell)
        
        self.setCornerRadius(radius: CavyDefine.commonCornerRadius)
        
        //TODO 接口返回的规则不确定，先不写
//        guard var achieveIndex = userInfo.achievementType.toInt() else {
//            return
//        }
//        
//        var locationIndex = 1
//        
//        for i in 0 ..< stepArray.count {
//            
//            if achievementCount >= stepArray[i] {
//                locationIndex += 1
//            }
//        }
//        
//        if locationIndex > achieveIndex {
//            
//            achieveIndex = locationIndex
//            // 上报 成就徽章是否点亮
//            userInfo.achievementType = String(achieveIndex)
//        }
        
    }
    
    /**
     传进来的指数 
     
     0:没有成就; 1:5000步;2:20000步;3:1000000步;4：500000步;5：1000000步;6：5000000步;
     - parameter index: 传进来的指数
     - Jessica
     - returns: 徽章数组
     */
    func configWithAchieveIndexForUser(awards: [Int] = []) {
        
       
        defaultConfigureAchievement(awards)
        
        // TODO 用户总步数获取
        achievementCount = 0
            
        
    }
    
    func defaultConfigureAchievement(awards: [Int] = []) {
        
        achievementsList?.removeAll()
        
        guard awards.count > 0 else {
            
            var array: [AchievementDataSource] = []
            
            for i in 0...5 {
                array.append(UserAchievementCellViewModel(madelIndex: i, isAchieve: 0))
            }
            
            achievementsList = array
            
            return
        }
        
        var array: [AchievementDataSource] = []
        
        let maxAwardIndex = sortInt(awards) 
        
        for i in 0 ..< medalCount {
            
            array.append(UserAchievementCellViewModel(madelIndex: i, isAchieve: 0))
        }
        
        for i in 0 ..< maxAwardIndex  {
            
            let vm = UserAchievementCellViewModel(madelIndex: i, isAchieve: 1)
            array[i] = vm
            
        }
        
        achievementsList = array
    }
    
    func sortInt(awards: [Int]) -> Int {
        
        var x: Int = 0
        
        for value in awards {
            
            if value > x { x = value }
            
        }
        
        return x
        
    }
    
    
    
}

// MARK: - Tool Functions
extension UserAchievementView {

    
    /**
     infoLabel 的 text 格式化
     ep:"0" -> "您已累计行走0步"
     
     - parameter info: info字符串
     
     - returns: String
     */
    func infoStrFormatter(info: String = "0") -> String {
        return "\(L10n.AccountInfoAchieveViewNumPrefix)\(info)\(L10n.GuideStep.string)"
    }

}

// MARK: - UICollectionViewDataSource
extension UserAchievementView: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return medalCount
        
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(userAchievementViewCollectionCell, forIndexPath: indexPath) as! UserAchievementCell
        
        cell.configure(achievementsList![indexPath.row])
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension UserAchievementView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserAchievementView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return cellSize
    
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
    
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsZero
    
    }
    
}

