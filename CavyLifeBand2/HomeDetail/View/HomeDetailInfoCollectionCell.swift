//
//  HomeDetailInfoCollectionCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

let chartViewHight: CGFloat = 264
let listViewHight: CGFloat = 200

class HomeDetailInfoCollectionCell: UICollectionViewCell {
    
    /// 柱状图
    var chartView: UIView?
    ///  列表展示信息
    var listView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        chartView = UIView()
        addSubview(chartView!)
        chartView!.snp_makeConstraints { make in
            make.height.equalTo(chartViewHight)
            make.top.left.right.equalTo(self)
        }
        let test = UIView(frame: CGRectMake(50, 50, 100, 100))
        test.backgroundColor = UIColor.brownColor()
        chartView!.addSubview(test)
        
        listView = UIView()
        addSubview(listView!)
        listView!.snp_makeConstraints { make in
            make.top.equalTo(self).offset(chartViewHight + 10)
            make.height.equalTo(listViewHight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
