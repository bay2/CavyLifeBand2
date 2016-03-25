//
//  SearchTableView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/21.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class SearchTableView: UITableView {
    
    var currPage      = 1// 下拉加载当前页
    let pageSize      = 10// 每页获取的数目
    var searchName      = String()
    var searchImage     = UIImage()
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        
        super.init(frame: frame, style: style)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 加载数据
    func loadData(){
        
    }
    
    // 下拉刷新
    func headerRefresh(){
      
        
        
    }


}
