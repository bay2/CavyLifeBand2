//
//  ChartsTimeButton.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ChartsTimeButton: UIButton {

    let searchBtnTitle: Array<String> = [L10n.ChartTimeBucketDay.string, L10n.ChartTimeBucketWeek.string, L10n.ChartTimeBucketMonth.string]
    
    //当前按钮类型
    var selectedIndex: Int = 0

    //按钮文字
    private var nameLabel: UILabel!
    
    convenience init(frame: CGRect = CGRectMake(0, 0, 0, 0), selectIndex: Int) {
        
        self.init(frame: frame)
        
        self.selectedIndex = selectIndex
        self.backgroundColor = UIColor(named: .HomeViewMainColor)
        nameLabel = UILabel()
        self.addSubview(nameLabel)
        nameLabel.textAlignment = .Center
        nameLabel.textColor = UIColor(named: .BColor)
        nameLabel.font = UIFont.mediumSystemFontOfSize(16)
        nameLabel.text = searchBtnTitle[selectIndex]
        nameLabel.snp_makeConstraints { make -> Void in
            make.left.right.top.bottom.equalTo(self)
        }
        
    }
    
    /**
     选中的状态
     */
    func selectStatus() {
        
        nameLabel.textColor = UIColor(named: .AColor)
        
    }
    
    /**
     未选中的状态
     */
    func deselectStatus() {
        
        nameLabel.textColor = UIColor(named: .BColor)

    }
    

}
