//
//  UserAchievementCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Log

class UserAchievementCell: UICollectionViewCell {

    @IBOutlet weak var achieveImageView: UIImageView!
    
    @IBOutlet weak var achieveTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        achieveImageView.image = UIImage(asset: .Medal5000)
        
        achieveTitleLabel.textColor = UIColor(named: .GColor)
        achieveTitleLabel.font = UIFont.systemFontOfSize(12.0)
        
    }
    
    
    func configure(dataSource: AchievementDataSource) {
        
        Log.info(dataSource)
        
        achieveTitleLabel.text = achieveLabelArray[dataSource.index]
       
        if dataSource.isAchieve == 1 {
            
            achieveImageView.image = achieveImageLight[dataSource.index]
            
        } else {
            
            achieveImageView.image = achieveImage[dataSource.index]
            
        }
        
    }
    
    
}


protocol AchievementDataSource {
    
    var index: Int { get }
    
    var isAchieve: Int { get }
    
}

struct UserAchievementCellViewModel: AchievementDataSource {
    
    var index: Int
    
    var isAchieve: Int
    
    init(madelIndex: Int, isAchieve: Int = 1) {
        
        self.index = madelIndex
        self.isAchieve = isAchieve
    }
    
}

/// 成就的LabelText
let achieveLabelArray: [String] = ["5000\(L10n.GuideStep.string)",
                                   "20000\(L10n.GuideStep.string)",
                                   "100000\(L10n.GuideStep.string)",
                                   "500000\(L10n.GuideStep.string)",
                                   "1000000\(L10n.GuideStep.string)",
                                   "5000000\(L10n.GuideStep.string)",]
/// 成就的灰色图标
let achieveImage = [UIImage(asset: .Medal5000),
                    UIImage(asset: .Medal20000),
                    UIImage(asset: .Medal100000),
                    UIImage(asset: .Medal500000),
                    UIImage(asset: .Medal1000000),
                    UIImage(asset: .Medal5000000)]

/// 成就点亮的图标
let achieveImageLight = [UIImage(asset: .Medal5000Lighted),
                         UIImage(asset: .Medal20000Lighted),
                         UIImage(asset: .Medal100000Lighted),
                         UIImage(asset: .Medal500000Lighted),
                         UIImage(asset: .Medal1000000Lighted),
                         UIImage(asset: .Medal5000000Lighted)]




