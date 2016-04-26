//
//  HomeDateTimeLineCell.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/4/15.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class HomeDateTimeLineCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource{
    
    var tableView =  UITableView()
    
    /// cell数据的数组
    var dataArray: Array<HomeTimeLineMoudle> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addCollectionView()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addCollectionView() {
      
        tableView.backgroundColor = UIColor.whiteColor()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        
        tableView.registerNib(UINib(nibName: "HomeTimeLineTableCell", bundle: nil), forCellReuseIdentifier: "HomeTimeLineTableCell")
        
        self.addSubview(tableView)
        
        tableView.snp_makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        

        
        
    }
    
    // MARK: UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 8
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = NSBundle.mainBundle().loadNibNamed("HomeTimeLineSection", owner: nil, options: nil).first as! HomeTimeLineSection
        
        if section == 0 {
            
            sectionView.lineView.hidden = true
        }
        
        
        
        return sectionView //HomeTimeLineSection(frame: CGRectMake(0, 0, ez.screenWidth, 10))

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 66
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 16
        }
        
        return 10
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTimeLineTableCell", forIndexPath: indexPath) as! HomeTimeLineTableCell
        
        if indexPath.section == 0 {
            
            cell.headLine.hidden = true
            
        }
        
        
        
        cell.addAllViewLayout()
        
        return cell
    }

}
