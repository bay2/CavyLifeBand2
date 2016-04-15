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
    
    /// 图片
    @IBOutlet weak var imgView: UIImageView!
    
    /// 模块名字
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 其他人名字
    @IBOutlet weak var othersName: UILabel!
    
    /// 结果值
    @IBOutlet weak var resultLabel: UILabel!
    
    /**
     cell加载数据
     */
    func cellConfig(moudle: HomeTimeLineMoudle) {
        
        addAllViewLayout()
        
        imgView.image = UIImage(contentsOfFile: moudle.image)
        imgView.af_setImageWithURL(NSURL(string: moudle.image)!, runImageTransitionIfCached: true)
        nameLabel.text = moudle.name
        timeLabel.text = moudle.time
        othersName.text = moudle.othersName
        resultLabel.attributedText = resultAttribtuedTest(moudle.result)
        
    }
    
    /**
     返回右面结果值
     */
    func resultAttribtuedTest(string: String) -> NSAttributedString {
        
        let attrs = NSAttributedString(string: string)
        
        if string == L10n.HomeTimeLineCellSleep.string {
            
            
            
        HomeRingView(frame: frame).addSleepAttributeText("6", hourUnit: "小时", minutes: "34", minUnit: "分钟")
            
        }
        if string == L10n.HomeTimeLineCellStep.string {
            
        }
        if string == L10n.HomeTimeLineCellPK.string {
            
        }
        if string == L10n.HomeTimeLineCellAchive.string {
            
        }
        if string == L10n.HomeTimeLineCellHealthiy.string {
            
        }
        
        return attrs
    }
    
    /**
     所有视图的布局
     */
    func addAllViewLayout() {
        
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = imgView.frame.width / 2
        imgView.backgroundColor = UIColor.lightGrayColor()
        
        nameLabel.textColor = UIColor(named: .HomeViewUserName)
        timeLabel.textColor = UIColor(named: .ContactsIntrouduce)
        othersName.textColor = UIColor(named: .HomeViewUserName)
        resultLabel.textColor = UIColor(named: .HomeViewUserName)
    }
    
    func haveOthers(moudle: HomeTimeLineMoudle) {
    
        /**
         *  判断PK 成就
         */
        if moudle.othersName != "" {
            
            nameLabel.snp_makeConstraints(closure: { (make) in
                make.centerX.equalTo(imgView)
            })
            
        } else {
            nameLabel.snp_makeConstraints(closure: { (make) in
                make.centerX.equalTo(imgView).offset(-3)
            })
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
