//
//  RecommendSearchView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/21.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class RecommendSearchView: UIView {
    
    var searchView = UISearchBar()
    var tableView = SearchTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加 SearchController 和 TableView
        searchView.frame = CGRectMake(0, 0, ez.screenWidth, 44)
        addSubview(self.searchView)
        tableView.frame = CGRectMake(0, 44, ez.screenWidth, ez.screenHeight)
        addSubview(tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
