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
    var dataCount = 5
    
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
        tableView.separatorStyle = .None
        
        tableView.registerNib(UINib(nibName: "HomeTimeLineTableCell", bundle: nil), forCellReuseIdentifier: "HomeTimeLineTableCell")
        
        self.addSubview(tableView)
        
        tableView.snp_makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        

        
        
    }
    
    // MARK: UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return dataCount
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
        
        cell.headLine.hidden = false
        cell.bottomLine.hidden = false
        
        if indexPath.section == 0 {
            
            cell.headLine.hidden = true
            
            let cellVM = TimeLineStepViewModel(stepNumber: 10000)
            cell.cellConfig(cellVM, delegate: cellVM)
        }
        
        if indexPath.section == 1 {
            
            let cellVM = TimeLineSleepViewModel(sleepHour: 6, sleepMin: 30)
            
            cell.cellConfig(cellVM, delegate: cellVM)
        }
        if indexPath.section == 2 {
            
            let cellVM = TimeLinePKViewModel(othersName: "东坡排骨", result: "胜利了！")
            cell.cellConfig(cellVM, delegate: cellVM)
        }

        if indexPath.section == 3 {
            
            let cellVM = TimeLineAchiveViewModel(result: "徽章")
            cell.cellConfig(cellVM, delegate: cellVM)
        }

        if indexPath.section == 4 {
            
            let cellVM = TimeLineHealthViewModel(othersName: "水煮肉片")
            cell.cellConfig(cellVM, delegate: cellVM)
        }

        if indexPath.section == dataCount - 1 {
            
            cell.bottomLine.hidden = true
        }
        
        
        return cell
    }
    
    /**
     section不悬浮
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let sectionHeight: CGFloat = 16
        
        if scrollView.contentOffset.y <= sectionHeight && scrollView.contentOffset.y >= 0{
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
            
        } else if scrollView.contentOffset.y >= sectionHeight {
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeight, 0, 0, 0)
            
        }

    }

}
