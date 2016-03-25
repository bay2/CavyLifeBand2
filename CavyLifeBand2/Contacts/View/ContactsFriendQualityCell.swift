//
//  ContactsFriendQualityCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ContactsFriendQualityCell: UITableViewCell {

    /// 图片
    @IBOutlet weak var imgView: UIImageView!
    
    /// 左边Label
    @IBOutlet weak var infoLable: UILabel!
    
    /// 右边数值Label
    @IBOutlet weak var numberLabel: UILabel!
    
    /// 是否是可编辑状态
    var cellEditOrNot: Bool = false
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        imgView.roundSquareImage()
        numberLabel.textColor = UIColor(named: .ContactsTitleColor)
        self.selectionStyle = .None
        
        if cellEditOrNot {
            
            // 可编辑状态时候 右边是浅色的
            infoLable.textColor = UIColor(named: .ContactsIntrouduce)
            
        } else {
            
            infoLable.textColor = UIColor(named: .ContactsName)
            
        }
        
    }
    
    /**
     添加数据
     */
    func addData(image: UIImage, info: String, number: String) {
        
        imgView.image = image
        infoLable.text = info
        numberLabel.text = number
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
