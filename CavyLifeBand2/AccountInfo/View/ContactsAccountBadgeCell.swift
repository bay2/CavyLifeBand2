//
//  ContactsAccountBadgeCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class ContactsAccountBadgeCell: UICollectionViewCell {

    
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var badgeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    
    /**
     添加CollectionView数据
     */
    func addData(image: UIImage, title: String) {
        badgeImageView.image = image
        badgeLabel.textColor = UIColor(named: .ContactsIntrouduce)
        badgeLabel.text = title
    }
    
}
