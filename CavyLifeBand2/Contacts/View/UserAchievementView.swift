//
//  UserAchievementView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import RealmSwift

class UserAchievementView: UIView, UserInfoRealmOperateDelegate {

    let userAchievementViewCollectionCell = "UserAchievementCell"
    
    let cellSize  = CGSizeMake(90, 132)
    
    /// 徽章个数
    var medalCount = 6
    
    var achievementsList: [AchievementDataSource]?
    
    var achievementCount: Int? {
        
        didSet {
            infoLabel.text = infoStrFormatter(String.numberDecimalFormatter(achievementCount!))
        }
    
    }
    
    var realm: Realm = try! Realm()
    var userId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId

    /// 成就标题Label
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 成就详情Label
    @IBOutlet weak var infoLabel: UILabel!
    
    /// 成就图标展示视图
    @IBOutlet weak var collectionView: UICollectionView!
        
    override func awakeFromNib() {
        
        
        guard let userInfo: UserInfoModel = queryUserInfo(userId) else {
            return
        }
        
        achievementsList = configWithMadelIndex(0)
        
        // 成就标题Label样式设置
        titleLabel.text      = L10n.ContactsShowInfoAchievement.string
        titleLabel.textColor = UIColor(named: .ContactsTitleColor)
        
        
        // 斜体字体
        let font   = UIFont.italicFontWithSize(16)
        
        // 成就详情Label样式设置
        infoLabel.text      = infoStrFormatter()
        infoLabel.font      = font
        infoLabel.textColor = UIColor(named: .ContactsAccountLogoutButton)
        
        // 成就图标展示视图设置
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerNib(UINib(nibName: userAchievementViewCollectionCell, bundle: nil), forCellWithReuseIdentifier: userAchievementViewCollectionCell)
        
        
        self.clipsToBounds      = true
        self.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        guard let achieveIndex = userInfo.achievementType.toInt() else {
            return
        }
        
        achievementsList = configWithMadelIndex(achieveIndex)
        
    }
    
    /**
     传进来的指数  
     0:没有成就; 1:5000步;2:20000步;3:1000000步;4：500000步;5：1000000步;6：5000000步;
     
     - parameter index: 传进来的指数
     
     - returns: 徽章数组
     */
    func configWithMadelIndex(index: Int = 0) -> [AchievementDataSource]? {

        var array: [AchievementDataSource] = []

        for i in 0 ..< medalCount {
            
            array.append(UserAchievementCellViewModel(madelIndex: i, isAchieve: 0))
        }
        
        for i in 0 ..< index  {
            
            let vm = UserAchievementCellViewModel(madelIndex: index, isAchieve: 1)
            array[i] = vm
            
        }
        
        return array
    }
    
    

}

// MARK: - Tool Functions
extension UserAchievementView {

    
    /**
     infoLabel 的 text 格式化
     ep:"0" -> "0 步"
     
     - parameter info: info字符串
     
     - returns: String
     */
    func infoStrFormatter(info: String = "0") -> String {
        return "\(info) \(L10n.GuideStep.string)"
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

