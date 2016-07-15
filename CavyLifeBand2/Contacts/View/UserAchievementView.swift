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
        
        infoLabel.text = infoStrFormatter("0")

        defaultConfigureAchievement()
        
        // 成就标题Label样式设置
        titleLabel.text      = L10n.ContactsShowInfoAchievement.string
        titleLabel.textColor = UIColor(named: .EColor)
        titleLabel.font      = UIFont.mediumSystemFontOfSize(16.0)
        
        // 成就详情Label样式设置
        infoLabel.font      = UIFont.systemFontOfSize(14.0)
        infoLabel.textColor = UIColor(named: .KColor)
        
        // 成就图标展示视图设置
        collectionView.delegate      = self
        collectionView.dataSource    = self
        collectionView.scrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerNib(UINib(nibName: userAchievementViewCollectionCell, bundle: nil), forCellWithReuseIdentifier: userAchievementViewCollectionCell)
        
        self.setCornerRadius(radius: CavyDefine.commonCornerRadius)
        
    }
    
    /**
     配置登录用户的成就页面
     */
    func configWithAchieveIndexForUser() {
        
        let userInfo: UserInfoModel = queryUserInfo(userId)!
        
        defaultConfigureAchievement(userInfo.translateAwards())
        
        achievementCount = userInfo.steps
        
    }
    
    func defaultConfigureAchievement(awards: [Int] = []) {
        
        achievementsList?.removeAll()
        
        var array: [AchievementDataSource] = []
        
        for i in 0 ..< medalCount {
            
            array.append(UserAchievementCellViewModel(madelIndex: i, isAchieve: 0))
        }
        
        guard awards.count > 0 else {
            
            achievementsList = array
            
            return
        }
        
        let maxAwardIndex = sortInt(awards)
        
        for j in 0 ..< maxAwardIndex  {
            
            let vm = UserAchievementCellViewModel(madelIndex: j, isAchieve: 1)
            array[j] = vm
            
        }
        
        achievementsList = array
        
    }
    
    /**
     取出Int数组中的最大值
     
     - parameter awards: [Int]  如 [2,3]
     
     - returns: Int
     */
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

