//
//  AboutCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        infoLabel.textColor = UIColor(named: .EColor)
        titleLabel.textColor = UIColor(named: .FColor)
        
        infoLabel.font = UIFont.systemFontOfSize(16.0)
        titleLabel.font = UIFont.systemFontOfSize(16.0)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: AboutCellDataSource) {
        infoLabel.text = model.info
        titleLabel.text = model.title
    }
    
}

protocol AboutCellDataSource {
    var title: String { get }
    var info: String { get }
}


struct AboutCellModel: AboutCellDataSource {
    var title: String
    var info: String
    
    init(title: String, info: String = "") {
        self.title = title
        self.info = info
    }
}

struct HelpFeedbackCellModel: AboutCellDataSource {
    var title: String
    var info: String
    var webUrlStr: String
    
    init(title: String, webStr: String, info: String = "") {
        self.title = title
        self.info = info
        self.webUrlStr = webStr
    }
}