//
//  HomeTimeLineTableCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/15.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTimeLineTableCell: UITableViewCell {
    
    /// 图片上面的线
    @IBOutlet weak var headLine: UIView!
    /// 图片下面的线
    @IBOutlet weak var bottomLine: UIView!
    
    /// 图片
    @IBOutlet weak var imgView: UIImageView!
    
    /// 模块名字
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 其他人名字
    @IBOutlet weak var othersName: UILabel!
    
    /// 结果值
    @IBOutlet weak var resultLabel: UILabel!
    
    func configVM(dataSource: HomeListViewModelProtocol) {

        if dataSource.friendIconUrl == "" {
            
            imgView.image = dataSource.image
            
        } else {
            imgView.af_setCircleImageWithURL(NSURL(string: dataSource.friendIconUrl)!, placeholderImage: UIImage(asset: .DefaultHead_small))
        }
        
        nameLabel.text = dataSource.title
        nameLabel.textColor = UIColor(named: .EColor)
        nameLabel.font = UIFont.mediumSystemFontOfSize(16.0)
        
        othersName.text = dataSource.friendName
        othersName.textColor = UIColor(named: .EColor)
        othersName.font = UIFont.mediumSystemFontOfSize(12.0)
        
        resultLabel.attributedText = dataSource.resultNum
        addAllViewLayout(dataSource.friendName)
        
    }

    
    /**
     所有视图的布局
     */
    func addAllViewLayout(name: String) {
        
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = imgView.frame.width / 2
        headLine.backgroundColor = UIColor(named: .HomeTimeLineLineColor)
        bottomLine.backgroundColor = UIColor(named: .HomeTimeLineLineColor)
        nameLabel.textColor = UIColor(named: .HomeViewUserName)
        othersName.textColor = UIColor(named: .HomeViewUserName)
        resultLabel.textColor = UIColor(named: .HomeViewUserName)
    
        // 判断PK 成就
        if name == "" {
            
            nameLabel.snp_remakeConstraints{ make in
                make.centerY.equalTo(imgView)
            }
            
        } else {
            
            nameLabel.snp_remakeConstraints{ make in
                make.centerY.equalTo(imgView).offset(-10)
            }
        }
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
