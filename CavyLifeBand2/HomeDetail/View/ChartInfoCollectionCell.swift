//
//  ChartInfoCollectionCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class ChartInfoCollectionCell: UICollectionViewCell {

    /// 柱状图
    var chartView: UIView?
    ///  列表展示信息
    var listView: UITableView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        allViewLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func allViewLayout() {
        
        self.backgroundColor = UIColor(named: .ChartBackground)
        
        chartView = UIView()
        self.addSubview(chartView!)
        chartView!.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: infoViewWidth, height: chartViewHight))
        }
        chartView!.backgroundColor = UIColor.lightGrayColor()
        
        let listBottomView = UIView()
        self.addSubview(listBottomView)
        listBottomView.snp_makeConstraints { make in
            make.top.equalTo(self).offset(chartViewHight)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: infoViewWidth, height: listViewHight))
        }
        listBottomView.backgroundColor = UIColor.whiteColor()
        
        listView = UITableView()
        listView!.separatorStyle = .None
        listView!.scrollEnabled = false 
        listBottomView.addSubview(listView!)
        listView!.snp_makeConstraints { make in
            make.top.equalTo(listBottomView).offset(10)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: infoViewWidth, height: listViewHight - 20))
        }
        listView!.backgroundColor = UIColor.whiteColor()
    }

    
    
    
    
    
    
    
    
    
}
