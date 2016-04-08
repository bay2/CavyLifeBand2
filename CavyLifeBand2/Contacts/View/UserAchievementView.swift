//
//  UserAchievementView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

/**
 
 使用示例
 
 let achieveView = NSBundle.mainBundle().loadNibNamed("UserAchievementView", owner: nil, options: nil).first as? UserAchievementView
 
 achieveView?.frame = CGRect(x: 20, y: 20, w: ez.screenWidth - 40, h: 342)
 
 achieveView?.achievementsList = [UserAchievementCellViewModel(),
                                  UserAchievementCellViewModel(),
                                  UserAchievementCellViewModel()]
 
 achieveView?.achievementCount = 500000
 
 */

class UserAchievementView: UIView {

    let userAchievementViewCollectionCell = "UserAchievementCell"
    
    let cellSize  = CGSizeMake(90, 132)
    
    var achievementsList: [AchievementDataSource]?
    
    var achievementCount: Int? {
        
        didSet {
            infoLabel.text = infoStrFormatter(transformNumberStyle(achievementCount!))
        }
    
    }
    

    /// 成就标题Label
    @IBOutlet weak var titleLabel: UILabel!
    /// 成就详情Label
    @IBOutlet weak var infoLabel: UILabel!
    /// 成就图标展示视图
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {

        // 成就标题Label样式设置
        titleLabel.text      = L10n.ContactsShowInfoAchievement.string
        titleLabel.textColor = UIColor(named: .ContactsTitleColor)
        
        
        // 斜体字体
        let matrix = CGAffineTransformMake(1, 0, CGFloat(tanf(15 * Float(M_PI) / 180)), 1, 0, 0)
        let desc   = UIFontDescriptor(name: UIFont.systemFontOfSize(16).fontName, matrix: matrix)
        let font   = UIFont(descriptor: desc, size: 16)
        
        
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
        
    }
    
    
    

}

// MARK: - Tool Functions
extension UserAchievementView {
    
    /**
     转换数字格式 ep:50000 -> 50,000
     
     - parameter number: Int数据
     
     - returns: String
     */
    func transformNumberStyle(number: Int = 0) -> String {
        
        let numberFormatter = NSNumberFormatter()
        
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        let numberStr = numberFormatter.stringFromNumber(NSNumber(integer: number))
        
        return numberStr!
        
    }
    
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
        
//        return cellCount
        return achievementsList!.count
        
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


