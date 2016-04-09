//
//  UserAchievementCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import JSONJoy
import Log

class UserAchievementCell: UICollectionViewCell {

    @IBOutlet weak var achieveImageView: UIImageView!
    
    @IBOutlet weak var achieveTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        achieveImageView.image = UIImage(asset: .GuideGenderBoyChosen)
        
        achieveTitleLabel.textColor = UIColor(named: .ContactsLetterColor)
        
    }
    
    
    func configure(dataSource: AchievementDataSource) {
        
        
        achieveTitleLabel.text = dataSource.title
       
        if dataSource.isAchieve == 1 {
            
//            achieveImageView.image = UIImage(asset: )
            
        } else {
            
//            achieveImageView.image = UIImage(asset: )
            
        }
        
        Log.info("|\(self.className)| ----- TODO  显示图片没换")
        
    }
    
    
}


protocol AchievementDataSource {
    
    var title: String { get }
    
    var isAchieve: Int { get }
    
}

struct UserAchievementCellViewModel: AchievementDataSource, JSONJoy {
    
    var title: String
    
    var isAchieve: Int
    
    init(_ decoder: JSONDecoder) throws {
        
        do { title = try decoder["title"].getString() } catch { title = "" }
        do { isAchieve = try decoder["isAchieve"].getInt() } catch { isAchieve = 1 }
        
    }
    
    init(title: String = "累计5000步", isAchieve: Int = 1) {
        self.title = title
        self.isAchieve = isAchieve
    }
    
}

