//
//  ContactRecommendFriendView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/21.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SnapKit

class ContactRecommendFriendView: UIView {
    
    var tableView = ContactRecommendFriendTV()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加 SearchController 和 TableView
        tableView.frame = CGRectMake(0, 44, ez.screenWidth, frame.height - 44)
        addSubview(tableView)
        tableView.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20)
        tableView.separatorStyle = .SingleLine
        tableView.separatorColor = UIColor(named: .LColor)
        tableView.tableFooterView = UIView()
        
        self.backgroundColor = UIColor(named: .HomeViewMainColor)
    }
    
    /**
     添加搜索bar
     
     - parameter searchBar:
     */
    func addSearchBar(searchBar: UISearchBar) {
        
        addSubview(searchBar)
        searchBar.snp_makeConstraints { make in
            make.top.left.right.equalTo(self)
        }
        
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
