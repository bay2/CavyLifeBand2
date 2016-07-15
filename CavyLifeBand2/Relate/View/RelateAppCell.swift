//
//  RelateAppCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import AlamofireImage

class RelateAppCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.font = UIFont.mediumSystemFontOfSize(16.0)
        sizeLabel.font = UIFont.systemFontOfSize(12.0)
        infoLabel.font = UIFont.systemFontOfSize(14.0)
        
        titleLabel.textColor = UIColor(named: .EColor)
        sizeLabel.textColor = UIColor(named: .FColor)
        infoLabel.textColor = UIColor(named: .GColor)
        
        logoImageView.layer.borderWidth = 1.0 / 3
        logoImageView.layer.borderColor =  UIColor(named: .RalateAppCellImageBorderColor).CGColor
        logoImageView.layer.cornerRadius = 12.0
        logoImageView.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: RelateAppCellDataSource) {
        
        titleLabel.text = model.title
        
        sizeLabel.text = model.size
        
        infoLabel.text = model.info

        logoImageView.af_setCornerRadiusImageWithURL(NSURL(string: model.logoImageUrlStr)!, radius: 12)
        
    }
    
}

protocol RelateAppCellDataSource {
    
    var logoImageUrlStr: String { get }
    
    var title: String { get }
    
    var size: String { get }
    
    var info: String { get }
    
    var webUrlStr: String { get }
    
}

struct RelateAppCellModel: RelateAppCellDataSource {
    var logoImageUrlStr: String
    
    var title: String
    
    var size: String {
        
        get { return "" }
        //get { return trueSize + "M" } 接口暂时资料不全不能提供
        
    }
    
    var webUrlStr: String
    
    var trueSize: String
    
    var info: String 
    
    init(gameModel: GameJSON) {
        
        title = gameModel.title
        
        trueSize = "0" //gameModel.filesize
        
        info = gameModel.desc
        
        logoImageUrlStr = gameModel.icon
        
        webUrlStr = gameModel.htmlUrl
        
    }

}
