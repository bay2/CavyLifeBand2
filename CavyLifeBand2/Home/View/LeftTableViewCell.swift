//
//  LeftTableViewCell.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class LeftTableViewCell: UITableViewCell {

    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var listTitle: UILabel!

    override func awakeFromNib() {

        super.awakeFromNib()

        self.backgroundColor = UIColor(named: .HomeViewMainColor)

        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(named: .HomeViewLeftSelected)
        self.selectedBackgroundView = selectedView

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(dataSource: LeftListCellDateSource, delegate: LeftListCellDelegate) {

        listIcon.image = dataSource.icon
        listTitle.text = dataSource.title

        listTitle.font = delegate.titleFont
        listTitle.textColor = delegate.titleColor

    }
    
}

protocol LeftListCellDateSource {

    var title: String { get }
    var icon: UIImage { get }

}

protocol LeftListCellDelegate {

    var titleColor: UIColor { get }
    var titleFont: UIFont { get }
    var nextView: UIViewController { get }

}

extension LeftListCellDateSource {

    var titleColor: UIColor {
        return UIColor.whiteColor()
    }

    var titleFont: UIFont {
        
        let font = UIFont.systemFontOfSize(16)
        font.fontWithSize(0.23)
        return font
   
    }


}

